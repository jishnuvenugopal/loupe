#!/usr/bin/env python3
"""Check that the numbers in README.md come from the committed data.

Steps:
1. Recompute the headline table from the per-sample scores (verify/recompute.py,
   independent code) and compare every point estimate with results/main/stats.json.
2. Compare every number inside the marked README tables with those files:
   - headline table  <- recompute (points) and results/main/stats.json (intervals)
   - contrasts table <- recompute (points, calls) and stats.json (intervals)
   - blind-40 table  <- results/main/blind40/unblinded.ai.json
   - GRPO/E1 table   <- results/e1/stats.json
3. Exit 1 if any value differs.

    python3 verify/check.py            # from the repository root
"""
import json
import os
import re
import sys
import tempfile

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(ROOT, "verify"))
import recompute  # noqa: E402

FAILS = []


def check(name, ok, detail=""):
    if not ok:
        FAILS.append(f"{name}: {detail}")


def pct(x):
    return f"{100 * x:.1f}"


def ci_txt(c):
    return f"[{100 * c[0]:.1f}, {100 * c[1]:.1f}]"


def signed(x):
    return f"{100 * x:+.1f}"


def table(readme, tag):
    m = re.search(rf"<!-- {tag}:begin -->(.*?)<!-- {tag}:end -->", readme, re.S)
    if not m:
        FAILS.append(f"README: table '{tag}' not found")
        return []
    rows = []
    for line in m.group(1).splitlines():
        line = line.strip()
        if not line.startswith("|") or set(line) <= set("|-: "):
            continue
        cells = [c.strip().replace("**", "") for c in line.strip("|").split("|")]
        rows.append(cells)
    return rows[1:]  # drop the header row


def load(path):
    with open(os.path.join(ROOT, path)) as f:
        return json.load(f)


