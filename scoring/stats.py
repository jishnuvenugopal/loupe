#!/usr/bin/env python3
"""scoring/stats.py — pinned statistics for the study (A16 §3 step 8 / §6 step 6;
REVISED by amendment A17 items 1, 3, 4, 2, 5 — this version is the pre-G0 pin).

Two definitions of correct, one primary (A17 item 1). Classes of an official
pass (tb == "pass"), read from the frozen score.py verdict `class` field:

  proved equivalent : UNBOUNDED-EQ
  bounded only      : BMC-N-EQ-ONLY (equivalent up to depth d, no unbounded proof)
  proved wrong      : DIFFERENT (has a counterexample)
  unverified        : UNKNOWN (timeout or engine error) or equiv == "error"
                      (port/read failures); reported as `timeout` when an engine
                      said timeout, else `error`
  vacuous           : tb passed but checked nothing (nonvacuous false) — a flag
                      reported with each class; it overrides the class count slot

Definitions (PREREG.md):
  proved correct            = official pass AND non-vacuous AND UNBOUNDED-EQ
  correct within depth d    = official pass AND non-vacuous AND
                              (UNBOUNDED-EQ or BMC-N-EQ-ONLY)
  PRIMARY  not-proved-correct share = official passes not proved correct /
                              official passes
  companion not-correct-within-depth-d share = official passes not correct
                              within depth d / official passes
  floor    proved-wrong share = DIFFERENT official passes / official passes
The three nest: proved wrong <= not correct within depth d <= not proved
correct. The step companion -> primary is the bounded-only share; the step
floor -> companion is the unverified share (plus any vacuous passes).

score.py is FROZEN (tag scorer-v1): it sets equiv = "equivalent" only for
UNBOUNDED-EQ; BMC-N-EQ-ONLY lands in equiv "error". That behaviour is kept and
this module re-derives the A17 classes from verdict["class"], never from a
re-cut of score.py. Strict pass@1 (H2) uses "proved correct"; its companion
uses "correct within depth d". H1 runs on the primary share; the same contrast
on the proved-wrong share is a pre-registered sensitivity row (engine success
can differ between arms).

Bootstrap: task-clustered, 10,000 resamples of tasks with replacement,
numpy.random.default_rng(0), percentile 95% intervals; paired contrasts
resample the SAME task draws for both arms. Interval containing zero is
reported as "not resolved". Wordinq rule: the primary share is never called
"false passes" or "wrong"; every headline number appears with the proved-wrong
floor beside it.

Gates (A17 item 2): every STRICT metric runs only on the committed gate lists
(scoring/gates/ve_strict.txt = 144, rtllm_strict.txt = 37 — references whose
self-equivalence is UNBOUNDED-EQ, their own TB passes under Icarus, they read
in Yosys; div_16bit and Prob099 stay out). Official pass@1 (G1b) runs on all
156 / 50 tasks. Headline RTLLM = 33 (37 minus accu/LIFObuffer/RAM/
square_wave, listed in rtllm_apart.txt); --rtllm-all37 is the sensitivity.
--wide-gate adds wide_bmc.txt (149 / 40) for the within-depth-d companion.

Adapters (pre-G0 smoke tests, A17 item 2): --scores (canonical run_scoring
rows), --pilot (deep RUN2 290), --shakedown (results/shakedown/<arm>.json).

Sensitivities: --drop-tasks (contamination), --dedup (per-unique-design, keyed
(arm, bench, task, sample_idx) — A17 item 4), --rtllm-all37, --wide-gate.
"""
import argparse
import json
import os

GATES_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "gates")
N_RESAMPLES = 10_000
CLASSES = ("different", "bounded-only", "timeout", "error", "vacuous")


def wilson(k, n, z=1.959963984540054):
    """Wilson score interval for k successes in n (blind-sample class shares)."""
    if n == 0:
        return (0.0, 0.0)
    p = k / n
    d = 1 + z * z / n
    c = p + z * z / (2 * n)
    h = z * math_sqrt(p * (1 - p) / n + z * z / (4 * n * n))
    return (max(0.0, (c - h) / d), min(1.0, (c + h) / d))


def math_sqrt(x):
    import math
    return math.sqrt(x)


