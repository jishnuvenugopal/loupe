#!/usr/bin/env python3
"""Independent recompute of the headline numbers.

Written from the definitions in PREREG.md ("Primary outcome", "Secondary",
"Analysis plan"), without importing or copying scoring/stats.py. Reads only
the committed per-sample scores (scores/<arm>.jsonl) and the gate lists
(scoring/gates/). It uses its own bootstrap seed, so its intervals are a
second random draw, not a copy.

    python3 verify/recompute.py . recompute.json
"""
import json
import os
import sys

import numpy as np

ARMS = ["7b-rl", "7b-sft", "7b-base", "3b-rl", "3b-base"]
BENCHES = ["ve", "rtllm"]
N_BOOT = 10_000
SEED = 20261021  # deliberately not the Spark's seed 0


def load_gates(repo):
    def rd(name):
        with open(os.path.join(repo, "scoring/gates", name)) as f:
            return {l.strip() for l in f if l.strip()}
    rt = rd("rtllm_strict.txt") - rd("rtllm_apart.txt")
    return {"ve": rd("ve_strict.txt"), "rtllm": rt}


def outcome(r):
    """Per-sample flags straight from the scorer fields, per PREREG 'Primary outcome'."""
    op = r["tb"] == "pass"
    vc = r.get("vclass") or ""
    pc = op and bool(r["nonvacuous"]) and vc == "UNBOUNDED-EQ"
    cw = op and bool(r["nonvacuous"]) and (vc == "UNBOUNDED-EQ" or vc.startswith("BMC-"))
    pw = op and (vc == "DIFFERENT" or r.get("equiv") == "different")
    return op, pc, cw, pw


def task_table(rows):
    """task -> [samples, official, proved_correct, within_d, proved_wrong]"""
    t = {}
    for r in rows:
        a = t.setdefault(r["task_id"], [0, 0, 0, 0, 0])
        a[0] += 1
        for i, v in enumerate(outcome(r), start=1):
            a[i] += int(v)
    return t


def point(arr):
    s, o, p, w, d = arr.T
    return {
        "official_pass_at_1": float(np.mean(o / s)),
        "strict_pass_at_1": float(np.mean(p / s)),
        "official_passes": int(o.sum()),
        "not_proved_correct_share": float((o.sum() - p.sum()) / o.sum()) if o.sum() else None,
        "not_correct_within_d_share": float((o.sum() - w.sum()) / o.sum()) if o.sum() else None,
        "proved_wrong_share": float(d.sum() / o.sum()) if o.sum() else None,
    }


def boot(arr, idx):
    """Vectorised task-clustered bootstrap; idx is (N_BOOT, n_tasks)."""
    s, o, p, w, d = (arr[:, i][idx] for i in range(5))
    O = o.sum(1)
    with np.errstate(invalid="ignore", divide="ignore"):
        return {
            "official_pass_at_1": (o / s).mean(1),
            "strict_pass_at_1": (p / s).mean(1),
            "not_proved_correct_share": (O - p.sum(1)) / O,
            "not_correct_within_d_share": (O - w.sum(1)) / O,
            "proved_wrong_share": d.sum(1) / O,
        }


def ci(v):
    v = v[~np.isnan(v)]
    return [float(np.percentile(v, 2.5)), float(np.percentile(v, 97.5))]


def main(repo, out):
    gates = load_gates(repo)
    rng = np.random.default_rng(SEED)
    res = {"seed": SEED, "n_boot": N_BOOT, "gates": {b: len(g) for b, g in gates.items()},
           "arms": {}, "class_field_mismatches": 0, "pairs": {}}
    pooled = {}
    for arm in ARMS:
        with open(os.path.join(repo, "scores", f"{arm}.jsonl")) as f:
            rows = [json.loads(l) for l in f]
        res["arms"][arm] = {}
        for bench in BENCHES:
            sub = [r for r in rows if r["bench"] == bench]
            all_tt = task_table(sub)
            gated = {k: v for k, v in all_tt.items() if k in gates[bench]}
            keys = sorted(gated)
            arr = np.array([gated[k] for k in keys], dtype=float)
            pooled.setdefault(arm, {}).update({(bench, k): gated[k] for k in keys})
            idx = rng.integers(0, len(keys), size=(N_BOOT, len(keys)))
            b = boot(arr, idx)
            all_arr = np.array([all_tt[k] for k in sorted(all_tt)], dtype=float)
            all_idx = rng.integers(0, len(all_arr), size=(N_BOOT, len(all_arr)))
            res["arms"][arm][bench] = {
                "tasks": len(keys),
                "point": point(arr),
                "ci95": {k: ci(v) for k, v in b.items()},
                "official_pass_at_1_all_tasks": float(np.mean(all_arr[:, 1] / all_arr[:, 0])),
                "ci95_all_tasks": ci(boot(all_arr, all_idx)["official_pass_at_1"]),
            }
            # cross-check the scorer's own class label against the raw fields
            for r in sub:
                if r["task_id"] not in gates[bench] or r["tb"] != "pass":
                    continue
                op, pc, cw, pw = outcome(r)
                want = None if pc else ("different" if pw else
                                        "bounded-only" if cw else r.get("class"))
                if r.get("class") != want and not (want is None and r.get("class") == "vacuous"):
                    res["class_field_mismatches"] += 1

    # H1 / H1-floor / H2: RL vs Distill, pooled over both gated benchmarks,
    # paired on the same task draws (PREREG 'Secondary' + 'Statistics').
    a, bb = pooled["7b-rl"], pooled["7b-sft"]
    keys = sorted(set(a) | set(bb))
    A = np.array([a.get(k, [0] * 5) for k in keys], dtype=float)
    B = np.array([bb.get(k, [0] * 5) for k in keys], dtype=float)
    idx = rng.integers(0, len(keys), size=(N_BOOT, len(keys)))
    pa, pb = point(A), point(B)
    ba, bbb = boot(A, idx), boot(B, idx)
    contrasts = {
        "h1_not_proved_correct": (pa["not_proved_correct_share"] - pb["not_proved_correct_share"],
                                  ba["not_proved_correct_share"] - bbb["not_proved_correct_share"]),
        "h1_floor_proved_wrong": (pa["proved_wrong_share"] - pb["proved_wrong_share"],
                                  ba["proved_wrong_share"] - bbb["proved_wrong_share"]),
        "h2_pass1_gap": ((pa["official_pass_at_1"] - pb["official_pass_at_1"])
                         - (pa["strict_pass_at_1"] - pb["strict_pass_at_1"]),
                         (ba["official_pass_at_1"] - bbb["official_pass_at_1"])
                         - (ba["strict_pass_at_1"] - bbb["strict_pass_at_1"])),
    }
    for name, (pt, dist) in contrasts.items():
        lo, hi = ci(dist)
        res["pairs"][name] = {"point": float(pt), "boot_mean": float(np.nanmean(dist)),
                              "ci95": [lo, hi], "resolved": not (lo <= 0 <= hi)}

    with open(out, "w") as f:
        json.dump(res, f, indent=1)
    print(f"wrote {out}")


if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
