# PREREG-A20 — Phase 9 (GRPO stretch) + E1, fixed before any training step

Written and OpenTimestamps-stamped before the first Phase 9 training step, per
amendment A20 (operator, 21 Oct 2026, carrying the G3 decision `G3 pass, start
GRPO`, effective after Part A and this stamped file are pushed). Phase 9 and
E1 are **exploratory**: they never change the primary results, the primary
table in `results/main/summary.md`, or any primary contrast. Everything they
produce lives under `results/grpo/` and `results/e1/` (+ `scores_e1/`).
`PREREG.md` (tag `g0-prereg`) and `PREREG-A19.md` stay byte-identical to
their stamps; `scorer/` and the pinned `scoring/` analysis code are untouched.

## 1. Phase 9, brief setting

- **Base model (correction to the earlier report):** Phase 9 trains
  `Qwen/Qwen2.5-Coder-1.5B-Instruct` at revision
  `2e1fd397ee46e1388853d2af2c993145b0f1098a` (the brief's "GRPO stretch base",
  Apache-2.0, weights verified 8/8 in `results/h0/weights_sha256.tsv`) — not a
  3B model.
- **Arms.** W = the row-testbench verdict only. S = testbench + non-vacuity +
  formal ≤ 10 s, with a 10,000-vector simulation fallback. Both exactly as
  `grpo/reward.py` implements them (`reward_for_row(..., "weak"|"strict")`;
  formal via the frozen `deep/common.py` machinery with
  `BMC_TIMEOUT = PDR_TIMEOUT = 10`).
- **Shared settings** (same model, data and seed 0 for both arms): the passed
  2-step trial's GRPOConfig (`grpo/train_grpo.py`,
  `results/shakedown/grpo_trial_S.json`; lane: `pip install trl==1.15.0
  peft==0.21.2` in `nvcr.io/nvidia/vllm:26.05.post1-py3`, colocated vLLM):
  - `num_generations 8`, `per_device_train_batch_size 8`,
    `gradient_accumulation_steps 8`
  - `max_completion_length 768`, `learning_rate 1e-6`, `bf16`
  - colocated vLLM at `vllm_gpu_memory_utilization 0.3`
  - LoRA r 16 / alpha 32 / all-linear (`task_type CAUSAL_LM`)
  - the VeriReason system prompt (`prompts/system_prompts/verireason.txt`,
    sha256 per PREREG `75a7d783…`)
  - 100 steps per arm; `seed 0`; `max_prompt_length 1024` when offered
    (operational, unchanged from the trial)
- **Data:** the trial's dataset file
  `~/hf/hub/datasets--Nellyw888--VeriReason-RTL-Coder_7b_reasoning_tb/snapshots/42823db968114c25da260dece0e4bea8ab20d573/train_tb_filtered.jsonl`
  (revision `42823db968114c25da260dece0e4bea8ab20d573`, 1,149 rows, file
  sha256 `ca03fa1b7be46a7ba56db17587cd3c20a18073303ba986096164422bb7746417`),
  minus any H0-d overlaps — **0 were found** (`results/h0/h0d_contamination.json`),
  so nothing is excluded on contamination grounds.
- **Held-out set:** before training, 64 row indices drawn with
  `random.Random(20261021).sample(range(1149), 64)`, listed below, excluded
  from training. `grpo/train_grpo.py` recomputes the draw at every run start
  and hard-fails unless it equals `grpo/heldout_indices.txt` (committed,
  pinned in §6) element for element.

  Held-out indices (sorted, 64 values — the committed `grpo/heldout_indices.txt`
  is authoritative and hard-checked at every run start):
  0, 22, 26, 30, 37, 61, 95, 102, 110, 112, 126, 150, 175, 185, 194, 206,
  211, 216, 223, 234, 242, 246, 288, 312, 321, 348, 362, 366, 416, 441, 449,
  477, 494, 518, 522, 530, 539, 546, 572, 620, 631, 643, 667, 673, 732, 749,
  780, 784, 788, 811, 817, 828, 830, 836, 868, 944, 945, 986, 1078, 1079,
  1082, 1118, 1140, 1143.

