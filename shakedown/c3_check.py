#!/usr/bin/env python3
"""shakedown/c3_check.py — A18 §8 C3: hard per-arm checks on the 7B shakedown.

Pass conditions per arm (Phase 6 step 1):
  1. the logged effective SamplingParams equal §6.2 for that arm
     (T per arm; top_p 1.0 VE / 0.95 RTLLM; max_tokens 16384; top_k -1;
      min_p 0.0; repetition_penalty 1.0; n=1; per-task seed)
  2. at least 14 of 16 samples extract a module with the right name
  3. at most 4 of 16 hit the 16,384-token cap
  4. every sample is scored without a scorer crash (a `tb` key, no `error` crash)
Also records (A18 item 7): official passes from finish_reason == length.

Usage: python3 shakedown/c3_check.py --arm 7b-rl [--params-file ~/runs/7b-rl_effective_params.json]
Exit 0 = pass; exit 1 = fail (reason on stdout). --force-fail always exits 1
with a forced reason (chain dry-run).
"""
import argparse
import json
import os
import re
import sys

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
EXPECT_T = {"7b-rl": 1.0, "7b-sft": 0.6, "7b-base": 1.0, "3b-rl": 0.2, "3b-base": 0.2}
MAX_TOKENS = {"7b-rl": 16384, "7b-sft": 16384, "7b-base": 16384, "3b-rl": 2048, "3b-base": 2048}


def parse_params(s):
    out = {}
    for k in ("temperature", "top_p", "top_k", "min_p", "repetition_penalty",
              "max_tokens", "n", "seed", "max_logprobs"):
        m = re.search(rf"\b{k}=([^,\)]+)", s)
        if m:
            out[k] = m.group(1)
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--arm", required=True)
    ap.add_argument("--params-file", default="")
    ap.add_argument("--force-fail", action="store_true")
    args = ap.parse_args()
    if args.force_fail:
        print(f"C3 FAIL {args.arm}: forced failure (chain dry-run)")
        return 1
    rep_p = os.path.join(REPO, f"results/shakedown/{args.arm}.json")
    pf = args.params_file or os.path.expanduser(f"~/runs/shakedown/{args.arm}_effective_params.json")
    if os.path.isfile(os.path.expanduser(f"~/runs/{args.arm}_effective_params.json")):
        pf = os.path.expanduser(f"~/runs/{args.arm}_effective_params.json")
    fails = []
    rep = json.load(open(rep_p))
    # 1. effective SamplingParams
    pj = json.load(open(pf))
    got = parse_params(pj["SamplingParams"])
    want = {"temperature": EXPECT_T[args.arm], "top_p": 1.0, "top_k": -1.0,
            "min_p": 0.0, "repetition_penalty": 1.0, "max_tokens": MAX_TOKENS[args.arm],
            "n": 1}
    for k, v in want.items():
        g = got.get(k)
        if g is None or abs(float(g) - float(v)) > 1e-9:
            fails.append(f"SamplingParams.{k}={g} != {v} (logged: {pj['SamplingParams'][:120]})")
    # 2/3/4. per-sample checks
    recs = rep["per_sample"]
    name_ok = sum(bool(r.get("module_name_ok")) for r in recs)
    cap = rep["completion_tokens"]["cap_hits"]
    crashes = [r for r in recs if not r.get("score") or "tb" not in (r.get("score") or {})]
    if name_ok < 14:
        fails.append(f"module_name_ok {name_ok}/16 < 14")
    if cap > 4:
        fails.append(f"cap hits {cap}/16 > 4")
    if crashes:
        fails.append(f"{len(crashes)} samples scored with a scorer crash")
    if len(recs) != 16:
        fails.append(f"{len(recs)} samples (!= 16)")
    opfl = rep.get("official_passes_from_length")
    print(json.dumps({"arm": args.arm, "module_name_ok": name_ok, "cap_hits": cap,
                      "crashes": len(crashes), "effective_params": got,
                      "official_passes_from_length": opfl,
                      "verdicts": rep.get("verdicts"), "strict": rep.get("strict"),
                      "throughput": rep.get("throughput")}, indent=1))
    if fails:
        print("C3 FAIL " + args.arm + ": " + "; ".join(fails))
        return 1
    print(f"C3 PASS {args.arm}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
