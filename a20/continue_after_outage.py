#!/usr/bin/env python3
"""Unfrozen operational continuation after the October network outage.

Uses the pinned GRPO/E1 machinery without editing it. The operator approved
continuation on 10 Nov, with the existing 14/15 Nov deadlines unchanged.
--attach-container adopts the live extended-S job without restarting training.
Downstream work fails closed on missing outputs, pin drift or failed commands.
"""
import argparse
import datetime
import fcntl
import importlib.util
import json
import os
from pathlib import Path
import re
import signal
import subprocess
import threading
import time

from adopt_training import adopt, docker
from recovery_checks import ARMS, BENCH_TASKS, e1_check, freeze_check, training_check

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
spec = importlib.util.spec_from_file_location("a20sup", os.path.join(REPO, "a20/supervisor.py"))
sup = importlib.util.module_from_spec(spec)
spec.loader.exec_module(sup)
sup.DEADLINE = datetime.datetime(2026, 11, 14, 20, 0)
sup.END_OF_MISSION = datetime.datetime(2026, 11, 15, 23, 59)
E1_ARMS = list(ARMS)
CHECK_PATH = Path(REPO) / "results/e1/recovery_checks.json"


def write_json(path, value):
    path = Path(path)
    path.parent.mkdir(parents=True, exist_ok=True)
    tmp = path.with_suffix(path.suffix + ".tmp")
    tmp.write_text(json.dumps(value, indent=1) + "\n")
    tmp.replace(path)


def require(check, stage):
    if not check["ok"]:
        raise RuntimeError(f"{stage} failed — see results/e1/recovery_checks.json")


def report_state(status, detail):
    """Never write 'done' just because a subprocess returned zero."""
    stamp = datetime.datetime.now().isoformat(timespec="seconds")
    record = {"updated_at": stamp, "status": status, "detail": detail,
              "evidence": "results/e1/recovery_checks.json",
              "heavy_deadline": sup.DEADLINE.isoformat(),
              "mission_end": sup.END_OF_MISSION.isoformat()}
    report = Path(REPO) / "spark_report.json"
    data = json.loads(report.read_text())
    data["a20_recovery"] = record
    write_json(report, data)
    section = ["## 13. Phase 9 + E1 (A20)", "", f"Updated {stamp} +08. **{status.upper()}**.", "",
               detail, "", "This continuation is exploratory and does not change the primary study.",
               "Evidence: `results/e1/recovery_checks.json`; GRPO status/CSV/adapter hashes in",
               "`results/grpo/`; E1 scores in `scores_e1/` and report in `results/e1/summary.md`.", "",
               "The October DNS outage left extended-S untrained and extended E1 absent.",
               "The 10 Nov recovery adopts the live training job without restarting it;",
               "training, reward, prompts, sampling, scorer and statistical analysis are unchanged.",
               "The blind-review packet lookup is repaired under the approved A21 amendment.",
               "Checks require exact sample identities: 432 VE + 99 RTLLM, and 531 scores per arm.", "",
               f"Heavy-work deadline: {sup.DEADLINE} +08; heartbeat/label-poll window ends",
               f"{sup.END_OF_MISSION} +08. Blind-40 status: {sup.state['part_e']}.", ""]
    if status == "done":
        section.append("STOP — Phase 9 + E1 complete; waiting for operator review and blind-40 labels.")
    elif status == "blocked":
        section.append("STOP — A20 recovery blocked; waiting for operator review. No downstream jobs started.")
    path = Path(REPO) / "SPARK_REPORT.md"
    text = path.read_text()
    text = re.sub(r"^## 13\. Phase 9 \+ E1 \(A20\).*", "", text, flags=re.M | re.S)
    path.write_text(text.rstrip() + "\n\n" + "\n".join(section).rstrip() + "\n")


