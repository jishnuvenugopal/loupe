#!/usr/bin/env python3
"""scoring/phase10.py — Phase 10 orchestrator (A16 §6 steps 1-8; frozen
analysis code pinned in PREREG "Analysis code"; runs after Phase 8 with no
new message).

Per-arm order = the overnight order (7b-rl, 7b-sft, 3b-rl, 3b-base, 7b-base).
Steps:
  0. Freeze checks (git diff vs scorer-v1 excluding __pycache__; sha256sum -c).
  1. G2 (extraction >= 95% per arm; on failure STOP for that arm + 10 samples).
  2/3. run_scoring per arm (official TB + strict in one pass, resumable); G1b
      checked per CodeV arm right after its rows exist (A18 item 1: the
      all-task point official_pass_at_1_all_tasks with ci95_all_tasks; anchors
      VE 31.3 base / 65.2 Distill / 68.8 RL, pass = anchor in CI or within
      ±8 pp; RTLLM 36.1/57.2/68.0 loose). G1b failure -> STOP.
  4. Dedup (scoring/dedup.py) + sensitivity stats.
  5. Contamination (scoring/contamination.py; rules fixed in PREREG).
  6. Statistics (scoring/stats.py: primary/companion/floor, classes, H1/H2,
     sensitivities: --rtllm-all37, --wide-gate companion-only, --dedup,
     --drop-tasks).
  7. Blind-40 packets (scoring/blind40.py); key outside the repo, sha256 in.
  8. results/main/summary.md + official_vs_strict.{csv,png}; SPARK_REPORT
     section; commit + push (the chain commits); STOP line.

Every step logs to notes/LOG.md. Resumable: scoring rows already done are
skipped by run_scoring.py; re-running this script is safe.
"""
import glob
import hashlib
import json
import os
import subprocess
import sys
import time

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RUNS = os.path.expanduser("~/runs/gen")
PY = sys.executable
LOGMD = os.path.join(REPO, "notes/LOG.md")
ORDER = ["7b-rl", "7b-sft", "3b-rl", "3b-base", "7b-base"]
ANCHOR_VE = {"7b-rl": 0.688, "7b-sft": 0.652, "7b-base": 0.313}
ANCHOR_RT = {"7b-rl": 0.680, "7b-sft": 0.572, "7b-base": 0.361}


def log(msg):
    line = f"- {time.strftime('%Y-%m-%d %H:%M')} — {msg}"
    print(line, flush=True)
    with open(LOGMD, "a") as f:
        f.write(line + "\n")


def run(cmd, **kw):
    log("phase10: " + " ".join(cmd[:6]) + (" ..." if len(cmd) > 6 else ""))
    return subprocess.run(cmd, **kw)


def gen_files(arm):
    return sorted(glob.glob(os.path.join(RUNS, f"{arm}_*.jsonl")))


# A18 items 1-5 added these test files AFTER tag scorer-v1 (committed in the
# pre-G0 revision c83f842). They are excluded from the scorer-v1 diff but
# pinned to their c83f842 content, so the exclusion cannot smuggle changes.
A18_TEST_ADDS = {
    "tests/test_a18_stats.py":
        "57ce646df5c43a920c258aeccf74f94db2349681c6abe4a7d8e70cc8fde8247b",
    "tests/test_a18_dedup_blind40.py":
        "062d6261823ba22d97be4551e810529ab54b8ce4ccd293887673ddcfee36110b",
}


def freeze_check():
    p1 = run(["git", "-C", REPO, "diff", "--quiet", "scorer-v1", "--", "scorer",
              "tests", ":(exclude)scorer/__pycache__"]
             + [f":(exclude){p}" for p in A18_TEST_ADDS], capture_output=True)
    p2 = run(["sha256sum", "-c", "results/pilot_repro/SCORER_SHA256"],
             cwd=REPO, capture_output=True, text=True)
    pinned_ok = True
    for p, want in A18_TEST_ADDS.items():
        got = hashlib.sha256(open(os.path.join(REPO, p), "rb").read()).hexdigest()
        if got != want:
            pinned_ok = False
            log(f"phase10 freeze check: {p} sha256 {got} != pinned c83f842 {want}")
    ok = p1.returncode == 0 and p2.returncode == 0 and pinned_ok
    log(f"phase10 freeze check: diff rc={p1.returncode} sha256 rc={p2.returncode} "
        f"a18-test pins ok={pinned_ok}" + ("" if ok else " FAILED"))
    if not ok:
        log(p2.stdout[-500:] + p2.stderr[-500:])
    return ok


