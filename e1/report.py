#!/usr/bin/env python3
"""e1/report.py — E1 tables and contrasts (PREREG-A20 B4), exploratory.

Reads scores_e1/*.jsonl (rows written by the pinned scoring/run_scoring.py)
and computes, per E1 arm × benchmark, via the PINNED scoring/stats.py
(identical methodology to the primary table: gate lists, A17/A18 class
definitions, task-clustered bootstrap, 10,000 resamples, default_rng(0)):
  official pass@1 (all tasks in the E1 gated files), not-proved-correct
  share, correct-within-depth-d share, proved-wrong floor — each with its
  task-clustered 95% CI.
Contrasts (paired, same task draws, both arms): W − base, S − base, S − W for
OFFICIAL pass@1 and for the not-proved-correct share, per completed setting.
The official-pass@1 contrast is computed here (stats.paired_contrast covers
shares and the H2 gap; this adds the plain pass@1 difference with the same
recipe). G2 extraction check per file is reported as-is (no waivers).

Writes results/e1/stats.json and results/e1/summary.md.
Usage (host): python3 e1/report.py
"""
import glob
import json
import os
import sys

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(REPO, "scoring"))
import stats as S  # pinned (PREREG "Analysis code"); imported, never modified


def paired_diff(map_a, map_b, keys, key, rng):
    """Same recipe as stats.paired_contrast: same task draws for both arms."""
    keys = sorted(set(keys))
    v = []
    for _ in range(S.N_RESAMPLES):
        draw = [keys[rng.integers(len(keys))] for _ in range(len(keys))]
        ma = S._boot_draw(map_a, keys, draw)
        mb = S._boot_draw(map_b, keys, draw)
        if ma.get(key) is not None and mb.get(key) is not None:
            v.append(ma[key] - mb[key])
    if not v:
        return {"mean": None, "ci95": [None, None], "resolved": None}
    v.sort()
    lo, hi = v[int(0.025 * len(v))], v[min(len(v) - 1, int(0.975 * len(v)))]
    return {"mean": sum(v) / len(v), "ci95": [lo, hi], "resolved": not (lo <= 0.0 <= hi)}