def run_e1_checked(checks):
    if sup.past_deadline():
        raise RuntimeError("extended heavy-work deadline reached before E1")
    checks["freeze_before_e1"] = freeze_check(REPO)
    write_json(CHECK_PATH, checks)
    require(checks["freeze_before_e1"], "freeze before E1")
    # Each launch of the frozen driver is one arm, so the deadline is checked
    # between arms. A running arm is allowed to finish at its natural end.
    for arm, run in (("base", None), ("w100", "grpo_brief_W"), ("s100", "grpo_brief_S"),
                     ("wext", "grpo_ext_W"), ("sext", "grpo_ext_S")):
        if sup.past_deadline():
            raise RuntimeError(f"extended heavy-work deadline reached before E1 {arm}")
        current = e1_check(REPO, sup.RUNS, [arm])["arms"][arm]
        if current["ok"]:
            sup.log(f"E1 {arm}: exact generation/scoring identities verified — resume skip")
            continue
        checks[f"freeze_before_{arm}"] = freeze_check(REPO)
        write_json(CHECK_PATH, checks)
        require(checks[f"freeze_before_{arm}"], f"freeze before E1 {arm}")
        args = [sup.PYV, str(Path(REPO) / "e1/run_e1.py"), "--arms", arm]
        if run and not (current["ve"]["ok"] and current["rtllm"]["ok"]):
            adapter = sup.adapter_source(run)
            if not adapter:
                raise RuntimeError(f"no adapter for E1 {arm}; refusing hollow success")
            args += ["--merge", f"{arm}:{adapter}"]
        sup.set_state(part_c="Part C E1", run=f"e1:{arm}", train_step="-")
        p = subprocess.run(args, cwd=REPO)
        checks[f"e1_{arm}"] = e1_check(REPO, sup.RUNS, [arm])
        checks[f"e1_{arm}"]["driver_rc"] = p.returncode
        write_json(CHECK_PATH, checks)
        if p.returncode:
            raise RuntimeError(f"E1 driver failed for {arm}: rc={p.returncode}")
        require(checks[f"e1_{arm}"], f"E1 {arm} completeness")
        sup.commit_push(["results/e1", "scores_e1", "notes/LOG.md"],
                        f"A20 E1 {arm}: exact generation and score identities verified")
    checks["e1"] = e1_check(REPO, sup.RUNS)
    write_json(CHECK_PATH, checks)
    require(checks["e1"], "all-arm E1 completeness")
    p = subprocess.run([sup.PYV, str(Path(REPO) / "e1/report.py")], cwd=REPO)
    if p.returncode:
        raise RuntimeError(f"E1 report failed: rc={p.returncode}")
    stats = json.loads((Path(REPO) / "results/e1/stats.json").read_text())
    if set(stats["arms"]) != {f"e1-{a}" for a in ARMS}:
        raise RuntimeError("E1 report does not contain exactly the five expected arms")
    for arm, cells in stats["arms"].items():
        if set(cells) != set(BENCH_TASKS) or any(
                cells[b]["point"]["tasks"] != n for b, n in BENCH_TASKS.items()):
            raise RuntimeError(f"incomplete benchmark coverage in E1 report: {arm}")
    expected_files = {f"e1-{a}_{b}.jsonl" for a in ARMS for b in BENCH_TASKS}
    g2 = stats.get("g2") or {}
    if set(g2) != expected_files or any(not isinstance(v, dict) or "share" not in v for v in g2.values()):
        raise RuntimeError("E1 report lacks extraction checks for every generation file")
    checks["report"] = {"ok": True, "path": "results/e1/stats.json"}
    checks["freeze_after_e1"] = freeze_check(REPO)
    write_json(CHECK_PATH, checks)
    require(checks["freeze_after_e1"], "freeze after E1")


