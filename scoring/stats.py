#!/usr/bin/env python3
"""scoring/stats.py — pinned statistics for the study (A16 §3 step 8 / §6 step 6).

Frozen before G0; sha256 recorded in PREREG.md "Analysis code".

Definitions (pre-registered):
  official pass     : scorer tb == "pass"
  strict-correct    : tb == "pass" AND nonvacuous AND equiv == "equivalent"
  false-pass share  : (official passes that are not strict-correct) / (official passes),
                      computed as a ratio of sums over tasks (never a mean of per-task
                      ratios)
  a16 class of an official pass that is not strict-correct (precedence):
                      equiv=="different"                          -> different
                      equiv=="equivalent" and not nonvacuous     -> vacuous
                      equiv=="timeout"                           -> timeout
                      else                                       -> error
  "formally different within depth d" : equiv == "different"

Bootstrap: task-clustered, 10,000 resamples of tasks with replacement (all samples
of a task move together), numpy.random.default_rng(0), percentile 95% intervals.
Paired contrasts (H1 false-pass-share difference RL-SFT; H2 official-gap minus
strict-gap RL-SFT) resample the SAME task draws for both arms. An interval that
includes zero is reported as "not resolved".

Adapters (for the pre-G0 tests A16 §3 step 8 demands):
  --scores   scores/<arm>.jsonl   (scoring/run_scoring.py output; canonical)
  --pilot    gpt_summary.json     (deep RUN2, 290 verdicts; nonvacuous not recorded
                                   -> assumed True, flagged in meta.assumptions)
  --shakedown results/shakedown/<arm>.json (per_sample score dicts)

Sensitivities: --drop-tasks FILE (contamination), --dedup FILE (per-unique-design:
rows collapse to one per design hash), --rtllm-all38 (headline RTLLM excludes the
four reported-apart designs accu/LIFObuffer/RAM/square_wave unless this is set).
"""
import argparse
import json
import math
import os

REPORTED_APART = ["accu", "LIFObuffer", "RAM", "square_wave"]
N_RESAMPLES = 10_000


def wilson(k, n, z=1.959963984540054):
    """Wilson score interval for k successes in n (blind-sample class shares)."""
    if n == 0:
        return (0.0, 0.0)
    p = k / n
    d = 1 + z * z / n
    c = p + z * z / (2 * n)
    h = z * math.sqrt(p * (1 - p) / n + z * z / (4 * n * n))
    return (max(0.0, (c - h) / d), min(1.0, (c + h) / d))


def a16_class(tb, equiv, nonvacuous):
    if tb != "pass":
        return None
    if tb == "pass" and nonvacuous and equiv == "equivalent":
        return None  # strict-correct, no failure class
    if equiv == "different":
        return "different"
    if equiv == "equivalent" and not nonvacuous:
        return "vacuous"
    if equiv == "timeout":
        return "timeout"
    return "error"


def normalize(row, source):
    """row -> dict(arm, bench, task, tb, equiv, nonvacuous, strict, cls, fdiff)."""
    if source == "scores":
        tb, equiv, nv = row["tb"], row["equiv"], row["nonvacuous"]
        return dict(arm=row["arm"], bench=row["bench"], task=row["task_id"],
                    tb=tb, equiv=equiv, nonvacuous=nv,
                    strict=(tb == "pass" and nv and equiv == "equivalent"),
                    cls=a16_class(tb, equiv, nv), fdiff=(equiv == "different"))
    if source == "pilot":
        tb = row["tb_icarus"]
        cls, ev = row.get("class"), row.get("equiv")
        if ev == "read_error":
            equiv = "error"
        elif cls == "UNBOUNDED-EQ":
            equiv = "equivalent"
        elif cls == "DIFFERENT":
            equiv = "different"
        elif cls and cls.startswith("BMC-"):
            equiv = "error"  # bounded-only: not strict (same bucket as score.py's equiv)
        elif cls == "UNKNOWN":
            equiv = "timeout" if "timeout" in (
                row.get("bmc"), row.get("pdr"), row.get("tind")) else "error"
        else:
            equiv = "skipped" if tb != "pass" else "error"
        nv = True  # not recorded in RUN2; see docstring
        return dict(arm=row["model"], bench="rtllm", task=row["design"],
                    tb=tb, equiv=equiv, nonvacuous=nv,
                    strict=(tb == "pass" and nv and equiv == "equivalent"),
                    cls=a16_class(tb, equiv, nv), fdiff=(equiv == "different"))
    if source == "shakedown":
        s = row.get("score") or {}
        tb, equiv = s.get("tb"), s.get("equiv")
        nv = bool(s.get("nonvacuous"))
        return dict(arm=row.get("arm", "shakedown"), bench=row["bench"],
                    task=row["task_id"], tb=tb, equiv=equiv, nonvacuous=nv,
                    strict=(tb == "pass" and nv and equiv == "equivalent"),
                    cls=a16_class(tb, equiv, nv), fdiff=(equiv == "different"))
    raise ValueError(source)