def main():
    files = sorted(glob.glob(os.path.join(REPO, "scores_e1/*.jsonl")))
    if not files:
        sys.exit("no scores_e1/*.jsonl — run e1/run_e1.py first")
    rows = S.load_rows(files, "scores")
    gates = S.load_gates()

    def gated(r):
        return r["task"] in gates[r["bench"]]

    res = {"arms": {}, "pairs": {}, "n_resamples": S.N_RESAMPLES}
    arms = sorted({r["arm"] for r in rows})
    for arm in arms:
        res["arms"][arm] = {}
        for bench in sorted({r["bench"] for r in rows if r["arm"] == arm}):
            sub = [r for r in rows if r["arm"] == arm and r["bench"] == bench]
            tm_all = S.by_task(sub)
            tm = S.by_task([r for r in sub if gated(r)])
            m = S.metrics(tm, list(tm))
            m["official_pass_at_1_all_tasks"] = (
                sum(sum(r["tb"] == "pass" for r in v) / len(v) for v in tm_all.values())
                / len(tm_all)) if tm_all else None
            res["arms"][arm][bench] = {
                "point": m,
                "ci95": S.bootstrap(tm, list(tm), S._rng()),
                "ci95_all_tasks": S.bootstrap_official(tm_all, list(tm_all), S._rng()),
            }

    # contrasts per completed setting: W − base, S − base, S − W
    settings = {"100": ("e1-w100", "e1-s100"), "ext": ("e1-wext", "e1-sext")}
    for st, (w, s) in settings.items():
        for name, ra, rb in ((f"w{st}_minus_base", w, "e1-base"),
                             (f"s{st}_minus_base", s, "e1-base"),
                             (f"s{st}_minus_w{st}", s, w)):
            if ra not in arms or rb not in arms:
                continue
            cell = {"arm_a": ra, "arm_b": rb}
            for bench in ("ve", "rtllm"):
                ma = S.by_task([r for r in rows if r["arm"] == ra and r["bench"] == bench
                                and gated(r)])
                mb = S.by_task([r for r in rows if r["arm"] == rb and r["bench"] == bench
                                and gated(r)])
                keys = sorted(set(ma) | set(mb))
                if not keys:
                    continue
                cell[bench] = {
                    "official_pass_at_1": paired_diff(ma, mb, keys, "official_pass_at_1", S._rng()),
                    "not_proved_correct_share": paired_diff(
                        ma, mb, keys, "not_proved_correct_share", S._rng()),
                }
            res["pairs"][name] = cell

    g2p = os.path.join(REPO, "results/e1/g2.json")
    res["g2"] = json.load(open(g2p)) if os.path.isfile(g2p) else None
    out = os.path.join(REPO, "results/e1/stats.json")
    os.makedirs(os.path.dirname(out), exist_ok=True)
    json.dump(res, open(out, "w"), indent=1)

    def f(v):
        return "–" if v is None else f"{100 * v:.1f}"

    def ci(c, k):
        return "–" if c[k][0] is None else f"[{100 * c[k][0]:.1f}, {100 * c[k][1]:.1f}]"

    L = ["# E1 — exploratory evaluation (PREREG-A20 B4)", "",
         f"Written by e1/report.py. Arms: {', '.join(arms)}. Scores: `scores_e1/` "
         "(pinned scoring/run_scoring.py; frozen scorer-v1; same task-clustered "
         "bootstrap as the primary table). Exploratory: never feeds the primary "
         "results.", "",
         "## Per-arm table (gated sets: VE 144, RTLLM 33 headline)", "",
         "| arm | bench | tasks | official pass@1 | not proved correct % [CI] | "
         "not correct within d % [CI] | proved wrong % [CI] | classes |", "",
         "|---|---|---|---|---|---|---|---|"]
    for arm in arms:
        for bench, cell in sorted(res["arms"][arm].items()):
            p, c = cell["point"], cell["ci95"]
            cls = p["classes"]
            L.append(f"| {arm} | {bench} | {p['tasks']} | {f(p['official_pass_at_1_all_tasks'])} | "
                     f"{f(p['not_proved_correct_share'])} {ci(c, 'not_proved_correct_share')} | "
                     f"{f(p['not_correct_within_d_share'])} {ci(c, 'not_correct_within_d_share')} | "
                     f"{f(p['proved_wrong_share'])} {ci(c, 'proved_wrong_share')} | "
                     f"diff {cls['different']}, bnd {cls['bounded-only']}, tmo {cls['timeout']}, "
                     f"err {cls['error']}, vac {cls['vacuous']} |")
    L += ["", "Source: `results/e1/stats.json`.", "", "## Contrasts (paired, same task draws)", "",
          "| contrast | bench | official pass@1 diff [CI] | not-proved-correct diff [CI] |", "",
          "|---|---|---|---|"]
    for name, cell in res["pairs"].items():
        for bench in ("ve", "rtllm"):
            if bench not in cell:
                continue
            o, n = cell[bench]["official_pass_at_1"], cell[bench]["not_proved_correct_share"]
            L.append(f"| {name} ({cell['arm_a']} − {cell['arm_b']}) | {bench} | "
                     f"{f(o['mean'])} pp {ci(o, 'ci95')} | "
                     f"{f(n['mean'])} pp {ci(n, 'ci95')} |")
    L += ["", "An interval that includes zero is reported as not resolved.", ""]
    if res["g2"]:
        L += ["## G2 extraction check (reported as-is; exploratory — no waivers)", ""]
        for fn, g in res["g2"].items():
            if g:
                L.append(f"- {fn}: share {g.get('share')} "
                         f"({'pass' if g.get('g2_pass') else 'below 0.95 — flagged'})")
        L.append("")
    open(os.path.join(REPO, "results/e1/summary.md"), "w").write("\n".join(L) + "\n")
    print("wrote results/e1/stats.json and results/e1/summary.md")


if __name__ == "__main__":
    main()