def retire_paused_supervisor(pid):
    """After training exits, retire only the explicitly superseded, paused driver."""
    proc = Path(f"/proc/{pid}")
    if not proc.exists():
        return
    cmd = (proc / "cmdline").read_bytes().split(b"\0")
    state = (proc / "stat").read_text().rsplit(") ", 1)[1].split()[0]
    if pid == os.getpid() or state not in ("T", "t") or not any(
            arg.endswith(b"a20/continue_after_outage.py") for arg in cmd):
        raise RuntimeError("refusing to retire an unexpected/non-paused process")
    os.kill(pid, signal.SIGTERM)
    os.kill(pid, signal.SIGCONT)
    sup.log(f"retired superseded paused supervisor {pid} after training exit")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--attach-container", help="full ID of the live a20_grpo_ext_S container")
    ap.add_argument("--retire-supervisor-pid", type=int,
                    help="paused old driver to retire only after the adopted training exits")
    args = ap.parse_args()
    if args.retire_supervisor_pid and not args.attach_container:
        ap.error("--retire-supervisor-pid requires --attach-container")
    os.chdir(REPO)
    # Only one corrected continuation process may supervise or launch work.
    lock = open(Path(sup.RUNS) / "a20_recovery.lock", "w")
    fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
    checks = {"checked_at": datetime.datetime.now().isoformat(timespec="seconds"),
              "freeze": freeze_check(REPO), "e1_before": e1_check(REPO, sup.RUNS)}
    write_json(CHECK_PATH, checks)
    require(checks["freeze"], "startup freeze")
    inhib = sup.run_inhibit()
    sup.log(f"corrected continuation up (pid {os.getpid()}); fail-closed E1 checks; "
            f"attach={args.attach_container or 'none'}")
    sup.set_state(part_c="recovery preflight")
    report_state("running", "Extended-S training is in progress. E1 remains incomplete; no completion claim is made.")
    threading.Thread(target=sup.heartbeat_loop, daemon=False, name="heartbeat").start()
    threading.Thread(target=sup.epoll_loop, daemon=False, name="epoll").start()
    try:
        if args.attach_container:
            trained = adopt(sup, args.attach_container)
            if args.retire_supervisor_pid:
                retire_paused_supervisor(args.retire_supervisor_pid)
            if not trained:
                raise RuntimeError("adopted training did not finish successfully; downstream work blocked")
        else:
            # A rerun must never silently restart an existing checkpointed job.
            live = docker("ps", "-q", "--filter", "name=^/a20_grpo_ext_S$")
            if live:
                raise RuntimeError("extended-S is live; use --attach-container, never launch a duplicate")
            status = json.loads((Path(sup.GRPO_DIR) / "grpo_ext_S_status.json").read_text())
            if status.get("status") != "done":
                raise RuntimeError("extended-S is not done; inspect checkpoints before any restart")
        checks["training"] = training_check(REPO, sup.RUNS)
        write_json(CHECK_PATH, checks)
        require(checks["training"], "extended-S training artifacts")
        run_e1_checked(checks)
        report_state("done", "Extended-S passed the final-artifact checks. All five E1 arms have exact "
                     "generation/scoring coverage and the E1 report was regenerated successfully.")
        sup.log("STOP — Phase 9 + E1 complete; waiting for operator review and blind-40 labels")
        sup.set_state(part_c="idle (Parts D/E only)", run="-", train_step="-")
    except Exception as e:
        checks["error"] = str(e)
        write_json(CHECK_PATH, checks)
        sup.log(f"RECOVERY BLOCKED: {e}")
        sup.set_state(part_c="blocked — operator review", last_error=str(e))
        report_state("blocked", str(e))
    sup.commit_push(["SPARK_REPORT.md", "spark_report.json", "results/e1/recovery_checks.json", "notes/LOG.md"],
                    "A20 recovery: verified final state (or explicit blocking failure)")
    while datetime.datetime.now() < sup.END_OF_MISSION:
        time.sleep(60)
    sup.heartbeat_once()
    sup.log("corrected continuation exiting (extended mission end)")
    inhib.terminate()


if __name__ == "__main__":
    main()
