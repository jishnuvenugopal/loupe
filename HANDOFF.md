# HANDOFF — continuation notes for the next session

Repo: `~/rtl-strict-eval`, branch `spark`, private
`jishnuvenugopal/rte-strict-eval`. DGX Spark `spark-cff9` (aarch64, GB10).

## Current state (10 Nov 2026, 14:51 +08)

- Main study + A19 are recorded complete: `results/main/summary.md`,
  `results/sens/summary.md`, `results/main/g2.txt`, tag `phase10-results`.
- A20 brief-W, brief-S and extended-W finished. The October DNS outage left
  extended-S untrained and extended E1 absent; see `notes/LOG.md`.
- Operator requested a status report and then explicitly approved continuation
  (`yes`) in this session. **Extended-S training remains live**, launched at
  14:33 before this session, same container and training PID throughout handover.
- Active supervisor: **tmux `a20-recovery`**, PID **3563814**.
  Log: `~/runs/a20_recovery.log`. Trainer: PID **3515354**, container
  `a20_grpo_ext_S` (ID starts `1bef63a94802`). Training log:
  `~/runs/grpo_ext_S.train.log`; checkpoint/adapter files stay under `~/runs/`.
- **Old supervisor PID 3515236 in tmux `a20` is deliberately SIGSTOP-paused.**
  Do NOT resume it or close that pane while training is live: keeping its tty
  open avoids a hangup reaching the old Docker client. The new driver retires
  that paused supervisor after the adopted training exits. Only `a20-recovery`
  actively supervises work. Independent tmux `keepawake` is still running.

## What changed (unfrozen operational code only)

Commit `dc6443f` fixes the 10-Nov recovery wrapper and adds adoption/validation
helpers plus regressions under `a20/`. The old wrapper demanded 531 rows in
*each* benchmark file and then finalized even on failure. The corrected wrapper:

1. adopts the live container (no training restart);
2. preserves the pre-registered limit of two checkpoint resumes with unchanged
   settings; checks all 30 B2 rows and the final adapter/metrics before E1;
3. requires exact generation identities (432 VE + 99 RTLLM) and 531 score
   identities per arm, plus seeds, prompt hashes and scorer provenance;
4. checks pins before scoring, subprocess results and all-arm report coverage;
5. never writes a success report when validation fails. Errors block downstream
   jobs and update `SPARK_REPORT.md` §13 / `spark_report.json.a20_recovery`.

Evidence: `results/e1/recovery_checks.json` (40 pins pass; base/w100/s100
complete; wext/sext absent at startup), `results/e1/recovery_tests.txt`
(14 tests pass), `results/grpo/grpo_ext_S_status.json` (running; prior failed
attempt retained). No frozen training/scoring/generation/analysis file changed.

## Next work / restart safety

- The active driver finishes extended-S → E1 missing arms → exact checks →
  E1 report and final status. Existing valid base/w100/s100 outputs are reused.
- Heavy-work deadline remains **14 Nov 20:00 +08**; heartbeat/Part E polling
  ends **15 Nov 23:59 +08**, as set by the prior continuation.
- Blind-40 labels remain pending on `operator:results/main/blind40/labels.csv`.
  The key never leaves this machine. No labels were fabricated or unblinded.
- **Do not launch another driver while one is live.** A lock protects corrected
  drivers, but the old paused process predates that lock. If the new driver dies,
  inspect process/container/checkpoint state first; use `--attach-container` only
  for the verified live container. Running without that flag refuses to restart
  an unfinished job from scratch. Do not reset resume counts or change settings.
- Nonzero training exits automatically resume from a checkpoint at most twice.
  Missing artifacts, monitoring errors, pin drift or exhausted retries stop the
  downstream chain for operator review. Never bypass the checks to finish a run.

## Standing cautions

Frozen: `scorer-v1`, the analysis pins (A19 extractor supersession), and PREREG-A20
pins (21-Oct supervisor supersession documented in `notes/LOG.md`). Stamped
preregistration bytes never change. No primary result changes from exploratory
A20 work. Push only through the existing hook to private `origin/spark` and
allowed tags; no force-push. Never push koder/, blind key, weights or ~/runs/.

Pre-existing untracked `PREREG-A19.md.ots.bak` and `PREREG-A20.md.ots.bak` were
preserved. Logs and GRPO status/CSV files can change asynchronously during training.