def a16_class(tb, equiv, nonvacuous, vclass=None):
    """A17 item 1 class of an official pass (name kept: run_scoring imports it).

    vclass is the frozen score.py verdict["class"]: UNBOUNDED-EQ, BMC-N-EQ-ONLY,
    DIFFERENT, UNKNOWN. vacuous overrides (flag reported with each class).
    Returns None for non-passes and for proved-correct passes.
    """
    if tb != "pass":
        return None
    if tb == "pass" and nonvacuous and vclass == "UNBOUNDED-EQ":
        return None  # proved correct
    if not nonvacuous:
        return "vacuous"
    if vclass == "DIFFERENT" or equiv == "different":
        return "different"
    if vclass and vclass.startswith("BMC-"):
        return "bounded-only"
    if vclass == "UNKNOWN" or equiv in ("error", "read_error"):
        return "timeout" if equiv == "timeout" else "error"
    if equiv == "timeout":
        return "timeout"
    if equiv == "equivalent":  # nonvacuous equivalent without vclass: proved
        return None
    return "error"


def proved_correct(tb, nonvacuous, vclass):
    return tb == "pass" and nonvacuous and vclass == "UNBOUNDED-EQ"


def correct_within_d(tb, nonvacuous, vclass):
    return (tb == "pass" and nonvacuous and
            (vclass == "UNBOUNDED-EQ" or (vclass or "").startswith("BMC-")))


def normalize(row, source):
    """row -> dict(arm, bench, task, sample_idx, tb, nonvacuous, vclass, equiv)."""
    if source == "scores":
        v = row.get("verdict") or {}
        return dict(arm=row["arm"], bench=row["bench"], task=row["task_id"],
                    sample_idx=row.get("sample_idx"), tb=row["tb"],
                    equiv=row.get("equiv"), nonvacuous=bool(row.get("nonvacuous")),
                    vclass=v.get("class"))
    if source == "pilot":
        tb = row["tb_icarus"]
        vclass = row.get("class")
        equiv = row.get("equiv")
        if equiv == "read_error":
            equiv = "error"
        elif vclass == "UNBOUNDED-EQ":
            equiv = "equivalent"
        elif vclass == "DIFFERENT":
            equiv = "different"
        elif vclass and vclass.startswith("BMC-"):
            equiv = "error"  # frozen score.py maps BMC-only to equiv "error"
        elif vclass == "UNKNOWN":
            equiv = "timeout" if "timeout" in (
                row.get("bmc"), row.get("pdr"), row.get("tind")) else "error"
        else:
            equiv = "skipped" if tb != "pass" else "error"
        return dict(arm=row["model"], bench="rtllm", task=row["design"],
                    sample_idx=row.get("trial"), tb=tb, equiv=equiv,
                    nonvacuous=True,  # not recorded in RUN2 (assumption, flagged)
                    vclass=vclass)
    if source == "shakedown":
        s = row.get("score") or {}
        return dict(arm=row.get("arm", "shakedown"), bench=row["bench"],
                    task=row["task_id"], sample_idx=row.get("sample_idx"),
                    tb=s.get("tb"), equiv=s.get("equiv"),
                    nonvacuous=bool(s.get("nonvacuous")), vclass=s.get("class"))
    raise ValueError(source)


def load_rows(paths, source):
    rows = []
    for p in paths:
        if source == "shakedown":
            d = json.load(open(p))
            arm = d.get("arm", os.path.basename(p).split(".")[0])
            rows += [normalize({**r, "arm": arm}, "shakedown") for r in d["per_sample"]]
        elif source == "pilot":
            rows += [normalize(r, "pilot") for r in json.load(open(p))]
        else:
            rows += [normalize(json.loads(l), source) for l in open(p)]
    return rows


def load_gates(wide=False, rtllm_all37=False):
    def rd(f):
        p = os.path.join(GATES_DIR, f)
        return set(l.strip() for l in open(p)) if os.path.isfile(p) else None
    ve, rt = rd("ve_strict.txt"), rd("rtllm_strict.txt")
    apart = rd("rtllm_apart.txt") or set()
    if wide:  # 149 / 40: the BMC-only references go back in (companion only)
        wb = rd("wide_bmc.txt") or set()
        ve = (ve | {t for t in wb if t.startswith("Prob")})
        rt = rt | {t for t in wb if not t.startswith("Prob")}
    if not rtllm_all37:
        rt = rt - apart          # headline: 33
    return {"ve": ve, "rtllm": rt, "ve_wide": wide, "rtllm_all37": rtllm_all37}


def by_task(rows):
    t = {}
    for r in rows:
        t.setdefault((r["bench"], r["task"]), []).append(r)
    return t


