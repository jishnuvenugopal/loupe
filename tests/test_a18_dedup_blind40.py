#!/usr/bin/env python3
"""tests/test_a18_dedup_blind40.py — A18 item 5 tests: scoring/dedup.py and
scoring/blind40.py, on synthetic rows, on the pilot's 290 rows and on the 3B
shakedown rows.

Run: python3 tests/test_a18_dedup_blind40.py  (exit 0 = all pass)
"""
import glob
import json
import os
import random
import shutil
import subprocess
import sys
import tempfile

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PY = sys.executable
sys.path.insert(0, os.path.join(REPO, "scoring"))
import stats  # noqa: E402

FAILS = {}
TD = tempfile.mkdtemp(prefix="a18_")


def check(name, cond, detail=""):
    print(("  PASS " if cond else "  FAIL ") + name + ("" if cond else f"  [{detail}]"))
    if not cond:
        FAILS[name] = detail


def gen_row(arm, bench, task, i, code):
    return {"arm": arm, "bench": bench, "task_id": task, "sample_idx": i,
            "completion": "```verilog\n" + code + "\n```", "finish_reason": "stop",
            "n_completion_tokens": 10}


def write_jsonl(p, rows):
    with open(p, "w") as f:
        for r in rows:
            f.write(json.dumps(r) + "\n")
    return p


def run_dedup(files, out):
    p = subprocess.run([PY, os.path.join(REPO, "scoring/dedup.py"),
                        "--gen", *files, "--out", out],
                       capture_output=True, text=True)
    assert p.returncode == 0, p.stderr[-2000:]
    return json.load(open(out)), json.load(open(out + ".summary.json"))


CODE_A = "module TopModule(input a, output b);\nassign b = a;\nendmodule\n"
CODE_A_FMT = ("// a formatted copy with comments and different whitespace\n"
              "module TopModule(\n  input a,\n  output b\n);\n"
              "  assign   b=a;   \nendmodule\n")
CODE_A_EXPLICIT = ("module TopModule(input wire a, output wire b);\nwire b;\n"
                   "assign b = a;\nendmodule\n")
CODE_B = "module TopModule(input a, output b);\nassign b = ~a;\nendmodule\n"
VE_GATE = sorted(set(open(os.path.join(REPO, "scoring/gates/ve_strict.txt")).read().split()))


def test_dedup_synthetic():
    tasks = VE_GATE[:20]
    rows = []
    for t in tasks:
        rows.append(gen_row("syn", "ve", t, 0, CODE_A))
        rows.append(gen_row("syn", "ve", t, 1, CODE_A_FMT))     # exact-duplicate
        rows.append(gen_row("syn", "ve", t, 2, CODE_A_EXPLICIT))  # normalised-duplicate
    random.Random(7).shuffle(rows)  # order must not matter
    f = write_jsonl(os.path.join(TD, "syn.jsonl"), rows)
    dmap, summary = run_dedup([f], os.path.join(TD, "dedup_syn.json"))
    check("dedup: 60 rows -> 20 unique (exact + normalised)", summary["unique_designs"] == 20,
          json.dumps(summary))
    check("dedup: 40 rows collapsed", summary["rows_collapsed"] == 40, json.dumps(summary))
    check("dedup: no yosys failures", summary["yosys_failures"] == 0, json.dumps(summary))
    keys = set(dmap)
    check("dedup: keys are arm|bench|task|sample_idx with STR sample_idx",
          keys == {f"syn|ve|{t}|{i}" for t in tasks for i in range(3)},
          str(list(keys)[:3]))
    # a genuinely different design must NOT collapse
    rows2 = [gen_row("syn", "ve", tasks[0], 0, CODE_A),
             gen_row("syn", "ve", tasks[0], 1, CODE_B)]
    f2 = write_jsonl(os.path.join(TD, "syn2.jsonl"), rows2)
    d2, s2 = run_dedup([f2], os.path.join(TD, "dedup_syn2.json"))
    check("dedup: different designs stay separate", s2["unique_designs"] == 2, json.dumps(s2))
    # stats.py consumes the map (A18 item 2 integration): 60 rows -> 20
    srows = [dict(r, tb="pass", equiv="equivalent", nonvacuous=True,
                  verdict={"class": "UNBOUNDED-EQ"}) for r in rows]
    sf = write_jsonl(os.path.join(TD, "syn_scores.jsonl"), srows)
    p = subprocess.run([PY, os.path.join(REPO, "scoring/stats.py"), "--scores", sf,
                        "--dedup", os.path.join(TD, "dedup_syn.json"),
                        "--out", os.path.join(TD, "stats_syn.json")],
                       capture_output=True, text=True)
    res = json.load(open(os.path.join(TD, "stats_syn.json")))
    check("dedup+stats: stats.py reports 40 collapsed rows",
          res.get("dedup", {}).get("rows_collapsed") == 40, p.stderr[-500:])


