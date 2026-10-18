#!/usr/bin/env python3
"""Phase 6 shakedown orchestrator (brief §5 Phase 6 steps 1-3).

Runs on the HOST. For each requested arm whose weights are complete:
  1. 16 seeded shakedown tasks (8 VE gated + 8 RTLLM usable,
     random.Random(42).sample, list saved to results/shakedown/tasks.json),
     n = 1, at the arm's §6.2 protocol, inside the vLLM container.
  2. Extraction (CodeV extractor) + module-name check + score.py verdicts.
  3. Throughput: 22 prompts x n = 3 concurrent, aggregate tok/s + wall.
Everything is labelled shakedown; generations live under ~/runs/shakedown and
are deleted at the end of the phase (never scored for results).

Usage: python3 shakedown/shakedown_run.py --arm 7b-rl [--skip-gen] [--skip-throughput]
"""
import argparse
import glob
import json
import os
import random
import shutil
import statistics
import subprocess
import sys
import time

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RUNS = os.path.expanduser("~/runs/shakedown")
PY = os.path.expanduser("~/.venvs/host/bin/python3")
IMAGE = "nvcr.io/nvidia/vllm:26.05.post1-py3"
VE_GATE = json.load(open(os.path.join(REPO, "results/pilot_repro/ve_gate_summary.json")))
VE_KEPT = sorted(r["task"] for r in VE_GATE
                 if r["tb_icarus"] == "pass" and r["class"] in ("UNBOUNDED-EQ", "BMC-10-EQ-ONLY"))
RTLLM_USABLE_EXTRA = ["multi_8bit", "multi_pipe_8bit"]
RTLLM_38 = ["JC_counter", "LFSR", "LIFObuffer", "RAM", "ROM", "accu", "adder_16bit",
            "adder_32bit", "adder_8bit", "adder_bcd", "alu", "asyn_fifo", "barrel_shifter",
            "calendar", "comparator_3bit", "comparator_4bit", "counter_12", "edge_detect",
            "fixed_point_adder", "freq_div", "freq_divbyfrac", "freq_divbyodd", "fsm",
            "instr_reg", "multi_16bit", "multi_booth_8bit", "parallel2serial", "pe",
            "pulse_detect", "right_shifter", "sequence_detector", "serial2parallel",
            "signal_generator", "square_wave", "sub_64bit", "traffic_light",
            "up_down_counter", "width_8to16"]
RTLLM_USABLE = sorted(RTLLM_38 + RTLLM_USABLE_EXTRA)

ARMS = {
    # arm -> (repo_id, revision, family, T, max_tokens, dtype_note)
    "7b-base": ("Qwen/Qwen2.5-Coder-7B-Instruct",
                "c03e6d358207e414f1eca0bb1891e29f1db0e242", "codev", 1.0, 16384),
    "7b-sft": ("zhuyaoyu/CodeV-R1-Distill-Qwen-7B",
               "8fdb92e328cb2a98ef9a3f9dcd82995a2112bd9c", "codev", 0.6, 16384),
    "7b-rl": ("zhuyaoyu/CodeV-R1-RL-Qwen-7B",
              "286cf433f596f1b8525529c1163eb81c19425c22", "codev", 1.0, 16384),
    "3b-rl": ("Nellyw888/VeriReason-Qwen2.5-3b-RTLCoder-Verilog-GRPO-reasoning-tb",
              "3b93ce1bd7e5d90dae8761363a9c6862d0ed583a", "verireason", 0.2, 2048),
    "3b-sft": ("Nellyw888/Qwen2.5-3b-sft-reasoning",
               "1f0b7fac9c057b32cba9107a854518be92e45c91", "verireason", 0.2, 2048),
    # A16 §3 step 3: 3B base = Qwen2.5-Coder-3B-Instruct (never the raw 3B).
    # 3b-sft is KEPT FOR THE RECORD ONLY: H0-a dropped the arm (PREREG), A16 §3
    # step 3 says "3B SFT unless H0-a dropped it" -> do not run it.
    "3b-base": ("Qwen/Qwen2.5-Coder-3B-Instruct",
                "488639f1ff808d1d3d0ba301aef8c11461451ec5", "verireason", 0.2, 2048),
}
# A16 §3 step 3: max_model_len = largest rendered 3B prompt (1279 tok, rtllm
# asyn_fifo, both 3B tokenizers) + 2048 + 64 = 3391 -> roundup256 = 3584 ->
# floor at 4096. Computed 18 Oct 2026, prompts/SHA256SUMS state.
MAX_MODEL_LEN_3B = 4096
TOP_P = {"ve": 1.0, "rtllm": 0.95}  # VeriReason 0.95 both (§6.2)


