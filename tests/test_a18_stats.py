#!/usr/bin/env python3
"""tests/test_a18_stats.py — A18 items 1-4 tests for scoring/stats.py.

1. ci95_all_tasks: task-clustered bootstrap of official pass@1 over ALL tasks
   (the G1b point), tested on a case where the gated and all-task sets differ.
2. dedup: str-normalised sample_idx both sides; collapsed rows reported;
   a map matching no row is an error.
3. missing/empty gate file is a hard error (no silent no-gate fallback).
4. vacuous is a flag: a vacuous pass keeps its proof class; class counts add
   up to official_pass_count - proved_correct_count.

Run: python3 tests/test_a18_stats.py   (exit 0 = all pass)
"""
import json
import os
import subprocess
import sys
import tempfile

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(REPO, "scoring"))
import stats  # noqa: E402

VE_ALL = [json.loads(l)["task_id"] for l in open(os.path.join(REPO, "prompts/built/codev_ve.jsonl"))]
RT_ALL = [json.loads(l)["task_id"] for l in open(os.path.join(REPO, "prompts/built/codev_rtllm.jsonl"))]
VE_GATE = set(open(os.path.join(REPO, "scoring/gates/ve_strict.txt")).read().split())
RT_GATE = (set(open(os.path.join(REPO, "scoring/gates/rtllm_strict.txt")).read().split())
           - set(open(os.path.join(REPO, "scoring/gates/rtllm_apart.txt")).read().split()))
CODE = "// c\nmodule TopModule(\n  input a,\n  output b\n);\nassign b = a;\nendmodule\n"
FAILS = {}


def check(name, cond, detail=""):
    if cond:
        print(f"  PASS {name}")
    else:
        FAILS[name] = detail
        print(f"  FAIL {name} {detail}")


def row(bench, task, i, tb, vclass="UNBOUNDED-EQ", nonvacuous=True, equiv=None):
    if equiv is None:
        equiv = {"UNBOUNDED-EQ": "equivalent", "DIFFERENT": "different",
                 "UNKNOWN": "timeout"}.get(vclass, "error")
    return dict(arm="syn", bench=bench, task=task, sample_idx=i, tb=tb,
                equiv=equiv, nonvacuous=nonvacuous, vclass=vclass)


def test_item1_ci95_all_tasks():
    """RTLLM: headline gate keeps 33 of 50 designs. Gated tasks pass at ~40%;
    non-gated tasks all pass. The all-task point must sit well above the gated
    point, and ci95_all_tasks must bracket the ALL-task point (the A18 bug had
    it centred on the gated point — e.g. 0.64 point vs a [0.417, 0.683] gated
    interval)."""
    rows = []
    for t in RT_ALL:
        ingate = t in RT_GATE
        for i in range(3):
            tb = ("pass" if RT_ALL.index(t) % 5 in (0, 1) else "fail") if ingate else "pass"
            rows.append(row("rtllm", t, i, tb, "UNBOUNDED-EQ" if tb == "pass" else None,
                            equiv="equivalent" if tb == "pass" else "skipped"))
    res = stats.analyze(rows)
    arm = res["arms"]["syn"]["rtllm"]
    pt_gated = arm["point"]["official_pass_at_1"]
    pt_all = arm["point"]["official_pass_at_1_all_tasks"]
    lo, hi = arm["ci95_all_tasks"]
    lo_g, hi_g = arm["ci95"]["official_pass_at_1"]
    check("item1: sets differ (gated != all point)", abs(pt_gated - pt_all) > 0.15,
          f"{pt_gated} vs {pt_all}")
    check("item1: ci95_all_tasks brackets the all-task point", lo <= pt_all <= hi,
          f"[{lo},{hi}] vs {pt_all}")
    check("item1: all-task interval is NOT the gated interval",
          abs(lo - lo_g) > 1e-9 or abs(hi - hi_g) > 1e-9,
          f"all [{lo},{hi}] gated [{lo_g},{hi_g}]")
    # the operator's scenario: all-task point above the gated interval's centre
    check("item1: interval is centred on the all-task point, not the gated one",
          abs(((lo + hi) / 2) - pt_all) < abs(((lo + hi) / 2) - pt_gated),
          f"mid={((lo+hi)/2):.3f} all={pt_all:.3f} gated={pt_gated:.3f}")
    # gated metrics exclude non-gated tasks entirely
    check("item1: gated point ignores non-gated tasks",
          arm["point"]["tasks"] == len(RT_GATE),
          f"{arm['point']['tasks']} vs {len(RT_GATE)}")


def test_item2_dedup():
    # 20 VE gate tasks x 3 IDENTICAL samples -> 60 rows must collapse to 20
    tasks = sorted(VE_GATE)[:20]
    rows = [row("ve", t, i, "pass") for t in tasks for i in range(3)]
    dedup = {f"syn|ve|{t}|{i}": f"dh_{t}" for t in tasks for i in range(3)}
    res = stats.analyze(rows, dedup=dict(((a, b, t, s), h)
                                         for (a, b, t, s), h in
                                         [((k.split("|")[0], k.split("|")[1],
                                            k.split("|")[2], k.split("|")[3]), v)
                                           for k, v in dedup.items()]))
    d = res["dedup"]
    check("item2: 60 rows collapse to 20", d["rows_after"] == 20 and d["rows_collapsed"] == 40,
          json.dumps(d))
    check("item2: all 60 rows matched the map", d["rows_matched"] == 60, json.dumps(d))
    check("item2: point estimate now on 20 samples", res["arms"]["syn"]["ve"]["point"]["samples"] == 20)
    # int sample_idx on the row side (run_scoring rows) must match str keys
    res2 = stats.analyze([row("ve", t, i, "pass") for t in tasks for i in range(3)],
                         dedup={(a, b, t, s): h for (a, b, t, s), h in
                                [(("syn", "ve", t, str(i)), f"dh_{t}")
                                 for t in tasks for i in range(3)]})
    check("item2: int sample_idx rows match str map keys",
          res2["dedup"]["rows_collapsed"] == 40, json.dumps(res2["dedup"]))
    # a map that matches nothing is an error
    try:
        stats.analyze(rows, dedup={("other", "ve", "nope", "0"): "x"})
        check("item2: no-match map errors", False, "no exception")
    except SystemExit as e:
        check("item2: no-match map errors", "matched no row" in str(e), str(e))


