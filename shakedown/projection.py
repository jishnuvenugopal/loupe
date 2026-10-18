#!/usr/bin/env python3
"""shakedown/projection.py — overnight projection (A16 §3 steps 5 and 6;
A18 §8 C4: steady-state tok/s + per-arm load time, cut ladder to <= 9 h).

  1. Generation (C4 form): hours = sum over arm x bench of
        load_s + (tasks x n x mean completion tokens) / steady-state tok/s
     where steady tok/s = throughput-batch tokens / gen_wall_s (model load
     excluded; the load is paid once per docker run, i.e. per arm x bench) —
     from results/shakedown/<arm>.json throughput[bench].{steady_tok_per_s,
     load_s}. Arms missing the steady split fall back to the load-inclusive
     wall rate and are flagged (re-run shakedown --throughput-only).
  2. Cut ladder (A16 §3 step 5 order), applied in sequence until the
     steady-state projection is at most 9 h (A18 §8 C4):
        (1) VerilogEval seeded subset of 60 (gen/ve_subset60.txt,
            random.Random(0).sample(sorted(ve_ids), 60), pinned pre-G0)
        (2) n 3 -> 2 (both benchmarks)
        (3) drop the 7B base arm
        (4) drop the 3B base arm
     Never max tokens, never an SFT arm. The step applied (or "none") is
     written to results/shakedown/projection.json for PREREG.
  3. RTLLM n = 5 option: A18 §8 C4 fixes it to NO (still shown for the record).

Scoring projection unchanged (A17 item 5 counts).

Usage: python3 shakedown/projection.py [--window 9.0] [--json-out FILE]
"""
import argparse
import json
import os

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
TASKS = {"ve": 156, "rtllm": 50}          # official benchmark sizes
GATED = {"ve": 144, "rtllm": 37}          # A17 item 2 strict gate
WINDOW_SCORE_H = 4.5
VE_SUBSET = 60
ORDER = ["7b-rl", "7b-sft", "3b-rl", "3b-base", "7b-base"]
CUTS = ["none", "ve-subset-60", "n-3-to-2", "drop-7b-base", "drop-3b-base"]


def load(arm):
    p = os.path.join(REPO, f"results/shakedown/{arm}.json")
    if not os.path.isfile(p):
        return None
    d = json.load(open(p))
    out = {"mean_tok": d["completion_tokens"]["mean"], "cells": {}}
    for b in ("ve", "rtllm"):
        t = d.get("throughput", {}).get(b, {})
        out["cells"][b] = {
            "steady_tok_per_s": t.get("steady_tok_per_s") or t.get("tok_per_s"),
            "load_s": t.get("load_s"),
            "steady": t.get("steady_tok_per_s") is not None,
            "wall_tok_per_s": t.get("tok_per_s")}
    return out


