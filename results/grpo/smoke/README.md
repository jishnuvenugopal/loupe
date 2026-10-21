# A20 smoke results (PREREG-A20 §6; run before the stamp)

`a20/smoke.sh` (+ the fix-verification run `smoke_fix_W`, see below) ran each
arm at both settings for 2 steps with the 10-step callback forced to step 1
(`--callback-every 1 --save-steps 1`; the real runs use 10/10), the full
64-row held-out eval at every step, `TRL 1.15.0 / PEFT 0.21.2` installed
in-container exactly as the trial's lane.

## Runs

| run | arm | lr | steps | rc | checkpoints | CSV rows | notes |
|---|---|---|---|---|---|---|---|
| smoke_W_lr6 | W | 1e-6 | 2 | 0 | checkpoint-1, checkpoint-2 | 1, 2 | |
| smoke_S_lr6 | S | 1e-6 | 2 | 0 | checkpoint-1, checkpoint-2 | 1, 2 | adapter used for the first (failed) merge attempt |
| smoke_W_lr5 | W | 1e-5 | 2 | 0 | checkpoint-1, checkpoint-2 | 1, 2 | |
| smoke_S_lr5 | S | 1e-5 | 2 | 0 | checkpoint-1, checkpoint-2 | 1, 2 | |
| smoke_W_lr6 (resumed) | W | 1e-6 | 2 | 0 | resumed from checkpoint-1, re-reached checkpoint-2 | 1, 2 | **resume check: PASS** (`--resume-from-checkpoint /runs/smoke_W_lr6/checkpoint-1`; step 2 re-trained, row rewritten) |
| smoke_fix_W | W | 1e-6 | 2 | 0 | checkpoint-1, checkpoint-2 | 1, 2 | run with the corrected callback (+08 timestamps via container TZ) |

## The four B6 checks

1. **CSV has every B2 column — PASS.** Header of every `smoke_*.csv`:
   `step,mean_reward,kl,entropy,mean_completion_length,zero_advantage_rate,heldout_tb_pass_rate,heldout_strict_pass_rate,lr,wall_s,timestamp`.
   Example row (smoke_fix_W step 1): mean_reward 0.047, kl empty (null — beta=0,
   pre-declared), entropy 0.488, mean_completion_length 442.6,
   zero_advantage_rate 0.875, heldout_tb_pass_rate 0.094 (W reward),
   heldout_strict_pass_rate 0.078 (S reward).
2. **One checkpoint written — PASS.** `checkpoint-1` and `checkpoint-2` under
   each run dir, each holding `adapter_model.safetensors`, `adapter_config.json`,
   `optimizer.pt`, `rng_state.pth`, `scheduler.pt`, `trainer_state.json`
   (everything `--resume-from-checkpoint` needs).
3. **One resume from that checkpoint works — PASS.** rc=0, step 2 retrained,
   CSV row for step 2 rewritten, `final_adapter` re-saved.
4. **E1 generates 2 tasks from a 2-step adapter — PASS.** The smoke_fix_W
   adapter (corrected code) was merged to bf16 (`~/runs/e1_models/smoke_fixw`,
   sha256 record in `results/e1/models/smoke_fixw.sha256.json`) and
   `gen/gen_vllm.py` (untouched) generated the first 2 gated VE tasks and the
   first 2 gated RTLLM tasks, n=1, T 0.2, max_tokens 2048; rows carry the full
   schema (arm e1-smoke_fixw, prompt_sha256 from the built files, per-task
   seed, finish_reason stop). See `results/e1/smoke_gen_rows.txt`. (The first
   merge attempt against smoke_S_lr6's adapter failed on the missing-peft
   bug — fixed, see below.)

## Bugs found by the smoke and fixed before the stamp

- **Duplicate final CSV row (fixed):** TRL delivers the end-of-train summary
  through `on_log` too, so the step-N row was written twice and the second
  (empty-window) write clobbered the real one. Fix: `on_log` acts only on
  per-step training logs (`"loss" in logs`). The four `smoke_*` CSVs above
  still show the clobbered last row (they ran the pre-fix code);
  `smoke_fix_W.csv` is the corrected behaviour and the pinned code produces
  that behaviour.
- **Merge container missing peft (fixed):** `e1/run_e1.py`'s merge container
  now installs `peft==0.21.2` first (same pin as the training lane).
- **E1 smoke mount shadowing (fixed before it could bite):** the generation
  container mounts the gen dir at `/genout` and `~/runs` at `/runs`, so the
  merged model path resolves in both normal and smoke runs.

## Facts for the real runs

- Held-out eval ≈ 6.5 min per callback (64 rows, greedy, batch 16, ≤768 new
  tokens; TB+formal rewards on 64 completions). Training step ≈ 66–70 s.
  Expected wall: brief arm ≈ 3.2 h (100 steps + 10 evals), extension arm
  ≈ 8.5–9 h (300 steps + 30 evals).
- Reward wall stays small at these pass rates (S arm: 0.15 s/call).
- GPU peak ≈ 43 GiB of 121 GB (colocate 0.3 + LoRA training + eval batches).