def step1_g2():
    ok = True
    for arm in ORDER:
        for f in gen_files(arm):
            p = run([PY, os.path.join(REPO, "scoring/extract.py"), "--gen", f],
                    capture_output=True, text=True)
            share = None
            for l in p.stdout.splitlines():
                if l.startswith("{") and '"share"' in l:
                    try:
                        share = json.loads(l)
                    except Exception:
                        pass
            log(f"phase10 G2 {arm} {os.path.basename(f)}: rc={p.returncode} "
                f"{(share or {}).get('share')}")
            if p.returncode != 0 or (share and share.get("share") is not None
                                     and share["share"] < 0.95):
                ok = False
                log("G2 FAILED for " + arm + " — output:\n"
                    + "\n".join((p.stdout + p.stderr).splitlines()[-30:]))
    return ok


def score_arm(arm):
    out = os.path.join(REPO, f"scores/{arm}.jsonl")
    for f in gen_files(arm):
        p = run([PY, os.path.join(REPO, "scoring/run_scoring.py"),
                 "--arm", arm, "--gen", f, "--out", out,
                 "--workers", str(max(1, (os.cpu_count() or 4) - 2)),
                 "--sat-timeout", "60", "--cex-out",
                 os.path.join(REPO, "results/main/cex")])
        if p.returncode != 0:
            log(f"phase10: run_scoring {arm} rc={p.returncode} — STOP")
            return False
    return True


def stats_for(extra_args, out_json):
    cmd = [PY, os.path.join(REPO, "scoring/stats.py"),
           "--scores", *glob.glob(os.path.join(REPO, "scores/*.jsonl"))]
    cmd += extra_args + ["--out", out_json]
    p = run(cmd, capture_output=True, text=True)
    if p.returncode != 0:
        log(f"stats failed: {p.stderr[-500:]}")
    return json.load(open(out_json)) if os.path.isfile(out_json) else None


def step2_g1b(stats):
    """A18 item 1: all-task point + ci95_all_tasks; anchors in CI or ±8 pp."""
    ok, table = True, []
    for arm, anchor in ANCHOR_VE.items():
        cell = (stats or {}).get("arms", {}).get(arm, {}).get("ve")
        if not cell:
            continue
        pt = cell["point"]["official_pass_at_1_all_tasks"]
        lo, hi = cell["ci95_all_tasks"]
        inside = lo is not None and lo <= anchor <= hi
        within8 = pt is not None and abs(pt - anchor) <= 0.08
        row = {"arm": arm, "bench": "ve", "point_all_tasks": pt, "ci95_all_tasks": [lo, hi],
               "anchor": anchor, "inside_ci": inside, "within_8pp": within8,
               "pass": inside or within8}
        table.append(row)
        rt = (stats or {}).get("arms", {}).get(arm, {}).get("rtllm")
        if rt:
            row["rtllm_point_all"] = rt["point"]["official_pass_at_1_all_tasks"]
            row["rtllm_anchor_loose"] = ANCHOR_RT[arm]
        if not row["pass"]:
            ok = False
    json.dump(table, open(os.path.join(REPO, "results/main/g1b.json"), "w"), indent=1)
    for r in table:
        log(f"phase10 G1b {r['arm']}/ve: point={r['point_all_tasks']:.3f} "
            f"CI={[round(x,3) if x else x for x in r['ci95_all_tasks']]} "
            f"anchor={r['anchor']} -> {'PASS' if r['pass'] else 'FAIL'}"
            f" (rtllm loose: {r.get('rtllm_point_all')} vs {r.get('rtllm_anchor_loose')})")
    return ok, table


def gap_tasks(stats, arm, bench="ve"):
    cell = stats["arms"][arm][bench]
    rows = []
    for r in json.load(open(os.path.join(REPO, f"scores/{arm}.jsonl"))):
        if r["bench"] == bench:
            rows.append(r)
    by_task = {}
    for r in rows:
        by_task.setdefault(r["task_id"], []).append(r["tb"] == "pass")
    rates = {t: sum(v) / len(v) for t, v in by_task.items()}
    return sorted(rates.items(), key=lambda kv: kv[1])[:10]


