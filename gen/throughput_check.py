#!/usr/bin/env python3
"""gen/throughput_check.py — Phase 8 throughput check (A16 §5 step 3).

Parses a generation container log for vLLM's periodic engine-stats lines
("Avg generation throughput: N.N tok/s") and reports the mean of the last 10
intervals, the max, and any output-file token totals. Emits one JSON line
(append) for the run record.

Usage: python3 gen/throughput_check.py --log ~/runs/gen/log_7b-rl_ve.txt \
         --label "30-min check" [--out ~/runs/gen/throughput_checks.jsonl] \
         [--gen-file ~/runs/gen/7b-rl_ve.jsonl]
"""
import argparse
import json
import os
import re
import time

RE_TPS = re.compile(r"Avg generation throughput:\s*([\d.]+)\s*tok/s")
# vLLM 0.21 tqdm progress lines: "... est. speed input: X toks/s, output: Y toks/s"
RE_TQDM = re.compile(r"output:\s*([\d.]+)\s*toks/s")
RE_PROG = re.compile(r"Processed prompts:\s+(\d+)%\|[^|]*\|\s*(\d+)/(\d+)")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--log", required=True)
    ap.add_argument("--label", required=True)
    ap.add_argument("--out", default=os.path.expanduser("~/runs/gen/throughput_checks.jsonl"))
    ap.add_argument("--gen-file", default="")
    args = ap.parse_args()
    rec = {"when": time.strftime("%Y-%m-%d %H:%M:%S"), "label": args.label,
           "log": args.log}
    if os.path.isfile(args.log):
        txt = open(args.log, errors="ignore").read()
        tps = [float(m) for m in RE_TPS.findall(txt)]
        rec.update({"intervals": len(tps),
                    "mean_last10_tok_s": round(sum(tps[-10:]) / min(len(tps), 10), 1) if tps else None,
                    "max_tok_s": max(tps) if tps else None})
        if not tps:  # vLLM 0.21: tqdm cumulative output speed instead
            tq = [float(m) for m in RE_TQDM.findall(txt)]
            pr = RE_PROG.findall(txt)
            rec.update({"tqdm_output_tok_s_last": tq[-1] if tq else None,
                        "tqdm_output_tok_s_max": max(tq) if tq else None,
                        "progress": f"{pr[-1][1]}/{pr[-1][2]} ({pr[-1][0]}%)" if pr else None})
    if args.gen_file and os.path.isfile(args.gen_file):
        rows = [json.loads(l) for l in open(args.gen_file, errors="ignore")]
        toks = sum(r.get("n_completion_tokens", 0) for r in rows)
        rec.update({"rows_written": len(rows), "tokens_written": toks,
                    "first_finished_at": min((r["finished_at"] for r in rows), default=None),
                    "last_finished_at": max((r["finished_at"] for r in rows), default=None)})
    os.makedirs(os.path.dirname(args.out), exist_ok=True)
    with open(args.out, "a") as f:
        f.write(json.dumps(rec) + "\n")
    print(json.dumps(rec))


if __name__ == "__main__":
    main()