def build_pilot_gen():
    """pilot 290 rows -> gen jsonl (completions from ~/runs/deep/gpt gen.v) +
    scores jsonl (class via the pinned a16_class)."""
    rows = json.load(open(os.path.join(REPO, "results/deep/gpt_summary.json")))
    gen_p, score_rows = os.path.join(TD, "pilot_gen.jsonl"), os.path.join(TD, "pilot_scores.jsonl")
    ng = ns = 0
    with open(gen_p, "w") as fg, open(score_rows, "w") as fs:
        for r in rows:
            gv = os.path.expanduser(
                f"~/runs/deep/gpt/{r['model']}/{r['trial']}/{r['design']}/gen.v")
            code = open(gv, errors="ignore").read() if os.path.isfile(gv) else ""
            si = int(r["trial"][1:]) - 1
            fg.write(json.dumps(gen_row(r["model"], "rtllm", r["design"], si, code)) + "\n")
            ng += 1
            n = stats.normalize(r, "pilot")
            cls = stats.a16_class(n["tb"], n["equiv"], n["nonvacuous"], n["vclass"])
            fs.write(json.dumps({"arm": r["model"], "bench": "rtllm",
                                 "task_id": r["design"], "sample_idx": si,
                                 "tb": n["tb"], "class": cls,
                                 "nonvacuous": n["nonvacuous"]}) + "\n")
            ns += 1
    return gen_p, score_rows, ng, ns


def build_shakedown_gen():
    """3B shakedown rows -> gen jsonl + scores jsonl from per_sample."""
    gen_p = os.path.join(TD, "sd_gen.jsonl")
    score_rows = os.path.join(TD, "sd_scores.jsonl")
    ng = 0
    with open(gen_p, "w") as fg, open(score_rows, "w") as fs:
        for arm in ("3b-rl", "3b-base"):
            g = os.path.expanduser(f"~/runs/shakedown/{arm}_shakedown.jsonl")
            d = json.load(open(os.path.join(REPO, f"results/shakedown/{arm}.json")))
            sc = {(r["bench"], r["task_id"], r["sample_idx"]): r for r in d["per_sample"]}
            for l in open(g):
                r = json.loads(l)
                fg.write(json.dumps(r) + "\n")
                ng += 1
                s = sc.get((r["bench"], r["task_id"], r["sample_idx"]), {}).get("score", {})
                n = stats.normalize({"arm": arm, "bench": r["bench"], "task_id": r["task_id"],
                                     "sample_idx": r["sample_idx"], "score": s}, "shakedown")
                cls = stats.a16_class(n["tb"], n["equiv"], n["nonvacuous"], n["vclass"])
                fs.write(json.dumps({"arm": arm, "bench": r["bench"],
                                     "task_id": r["task_id"], "sample_idx": r["sample_idx"],
                                     "tb": n["tb"], "class": cls,
                                     "nonvacuous": n["nonvacuous"]}) + "\n")
    return gen_p, score_rows, ng


