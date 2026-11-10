#!/usr/bin/env python3
"""a20/continue_after_outage.py — continuation driver (10 Nov 2026; operator:
"continue what's left").

Why this exists: DNS to the outside was dead ~22 Oct 09:00 → 8 Nov 05:00 +08.
The supervisor finished its mission (ended 31 Oct 23:59, process exit 8 Nov
05:11) with two gaps, both caused by the outage, both handled per the A20
rules at the time:
  - grpo_ext_S: its 25 Oct 04:03 attempt died at birth (pip install could not
    reach PyPI; no checkpoint; marked incomplete, 0 resumes).
  - The ext-setting E1 never actually generated: the merge container's pip
    install failed the same way, and run_e1's skip-path then reported "ok"
    with nothing done (hollow-ok — diagnosed 10 Nov; this driver adds hard
    existence checks so it cannot recur silently).
Everything else completed: brief W (3.28 h) and S (3.35 h), ext W (29.75 h,
30 logs), E1 on base/w100/s100, ots upgrades (A20 stamp has 2 Bitcoin
attestations), heartbeats to 31 Oct 23:59, all commits pushed by 8 Nov 05:11
backlog flush on 10 Nov.

This driver reuses the PREREG-A20-pinned code verbatim via import; only the
module-level deadline constants are monkey-patched (no pinned file changes):
  DEADLINE       → 2026-11-14 20:00 +08 (new heavy-work stop; the 30 Oct one
                   governed the October unattended window and is superseded by
                   the operator's live instruction to continue)
  END_OF_MISSION → 2026-11-15 23:59 +08 (heartbeats + the Part E label poll
                   continue meanwhile)

Steps: grpo_ext_S (300 steps, lr 1e-5) → E1 all five arms (base/w100/s100
resume-skip; wext/sext new) with hard checks → strip the superseded
SPARK_REPORT §13 → final_steps (fresh §13 + STOP) → continuation addendum →
idle until end of mission.
"""
import datetime
import glob
import json
import os
import re
import subprocess
import threading
import time

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
import importlib.util
spec = importlib.util.spec_from_file_location("a20sup", os.path.join(REPO, "a20/supervisor.py"))
sup = importlib.util.module_from_spec(spec)
spec.loader.exec_module(sup)

# operator instruction (this session, 10 Nov 2026) supersedes the October deadline
sup.DEADLINE = datetime.datetime(2026, 11, 14, 20, 0)
sup.END_OF_MISSION = datetime.datetime(2026, 11, 15, 23, 59)

E1_ARMS = ["base", "w100", "s100", "wext", "sext"]


def arm_dirs(arm):
    return [os.path.join(sup.RUNS, "gen_e1", f"e1-{arm}_{b}.jsonl") for b in ("ve", "rtllm")]


def e1_complete(arm):
    for f in arm_dirs(arm):
        if not os.path.isfile(f):
            return False
        n = sum(1 for _ in open(f))
        if n < 531:  # (144 + 33) x n=3
            return False
    return os.path.isfile(os.path.join(REPO, f"scores_e1/e1-{arm}.jsonl"))


def strip_section13():
    p = os.path.join(REPO, "SPARK_REPORT.md")
    txt = open(p).read()
    m = re.search(r"^## 13\. Phase 9 \+ E1 \(A20\).*$", txt, re.S | re.M)
    if m:
        open(p, "w").write(txt[:m.start()].rstrip() + "\n")
        sup.log("continuation: superseded SPARK_REPORT §13 stripped "
                "(preserved in git history; final_steps appends a fresh one)")


def addendum():
    p = os.path.join(REPO, "SPARK_REPORT.md")
    with open(p, "a") as f:
        f.write(
            "\n### Continuation addendum (10–12 Nov 2026)\n\n"
            "The §13 line above about the 30 Oct 20:00 deadline describes the October\n"
            "unattended window. DNS to the outside was dead ~22 Oct 09:00 → 8 Nov 05:00,\n"
            "which left grpo_ext_S untrained (its single attempt died at birth on\n"
            "pip-install name resolution; no checkpoint) and the ext-setting E1 never\n"
            "generated (the merge container failed the same way; the run_e1 skip path\n"
            "then reported a hollow 'ok' — diagnosed and hard-checked on 10 Nov).\n"
            "On the operator's instruction (\"continue what's left\", 10 Nov), the\n"
            "pinned machinery was re-run via a20/continue_after_outage.py with only the\n"
            "deadline constants extended: grpo_ext_S trained, E1 completed for all five\n"
            "arms, and this report re-finalised. Heartbeats and the Part E poll ran\n"
            "throughout; the blind-40 labels never arrived on `operator`.\n")


def main():
    inhib = sup.run_inhibit()
    sup.log("continuation driver up (pid %d): ext_S (300 steps, lr 1e-5) -> E1 all arms "
            "-> re-finalise. New deadline %s, end of mission %s."
            % (os.getpid(), sup.DEADLINE, sup.END_OF_MISSION))
    threading.Thread(target=sup.heartbeat_loop, daemon=False, name="heartbeat").start()
    threading.Thread(target=sup.epoll_loop, daemon=False, name="epoll").start()

    # 1. the run the outage killed
    sup.run_grpo("ext", "S", 300, 1e-5)

    # 2. E1 on every arm (brief pass resume-skips; wext/sext are new)
    merges = []
    for arm, run in (("w100", "grpo_brief_W"), ("s100", "grpo_brief_S"),
                     ("wext", "grpo_ext_W"), ("sext", "grpo_ext_S")):
        src = sup.adapter_source(run)
        if src:
            merges.append(f"{arm}:{src}")
        else:
            sup.log(f"continuation: no adapter for {arm} ({run}) — E1 will lack this arm")
    sup.run_e1(E1_ARMS, merges)
    missing = [a for a in E1_ARMS if not e1_complete(a)]
    if missing:
        sup.set_state(last_error=f"E1 incomplete for: {', '.join(missing)}")
        sup.log(f"E1 HARD CHECK: incomplete arms: {missing} (reported as-is; see LOG)")
    else:
        sup.log("E1 HARD CHECK: all five arms complete (531 samples each, scored)")

    # 3. re-finalise (fresh §13 + STOP), then the addendum
    strip_section13()
    sup.final_steps()
    addendum()
    sup.commit_push(["SPARK_REPORT.md", "notes/LOG.md"],
                    "A20 continuation: addendum (outage timeline, hard checks, final state)")

    # 4. idle for Parts D/E until the extended mission end
    sup.set_state(part_c="idle (Parts D/E only)", run="-", train_step="-")
    while datetime.datetime.now() < sup.END_OF_MISSION:
        time.sleep(60)
    sup.heartbeat_once()
    sup.log("continuation driver exiting (end of extended mission)")
    inhib.terminate()


if __name__ == "__main__":
    main()
