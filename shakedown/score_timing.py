#!/usr/bin/env python3
"""Phase 6 step 5: scoring speed measurement (timing proxy).

DEVIATION (recorded in SPARK_REPORT §7): the brief times 20 shakedown samples;
those are vLLM generations of the study arms and cannot exist yet (docker
blocked). Instead this times score.py on the first 20 (sorted) RTLLM-shipped
GPT-4 t1 designs — pilot inputs, never study-arm samples, never a result.

Protocol: WORKERS = nproc-2 concurrent score.py runs (as production), per-sample
wall time + per-stage EDA time from run_score_timed.py. Output:
results/shakedown/scoring_speed.json.
"""
import glob
import json
import os
import statistics
import subprocess
import sys
import time
from concurrent.futures import ThreadPoolExecutor

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PY = os.path.expanduser("~/.venvs/host/bin/python3")
RTLLM_GPT4_T1 = os.path.expanduser("~/bench/RTLLM/_chatgpt4/t1")
WORK = os.path.expanduser("~/runs/shakedown_timing")
N = 20


def one(i, path):
    task = os.path.splitext(os.path.basename(path))[0]
    out = os.path.join(WORK, f"{i:02d}_{task}")
    cmd = [PY, os.path.join(REPO, "shakedown/run_score_timed.py"),
           "--bench", "rtllm", "--task", task, "--sample", path, "--out", out]
    t0 = time.monotonic()
    p = subprocess.run(cmd, capture_output=True, text=True, timeout=1800)
    wall = time.monotonic() - t0
    rec = {"i": i, "task": task, "wall_s": round(wall, 2), "rc": p.returncode}
    try:
        rec["verdict"] = json.loads(p.stdout.strip().splitlines()[-1])
    except Exception:
        rec["verdict"] = None
        rec["stderr"] = p.stderr[-500:]
    try:
        rec["stages"] = json.load(open(os.path.join(out, "timing.json")))
    except Exception:
        rec["stages"] = None
    return rec


def main():
    files = sorted(glob.glob(os.path.join(RTLLM_GPT4_T1, "*.v")))[:N]
    assert len(files) == N, len(files)
    os.makedirs(WORK, exist_ok=True)
    workers = max(1, os.cpu_count() - 2)
    t0 = time.monotonic()
    with ThreadPoolExecutor(max_workers=workers) as ex:
        recs = list(ex.map(lambda t: one(*t), enumerate(files)))
    total_wall = time.monotonic() - t0
    walls = sorted(r["wall_s"] for r in recs)
    stages = {"testbench": 0.0, "formal": 0.0, "synth_lint": 0.0, "other": 0.0}
    for r in recs:
        if r["stages"]:
            for k in stages:
                stages[k] += r["stages"].get(k, 0.0)
    report = {
        "note": "timing proxy on RTLLM-shipped GPT-4 t1 designs (see module docstring)",
        "n_samples": N, "workers": workers,
        "total_wall_s": round(total_wall, 1),
        "per_sample_wall_s": {"mean": round(statistics.mean(walls), 2),
                              "p50": round(walls[N // 2], 2),
                              "p95": round(walls[int(0.95 * N) - 1], 2),
                              "max": round(walls[-1], 2)},
        "aggregate_stage_s": {k: round(v, 1) for k, v in stages.items()},
        "throughput_samples_per_s_at_workers": round(N / total_wall, 4),
        "verdict_tally": {v: sum(1 for r in recs if (r["verdict"] or {}).get("tb") == v)
                          for v in ("pass", "fail", "compile_error", "timeout", "no_task")},
        "samples": recs,
    }
    os.makedirs(os.path.join(REPO, "results/shakedown"), exist_ok=True)
    with open(os.path.join(REPO, "results/shakedown/scoring_speed.json"), "w") as f:
        json.dump(report, f, indent=1)
    print(json.dumps({k: report[k] for k in ("n_samples", "workers", "total_wall_s",
                                             "per_sample_wall_s", "aggregate_stage_s",
                                             "throughput_samples_per_s_at_workers",
                                             "verdict_tally")}, indent=1))


if __name__ == "__main__":
    main()