def main():
    with tempfile.TemporaryDirectory() as tmp:
        out = os.path.join(tmp, "recompute.json")
        recompute.main(ROOT, out)
        rc = json.load(open(out))
    st = load("results/main/stats.json")

    # 1. recompute vs the pre-registered analysis output
    check("gates", rc["gates"] == {"ve": 144, "rtllm": 33}, rc["gates"])
    check("class field", rc["class_field_mismatches"] == 0, rc["class_field_mismatches"])
    fields = ["official_pass_at_1", "strict_pass_at_1", "not_proved_correct_share",
              "not_correct_within_d_share", "proved_wrong_share"]
    for arm, benches in rc["arms"].items():
        for bench, r in benches.items():
            sp = st["arms"][arm][bench]["point"]
            for f in fields:
                check(f"{arm}/{bench}/{f}", abs(r["point"][f] - sp[f]) < 1e-9,
                      f"{r['point'][f]} vs {sp[f]}")
            check(f"{arm}/{bench}/passes", r["point"]["official_passes"] == sp["official_pass_count"])
    pairs = st["pairs"]["h1_rl_vs_distill"]
    smap = {"h1_not_proved_correct": "not_proved_correct_share",
            "h1_floor_proved_wrong": "not_proved_correct_share_floor",
            "h2_pass1_gap": "h2_pass1_gap"}
    for k, sk in smap.items():
        check(f"{k}/call", rc["pairs"][k]["resolved"] == pairs[sk]["resolved"])

    readme = open(os.path.join(ROOT, "README.md")).read()

    # 2a. headline table: arm | bench | official passes | official pass@1 | strict pass@1 |
    #     not proved correct % [CI] | proved wrong % [CI]
    rows = table(readme, "loupe:headline")
    check("headline rows", len(rows) == 10, len(rows))
    for c in rows:
        arm, bench = c[0], {"VerilogEval": "ve", "RTLLM": "rtllm"}.get(c[1], c[1])
        p, ci = rc["arms"][arm][bench]["point"], st["arms"][arm][bench]["ci95"]
        want = [str(p["official_passes"]), pct(p["official_pass_at_1"]), pct(p["strict_pass_at_1"]),
                f"{pct(p['not_proved_correct_share'])} {ci_txt(ci['not_proved_correct_share'])}",
                f"{pct(p['proved_wrong_share'])} {ci_txt(ci['proved_wrong_share'])}"]
        check(f"README headline {arm}/{bench}", c[2:7] == want, f"{c[2:7]} vs {want}")

    # 2a'. numbers quoted in the prose of the first screen
    arms = list(rc["arms"])
    rt_npc = [rc["arms"][a]["rtllm"]["point"]["not_proved_correct_share"] for a in arms]
    rt_pw = [rc["arms"][a]["rtllm"]["point"]["proved_wrong_share"] for a in arms]
    ve_npc = [rc["arms"][a]["ve"]["point"]["not_proved_correct_share"] for a in arms]
    for want in [f"{pct(min(rt_npc))}% to {pct(max(rt_npc))}% of the passes",
                 f"For {pct(min(rt_pw))}% to {pct(max(rt_pw))}% of the passes",
                 f"At most {pct(max(ve_npc))}% of passes"]:
        check("README prose", want in readme, f"missing: {want!r}")

    # 2b. contrasts: name | point pp | 95% CI | call
    names = {"H1": "h1_not_proved_correct", "H1-floor": "h1_floor_proved_wrong", "H2": "h2_pass1_gap"}
    rows = table(readme, "loupe:contrasts")
    check("contrast rows", len(rows) == 3, len(rows))
    for c in rows:
        k = names[c[0]]
        r, s = rc["pairs"][k], pairs[smap[k]]
        want = [signed(r["point"]), ci_txt(s["ci95"]), "resolved" if r["resolved"] else "not resolved"]
        check(f"README contrast {c[0]}", c[2:5] == want, f"{c[2:5]} vs {want}")

    # 2c. blind-40: label | count | share % [Wilson CI]
    ub = load("results/main/blind40/unblinded.ai.json")
    rows = table(readme, "loupe:blind40")
    check("blind40 rows", len(rows) == 5, len(rows))
    for c in rows:
        o = ub["overall"][c[0]]
        want = [str(o["count"]), f"{pct(o['share'])} {ci_txt(o['wilson95'])}"]
        check(f"README blind40 {c[0]}", c[1:3] == want, f"{c[1:3]} vs {want}")
    check("blind40 n", ub["n"] == 40, ub["n"])
    rb = ub["overall"]["real bug"]
    want = f"An exploratory AI review of 40 such cases found {rb['count']} real bugs ({100 * rb['share']:.0f}%)"
    check("README prose blind40", want in readme, f"missing: {want!r}")

    # 2d. GRPO/E1: contrast | bench | official pass@1 diff [CI] | not-proved-correct diff [CI]
    e1 = load("results/e1/stats.json")
    rows = table(readme, "loupe:e1")
    check("e1 rows", len(rows) >= 4, len(rows))
    for c in rows:
        key = c[0].split()[0]
        bench = {"VerilogEval": "ve", "RTLLM": "rtllm"}[c[1]]
        d = e1["pairs"][key][bench]
        a, b = d["official_pass_at_1"], d["not_proved_correct_share"]
        want = [f"{signed(a['mean'])} {ci_txt(a['ci95'])}", f"{signed(b['mean'])} {ci_txt(b['ci95'])}"]
        check(f"README e1 {key}/{bench}", c[2:4] == want, f"{c[2:4]} vs {want}")

    print(f"checked: recompute vs stats.json, and {readme.count('<!-- loupe:') // 2} README tables")
    for f in FAILS:
        print("FAIL:", f)
    print("RESULT:", "PASS" if not FAILS else f"FAIL ({len(FAILS)})")
    return 0 if not FAILS else 1


if __name__ == "__main__":
    sys.exit(main())