def snapshot(repo_id, rev):
    p = os.path.expanduser(f"~/hf/hub/models--{repo_id.replace('/', '--')}/snapshots/{rev}")
    return p if os.path.isdir(p) else None


def shards_complete(repo_id, rev):
    p = snapshot(repo_id, rev)
    if not p:
        return False
    # complete = no .incomplete blobs remain for this model
    blobs = os.path.expanduser(f"~/hf/hub/models--{repo_id.replace('/', '--')}/blobs")
    return not glob.glob(os.path.join(blobs, "*.incomplete")) and bool(glob.glob(os.path.join(p, "*.safetensors")))


def shakedown_tasks():
    ve = sorted(random.Random(42).sample(VE_KEPT, 8))
    rt = sorted(random.Random(42).sample(RTLLM_USABLE, 8))
    return ve, rt


def docker_gen(arm, model_path, rev, family, prompt_file, out_file, n, max_tokens, temperature, extra_env="", timing_out=""):
    if family == "verireason":
        top_p_note = 0.95  # §6.2: VeriReason arms top_p 0.95 on both benchmarks
        mml = MAX_MODEL_LEN_3B  # A16 §3 step 3 pinned value
    else:
        top_p_note = TOP_P["ve"] if "_ve" in os.path.basename(prompt_file) else TOP_P["rtllm"]
        mml = 20480
    hf_dir = os.path.expanduser("~/hf")
    timing_arg = f" --timing-out {timing_out}" if timing_out else ""
    cmd = (f"sg docker -c 'docker run --rm --gpus all --ipc=host "
           f"--ulimit memlock=-1 --ulimit stack=67108864 "
           f"-v {hf_dir}:/models-hf "
           f"-v {REPO}:/work -v {RUNS}:/runs {extra_env} {IMAGE} "
           f"python3 /work/gen/gen_vllm.py --arm {arm} --model {model_path} --revision {rev} "
           f"--prompts {prompt_file} --system /work/prompts/system_prompts/{family}.txt "
           f"--n {n} --max-tokens {max_tokens} --temperature {temperature} --top-p {top_p_note} "
           f"--max-model-len {mml} "
           f"--log-effective-params /runs/{arm}_effective_params.json{timing_arg} "
           f"--out {out_file}'")
    return subprocess.run(["bash", "-c", cmd], capture_output=True, text=True)