## 2. Logging (every 10 steps, both arms)

CSV at `results/grpo/grpo_<setting>_<arm>.csv`, one row per 10 steps (plus the
final step), columns exactly:
`step, mean_reward, kl, entropy, mean_completion_length, zero_advantage_rate,
heldout_tb_pass_rate, heldout_strict_pass_rate, lr, wall_s, timestamp`.

- `mean_reward`, `zero_advantage_rate`, `mean_completion_length`: means/rates
  over the window since the previous row (zero-advantage = groups of
  `num_generations` whose rewards are all equal).
- `kl`: **null by construction** — the trial's GRPOConfig leaves `beta` at
  the trl 1.15.0 default (0.0), so no reference model and no KL term exist;
  changing `beta` would change the trial's config, so it is not done. The
  policy `entropy` (same window) is logged beside it.
- Held-out, BOTH measures for BOTH arms (so W and S can be compared on both):
  `heldout_tb_pass_rate` = share of the 64 held-out rows whose completion
  scores reward 1.0 under the **W** reward; `heldout_strict_pass_rate` = the
  same under the **S** reward. Held-out generation: the current policy (the
  PEFT model in training), greedy decoding (`do_sample=False`), batch 16,
  `max_new_tokens 768`, the training system prompt.
- Checkpoints every 10 steps under `~/runs/grpo_<setting>_<arm>/checkpoint-N`
  (never in git); the final adapter at `~/runs/grpo_<setting>_<arm>/
  final_adapter`; the sha256 of each final adapter's files committed to
  `results/grpo/grpo_<setting>_<arm>_adapter.sha256.json`. After every 10-step
  row the supervisor commits the CSV and a plot (`a20/plot.py`) and pushes.

## 3. Extension setting (pre-declared)

- **Why:** the trial showed a zero-advantage rate of 0.81–0.88 and a mean
  reward of about 0.02, so at LoRA lr 1e-6 for 100 steps the brief setting
  may not move the policy.
- **What:** only after the brief setting and its E1 are pushed, W and S run
  again **from the base**. Everything stays identical (model, data, held-out
  split, seed, all GRPOConfig fields) except `learning_rate 1e-5` and
  `max_steps 300`, with the same logging.
- Both settings are reported; neither replaces the other.

## 4. E1 (exploratory evaluation, decided before training)

Covers base, W-final and S-final of each completed setting (an incomplete
run contributes its last saved adapter, flagged as such).

- **Generation:** the gated sets — VerilogEval 144 (`scoring/gates/
  ve_strict.txt`) and RTLLM 33 (the headline set: `rtllm_strict.txt` minus
  `rtllm_apart.txt`); n = 3 samples per task; the same system prompt as in
  training; the same prompt-building code as the primary arms
  (`gen/gen_vllm.py`, untouched, over the committed built rows; the filtered
  task lists are `prompts/built_e1/verireason_gated_{ve,rtllm}.jsonl`,
  derived deterministically from the committed built files + gate lists by
  `e1/make_prompts.py`, sha256 in §6); the 3B arms' sampling settings (T 0.2,
  top_p 0.95, `top_k -1`, `min_p 0`, `repetition_penalty 1.0`, per-task seed
  `int(sha256(task_id)[:8],16)`, `max_model_len 4096`) but **max_tokens 2048
  for every arm**. Outputs `~/runs/gen_e1/e1-<arm>_<bench>.jsonl`.
- **Trained-arm path:** each final adapter is merged into a full bf16 copy
  under `~/runs/e1_models/<arm>/` (`e1/merge_adapter.py`); every merged
  file's sha256 is recorded in `results/e1/models/<arm>.sha256.json`
  (committed; weights never in git). `gen/gen_vllm.py` is untouched and loads
  the merged copy like any base model. The E1 base arm is the raw pinned
  snapshot.
