#!/usr/bin/env python3
"""shakedown/projection.py — overnight projection (A16 §3 steps 5 and 6).

Reads the shakedown results (per-arm mean completion tokens + tok/s) and the
scoring-speed proxy, and prints:

  1. Generation: expected tokens = sum over arms x benchmarks of
     tasks x n x mean completion tokens; hours = sum per arm of tokens /
     that arm's measured tok/s (per benchmark). Compared with the 10 h window
     (21:00-07:00). If it does not fit, applies the cut order in sequence:
     (a) VerilogEval seeded subset of 60, (b) n 3 -> 2, (c) drop base arms
     (7B base first, then 3B base). Never max tokens, never an SFT arm.
     Also projects the RTLLM n = 5 operator option.
  2. Scoring: (156+50) x n x arms official-testbench runs, of which
     (143+38) x n x arms also get the formal check, at the measured
     amortized samples/s (and a pessimistic all-formal bound), vs the 4.5 h
     morning window (08:00-12:30).

Usage: python3 shakedown/projection.py [--rtllm-n 3|5] [--arms 7b-rl,7b-sft,...]
Missing shakedown files are skipped with a warning (7B pending as of 18 Oct).
"""
import argparse
import json
import os

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
TASKS = {"ve": 156, "rtllm": 50}          # official benchmark sizes
GATED = {"ve": 143, "rtllm": 38}          # strict-scoring sizes
WINDOW_GEN_H = 10.0
WINDOW_SCORE_H = 4.5
CUT_VE_SUBSET = 60

# overnight arm order (A16 §3 step 4); 3b-sft dropped by H0-a
ORDER = ["7b-rl", "7b-sft", "3b-rl", "3b-base", "7b-base"]


def load(arm):
    p = os.path.join(REPO, f"results/shakedown/{arm}.json")
    if not os.path.isfile(p):
        return None
    d = json.load(open(p))
    return {"mean_tok": d["completion_tokens"]["mean"],
            "tok_s": {b: d["throughput"][b]["tok_per_s"] for b in ("ve", "rtllm")}}


def gen_projection(arms, n, ve_tasks, rtllm_n=None):
    rows, total_h = [], 0.0
    for arm in arms:
        d = load(arm)
        if d is None:
            rows.append((arm, None, None, None))
            continue
        h = 0.0
        for bench, n_b in (("ve", n), ("rtllm", rtllm_n or n)):
            cnt = TASKS[bench]
            if bench == "ve" and ve_tasks is not None:
                cnt = ve_tasks
            t = cnt * n_b * d["mean_tok"]
            h += t / d["tok_s"][bench] / 3600.0  # hours
        rows.append((arm, d["mean_tok"], d["tok_s"], h))
        total_h += h
    return rows, total_h


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--rtllm-n", type=int, default=0, help="option: RTLLM n (e.g. 5)")
    ap.add_argument("--arms", default=",".join(ORDER))
    args = ap.parse_args()
    arms = args.arms.split(",")
    n = 3

    def report(tag, ve_tasks, rn):
        rows, total = gen_projection(arms, n, ve_tasks, rn)
        print(f"--- generation projection [{tag}] ---")
        for arm, mt, ts, h in rows:
            if h is None:
                print(f"  {arm:9s} PENDING (no shakedown numbers yet)")
            else:
                print(f"  {arm:9s} mean_tok={mt:5d} tok/s ve/rtllm={ts['ve']}/{ts['rtllm']} -> {h:.2f} h")
        print(f"  TOTAL {total:.2f} h of {WINDOW_GEN_H} h window"
              f" -> {'FITS' if total <= WINDOW_GEN_H else 'DOES NOT FIT'}")
        return total

    report(f"full plan, n={n}", None, None)
    if args.rtllm_n:
        report(f"RTLLM n={args.rtllm_n}", None, args.rtllm_n)

    # cut ladder (only meaningful when all arms have numbers)
    if all(load(a) for a in arms):
        t = report("cut 1: VE seeded subset of 60", CUT_VE_SUBSET, None)
        if t > WINDOW_GEN_H:
            t = report("cut 2: n 3 -> 2", CUT_VE_SUBSET, 2)
        if t > WINDOW_GEN_H:
            report("cut 3: drop 7B base then 3B base (re-run with --arms)", CUT_VE_SUBSET, 2)

    # --- scoring projection (A16 §3 step 6) ---
    sp = json.load(open(os.path.join(REPO, "results/shakedown/scoring_speed.json")))
    rate = sp["throughput_samples_per_s_at_workers"]          # amortized, measured
    workers = sp["workers"]
    stage = sp["aggregate_stage_s"]
    n_arms = len(arms)
    for tag, rn in (("n=3", 3), ("RTLLM n=5", 5)):
        tb_runs = (TASKS["ve"] * 3 + TASKS["rtllm"] * rn) * n_arms
        formal = (GATED["ve"] * 3 + GATED["rtllm"] * rn) * n_arms
        h_meas = tb_runs / rate / 3600
        # pessimistic bound: every formal-eligible sample passes and pays full
        # formal stage; formal s per pass from the proxy = stage.formal / passes
        passes = sum(v for k, v in sp.get("verdict_tally", {}).items() if k == "pass")
        fpp = stage["formal"] / max(passes, 1)
        h_pess = (formal * fpp / workers + tb_runs * 0.2 / workers) / 3600
        print(f"--- scoring projection [{tag}] ---")
        print(f"  official TB runs: {tb_runs} ({formal} also formal) across {n_arms} arms")
        print(f"  measured-rate estimate: {h_meas:.2f} h | pessimistic all-pass bound: {h_pess:.2f} h"
              f" | window {WINDOW_SCORE_H} h -> "
              f"{'FITS' if max(h_meas, h_pess) <= WINDOW_SCORE_H else 'CHECK'}")


if __name__ == "__main__":
    main()