def gen_projection(arms, n, ve_tasks):
    rows, total_h, flagged = [], 0.0, []
    for arm in arms:
        d = load(arm)
        if d is None:
            rows.append((arm, None))
            continue
        h_arm = 0.0
        for bench, n_b in (("ve", n), ("rtllm", n)):
            cnt = TASKS[bench]
            if bench == "ve" and ve_tasks is not None:
                cnt = ve_tasks
            c = d["cells"][bench]
            if not c["steady"]:
                flagged.append(f"{arm}/{bench}")
            t = cnt * n_b * d["mean_tok"]
            h_arm += t / c["steady_tok_per_s"] / 3600.0
            h_arm += (c["load_s"] or 0.0) / 3600.0
        rows.append((arm, d["mean_tok"], h_arm))
        total_h += h_arm
    return rows, total_h, flagged


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--window", type=float, default=9.0, help="steady-state cut-off hours (A18 C4)")
    ap.add_argument("--rtllm-n", type=int, default=5, help="recorded option only (A18: NO)")
    ap.add_argument("--json-out", default=os.path.join(REPO, "results/shakedown/projection.json"))
    ap.add_argument("--allow-pending", action="store_true",
                    help="test only: allow a cut decision with missing arms")
    args = ap.parse_args()

    res = {"mode": "steady-state + per-arm load", "window_h": args.window,
           "rtllm_n5": "no (A18 §8 C4 fixed choice)",
           "arms": ORDER, "steps": []}

    def report(tag, arms, ve_tasks, n):
        rows, total, flagged = gen_projection(arms, n, ve_tasks)
        print(f"--- steady-state projection [{tag}] ---")
        detail = {}
        for r in rows:
            if r[1] is None:
                print(f"  {r[0]:9s} PENDING (no shakedown numbers)")
                continue
            print(f"  {r[0]:9s} mean_tok={r[1]:5d} -> {r[2]:.2f} h")
            detail[r[0]] = {"mean_tok": r[1], "hours": round(r[2], 3)}
        print(f"  TOTAL {total:.2f} h of {args.window} h window"
              f" -> {'FITS' if total <= args.window else 'DOES NOT FIT'}")
        if flagged:
            print(f"  WARNING: no steady split for {flagged} (wall rate used)")
        return total, detail, flagged

    # ladder in order until it fits (A16 §3 step 5 order; A18 C4 target 9 h)
    ladder = [("none", ORDER, None, 3),
              ("ve-subset-60", ORDER, VE_SUBSET, 3),
              ("n-3-to-2", ORDER, VE_SUBSET, 2),
              ("drop-7b-base", [a for a in ORDER if a != "7b-base"], VE_SUBSET, 2),
              ("drop-3b-base", [a for a in ORDER if a not in ("7b-base", "3b-base")], VE_SUBSET, 2)]
    # hard guard: no cut decision while any arm is unmeasured (A18 C4 needs
    # every arm's steady-state numbers; PENDING here means C3 did not finish)
    if any(load(a) is None for a in ORDER) and not args.allow_pending:
        missing = [a for a in ORDER if load(a) is None]
        print(f"ERROR: no cut decision possible; shakedown numbers missing for {missing}")
        return 1
    applied = None
    for tag, arms, ve_tasks, n in ladder:
        total, detail, flagged = report(tag, arms, ve_tasks, n)
        res["steps"].append({"step": tag, "total_h": round(total, 3),
                             "n": n, "ve_tasks": ve_tasks or TASKS["ve"], "arms": arms})
        if applied is None and total <= args.window:
            applied = tag
        if applied is not None:
            break
    res["cut_applied"] = applied
    print(f"\nCUT APPLIED: {applied} (RTLLM n=5: {res['rtllm_n5']}; "
          f"overlap probe: skipped — score nothing until generation ends)")

    # scoring projection (A16 §3 step 6; A17 item 5 counts) — unchanged rules
    sp = json.load(open(os.path.join(REPO, "results/shakedown/scoring_speed.json")))
    rate = sp["throughput_samples_per_s_at_workers"]
    stage = sp["aggregate_stage_s"]
    workers = sp["workers"]
    n_arms = len(ORDER)
    ve_tasks_after = VE_SUBSET if applied in ("ve-subset-60", "n-3-to-2",
                                              "drop-7b-base", "drop-3b-base") else TASKS["ve"]
    n_after = 2 if applied in ("n-3-to-2", "drop-7b-base", "drop-3b-base") else 3
    for tag, rn in (("n=3", 3), ("RTLLM n=5", 5)):
        tb_runs = (ve_tasks_after * n_after + TASKS["rtllm"] * max(n_after, 1 if rn == 3 else rn)) * n_arms
        formal = (min(GATED["ve"], ve_tasks_after) * n_after
                  + GATED["rtllm"] * max(n_after, 1 if rn == 3 else rn)) * n_arms
        h_meas = tb_runs / rate / 3600
        passes = sum(v for k, v in sp.get("verdict_tally", {}).items() if k == "pass")
        fpp = stage["formal"] / max(passes, 1)
        h_pess = (formal * fpp / workers + tb_runs * 0.2 / workers) / 3600
        print(f"--- scoring projection [{tag}, after cut '{applied}'] ---")
        print(f"  official TB runs: {tb_runs} ({formal} also formal) across {n_arms} arms")
        print(f"  measured-rate: {h_meas:.2f} h | pessimistic: {h_pess:.2f} h | window {WINDOW_SCORE_H} h")
        res["scoring_" + tag.replace("=", "").replace(" ", "_")] = {
            "tb_runs": tb_runs, "formal": formal, "h_measured": round(h_meas, 3),
            "h_pessimistic": round(h_pess, 3), "window_h": WINDOW_SCORE_H}

    json.dump(res, open(args.json_out, "w"), indent=1)
    print(f"wrote {args.json_out}")


if __name__ == "__main__":
    raise SystemExit(main())