- **Scoring:** the frozen `scorer-v1` via the pinned `scoring/run_scoring.py`
  (SAT_TIMEOUT 60, WORKERS = nproc − 2, cex under `results/e1/cex/`), scores
  in `scores_e1/`; the pinned `scoring/stats.py` methodology (gate lists,
  A17/A18 classes, task-clustered bootstrap, 10,000 resamples,
  `default_rng(0)`).
- **Report** (`results/e1/summary.md` + `stats.json`, by `e1/report.py`):
  official pass@1, the not-proved-correct share, the
  correct-within-depth-d share and the proved-wrong floor, each with its
  task-clustered 95% CI, per arm × benchmark; the contrasts W − base, S − base
  and S − W for official pass@1 and for the not-proved-correct share (paired,
  same task draws).
- **G2:** the extraction check (`scoring/extract.py`) runs on every E1 file
  and is reported as-is. E1 is exploratory, so there are no waivers, just a
  flag.

## 5. Run rules (unattended, `a20/supervisor.py` under tmux)

1. Brief W 100 → brief S 100 → push. 2. E1 on base, W-100, S-100 → push.
3. Extension W 300 → extension S 300 → push. 4. E1 on W-ext, S-ext → push.
5. Final steps (ots upgrades, SPARK_REPORT section "Phase 9 + E1 (A20)",
   `STOP — Phase 9 + E1 done; waiting for the operator (31 Oct)`), then idle.
- One heavy job at a time, through the same containers as before; GRPO never
  overlaps generation or scoring; the Part E unblind is a seconds-long CPU
  step and may run at any time.
- On a crash (or a 60-minute stall with no log/CSV progress): resume from the
  last checkpoint, at most 2 times per run. Hyperparameters, data, seeds and
  the reward are never changed to make a run finish. A run that still fails is
  marked incomplete (why recorded), E1 runs on what did finish, and the order
  continues.
- Push failures retry with backoff for up to 24 h; work continues locally.
- Heavy work stops by 30 Oct 2026 20:00 +08: the deadline is checked before
  starting each job (a job already running is allowed to reach its next safe
  point — its natural end or the next 10-step checkpoint).
- Heartbeat every 6 h to `notes/HEARTBEAT.md` (+ push; retries pending
  `ots upgrade`). Part E polls `origin/operator` every 30 min for
  `results/main/blind40/labels.csv`, validates it (exactly the 40 template
  ids; labels among `real bug`, `reference wrong`, `allowed by spec`,
  `unclear`, `scorer artefact`), copies it byte-for-byte, records the operator
  commit sha + commit time, re-checks the key sha256 against `KEY_SHA256`,
  runs the pinned `scoring/blind40.py --unblind --key ~/runs/blind40_key.json`
  (no `--out` flag; it writes `results/main/blind40/unblinded.json`), and
  rewrites the blind-sample section of `results/main/summary.md` with the
  overall and per-family shares and their Wilson 95% intervals. The key itself
  stays off git.

## 6. Code pins (sha256; frozen after the stamp)

Filled after the smoke test below passed; these files do not change after the
stamp.

- `grpo/train_grpo.py` — `e63269855d6a3d97f83428c687e3c22f7076eab9051c871e9fe691e81e2841fe`
- `grpo/heldout_indices.txt` — `f3f42290aa20228b8d01e9d5446f06853414e454826dafdd2aa62d405a4742f0`
- `grpo/reward.py` — `3d4ae0fb2d0cd6a5549bbbdb704e8770f8e00815e1cc50d477407d9ec25ce5d4`
  (unchanged since the trial; pinned here for reference because Phase 9 depends on it)
