# HANDOFF — continuation notes for the next session

Repo: `~/rtl-strict-eval`, private `jishnuvenugopal/rte-strict-eval`, branch
`spark`. DGX Spark `spark-cff9` (aarch64, GB10).

## Current state (10 Nov 2026, 21:32 +08)

- Main study + A19 recorded complete: `results/main/summary.md`,
  `results/sens/summary.md`, tag `phase10-results`.
- Extended-S training remains live in the ORIGINAL container `a20_grpo_ext_S`
  (`1bef63a94802…`), trainer PID **3515354**, started 14:33 +08. Checkpoint 200/300
  and 20 B2 rows recorded; zero training resumes. No second heavy job started.
- Active supervisor: **tmux `a20-recovery-a21`, PID 645785**, log
  `~/runs/a20_recovery.log`. It accepts the explicitly approved A21 packet-writer
  hash while retaining all other freeze checks (43 pins pass).
- Prior recovery supervisor 3563814 was retired at 21:31 to reload those checks;
  its only training-related child was a Docker waiter, not the original Docker
  client. Trainer PID, container start time and resume count did not change.
- Original supervisor **3515236 in tmux `a20` stays deliberately SIGSTOP-paused**.
  Do NOT resume it or close that pane while training lives: its terminal holds
  the original Docker client (3515249). The active supervisor retires it after
  training exits. Independent tmux `keepawake` remains active.

## A21 — approved repair COMPLETE; human review is ready

The 19:46 audit found that 33/40 blind packets displayed the wrong generated code:
`scoring/blind40.py` omitted arm from its generation lookup identity. The operator
explicitly approved the narrow repair. `PREREG-A21.md` records the post-generation
amendment, exact superseded pin and invariants; it was committed/pushed and separately
OTS-stamped before packet data changed (source/amendment commit `3d5ae54`).

- Frozen source changed only at the lookup's two key expressions plus docstring.
- Exactly 33 existing packet code sections repaired; all 40 now match their intended
  original generation and pass the existing blindness scrub.
- Same 40 IDs, draw, key bytes, metadata, blank template and non-code packet sections.
  No redraw, labels, unblinding, new generation or scoring was performed by the repair.
- 3,301 protected artifacts have identical aggregate before/after hashes; primary
  scores/results and all other frozen source are unchanged. Raw generated whitespace
  is intentionally preserved; `git diff --check` warnings in packet data are not
  grounds to normalize the code. Source/docs whitespace checks pass.
- Evidence: `notes/a21_packet_repair.json`, `notes/blind40_integrity_after_a21.json`,
  `notes/a21_packet_idempotence.json` (zero further edits), `notes/a21_freeze_check.json`.
  The original failure evidence remains at `notes/blind40_integrity_check.json`.
- Tests: `notes/a21_regression_before.txt` (3 expected failures),
  `notes/a21_regression_after.txt` (20 passes: 6 A21 + 14 recovery).

Operator's next action: review the CURRENT `results/main/blind40/packet/` files,
fill all IDs from `labels_template.csv`, save as `results/main/blind40/labels.csv`
on branch **operator**. Exact choices: `real bug`, `reference wrong`,
`allowed by spec`, `unclear`, `scorer artefact`. Avoid attribution files and repair
diffs/history while labeling. Never publish the key. Part E polls every 30 minutes.
The old warning not to label is superseded by the verified A21 repair.

## Remaining automatic work / restart safety

- Active driver: finish extended-S → validate all training artifacts → E1 missing
  arms → exact generation/scoring checks → E1 report and final status. Existing
  base/w100/s100 E1 outputs are reused. Current status in `SPARK_REPORT.md` §13 and
  `spark_report.json.a20_recovery`; review readiness in `.blind40_review`.
- No duplicate supervisors or heavy jobs. A lock protects corrected drivers.
  If supervision dies, inspect container/checkpoint state before re-adoption;
  never restart from scratch or reset an already-used resume budget.
- At most two checkpoint resumes with identical settings. Failed checks, pin drift
  or exhausted retries stop downstream work for operator review.
- Heavy deadline: 14 Nov 20:00 +08; heartbeat/label polling ends 15 Nov 23:59 +08.
- A21 OTS stamp is pending Bitcoin confirmation at 21:35
  (`notes/a21_ots_upgrade.txt`); retry `ots upgrade PREREG-A21.md.ots` once confirmed.
  The old pinned heartbeat upgrades only the three older stamps. Do not edit A21
  document bytes. Commit only an upgraded stamp and its log if/when available.

## Standing cautions

Freeze: scorer-v1; original analysis pins with A19 extractor and A21 packet-writer
supersessions; PREREG-A20 with its documented 21-Oct supervisor supersession.
Only the explicit A21 file is excluded from the phase10 tree comparison AND still
checked against its exact new digest. Never weaken other freeze checks.
Push only through the existing guard to private origin/spark and allowed tags;
no force-push. Never push koder/, the key, weights/adapters/checkpoints or ~/runs/.
Pre-existing untracked A19/A20 .ots.bak files and the local A18 brief are preserved.
Runtime logs/CSVs may change asynchronously; do not claim the whole tree is static.