def load_rows(paths, source):
    rows = []
    for p in paths:
        if source == "shakedown":
            d = json.load(open(p))
            arm = d.get("arm", os.path.basename(p).split(".")[0])
            rows += [normalize({**r, "arm": arm}, "shakedown") for r in d["per_sample"]]
        elif source == "pilot":
            rows += [normalize(r, "pilot") for r in json.load(open(p))]  # JSON array
        else:
            rows += [normalize(json.loads(l), source) for l in open(p)]
    return rows


def by_task(rows):
    t = {}
    for r in rows:
        t.setdefault((r["bench"], r["task"]), []).append(r)
    return t


def metrics(task_map, keys):
    """Point metrics over the given task keys (a task may be absent -> skipped)."""
    present = [k for k in keys if k in task_map]
    n_tasks = len(present)
    samples = sum(len(task_map[k]) for k in present)
    op = [r for k in present for r in task_map[k] if r["tb"] == "pass"]
    sc = [r for k in present for r in task_map[k] if r["strict"]]
    fd = [r for k in present for r in task_map[k] if r["fdiff"]]
    official_p1 = (sum(sum(r["tb"] == "pass" for r in task_map[k]) / len(task_map[k])
                       for k in present) / n_tasks) if n_tasks else None
    strict_p1 = (sum(sum(r["strict"] for r in task_map[k]) / len(task_map[k])
                     for k in present) / n_tasks) if n_tasks else None
    return {
        "tasks": n_tasks, "samples": samples,
        "official_pass_count": len(op), "strict_count": len(sc),
        "official_pass_at_1": official_p1, "strict_pass_at_1": strict_p1,
        "false_pass_share": (len(op) - len(sc)) / len(op) if op else None,
        "formally_different_share": len(fd) / samples if samples else None,
        "classes": {c: sum(1 for r in op if r["cls"] == c)
                    for c in ("different", "vacuous", "timeout", "error")},
    }


def _boot_draw(task_map, keys, draw):
    """One bootstrap draw: resample task keys with replacement, metric ratio-of-sums."""
    present = [k for k in draw if k in task_map]
    op = sc = fd = samples = 0
    op1 = s1 = 0.0
    for k in present:
        rows = task_map[k]
        samples += len(rows)
        o = sum(r["tb"] == "pass" for r in rows)
        s = sum(r["strict"] for r in rows)
        f = sum(r["fdiff"] for r in rows)
        op += o; sc += s; fd += f
        op1 += o / len(rows); s1 += s / len(rows)
    n = len(present)
    return {
        "official_pass_at_1": op1 / n if n else None,
        "strict_pass_at_1": s1 / n if n else None,
        "false_pass_share": (op - sc) / op if op else None,
        "formally_different_share": fd / samples if samples else None,
    }


def bootstrap(task_map, keys, rng):
    keys = sorted(set(keys))
    dists = None
    for _ in range(N_RESAMPLES):
        draw = [keys[rng.integers(len(keys))] for _ in range(len(keys))]
        m = _boot_draw(task_map, keys, draw)
        if dists is None:
            dists = {k: [] for k in m}
        for k, v in m.items():
            if v is not None:
                dists[k].append(v)
    out = {}
    for k, vals in dists.items():
        if not vals:
            out[k] = [None, None]
            continue
        vals.sort()
        out[k] = [vals[int(0.025 * len(vals))], vals[min(len(vals) - 1, int(0.975 * len(vals)))]]
    return out


def paired_contrast(map_a, map_b, keys, which, rng):
    """H1/H2 on the SAME task draws for both arms (keys = union of task keys)."""
    keys = sorted(set(keys))
    h1, h2 = [], []
    for _ in range(N_RESAMPLES):
        draw = [keys[rng.integers(len(keys))] for _ in range(len(keys))]
        ma, mb = _boot_draw(map_a, keys, draw), _boot_draw(map_b, keys, draw)
        if which in ("h1", "both") and ma["false_pass_share"] is not None \
                and mb["false_pass_share"] is not None:
            h1.append(ma["false_pass_share"] - mb["false_pass_share"])
        if which in ("h2", "both"):
            if None not in (ma["official_pass_at_1"], ma["strict_pass_at_1"],
                            mb["official_pass_at_1"], mb["strict_pass_at_1"]):
                h2.append((ma["official_pass_at_1"] - mb["official_pass_at_1"])
                          - (ma["strict_pass_at_1"] - mb["strict_pass_at_1"]))
    def ci(v):
        if not v:
            return {"mean": None, "ci95": [None, None], "resolved": None}
        v.sort()
        lo, hi = v[int(0.025 * len(v))], v[min(len(v) - 1, int(0.975 * len(v)))]
        return {"mean": sum(v) / len(v), "ci95": [lo, hi],
                "resolved": not (lo <= 0.0 <= hi)}
    return {"h1_false_pass_share_diff": ci(h1), "h2_gap_diff": ci(h2)}