- `e1/make_prompts.py` — `77b59dbd41ff293abf593196382b9cb4bce6200a021ed35a39fe11c54e530fdc`
- `e1/merge_adapter.py` — `635c92a62bda3996b09a9bc5e3367e5cd23f23a039de3571f2342d35f874d9c8`
- `e1/run_e1.py` — `93d5c442f227cdd965b7783bf6392822420db5a7733e19adf59d2eac4ddf7b6f`
- `e1/report.py` — `7aca060129ecb99ec951dc8d90b8075d96fac6fcc9c9820d87c2004b8a9c5c44`
- `a20/supervisor.py` — `ed9773421cfdd3fb1e94ad98d35dffcfb7376637dd90c40a0161ce0dbe91c6e2`
- `a20/plot.py` — `9ac87621a45363f0a99371dbbbe14f7969a28ea45374ecced18dbbc72c41cc1f`
- `a20/smoke.sh` — `f87b1692a26fe844aab3929198c237fece2e73692016803b7594fc8a5a8cdbef`
- `a20/run_supervisor.sh` — `ce6cfef844b8e331968cf59014227941fbdad2a1816075365a9f8d6044d40b3f`
- `prompts/built_e1/verireason_gated_ve.jsonl` — `fa0cf9b57441fbc7f5cc45bcf83e6110062e30c424cececb434fe71973a06381`
- `prompts/built_e1/verireason_gated_rtllm.jsonl` — `01fa84dd30072431c6692886ac2d8cb01e95cdb38e826cba078c339604b727bb`
- `prompts/built_e1/SHA256SUMS` — `b5ea72f79926d461abc6ecf2770656da4c2991d579265fc57f9e77b7584668d2`
- Smoke results (the corrected-code evidence): `results/grpo/smoke/README.md`
  `49c92817e37f08b18ef8a27d1340726f946290d4b68789abefaf3442c212333d`,
  `results/grpo/smoke/smoke_fix_W.csv`
  `14d8a45f2b45f483b12a6c3cbb4b49a37d578c9d19b22f458de1dee89e7e17e2`,
  `results/grpo/smoke/smoke_fix_W_adapter.sha256.json`
  `9c176095396e6227f71ce85e328d139e1ba461fa1653d5c4513d0458b83e184e`,
  `results/grpo/smoke/smoke_fix_W_metrics.json`
  `f28ebf28b2a76b36bd79c5c858113b1d8ef477f8f61870a3d7a839003843c7d1`,
  `results/e1/smoke_gen_rows.txt`
  `7eada4aa8523c105639fd60981f5328c2be92156547e84ee04c69b3d0fb69709`,
  `results/e1/models/smoke_fixw.sha256.json`
  `dcf33a5ea525b971b29ff80efdf0d569dee567b8c7d8a3e23dbfa687b5cf3f5e`.
  (The four pre-fix `smoke_*` CSVs are kept in the same directory as the
  honest record of the smoke process; the README names which behaviour each
  shows.)

### Smoke test (run before the stamp; `a20/smoke.sh` + the `smoke_fix_W` verification)

Each arm at both settings for 2 steps with the 10-step callback forced to step
1 (`--callback-every 1`, `--save-steps 1`; the real runs use 10/10):

1. the CSV has every B2 column — **PASS** (`results/grpo/smoke/README.md`)
2. one checkpoint is written — **PASS** (checkpoint-1, checkpoint-2 under each
   run dir, full resume payload)
3. one resume from that checkpoint works — **PASS** (rc=0, step retrained,
   CSV row rewritten)
4. E1 generates 2 tasks from a 2-step adapter — **PASS** (merged bf16 copy +
   untouched `gen_vllm.py`, rows in `results/e1/smoke_gen_rows.txt`)

The smoke also caught and fixed three defects before the stamp (duplicate
final CSV row via TRL's summary `on_log`; missing `peft` in the merge
container; a smoke-path mount shadowing) — all recorded in
`results/grpo/smoke/README.md`.

## 7. What does not change

`scorer/` (byte-identical to `scorer-v1`), the pinned `scoring/` analysis
code, prompts, primary-arm generations and every primary number
(`results/main/`, `results/sens/`), the blind-40 draw and key handling, tags
`scorer-v1` / `g0-prereg` / `phase10-results`, and the push guard's rules
(only `spark` and the allowed tags; `operator` is fetched, never written,
merged, rebased or checked out).
