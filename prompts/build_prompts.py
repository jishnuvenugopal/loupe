#!/usr/bin/env python3
"""H0-c / Phase 5: build every evaluation prompt from the pinned sources.

Outputs (brief §4, §6.1):
  prompts/system_prompts/{codev,verireason}.txt     verbatim system prompts
  prompts/built/{codev,verireason}_{ve,rtllm}.jsonl one row per task
  prompts/SHA256SUMS                                 sha256 of every artifact above

Row schema: {"task_id", "bench", "system_sha256", "user", "prompt_sha256"}
  prompt_sha256  = sha256 of the exact user-message string (UTF-8, no trailing
                   alteration; the user message itself already ends with "\n").
  system_sha256  = sha256 of the family system prompt (Appendix D1/D2 check).

Also writes results/h0/h0c_rtllm_diff.json: comparison of the RTLLM v2.1
design_description.txt texts (51ed553) against CodeV's rtllm2.jsonl (v2.0)
prompts, as required by H0-c.

Exits non-zero if either system-prompt sha256 differs from Appendix D.
"""
import hashlib
import json
import os
import sys

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
BENCH = os.path.expanduser("~/bench")
CODEV_VE_JSONL = os.path.join(BENCH, "CodeV-R1/test/testbench/VerilogEval_v2.0.0/spec-to-rtl_0shot_n1.jsonl")
CODEV_RTLLM_JSONL = os.path.join(BENCH, "CodeV-R1/test/testbench/RTLLM_v2.0/rtllm2.jsonl")
CODEV_PREP = os.path.join(BENCH, "CodeV-R1/test")
VERIREASON_YAML = os.path.join(BENCH, "VeriReason/GRPO/verilog_grpo_tb.yaml")
RTLLM = os.path.join(BENCH, "RTLLM")

# Appendix D pins (sha256 over UTF-8 bytes of the string value, trailing newline included)
D1_SHA = "f0696dc439292af149f7a6b3f0a3f8735d53e1a4b39e36571af69e3115bd64ac"  # CodeV
D2_SHA = "75a7d783907db0dc5e4200290dd7fb9635ef1b85d4479108559b99cdb5799228"  # VeriReason

BEGIN_DONE = "Enclose your code with [BEGIN] and [DONE]. Only output the code snippet\nand do NOT output anything else.\n\n"


def sha256_str(s: str) -> str:
    return hashlib.sha256(s.encode("utf-8")).hexdigest()


