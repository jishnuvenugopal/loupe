#!/usr/bin/env python3
"""H0-d (part 1): can the dataset's `tb_result` serve as the reward oracle?

For 30 seeded rows of the 1,149-row GRPO dataset (pinned revision):
  1. extract the golden code from `output` with CodeV's extractor (Appendix D3);
  2. run it with the row's `tb` under Icarus (pinned oss-cad-suite);
  3. compare the testbench's written file (test_vectors.txt) with `tb_result`.

Seeding: random.Random(0).sample(range(n_rows), 30) — documented here, fixed.

Writes results/h0/h0d_oracle.json (+ per-row verdicts) and prints the summary.
"""
import glob
import json
import os
import random
import re
import subprocess
import sys

EDA = os.path.expanduser("~/eda/oss-cad-suite/bin")
ENV = dict(os.environ, PATH=EDA + ":" + os.environ["PATH"])
REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DATA = os.path.expanduser(
    "~/hf/hub/datasets--Nellyw888--VeriReason-RTL-Coder_7b_reasoning_tb/"
    "snapshots/42823db968114c25da260dece0e4bea8ab20d573/train_tb_filtered.jsonl")
WORK = os.path.expanduser("~/runs/h0d_oracle")
sys.path.insert(0, os.path.expanduser("~/bench/CodeV-R1/test/utils"))
from verilog_extractor import extract_verilog_code  # CodeV-R1 @277ac46 (Appendix D3)

N_SAMPLE = 30
SEED = 0


def run(cmd, cwd, timeout):
    try:
        p = subprocess.run(cmd, cwd=cwd, env=ENV, capture_output=True, text=True, timeout=timeout)
        return p.returncode, (p.stdout or "") + (p.stderr or "")
    except subprocess.TimeoutExpired:
        return "timeout", ""


def check_row(idx, row):
    w = os.path.join(WORK, f"row_{idx:04d}")
    os.makedirs(w, exist_ok=True)
    code = extract_verilog_code(row["output"])
    rec = {"id": row.get("id"), "row": idx, "extracted_chars": len(code)}
    if not code.strip():
        rec.update(verdict="extract_fail")
        return rec
    open(os.path.join(w, "golden.v"), "w").write(code)
    open(os.path.join(w, "tb.v"), "w").write(row["tb"])
    rc, out = run(["iverilog", "-g2012", "-o", "sim", "golden.v", "tb.v"], w, 60)
    if rc != 0:
        rec.update(verdict="compile_error", detail=out.strip().splitlines()[-1] if out.strip() else "")
        return rec
    rc, out = run(["vvp", "-n", "sim"], w, 120)
    if rc == "timeout":
        rec.update(verdict="timeout")
        return rec
    vec = os.path.join(w, "test_vectors.txt")
    if not os.path.isfile(vec):
        rec.update(verdict="no_output_file")
        return rec
    got = open(vec).read()
    want = row["tb_result"]
    exact = got == want
    norm = "\n".join(l.rstrip() for l in got.strip().splitlines()) == \
           "\n".join(l.rstrip() for l in want.strip().splitlines())
    rec.update(verdict="reproduce" if exact else ("reproduce_normalized" if norm else "mismatch"),
               exact=exact, normalized=norm, got_lines=got.count("\n"), want_lines=want.count("\n"))
    return rec


def main():
    rows = [json.loads(l) for l in open(DATA)]
    assert len(rows) == 1149, len(rows)
    picked = sorted(random.Random(SEED).sample(range(len(rows)), N_SAMPLE))
    os.makedirs(WORK, exist_ok=True)
    recs = [check_row(i, rows[i]) for i in picked]
    import collections
    tally = collections.Counter(r["verdict"] for r in recs)
    report = {"dataset": "Nellyw888/VeriReason-RTL-Coder_7b_reasoning_tb@42823db968114c25da260dece0e4bea8ab20d573",
              "n_rows": len(rows), "seed": SEED, "sampled_rows": picked,
              "tally": dict(tally),
              "exact_reproduce": tally.get("reproduce", 0),
              "verdicts": recs}
    with open(os.path.join(REPO, "results/h0/h0d_oracle.json"), "w") as f:
        json.dump(report, f, indent=1)
    print(json.dumps({k: report[k] for k in ("n_rows", "seed", "tally", "exact_reproduce")}, indent=1))
    for r in recs:
        if r["verdict"] not in ("reproduce",):
            print("  non-exact:", r)


if __name__ == "__main__":
    main()