def metrics(task_map, keys):
    """Point metrics over the given task keys (A17 items 1 and 3)."""
    present = [k for k in keys if k in task_map]
    n_tasks = len(present)
    samples = sum(len(task_map[k]) for k in present)
    op = [r for k in present for r in task_map[k] if r["tb"] == "pass"]
    pc = [r for r in op if proved_correct(r["tb"], r["nonvacuous"], r["vclass"])]
    cw = [r for r in op if correct_within_d(r["tb"], r["nonvacuous"], r["vclass"])]
    pw = [r for r in op if r["vclass"] == "DIFFERENT" or r["equiv"] == "different"]
    official_p1 = (sum(sum(r["tb"] == "pass" for r in task_map[k]) / len(task_map[k])
                       for k in present) / n_tasks) if n_tasks else None
    strict_p1 = (sum(sum(proved_correct(r["tb"], r["nonvacuous"], r["vclass"])
                         for r in task_map[k]) / len(task_map[k])
                     for k in present) / n_tasks) if n_tasks else None
    strict_wd_p1 = (sum(sum(correct_within_d(r["tb"], r["nonvacuous"], r["vclass"])
                            for r in task_map[k]) / len(task_map[k])
                        for k in present) / n_tasks) if n_tasks else None
    cls = {c: 0 for c in CLASSES}
    for r in op:
        c = a16_class(r["tb"], r["equiv"], r["nonvacuous"], r["vclass"])
        if c:
            cls[c] += 1
    return {
        "tasks": n_tasks, "samples": samples,
        "official_pass_count": len(op),
        "proved_correct_count": len(pc), "correct_within_d_count": len(cw),
        "official_pass_at_1": official_p1,
        "strict_pass_at_1": strict_p1, "strict_within_d_pass_at_1": strict_wd_p1,
        # primary / companion / floor (A17 item 1); denominators are official
        # passes, including in the bootstrap (item 3)
        "not_proved_correct_share": (len(op) - len(pc)) / len(op) if op else None,
        "not_correct_within_d_share": (len(op) - len(cw)) / len(op) if op else None,
        "proved_wrong_share": len(pw) / len(op) if op else None,
        "classes": cls,
    }