def analyze(rows, drop_tasks=(), dedup=None, rtllm_all38=False, pairs=()):
    """rows: normalized. dedup: {(arm,task,sample_idx-esque): design_hash}."""
    if dedup:
        keep = {}
        for r in rows:
            k = (r["arm"], r["bench"], r["task"])
            h = dedup.get(k)
            if h is None:
                keep[(r["arm"], r["bench"], r["task"], id(r))] = r
            else:
                keep.setdefault((r["arm"], r["bench"], h), r)
        rows = list(keep.values())
    if drop_tasks:
        rows = [r for r in rows if r["task"] not in drop_tasks]
    if not rtllm_all38:
        rows = [r for r in rows if not (r["bench"] == "rtllm" and r["task"] in REPORTED_APART)]

    arms = sorted({r["arm"] for r in rows})
    out = {"arms": {}, "pairs": {}, "n_resamples": N_RESAMPLES}
    for arm in arms:
        out["arms"][arm] = {}
        for bench in sorted({r["bench"] for r in rows if r["arm"] == arm}):
            sub = [r for r in rows if r["arm"] == arm and r["bench"] == bench]
            tm = by_task(sub)
            keys = list(tm)
            rng = __import__("numpy.random", fromlist=["default_rng"]).default_rng(0)
            out["arms"][arm][bench] = {"point": metrics(tm, keys),
                                       "ci95": bootstrap(tm, keys, rng)}
    for name, ra, rb in pairs:
        ma_all, mb_all = by_task([r for r in rows if r["arm"] == ra]), \
                         by_task([r for r in rows if r["arm"] == rb])
        keys = sorted(set(ma_all) | set(mb_all))
        rng = __import__("numpy.random", fromlist=["default_rng"]).default_rng(0)
        out["pairs"][name] = {"arm_a": ra, "arm_b": rb,
                              **paired_contrast(ma_all, mb_all, keys, "both", rng)}
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--scores", nargs="*", default=[], help="run_scoring jsonl files")
    ap.add_argument("--pilot", nargs="*", default=[], help="deep gpt_summary.json files")
    ap.add_argument("--shakedown", nargs="*", default=[], help="results/shakedown/<arm>.json files")
    ap.add_argument("--drop-tasks", default="", help="file: one contaminated task per line")
    ap.add_argument("--dedup", default="", help="file: json {(arm,bench,task): design_hash}")
    ap.add_argument("--rtllm-all38", action="store_true")
    ap.add_argument("--pair", action="append", default=[], metavar="NAME:ARM_A:ARM_B",
                    help="e.g. h_7b:7b-rl:7b-sft")
    ap.add_argument("--out", default="")
    args = ap.parse_args()

    rows = []
    assumptions = []
    if args.scores:
        rows += load_rows(args.scores, "scores")
    if args.pilot:
        rows += load_rows(args.pilot, "pilot")
        assumptions.append("pilot rows carry no nonvacuous field; assumed True")
    if args.shakedown:
        rows += load_rows(args.shakedown, "shakedown")
        assumptions.append("shakedown rows are machinery checks, never results")

    drop = set(l.strip() for l in open(args.drop_tasks)) if args.drop_tasks else ()
    dedup = json.load(open(args.dedup)) if args.dedup else None
    dedup = {tuple(json.loads(k) if k.startswith("[") else k.split("|", 2)): v
             for k, v in dedup.items()} if dedup else None
    pairs = []
    for p in args.pair:
        n, a, b = p.split(":")
        pairs.append((n, a, b))

    res = analyze(rows, drop_tasks=drop, dedup=dedup,
                  rtllm_all38=args.rtllm_all38, pairs=pairs)
    res["meta"] = {"rows": len(rows), "assumptions": assumptions}
    txt = json.dumps(res, indent=1)
    if args.out:
        os.makedirs(os.path.dirname(args.out) or ".", exist_ok=True)
        open(args.out, "w").write(txt)
    print(txt)


if __name__ == "__main__":
    main()
