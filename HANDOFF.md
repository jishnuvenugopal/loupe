# HANDOFF — continuation notes for the next session (19 Oct 2026, night)

You are the engineering agent on this DGX Spark (`spark-cff9`, aarch64, GB10, 128 GB).
Master brief: `~/Downloads/pi/halo/spark-agent-brief.md` + addenda A16/A17/A18
(`koder/docs/brief-spark-addendum-A*.md`, verbatim). Read A18 §8 first — it is the
operator's G0 approval, conditional on C1–C5, and it is being executed tonight by
`shakedown/overnight_chain.sh` under tmux (`tmux attach -t overnight`).

## Machine state (19 Oct ~01:00 +08)

- **The A18 §8 chain is running autonomously in tmux session `overnight`**:
  C1 PASS (items 1–5+7 committed `c83f842`+`138c293`, pushed, PREREG sha256 final),
  C2 PASS (8/8 weights hash-verified 19 Oct 00:52; the "stuck 7B download" was
  root-caused — see §12 of SPARK_REPORT.md and notes/LOG.md 23:52–00:05), then
  C3 7B shakedowns → C4 steady-state projection + cut ladder (≤9 h) → C5 PREREG
  final → G0 steps (tag `g0-prereg`, push, ls-remote, `ots stamp`) → Phase 8
  generation (docker-driven, cuts only from `gen/cut.txt`) → Phase 10
  (`scoring/phase10.py`) → STOP waiting for `G3 pass, start GRPO` + `blind labels in`.
  `ots upgrade` runs at T_stamp+6h as a detached job.
- Chain log: `~/runs/overnight_chain.log` + `notes/LOG.md` (every check).
  Dry run was verified before launch (forced C2 failure → stop+log+push, commit `e242afb`).
- Dead background jobs from the crashed 18 Oct session were removed (idle
  `grpo-trial` container, old A16 watcher). No stray downloads: all 8 weight sets
  are complete and verified.

## What A18 changed (all tested; `tests/test_a18_*.py` green)

1. `scoring/stats.py`: `ci95_all_tasks` (all-task bootstrap for G1b), vacuous as a
   flag (`vacuous_passes`; class counts add up), gate files hard-required, dedup
   `str(sample_idx)` keys + collapse report + no-match error, H2 paired contrast.
2. New pinned scripts (sha256 in PREREG "Analysis code"): `scoring/dedup.py`,
   `scoring/blind40.py`, `scoring/contamination.py` (machinery run: 0 overlaps,
   positive controls green; re-runs in Phase 10).
3. `shakedown/shakedown_run.py` records `official_passes_from_length` (A18 item 7);
   throughput runs now carry `load_s`/`steady_tok_per_s`.
4. Chain helpers: `shakedown/{c3_check,projection,prereg_finalize,report_status}.py`,
   `gen/run_overnight.py` (+`.sh`), `shakedown/overnight_chain.sh`.
   `gen/ve_subset60.txt` pins the cut-1 VE subset (`random.Random(0).sample`).

## If you wake up and the chain has STOPped

- `STOP — <condition> failed: <why>` is the last line of SPARK_REPORT.md and
  `~/runs/overnight_chain.log`; the failure is also in notes/LOG.md with context.
  Fix the cause, then re-run `bash shakedown/overnight_chain.sh` inside the tmux
  session — every step is resumable (scoring rows, generation rows) and
  C1–C5 re-verify cheaply. Do NOT bypass a condition.
- If it stopped at `ots stamp`: network/calendar issue; retry `ots stamp
  PREREG.md` manually, then continue the chain (it re-runs from the G0 steps only
  if you comment nothing — the tag push is idempotent, `ots stamp` is not; check
  whether PREREG.md.ots exists first).
- If Phase 8 partially ran: `~/runs/gen/<arm>_<bench>.jsonl` rows are resumed, not
  regenerated; `gen/cut.txt` holds the applied cut.

## Messages the run may be waiting for (exactly)

`G3 pass, start GRPO`; `blind labels in` (either order; Phase 9 only after G3 AND
never while Phase 10 scoring runs). The blind-40 key is `~/runs/blind40_key.json`
(outside the repo; only its sha256 is committed as `results/main/blind40/KEY_SHA256`).

## Standing cautions (unchanged)

- Rules §2 absolute: no force-push/ref deletion; no koder/ or weights in the repo;
  no numbers without file pointers; pin mismatches reported, never substituted.
- Freeze checks before every scoring run: `git diff --quiet scorer-v1 -- scorer
  tests ':(exclude)scorer/__pycache__'` AND `sha256sum -c results/pilot_repro/SCORER_SHA256`.
- scorer/ and prompts/ are frozen; the pinned analysis code is frozen at the
  sha256s in PREREG "Analysis code".

First command to orient yourself:
  tmux attach -t overnight   # (detach: Ctrl-b d)
  tail -30 ~/runs/overnight_chain.log && tail -40 notes/LOG.md