def step4_dedup():
    files = [f for arm in ORDER for f in gen_files(arm)]
    out = os.path.join(REPO, "results/main/dedup_map.json")
    p = run([PY, os.path.join(REPO, "scoring/dedup.py"), "--gen", *files,
             "--out", out], capture_output=True, text=True)
    log(f"phase10 dedup rc={p.returncode}: {p.stdout[-400:] if p.returncode == 0 else p.stderr[-600:]}")
    return p.returncode == 0


def step5_contamination():
    p = run([PY, os.path.join(REPO, "scoring/contamination.py")],
            capture_output=True, text=True)
    log(f"phase10 contamination rc={p.returncode}: {p.stdout[-400:]}")
    return p.returncode == 0


def step7_blind40():
    files = [f for arm in ORDER for f in gen_files(arm)]
    p = run([PY, os.path.join(REPO, "scoring/blind40.py"),
             "--scores", *glob.glob(os.path.join(REPO, "scores/*.jsonl")),
             "--gen", *files, "--dedup", os.path.join(REPO, "results/main/dedup_map.json"),
             "--out-dir", os.path.join(REPO, "results/main/blind40"),
             "--key", os.path.expanduser("~/runs/blind40_key.json"),
             "--cex-dir", os.path.join(REPO, "results/main/cex")],
            capture_output=True, text=True)
    log(f"phase10 blind40 rc={p.returncode}: {p.stdout[-500:] if p.returncode == 0 else p.stderr[-800:]}")
    if p.returncode != 0:
        return False
    key = os.path.expanduser("~/runs/blind40_key.json")
    h = hashlib.sha256(open(key, "rb").read()).hexdigest()
    open(os.path.join(REPO, "results/main/blind40/KEY_SHA256"), "w").write(h + "\n")
    log(f"phase10 blind40 key sha256={h} (key stays outside the repo)")
    return True


def fmt_ci(v):
    return "–" if v is None else f"{100 * v:.1f}"