def sha256_file(p: str) -> str:
    h = hashlib.sha256()
    with open(p, "rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def load_codev_system() -> str:
    """The exact system string from mk_prompt_codev_rl at the pinned commit."""
    sys.path.insert(0, CODEV_PREP)
    from llmkit_data.cli.prep_verilogeval import mk_prompt_codev_rl
    sys.path.pop(0)
    conv = mk_prompt_codev_rl("placeholder question")
    assert conv[0]["role"] == "system"
    return conv[0]["content"]


def load_verireason_system() -> str:
    import yaml
    with open(VERIREASON_YAML) as f:
        cfg = yaml.safe_load(f)
    return cfg["system_prompt"]


def codev_ve_user(fullprompt: str) -> str:
    """CodeV's own transform (Appendix D4): strip BEGIN/DONE sentence; split on
    // and mark the module head when the prompt carries a TopModule header."""
    question = fullprompt.replace(BEGIN_DONE, "")
    if question.count("//") >= 2 and "module TopModule" in question:
        question = question.split("//")
        question[-1] = "The module head should be:" + question[-1]
        question = "".join(question)
    return question.strip() + "\n"


def rtllm_designs():
    import glob
    dirs = sorted(d for d in glob.glob(os.path.join(RTLLM, "*", "*", "*"))
                  if glob.glob(os.path.join(d, "verified_*.v")))
    out = {}
    for d in dirs:
        name = os.path.basename(d)
        desc = os.path.join(d, "design_description.txt")
        out[name] = open(desc, encoding="utf-8").read() if os.path.isfile(desc) else None
    return out


def main():
    os.makedirs(os.path.join(REPO, "prompts/system_prompts"), exist_ok=True)
    os.makedirs(os.path.join(REPO, "prompts/built"), exist_ok=True)
    os.makedirs(os.path.join(REPO, "results/h0"), exist_ok=True)

    systems = {"codev": load_codev_system(), "verireason": load_verireason_system()}
    expect = {"codev": D1_SHA, "verireason": D2_SHA}
    ok = True
    for fam, s in systems.items():
        got = sha256_str(s)
        path = os.path.join(REPO, f"prompts/system_prompts/{fam}.txt")
        with open(path, "w", encoding="utf-8") as f:
            f.write(s)
        status = "OK" if got == expect[fam] else f"MISMATCH expected {expect[fam]}"
        if got != expect[fam]:
            ok = False
        print(f"system[{fam}] sha256={got} {status}")

    # --- user texts -------------------------------------------------------
    ve_rows = [json.loads(l) for l in open(CODEV_VE_JSONL, encoding="utf-8")]
    assert len(ve_rows) == 156, len(ve_rows)
    ve_users = {r["task_id"]: codev_ve_user(r["fullprompt"]) for r in ve_rows}

    rtllm_desc = rtllm_designs()
    assert len(rtllm_desc) == 50 and all(v is not None for v in rtllm_desc.values()), \
        f"RTLLM designs: {len(rtllm_desc)}"
    rtllm_users = {k: v.strip() + "\n" for k, v in rtllm_desc.items()}

    users = {"ve": ve_users, "rtllm": rtllm_users}
    sums = []
    for fam in ("codev", "verireason"):
        for bench in ("ve", "rtllm"):
            rows = []
            for task_id in sorted(users[bench]):
                u = users[bench][task_id]
                rows.append({"task_id": task_id, "bench": bench,
                             "system_sha256": sha256_str(systems[fam]),
                             "user": u, "prompt_sha256": sha256_str(u)})
            out = os.path.join(REPO, f"prompts/built/{fam}_{bench}.jsonl")
            with open(out, "w", encoding="utf-8") as f:
                for r in rows:
                    f.write(json.dumps(r, ensure_ascii=False) + "\n")
            sums.append((sha256_file(out), os.path.relpath(out, REPO)))
            print(f"built {os.path.relpath(out, REPO)}: {len(rows)} rows")
    for fam in ("codev", "verireason"):
        p = os.path.relpath(os.path.join(REPO, f"prompts/system_prompts/{fam}.txt"), REPO)
        sums.append((sha256_file(os.path.join(REPO, p)), p))
    with open(os.path.join(REPO, "prompts/SHA256SUMS"), "w") as f:
        for h, p in sums:
            f.write(f"{h}  {p}\n")
    print("wrote prompts/SHA256SUMS")

    # --- H0-c: RTLLM v2.1 description vs CodeV v2.0 prompt ----------------
    codev_rtllm = {r["task_id"]: r["prompt"] for r in map(json.loads, open(CODEV_RTLLM_JSONL, encoding="utf-8"))}
    diff = {"exact_equal": [], "equal_after_strip": [], "different": []}
    for task_id, desc in sorted(rtllm_desc.items()):
        theirs = codev_rtllm.get(task_id)
        if theirs is None:
            diff["different"].append({"task_id": task_id, "reason": "not in rtllm2.jsonl"})
            continue
        ours = desc.strip()
        if ours == theirs.strip():
            (diff["exact_equal"] if ours == theirs else diff["equal_after_strip"]).append(task_id)
        else:
            diff["different"].append({"task_id": task_id,
                                      "v21_len": len(desc), "codev_v20_len": len(theirs)})
    report = {"rtllm_v21_commit": "51ed553d0ffd32797a1a0a13e051656bf302c81f",
              "codev_rtllm2_jsonl": "CodeV-R1@277ac46 test/testbench/RTLLM_v2.0/rtllm2.jsonl",
              "n_designs": len(rtllm_desc),
              "exact_equal": len(diff["exact_equal"]),
              "equal_after_whitespace_strip": len(diff["equal_after_strip"]),
              "different_count": len(diff["different"]),
              "different": diff["different"]}
    with open(os.path.join(REPO, "results/h0/h0c_rtllm_diff.json"), "w") as f:
        json.dump(report, f, indent=1)
    print(f"RTLLM v2.1 vs CodeV v2.0: exact={report['exact_equal']} "
          f"strip-equal={report['equal_after_whitespace_strip']} "
          f"different={report['different_count']}")
    for d in diff["different"]:
        print("  differs:", d)

    if not ok:
        print("SYSTEM PROMPT HASH MISMATCH — stopping (rule: stop if they differ)", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
