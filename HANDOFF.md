# HANDOFF — continuation notes for the next session

You are the engineering agent on this DGX Spark (`spark-cff9`, aarch64, GB10,
128 GB unified). Repo: `~/rtl-strict-eval`, branch `spark` of
`jishnuvenugopal/rte-strict-eval` (private). Frozen: tag `scorer-v1` (`4e49950`),
tag `g0-prereg` (`f8f23aa`), tag `phase10-results` (`611e13a`), the pinned
`scoring/` analysis sha256s in PREREG, and the `grpo/`+`e1/`+`a20/` sha256s in
PREREG-A20.md (a20/supervisor.py superseded once, 21 Oct, logged in
notes/LOG.md).

## Where things stand (10 Nov 2026, ~14:40 +08)

- **Primary study (Phases 0–10 + A19): COMPLETE** — `results/main/summary.md`,
  sensitivity `results/sens/summary.md`, G2 final `results/main/g2.txt`, G1b
  pass, blind-40 packets drawn (key on this machine only).
- **The A20 unattended window ran 21–31 Oct.** DNS to the outside died
  ~22 Oct 09:00 and returned ~8 Nov 05:00. The supervisor behaved per design:
  brief W (3.28 h) + brief S (3.35 h) + ext W (29.75 h) done with all 10-step
  CSVs; pushes queued locally during the outage and flushed 10 Nov
  (`6977dca..8fda0e3`); `ots` upgrades all complete (A20 stamp: 2 Bitcoin
  attestations); heartbeats every 6 h through 31 Oct 23:59.
- **Two outage casualties, being fixed now** (operator: "continue what's
  left", 10 Nov): `grpo_ext_S` died at birth (pip could not reach PyPI; 0
  checkpoints) and the ext-setting E1 was a hollow ok (merge pip failure →
  run_e1 skip path → "ok" with nothing generated). Diagnosis + hard checks:
  `a20/continue_after_outage.py`.

## What is running

- `tmux attach -t a20` — `a20/continue_after_outage.py`: reuses the pinned
  supervisor machinery via import (only DEADLINE/END_OF_MISSION constants
  monkey-patched to 14/15 Nov): grpo_ext_S 300 steps (~30 h expected — ext_W
  took 29.75 h as rewards improve and formal checks lengthen) → E1 on all
  five arms with hard completeness checks (531 samples/arm) → strip + re-append
  SPARK_REPORT §13 → STOP line → addendum → idle.
- `tmux attach -t keepawake` — independent sleep:shutdown:idle block inhibitor
  (still up since 21 Oct).
- Heartbeats continue every 6 h; the Part E poll every 30 min watches for
  `results/main/blind40/labels.csv` on branch `operator` (still nothing there).

## If you wake up and something is wrong

- `tail -40 notes/LOG.md`, `tail -6 notes/HEARTBEAT.md`,
  `tail -50 ~/runs/a20_supervisor.log` (the continuation logs there too),
  `tmux attach -t a20`.
- A crash mid-ext_S: checkpoints every 10 steps under `~/runs/grpo_ext_S/`;
  rerun `a20/continue_after_outage.py` in tmux — every step is resumable
  (run_grpo resumes from the last checkpoint at most twice, statuses gate the
  order, E1/gen/scoring all skip completed work). Never change hyperparameters,
  data, seeds or the reward to make a run finish.
- ext_S already 'done' but E1 missing: the driver still runs the E1 +
  re-finalise steps; just relaunch it.

## Standing cautions (unchanged)

- Rules §2 absolute: push only to `spark` (+ allowed tags); no force-push/ref
  deletion; no koder/, weights, adapters, checkpoints, the blind-40 key or
  anything under `~/runs/` in the repo; no numbers without file pointers; pin
  mismatches reported, never substituted.
- `scorer/` and the pinned `scoring/` analysis code never change; `grpo/`,
  `e1/`, `a20/` are frozen at their PREREG-A20 sha256s (documented supersessions
  only). PREREG-A20.md is OTS-stamped: its bytes never change.
- Freeze checks before any scoring run: `git diff --quiet scorer-v1 -- scorer
  tests ':(exclude)scorer/__pycache__'` AND `sha256sum -c
  results/pilot_repro/SCORER_SHA256`.
- The blind-40 key (`~/runs/blind40_key.json` + `.backup.json`) never leaves
  this machine; only `KEY_SHA256` is committed.

First commands to orient yourself:
  tmux attach -t a20        # (detach: Ctrl-b d)
  tail -6 notes/HEARTBEAT.md && tail -20 notes/LOG.md && tail -20 ~/runs/a20_supervisor.log