def extract_and_score(arm):
    sys.path.insert(0, os.path.expanduser("~/bench/CodeV-R1/test/utils"))
    from verilog_extractor import extract_verilog_code
    gen_file = os.path.join(RUNS, f"{arm}_shakedown.jsonl")
    rows = [json.loads(l) for l in open(gen_file)]
    recs = []
    for r in rows:
        code = extract_verilog_code(r["completion"])
        want = "TopModule" if r["bench"] == "ve" else r["task_id"]
        name_ok = bool(code.strip()) and want in code
        rec = {"task_id": r["task_id"], "bench": r["bench"], "sample_idx": r["sample_idx"],
               "n_completion_tokens": r["n_completion_tokens"],
               "finish_reason": r["finish_reason"],
               "extract_ok": bool(code.strip()), "module_name_ok": name_ok}
        sdir = os.path.join(RUNS, f"score_{arm}", f"{r['bench']}_{r['task_id']}_{r['sample_idx']}")
        sam_dir = os.path.join(RUNS, f"samples_{arm}")
        sf = os.path.join(sam_dir, f"{r['bench']}_{r['task_id']}_{r['sample_idx']}.v")
        os.makedirs(sam_dir, exist_ok=True)  # NB: score.py rmtree's --out; keep inputs outside it
        open(sf, "w").write(code if code.strip() else "// extraction failed\n")
        p = subprocess.run([PY, os.path.join(REPO, "scorer/score.py"), "--bench", r["bench"],
                            "--task", r["task_id"], "--sample", sf, "--out", sdir],
                           capture_output=True, text=True, timeout=1800)
        try:
            rec["score"] = json.loads(p.stdout.strip().splitlines()[-1])
        except Exception:
            rec["score"] = {"error": p.stderr[-300:]}
        recs.append(rec)
    return recs


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--arm", required=True, choices=sorted(ARMS))
    ap.add_argument("--skip-gen", action="store_true")
    ap.add_argument("--skip-throughput", action="store_true")
    ap.add_argument("--skip-score", action="store_true",
                    help="reuse the existing report's per_sample (throughput-only refresh)")
    args = ap.parse_args()
    repo_id, rev, family, T, maxtok = ARMS[args.arm]

    if not shards_complete(repo_id, rev):
        print(f"weights for {args.arm} not complete yet; nothing done")
        sys.exit(2)
    model_path = snapshot(repo_id, rev).replace(os.path.expanduser("~/hf"), "/models-hf")

    ve, rt = shakedown_tasks()
    os.makedirs(os.path.join(REPO, "results/shakedown"), exist_ok=True)
    tasks_path = os.path.join(REPO, "results/shakedown/tasks.json")
    if not os.path.isfile(tasks_path):
        json.dump({"seed": 42, "ve": ve, "rtllm": rt,
                   "ve_pool": len(VE_KEPT), "rtllm_pool": len(RTLLM_USABLE)},
                  open(tasks_path, "w"), indent=1)
    os.makedirs(os.path.join(RUNS, "prompts"), exist_ok=True)
    for bench, tasks in (("ve", ve), ("rtllm", rt)):
        rows = [json.loads(l) for l in open(os.path.join(REPO, f"prompts/built/{family}_{bench}.jsonl"))]
        sel = [r for r in rows if r["task_id"] in tasks]
        with open(os.path.join(RUNS, f"prompts/{family}_{bench}_16.jsonl"), "w") as f:
            for r in sel:
                f.write(json.dumps(r, ensure_ascii=False) + "\n")
        assert len(sel) == len(tasks), (bench, len(sel), len(tasks))

    report = {"arm": args.arm, "model": repo_id, "revision": rev, "T": T,
              "max_tokens": maxtok, "shakedown_tasks": {"ve": ve, "rtllm": rt}}
    if not args.skip_gen:
        t0 = time.time()
        for bench in ("ve", "rtllm"):
            pf = f"/runs/prompts/{family}_{bench}_16.jsonl"
            of = f"/runs/{args.arm}_shakedown_{bench}.jsonl"
            p = docker_gen(args.arm, model_path, rev, family, pf, of, 1, maxtok, T)
            print(p.stdout[-2000:], p.stderr[-2000:])
        # merge per-bench shakedown outputs
        rows = []
        for bench in ("ve", "rtllm"):
            f = os.path.join(RUNS, f"{args.arm}_shakedown_{bench}.jsonl")
            if os.path.isfile(f):
                rows += [json.loads(l) for l in open(f)]
        with open(os.path.join(RUNS, f"{args.arm}_shakedown.jsonl"), "w") as f:
            for r in rows:
                f.write(json.dumps(r, ensure_ascii=False) + "\n")
        report["gen_wall_s"] = round(time.time() - t0, 1)

    if args.skip_score:  # throughput-only refresh: keep the scored per_sample
        prev = os.path.join(REPO, f"results/shakedown/{args.arm}.json")
        recs = json.load(open(prev))["per_sample"] if os.path.isfile(prev) else []
    else:
        recs = extract_and_score(args.arm)
    toks = sorted(r["n_completion_tokens"] for r in recs)
    report["completion_tokens"] = {
        "mean": round(statistics.mean(toks)), "p95": toks[int(0.95 * len(toks)) - 1],
        "max": max(toks), "cap_hits": sum(r["finish_reason"] == "length" for r in recs)}
    report["extraction_ok"] = sum(r["extract_ok"] for r in recs)
    report["module_name_ok"] = sum(r["module_name_ok"] for r in recs)
    report["verdicts"] = {v: sum(1 for r in recs if (r.get("score") or {}).get("tb") == v)
                          for v in ("pass", "fail", "compile_error", "timeout")}
    report["strict"] = {c: sum(1 for r in recs if (r.get("score") or {}).get("class") == c)
                        for c in ("DIFFERENT", "UNBOUNDED-EQ", "BMC-10-EQ-ONLY", "UNKNOWN")}
    # A18 item 7: official passes whose output hit the token cap (reported,
    # not corrected) — the 3B-base <think> finding is the template for this.
    report["official_passes_from_length"] = sum(
        1 for r in recs if (r.get("score") or {}).get("tb") == "pass"
        and r.get("finish_reason") == "length")
    report["per_sample"] = recs

    if not args.skip_throughput:
        # 22 prompts x n = 3 from the same built prompt files (first 22 tasks)
        for bench in ("ve", "rtllm"):
            src = os.path.join(REPO, f"prompts/built/{family}_{bench}.jsonl")
            rows = [json.loads(l) for l in open(src)][:32]  # A16: 32 tasks x n=2 = 64 concurrent
            with open(os.path.join(RUNS, f"prompts/{family}_{bench}_tp.jsonl"), "w") as f:
                for r in rows:
                    f.write(json.dumps(r, ensure_ascii=False) + "\n")
        tput = {}
        for bench in ("ve", "rtllm"):
            pf = f"/runs/prompts/{family}_{bench}_tp.jsonl"
            of = f"/runs/{args.arm}_tp_{bench}.jsonl"
            tim = f"/runs/{args.arm}_tp_{bench}.timing.json"
            if os.path.isfile(os.path.join(RUNS, f"{args.arm}_tp_{bench}.jsonl")):
                os.remove(os.path.join(RUNS, f"{args.arm}_tp_{bench}.jsonl"))
            if os.path.isfile(os.path.join(RUNS, f"{args.arm}_tp_{bench}.timing.json")):
                os.remove(os.path.join(RUNS, f"{args.arm}_tp_{bench}.timing.json"))
            t0 = time.time()
            p = docker_gen(args.arm, model_path, rev, family, pf, of, 2, maxtok, T,
                           timing_out=tim)
            wall = time.time() - t0
            ntok = 0
            f = os.path.join(RUNS, f"{args.arm}_tp_{bench}.jsonl")
            if os.path.isfile(f):
                ntok = sum(json.loads(l)["n_completion_tokens"] for l in open(f))
            tput[bench] = {"wall_s": round(wall, 1), "tokens": ntok,
                           "tok_per_s": round(ntok / wall, 1) if wall else None}
            tp = os.path.join(RUNS, f"{args.arm}_tp_{bench}.timing.json")
            if os.path.isfile(tp):  # A18/C4: steady-state split (load excluded)
                timj = json.load(open(tp))
                tput[bench].update({"load_s": timj["load_s"],
                                    "gen_wall_s": timj["gen_wall_s"],
                                    "steady_tok_per_s": (round(ntok / timj["gen_wall_s"], 1)
                                                          if timj["gen_wall_s"] else None)})
            print(p.stdout[-1500:], p.stderr[-1500:])
        report["throughput"] = tput

    with open(os.path.join(REPO, f"results/shakedown/{args.arm}.json"), "w") as f:
        json.dump(report, f, indent=1)
    print(json.dumps({k: report[k] for k in ("completion_tokens", "extraction_ok",
                                             "module_name_ok", "verdicts", "strict",
                                             "official_passes_from_length", "throughput")
                      if k in report}, indent=1))


if __name__ == "__main__":
    main()
