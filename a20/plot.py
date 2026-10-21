#!/usr/bin/env python3
"""a20/plot.py — plot a Phase 9 B2 CSV (PREREG-A20; run by the supervisor
after every new 10-step row, beside the CSV under results/grpo/).

Usage: python3 a20/plot.py results/grpo/grpo_brief_W.csv [out.png]
"""
import csv
import os
import sys

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt


def main():
    src = sys.argv[1]
    out = sys.argv[2] if len(sys.argv) > 2 else os.path.splitext(src)[0] + ".png"
    rows = list(csv.DictReader(open(src)))
    if not rows:
        return
    step = [int(r["step"]) for r in rows]

    def col(name):
        return [float(r[name]) if r[name] not in ("", None, "None") else float("nan")
                for r in rows]

    fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(8, 8), sharex=True)
    ax1.plot(step, col("mean_reward"), "o-", label="mean reward (window)")
    ax1.plot(step, col("zero_advantage_rate"), "s--", color="tab:red",
             label="zero-advantage rate (window)")
    kl = col("kl")
    if any(v == v for v in kl):
        ax1.plot(step, kl, "^:", color="tab:gray", label="KL")
    else:
        ax1.set_title(f"{os.path.basename(src)} — KL: n/a (beta=0, PREREG-A20 B2)")
    ax1.set_ylabel("rate / mean reward")
    ax1.legend(fontsize=8)
    ax1.grid(alpha=0.3)
    ax2.plot(step, col("heldout_tb_pass_rate"), "o-", label="held-out row-TB pass rate (W reward)")
    ax2.plot(step, col("heldout_strict_pass_rate"), "s-",
             label="held-out strict pass rate (S reward)")
    ax2.plot(step, col("mean_completion_length"), ".:", color="tab:gray",
             label="mean completion length")
    ax2.set_ylabel("held-out (64 rows) / tokens")
    ax2.set_xlabel("training step")
    ax2.legend(fontsize=8)
    ax2.grid(alpha=0.3)
    fig.tight_layout()
    fig.savefig(out, dpi=130)
    print(f"wrote {out}")


if __name__ == "__main__":
    main()