def test_blind40_synthetic():
    """allocation (largest remainder, sums to 40), apart exclusion, sorted
    population, determinism across runs, blindness scrub."""
    sys.path.insert(0, os.path.join(REPO, "scoring"))
    import blind40
    rt = [l.strip() for l in open(os.path.join(REPO, "scoring/gates/rtllm_strict.txt"))]
    rt33 = [t for t in rt if t not in blind40.APART][:10]
    scores = []
    for i, (arm, n) in enumerate([("7b-rl", 30), ("7b-sft", 20), ("3b-rl", 10)]):
        for j in range(n):
            bench = "ve" if j % 2 == 0 else "rtllm"
            task = VE_GATE[j % 20] if bench == "ve" else rt33[j % 10]
            scores.append({"arm": arm, "bench": bench, "task_id": task,
                           "sample_idx": j,  # unique (task,sample) per row: no fallback collapse
                           "tb": "pass", "class": "different",
                           "nonvacuous": True})
    # apart designs must be excluded even if present
    scores.append({"arm": "7b-rl", "bench": "rtllm", "task_id": "accu",
                   "sample_idx": 0, "tb": "pass", "class": "different",
                   "nonvacuous": True})
    sf = write_jsonl(os.path.join(TD, "b40_scores.jsonl"), scores)
    out1 = os.path.join(TD, "b40_out1")
    key1 = os.path.join(TD, "b40_key1.json")
    p = subprocess.run([PY, os.path.join(REPO, "scoring/blind40.py"),
                        "--scores", sf, "--gen", os.path.join(TD, "pilot_gen.jsonl"),
                        "--out-dir", out1, "--key", key1, "--n", "40"],
                       capture_output=True, text=True)
    check("blind40: draw runs", p.returncode == 0, p.stderr[-800:])
    meta = json.load(open(os.path.join(out1, "draw_meta.json")))
    key = json.load(open(key1))
    check("blind40: 40 drawn", meta["drawn"] == 40 and len(key) == 40, json.dumps(meta["strata"]))
    check("blind40: apart design excluded", all(v["task"] != "accu" for v in key.values()))
    tot_pop = sum(s["population"] for s in meta["strata"].values())
    check("blind40: population excludes apart (60)", tot_pop == 60, str(tot_pop))
    alloc_ok = all(s["drawn"] <= s["population"] for s in meta["strata"].values())
    check("blind40: allocation never exceeds a stratum", alloc_ok)
    # determinism: identical second run
    out2 = os.path.join(TD, "b40_out2")
    p2 = subprocess.run([PY, os.path.join(REPO, "scoring/blind40.py"),
                         "--scores", sf, "--gen", os.path.join(TD, "pilot_gen.jsonl"),
                         "--out-dir", out2, "--key", os.path.join(TD, "b40_key2.json"),
                         "--n", "40"], capture_output=True, text=True)
    same = all(open(os.path.join(out1, "packet", f)).read()
               == open(os.path.join(out2, "packet", f)).read()
               for f in os.listdir(os.path.join(out1, "packet")))
    check("blind40: deterministic across runs (same packets)", same and p2.returncode == 0)
    # population ordering: sorted by (arm, bench, task, sample_idx)
    pop = blind40.population(scores, {})
    check("blind40: population sorted by (arm,bench,task,sample_idx)",
          pop == sorted(pop, key=blind40.sort_key))
    # scrub catches a leak
    try:
        blind40.scrub("this mentions 7b-rl", "t")
        check("blind40: scrub catches arm leak", False, "no exception")
    except SystemExit:
        check("blind40: scrub catches arm leak", True)
    # largest-remainder unit checks
    a1 = blind40.largest_remainder({"a": 10, "b": 1}, 4)
    check("blind40: largest-remainder sums and floors",
          a1 == {"a": 4, "b": 0} or a1 == {"a": 3, "b": 1}, str(a1))
    a2 = blind40.largest_remainder({"a": 5, "b": 5}, 3)
    check("blind40: ties break evenly", sum(a2.values()) == 3, str(a2))
    a3 = blind40.largest_remainder({"a": 2}, 40)
    check("blind40: population < n takes all", a3 == {"a": 2}, str(a3))


