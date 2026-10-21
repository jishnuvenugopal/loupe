# HANDOFF — continuation notes for the next session

You are the engineering agent on this DGX Spark (`spark-cff9`, aarch64, GB10,
128 GB unified). Repo: `~/rtl-strict-eval`, branch `spark` of
`jishnuvenopal/rte-strict-eval` (private). Frozen: tag `scorer-v1` (`4e49950`),
tag `g0-prereg` (`f8f23aa`), the pinned `scoring/` analysis sha256s in PREREG,
and after the A20 stamp, the `grpo/`+`e1/`+`a20/` sha256s in PREREG-A20.md.

## Where things stand (21 Oct 2026, after Part A of A20)

- **Phase 10 + A19 are complete.** Primary table: `results/main/summary.md`;
  sensitivity: `results/sens/summary.md`; G2 final output `results/main/g2.txt`;
  G1b `results/main/g1b.json` (all anchors PASS). Tag `phase10-results` marks
  the Part A commit.
- **The operator left on 21 Oct and returns 31 Oct 2026 morning (+08).**
  Until then: no messages. The operator reads GitHub only and may push
  `results/main/blind40/labels.csv` to branch `operator` (the only file you may
  read from that branch, via `git show origin/operator:...` — never check it
  out, never write to it).
- **A20 (this amendment, `koder/docs/` not needed — it arrived in-session and
  is reproduced in PREREG-A20.md's header):** G3 pass is carried by it.
  Parts: A close-out (done), B PREREG-A20 + Phase 9/E1 code + smoke (stamped
  before any training step), C the unattended run order, D heartbeat every 6 h,
  E blind-40 unblinding when the labels appear.

## What is running

- `tmux attach -t a20` — the A20 supervisor (`a20/supervisor.py`, launched by
  `a20/run_supervisor.sh`). It runs, in order, one heavy job at a time:
  1. GRPO brief setting: W 100 steps → S 100 steps (checkpoints + CSV/plots
     committed every 10 steps, pushed).
  2. E1 on base, W-100, S-100 (merge adapters → generate gated sets → score →
     report), pushed.
  3. GRPO extension setting: W 300 steps (lr 1e-5) → S 300 steps, pushed.
  4. E1 on W-ext, S-ext, pushed.
  5. Final: `ots upgrade` retries, SPARK_REPORT "Phase 9 + E1 (A20)" section,
     `STOP — Phase 9 + E1 done; waiting for the operator (31 Oct)`, then idle.
  In parallel (light): heartbeat every 6 h to `notes/HEARTBEAT.md` + push
  (retries any pending `ots upgrade` in the same beat), and the Part E poll
  every 30 min (`git fetch origin operator` … validate … unblind … update
  `results/main/summary.md` … push).
- Heavy work stops by **30 Oct 20:00 +08** (checked between jobs; the deadline
  is ~9 days after start, so on-schedule runs finish long before).
- On a crash mid-GRPO: the supervisor resumes from the last 10-step checkpoint
  at most 2 times per run; after that the run is marked incomplete (why in
  `results/grpo/` + LOG) and E1 runs on whatever finished. Hyperparameters,
  data, seeds and the reward are never changed to make a run finish.
- Push failures: retried with backoff up to 24 h; work continues locally.

## If you wake up and something is wrong

- `tail -40 notes/LOG.md`, `tail -10 notes/HEARTBEAT.md`,
  `tail -50 ~/runs/a20_supervisor.log`, `tmux attach -t a20`.
- A missing heartbeat line means the supervisor died: restart with
  `bash a20/run_supervisor.sh` inside tmux session `a20` — every step is
  resumable (generation rows, scoring rows, GRPO checkpoints, CSVs are
  append/dedup by step).
- If GRPO is wedged (GPU busy, no step progress): check
  `~/runs/grpo_<setting>_<arm>/` for the last checkpoint, kill the docker
  container, and let the supervisor's resume logic (or a restart) pick it up.
  Do not change any hyperparameter.

## Standing cautions (unchanged)

- Rules §2 absolute: push only to `spark` (+ the tags named in the local
  pre-push hook); no force-push/ref deletion; no koder/, weights, adapters,
  checkpoints, the blind-40 key or anything under `~/runs/` in the repo; no
  numbers without file pointers; pin mismatches reported, never substituted.
- `scorer/` and the pinned `scoring/` analysis code never change. `grpo/`,
  `e1/`, `a20/` are frozen at their PREREG-A20 sha256s after the stamp.
- Freeze checks before every scoring run: `git diff --quiet scorer-v1 --
  scorer tests ':(exclude)scorer/__pycache__'` AND `sha256sum -c
  results/pilot_repro/SCORER_SHA256`.
- The blind-40 key (`~/runs/blind40_key.json`, backup `.backup.json`) never
  leaves this machine; only `KEY_SHA256` is committed.

First commands to orient yourself:
  tmux attach -t a20        # (detach: Ctrl-b d)
  tail -30 notes/HEARTBEAT.md && tail -40 notes/LOG.md && tail -50 ~/runs/a20_supervisor.log