def _boot_draw(task_map, keys, draw):
    """One bootstrap draw: resample task keys with replacement; shares are
    ratios of sums over the resampled tasks (official passes = denominator)."""
    present = [k for k in draw if k in task_map]
    op = pc = cw = pw = samples = 0
    op1 = sp1 = sw1 = 0.0
    for k in present:
        rows = task_map[k]
        samples += len(rows)
        o = sum(r["tb"] == "pass" for r in rows)
        p = sum(proved_correct(r["tb"], r["nonvacuous"], r["vclass"]) for r in rows)
        w = sum(correct_within_d(r["tb"], r["nonvacuous"], r["vclass"]) for r in rows)
        d = sum(r["vclass"] == "DIFFERENT" or r["equiv"] == "different" for r in rows)
        op += o; pc += p; cw += w; pw += d
        op1 += o / len(rows); sp1 += p / len(rows); sw1 += w / len(rows)
    n = len(present)
    return {
        "official_pass_at_1": op1 / n if n else None,
        "strict_pass_at_1": sp1 / n if n else None,
        "strict_within_d_pass_at_1": sw1 / n if n else None,
        "not_proved_correct_share": (op - pc) / op if op else None,
        "not_correct_within_d_share": (op - cw) / op if op else None,
        "proved_wrong_share": pw / op if op else None,
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


def _rng():
    import numpy.random
    return numpy.random.default_rng(0)


def paired_contrast(map_a, map_b, keys, metric, rng):
    """H1 (primary share) / H1-floor (proved-wrong share) on the SAME draws."""
    keys = sorted(set(keys))
    out = {}
    for name in (metric, metric + "_floor"):
        v = []
        for _ in range(N_RESAMPLES):
            draw = [keys[rng.integers(len(keys))] for _ in range(len(keys))]
            ma = _boot_draw(map_a, keys, draw)
            mb = _boot_draw(map_b, keys, draw)
            ka = "proved_wrong_share" if name.endswith("_floor") else metric
            if ma.get(ka) is not None and mb.get(ka) is not None:
                v.append(ma[ka] - mb[ka])
        v.sort()
        if not v:
            out[name] = {"mean": None, "ci95": [None, None], "resolved": None}
            continue
        lo, hi = v[int(0.025 * len(v))], v[min(len(v) - 1, int(0.975 * len(v)))]
        out[name] = {"mean": sum(v) / len(v), "ci95": [lo, hi],
                     "resolved": not (lo <= 0.0 <= hi)}
    return out


def analyze(rows, drop_tasks=(), dedup=None, wide=False, rtllm_all37=False, pairs=()):
    gates = load_gates(wide=wide, rtllm_all37=rtllm_all37)
    if dedup:  # A17 item 4: key (arm, bench, task, sample_idx)
        keep = {}
        for r in rows:
            k = (r["arm"], r["bench"], r["task"], r["sample_idx"])
            h = dedup.get(k)
            if h is None:
                keep[("id", id(r))] = r
            else:
                keep.setdefault((r["arm"], r["bench"], h), r)
        rows = list(keep.values())
    if drop_tasks:
        rows = [r for r in rows if r["task"] not in drop_tasks]

    def gated(r):
        g = gates[r["bench"]]
        return g is None or r["task"] in g

    arms = sorted({r["arm"] for r in rows})
    out = {"arms": {}, "pairs": {}, "n_resamples": N_RESAMPLES,
           "gates": {"ve": len(gates["ve"]), "rtllm": len(gates["rtllm"]),
                     "wide": wide, "rtllm_all37": rtllm_all37}}
    for arm in arms:
        out["arms"][arm] = {}
        for bench in sorted({r["bench"] for r in rows if r["arm"] == arm}):
            sub = [r for r in rows if r["arm"] == arm and r["bench"] == bench]
            # official pass@1 on ALL tasks (G1b); strict metrics on the gate only
            tm_all = by_task(sub)
            tm = by_task([r for r in sub if gated(r)])
            keys = list(tm)
            m = metrics(tm, keys)
            m["official_pass_at_1_all_tasks"] = (
                sum(sum(r["tb"] == "pass" for r in v) / len(v) for v in tm_all.values())
                / len(tm_all)) if tm_all else None
            out["arms"][arm][bench] = {"point": m, "ci95": bootstrap(tm, keys, _rng())}
    for name, ra, rb in pairs:
        ma_all = by_task([r for r in rows if r["arm"] == ra and gated(r)])
        mb_all = by_task([r for r in rows if r["arm"] == rb and gated(r)])
        keys = sorted(set(ma_all) | set(mb_all))
        out["pairs"][name] = {"arm_a": ra, "arm_b": rb, "metric": "not_proved_correct_share",
                              **paired_contrast(ma_all, mb_all, keys,
                                                "not_proved_correct_share", _rng())}
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--scores", nargs="*", default=[])
    ap.add_argument("--pilot", nargs="*", default=[])
    ap.add_argument("--shakedown", nargs="*", default=[])
    ap.add_argument("--drop-tasks", default="")
    ap.add_argument("--dedup", default="",
                    help="json {(arm,bench,task,sample_idx): design_hash}")
    ap.add_argument("--rtllm-all37", action="store_true",
                    help="sensitivity: all 37 usable RTLLM designs (adds the 4 apart)")
    ap.add_argument("--wide-gate", action="store_true",
                    help="sensitivity: 149/40 gate (BMC-only references back in);"
                         " read the within-depth-d companion only")
    ap.add_argument("--pair", action="append", default=[], metavar="NAME:ARM_A:ARM_B")
    ap.add_argument("--out", default="")
    args = ap.parse_args()

    rows, assumptions = [], []
    if args.scores:
        rows += load_rows(args.scores, "scores")
    if args.pilot:
        rows += load_rows(args.pilot, "pilot")
        assumptions.append("pilot rows carry no nonvacuous field; assumed True")
    if args.shakedown:
        rows += load_rows(args.shakedown, "shakedown")
        assumptions.append("shakedown rows are machinery checks, never results")

    drop = set(l.strip() for l in open(args.drop_tasks)) if args.drop_tasks else ()
    dedup = None
    if args.dedup:
        raw = json.load(open(args.dedup))
        dedup = {}
        for k, v in raw.items():
            a, b, t, s = json.loads(k) if k.startswith("[") else k.split("|", 3)
            dedup[(a, b, t, s)] = v
    pairs = []
    for p in args.pair:
        n, a, b = p.split(":")
        pairs.append((n, a, b))

    res = analyze(rows, drop_tasks=drop, dedup=dedup, wide=args.wide_gate,
                  rtllm_all37=args.rtllm_all37, pairs=pairs)
    res["meta"] = {"rows": len(rows), "assumptions": assumptions}
    txt = json.dumps(res, indent=1)
    if args.out:
        os.makedirs(os.path.dirname(args.out) or ".", exist_ok=True)
        open(args.out, "w").write(txt)
    print(txt)


if __name__ == "__main__":
    main()