def test_end_to_end_pilot_shakedown():
    gen_p, score_p, ng, ns = build_pilot_gen()
    sd_gen, sd_scores, nsg = build_shakedown_gen()
    check("e2e: pilot gen rows == 290", ng == 290, str(ng))
    check("e2e: shakedown gen rows == 32", nsg == 32, str(nsg))
    dmap, summary = run_dedup([gen_p, sd_gen], os.path.join(TD, "dedup_e2e.json"))
    check("e2e: dedup covers all rows",
          summary["rows_in"] == 290 + 32, json.dumps({k: v for k, v in summary.items() if k != "per_arm"}))
    check("e2e: dedup map keys == rows", len(dmap) == 322, str(len(dmap)))
    # blind40 over pilot+shakedown scores with the real dedup map
    out = os.path.join(TD, "b40_e2e")
    p = subprocess.run([PY, os.path.join(REPO, "scoring/blind40.py"),
                        "--scores", score_p, sd_scores, "--gen", gen_p, sd_gen,
                        "--dedup", os.path.join(TD, "dedup_e2e.json"),
                        "--out-dir", out, "--key", os.path.join(TD, "b40_e2e_key.json"),
                        "--n", "40"], capture_output=True, text=True)
    check("e2e: blind40 draw runs on pilot+shakedown", p.returncode == 0, p.stderr[-800:])
    meta = json.load(open(os.path.join(out, "draw_meta.json")))
    key = json.load(open(os.path.join(TD, "b40_e2e_key.json")))
    diffs = json.load(open(os.path.join(TD, "b40_e2e_key.json")))
    n_diff = meta["population"]
    # population: pilot DIFFERENT official passes (22 minus 3 RAM/apart... RAM is
    # apart) + shakedown differents, deduped to unique designs
    check("e2e: population > 0 and <= available unique differents",
          0 < meta["drawn"] <= 40 and meta["drawn"] == min(meta["population"], 40),
          f"pop={meta['population']} drawn={meta['drawn']}")
    pk = sorted(os.listdir(os.path.join(out, "packet")))
    check("e2e: one packet per drawn id", len(pk) == meta["drawn"], str(pk[:5]))
    # packets blind + contain the five sections
    banned = ("7b-rl", "7b-sft", "7b-base", "3b-rl", "3b-base", "codev", "verireason",
              "qwen", "distill", "chatgpt", "sample_idx")
    leaks = []
    for f in pk:
        t = open(os.path.join(out, "packet", f)).read().lower()
        if any(b in t for b in banned):
            leaks.append(f)
        if not all(s in t for s in ("specification", "reference design",
                                    "generated design under review",
                                    "official testbench result",
                                    "formal counterexample")):
            leaks.append(f + "(sections)")
    check("e2e: packets blind and complete", not leaks, str(leaks[:3]))
    # labels template + unblind round trip
    lt = os.path.join(out, "labels_template.csv")
    check("e2e: labels_template written", os.path.isfile(lt))
    import csv
    ids = [r["id"] for r in csv.DictReader(open(lt))]
    lab = ("real bug", "reference wrong", "allowed by spec", "unclear", "scorer artefact")
    with open(os.path.join(TD, "labels.csv"), "w") as f:
        f.write("id,label\n")
        for i, pid in enumerate(ids):
            f.write(f"{pid},{lab[i % 5]}\n")
    p = subprocess.run([PY, os.path.join(REPO, "scoring/blind40.py"), "--unblind",
                        "--key", os.path.join(TD, "b40_e2e_key.json"),
                        "--labels", os.path.join(TD, "labels.csv"),
                        "--out-dir", out], capture_output=True, text=True)
    check("e2e: unblind runs", p.returncode == 0, p.stderr[-500:])
    ub = json.load(open(os.path.join(out, "unblinded.json")))
    check("e2e: unblind counts sum to n", ub["n"] == len(ids) and
          sum(v["count"] for v in ub["overall"].values()) == ub["n"])
    check("e2e: wilson intervals present",
          all(len(v["wilson95"]) == 2 and v["wilson95"][0] <= v["share"] <= v["wilson95"][1]
              for v in ub["overall"].values()))


def main():
    print("== A18 item 5a: scoring/dedup.py (synthetic)")
    test_dedup_synthetic()
    print("== A18 item 5b: scoring/blind40.py (synthetic: allocation, determinism, scrub)")
    gp, sp, ng, ns = build_pilot_gen()  # blind40 synthetic test needs a gen file for packets
    test_blind40_synthetic()
    print("== A18 item 5c: end-to-end on pilot (290) + shakedown (32) rows")
    test_end_to_end_pilot_shakedown()
    if FAILS:
        print("FAILED:", json.dumps(FAILS, indent=1))
        return 1
    print("ALL A18 dedup/blind40 tests PASS")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