def step8_summary(stats, stats_all37, stats_wide, stats_dedup, stats_drop, g1b_table):
    main_dir = os.path.join(REPO, "results/main")
    os.makedirs(main_dir, exist_ok=True)
    lines = ["# Main results — strict re-scoring (Phase 10)", "",
             f"Written {time.strftime('%Y-%m-%d %H:%M')} by scoring/phase10.py "
             "(analysis code pinned in PREREG; every number links to its file).", "",
             "## Gate status", "",
             "- G1-Spark: reproduced (PREREG Scorer; results/deep/gpt_summary.json).",
             "- G2 (extraction ≥ 95% per arm): see `results/main/g2.txt` extraction logs.",
             "- G1b (fidelity, A18: all-task point + ci95_all_tasks): "
             "`results/main/g1b.json`.", ""]
    lines += ["| arm | bench | official pass@1 (all tasks) | 95% CI (all tasks) | anchor | verdict |",
              "|---|---|---|---|---|---|"]
    for r in g1b_table:
        lines.append(f"| {r['arm']} | ve | {100 * r['point_all_tasks']:.1f} | "
                     f"[{fmt_ci(r['ci95_all_tasks'][0])}, {fmt_ci(r['ci95_all_tasks'][1])}] | "
                     f"{100 * r['anchor']:.1f} | {'PASS' if r['pass'] else 'FAIL'} |")
    lines += ["", "## Primary table (not-proved-correct share; proved-wrong floor beside it)", ""]
    lines += ["| arm | bench | tasks | official passes | not proved correct % [CI] | "
              "not correct within d % [CI] | proved wrong % [CI] | classes | vacuous |",
              "|---|---|---|---|---|---|---|---|---|"]
    for arm in ORDER:
        for bench in ("ve", "rtllm"):
            cell = stats["arms"].get(arm, {}).get(bench)
            if not cell:
                continue
            p, ci = cell["point"], cell["ci95"]
            cls = p["classes"]
            lines.append(
                f"| {arm} | {bench} | {p['tasks']} | {p['official_pass_count']} | "
                f"{fmt_ci(p['not_proved_correct_share'])} [{fmt_ci(ci['not_proved_correct_share'][0])},"
                f"{fmt_ci(ci['not_proved_correct_share'][1])}] | "
                f"{fmt_ci(p['not_correct_within_d_share'])} [{fmt_ci(ci['not_correct_within_d_share'][0])},"
                f"{fmt_ci(ci['not_correct_within_d_share'][1])}] | "
                f"{fmt_ci(p['proved_wrong_share'])} [{fmt_ci(ci['proved_wrong_share'][0])},"
                f"{fmt_ci(ci['proved_wrong_share'][1])}] | "
                f"diff {cls['different']}, bnd {cls['bounded-only']}, tmo {cls['timeout']}, "
                f"err {cls['error']}, vac {cls['vacuous']} | {p['vacuous_passes']} |")
    lines += ["", "Source: `results/main/stats.json` (10,000 task-clustered bootstrap "
              "resamples, `numpy.random.default_rng(0)`, percentile 95%; denominators "
              "are official passes, including in the bootstrap).", ""]
    if stats.get("pairs"):
        lines += ["## Secondary contrasts (exploratory; CodeV family only)", ""]
        for name, pc in stats["pairs"].items():
            lines.append(f"- {name} ({pc['arm_a']} − {pc['arm_b']}, primary share): "
                         f"mean {100 * pc['mean']:.1f} pp, 95% CI "
                         f"[{100 * pc['ci95'][0]:.1f}, {100 * pc['ci95'][1]:.1f}] — "
                         f"{'resolved' if pc['resolved'] else 'not resolved'}.")
        lines.append("")
    lines += ["## Sensitivity rows", "",
              f"- all 37 RTLLM designs (headline = 33): `results/main/stats_all37.json`",
              f"- wide 149/40 gate, within-depth-d companion only: `results/main/stats_wide.json`",
              f"- per-unique-design (dedup): `results/main/stats_dedup.json` "
              f"(dedup summary: `results/main/dedup_map.json.summary.json`)",
              f"- contaminated tasks dropped: `results/main/stats_drop.json`",
              "", "## Reported apart", "",
              "accu, LIFObuffer (RTLLM #25/#26 reference bugs), RAM, square_wave "
              "(#16/#23): `results/main/apart.json` (classes per arm, no headline).", "",
              "## Contamination", "",
              "`results/main/contamination/overlaps.csv` + `summary.json` "
              "(rules in PREREG Analysis plan).", "",
              "## Blind sample of 40", "",
              "`results/main/blind40/` — packets blind to arm/model/family/index; "
              "key outside the repo, only `KEY_SHA256` committed; labels pending "
              "(operator message `blind labels in`).", ""]
    open(os.path.join(main_dir, "summary.md"), "w").write("\n".join(lines) + "\n")

    # figure CSV + PNG
    csv = ["arm,bench,official_pass_at_1,official_lo,official_hi,strict_pass_at_1,strict_lo,strict_hi"]
    for arm in ORDER:
        for bench in ("ve", "rtllm"):
            cell = stats["arms"].get(arm, {}).get(bench)
            if not cell:
                continue
            p, ci = cell["point"], cell["ci95"]
            csv.append(",".join(map(str, [
                arm, bench, p["official_pass_at_1_all_tasks"],
                cell["ci95_all_tasks"][0], cell["ci95_all_tasks"][1],
                p["strict_pass_at_1"], ci["strict_pass_at_1"][0], ci["strict_pass_at_1"][1]])))
    open(os.path.join(main_dir, "official_vs_strict.csv"), "w").write("\n".join(csv) + "\n")
    try:
        import matplotlib
        matplotlib.use("Agg")
        import matplotlib.pyplot as plt
        fig, ax = plt.subplots(figsize=(9, 6))
        i = 0
        for arm in ORDER:
            for bench in ("ve", "rtllm"):
                cell = stats["arms"].get(arm, {}).get(bench)
                if not cell:
                    continue
                p = cell["point"]
                ax.errorbar(p["official_pass_at_1_all_tasks"], p["strict_pass_at_1"],
                            xerr=[[p["official_pass_at_1_all_tasks"] - cell["ci95_all_tasks"][0]],
                                  [cell["ci95_all_tasks"][1] - p["official_pass_at_1_all_tasks"]]],
                            yerr=[[p["strict_pass_at_1"] - cell["ci95"]["strict_pass_at_1"][0]],
                                  [cell["ci95"]["strict_pass_at_1"][1] - p["strict_pass_at_1"]]],
                            fmt="o", capsize=3, label=f"{arm} {bench}")
                i += 1
        ax.plot([0, 1], [0, 1], "--", color="gray", lw=0.8)
        ax.set_xlabel("official pass@1 (all tasks, 95% CI)")
        ax.set_ylabel("strict pass@1 (proved correct, gated, 95% CI)")
        ax.set_title("official vs strict pass@1 per checkpoint")
        ax.legend(fontsize=7, loc="upper left")
        fig.tight_layout()
        fig.savefig(os.path.join(main_dir, "official_vs_strict.png"), dpi=150)
    except Exception as e:  # figure is best-effort; CSV is the record
        log(f"figure failed ({e}); CSV remains the record")
    log("phase10 summary written: results/main/summary.md")