def test_item3_gate_files():
    env = dict(os.environ)
    for case in ("missing", "empty"):
        with tempfile.TemporaryDirectory() as td:
            for f in stats.GATE_FILES:
                open(os.path.join(td, f), "w").write("\n".join(sorted(VE_GATE)) + "\n")
            tgt = os.path.join(td, "ve_strict.txt")
            if case == "missing":
                os.remove(tgt)
            else:
                open(tgt, "w").write("")
            old = stats.GATES_DIR
            stats.GATES_DIR = td
            try:
                stats.load_gates()
                check(f"item3: {case} gate file errors", False, "no exception")
            except SystemExit as e:
                check(f"item3: {case} gate file errors",
                      case in str(e) or "empty" in str(e) or "missing" in str(e), str(e))
            finally:
                stats.GATES_DIR = old
    check("item3: real gates load", len(stats.load_gates()["ve"]) == 144)


def test_item4_vacuous_flag():
    # 6 official passes on gated VE tasks:
    #  a) vacuous + DIFFERENT  -> classes.different AND vacuous_passes
    #  b) vacuous + UNBOUNDED  -> classes.vacuous (sole failure) + vacuous_passes
    #  c) nonvac + DIFFERENT   -> classes.different, not vacuous_passes
    #  d) nonvac + UNBOUNDED   -> proved correct (no class)
    #  e) vacuous + BMC        -> classes.bounded-only AND vacuous_passes
    #  f) nonvac + UNKNOWN     -> classes.timeout
    tasks = sorted(VE_GATE)[:6]
    rows = [
        row("ve", tasks[0], 0, "pass", "DIFFERENT", nonvacuous=False),
        row("ve", tasks[1], 0, "pass", "UNBOUNDED-EQ", nonvacuous=False),
        row("ve", tasks[2], 0, "pass", "DIFFERENT", nonvacuous=True),
        row("ve", tasks[3], 0, "pass", "UNBOUNDED-EQ", nonvacuous=True),
        row("ve", tasks[4], 0, "pass", "BMC-10-EQ-ONLY", nonvacuous=False, equiv="error"),
        row("ve", tasks[5], 0, "pass", "UNKNOWN", nonvacuous=True, equiv="timeout"),
    ]
    res = stats.analyze(rows)
    p = res["arms"]["syn"]["ve"]["point"]
    cls, vp = p["classes"], p["vacuous_passes"]
    check("item4: vacuous DIFFERENT counted in classes.different", cls["different"] == 2,
          json.dumps(cls))
    check("item4: vacuous pass kept out of proved-correct (vacuous UNB -> class vacuous)",
          cls["vacuous"] == 1, json.dumps(cls))
    check("item4: vacuous BMC pass is bounded-only", cls["bounded-only"] == 1, json.dumps(cls))
    check("item4: vacuous_passes flag = 3", vp == 3, str(vp))
    check("item4: class counts add up to op - pc",
          sum(cls.values()) == p["official_pass_count"] - p["proved_correct_count"],
          f"{json.dumps(cls)} op={p['official_pass_count']} pc={p['proved_correct_count']}")
    check("item4: proved-wrong floor includes the vacuous DIFFERENT pass",
          abs(p["proved_wrong_share"] - 2 / 6) < 1e-12, str(p["proved_wrong_share"]))
    check("item4: nesting pw <= ncwd <= npc",
          p["proved_wrong_share"] <= p["not_correct_within_d_share"]
          <= p["not_proved_correct_share"],
          f"{p['proved_wrong_share']} {p['not_correct_within_d_share']} {p['not_proved_correct_share']}")
    # a16_class direct: name kept for run_scoring; per-row semantics
    check("item4: a16_class(vacuous DIFFERENT) == different",
          stats.a16_class("pass", "different", False, "DIFFERENT") == "different")
    check("item4: a16_class(vacuous UNBOUNDED-EQ) == vacuous",
          stats.a16_class("pass", "equivalent", False, "UNBOUNDED-EQ") == "vacuous")
    check("item4: a16_class(nonvac UNBOUNDED-EQ) is None",
          stats.a16_class("pass", "equivalent", True, "UNBOUNDED-EQ") is None)


def main():
    print("== A18 item 1: ci95_all_tasks (gated vs all-task sets differ)")
    test_item1_ci95_all_tasks()
    print("== A18 item 2: dedup str keys + collapsed-row report + no-match error")
    test_item2_dedup()
    print("== A18 item 3: missing/empty gate file is a hard error")
    test_item3_gate_files()
    print("== A18 item 4: vacuous as a flag, class counts add up")
    test_item4_vacuous_flag()
    if FAILS:
        print("FAILED:", json.dumps(FAILS, indent=1))
        return 1
    print("ALL A18 stats tests PASS")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