def apart_table():
    apart = {"accu", "LIFObuffer", "RAM", "square_wave"}
    out = {}
    for f in glob.glob(os.path.join(REPO, "scores/*.jsonl")):
        arm = os.path.basename(f)[: -len(".jsonl")]
        out[arm] = {}
        for r in map(json.loads, open(f)):
            if r["bench"] == "rtllm" and r["task_id"] in apart and r.get("tb") == "pass":
                c = out[arm].setdefault(r["task_id"], {"passes": 0})
                c["passes"] += 1
                c["last_class"] = r.get("class")
    json.dump(out, open(os.path.join(REPO, "results/main/apart.json"), "w"), indent=1)


def main():
    os.makedirs(os.path.join(REPO, "results/main"), exist_ok=True)
    log("phase10: start (freeze checks first)")
    if not freeze_check():
        print("STOP — phase10 freeze check failed")
        return 2
    if not step1_g2():
        print("STOP — G2 failed")
        return 3
    # contamination is CPU-light and independent: run it before the long lane
    step5_contamination()
    # score arms in order; G1b per CodeV arm as soon as its rows exist
    for arm in ORDER:
        if not score_arm(arm):
            print(f"STOP — scoring failed for {arm}")
            return 4
        if arm in ANCHOR_VE:
            stats = stats_for([], os.path.join(REPO, "results/main/stats.json"))
            ok, table = step2_g1b(stats)
            if not ok:
                gaps = gap_tasks(stats, arm)
                log(f"phase10 G1b FAILED on {arm}; 10 lowest-pass-rate VE tasks: {gaps}")
                print("STOP — G1b failed")
                return 5
    stats = stats_for([], os.path.join(REPO, "results/main/stats.json"))
    ok, table = step2_g1b(stats)
    if not ok:
        print("STOP — G1b failed")
        return 5
    stats_all37 = stats_for(["--rtllm-all37"],
                            os.path.join(REPO, "results/main/stats_all37.json"))
    stats_wide = stats_for(["--wide-gate"],
                           os.path.join(REPO, "results/main/stats_wide.json"))
    if not step4_dedup():
        print("STOP — dedup failed")
        return 6
    stats_dedup = stats_for(
        ["--dedup", os.path.join(REPO, "results/main/dedup_map.json")],
        os.path.join(REPO, "results/main/stats_dedup.json"))
    drop = os.path.join(REPO, "results/main/contamination/overlapping_tasks.txt")
    stats_drop = stats_for(["--drop-tasks", drop],
                           os.path.join(REPO, "results/main/stats_drop.json")) \
        if os.path.isfile(drop) else None
    # H1/H2 pairs (CodeV family; RL vs Distill)
    stats_pairs = stats_for(["--pair", "h1_rl_vs_distill:7b-rl:7b-sft"],
                            os.path.join(REPO, "results/main/stats_pairs.json"))
    if stats_pairs and "pairs" in stats_pairs and stats["pairs"] is not None:
        stats["pairs"] = stats_pairs["pairs"]
        json.dump(stats, open(os.path.join(REPO, "results/main/stats.json"), "w"), indent=1)
    apart_table()
    if not step7_blind40():
        print("STOP — blind40 failed")
        return 7
    step8_summary(stats, stats_all37, stats_wide, stats_dedup, stats_drop, table)
    log("phase10: complete — summary.md written; waiting for G3 review and blind labels")
    print("PHASE10 DONE")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
