# SPARK REPORT — strict re-scoring, DGX Spark lane

Updated 18 Oct 2026, ~16:10 UTC. Machine `spark-cff9`. Repo
`jishnuvenugopal/rte-strict-eval` (PRIVATE), branch `spark`, tag `scorer-v1` pushed.

## 1. Status

- Session completed: Phase 1b (koder scaffold), Phase 5 H0-b/c/d, Phase 6 step 4
  (GRPO two-step trial, PASSED), Phase 6 step 5 (scoring-speed proxy), Phase 7
  PREREG draft. **Phase 1 exit check PASSED** after the operator's docker fix.
- In progress (background): Phase 4 model downloads (throttled uplink);
  **H0-a watcher** (`h0/watch_h0a.sh`, pid `~/runs/h0a_watcher.pid`) fires in the
  pinned PyTorch container as soon as the image + all four 3B checkpoints land,
  commits and pushes `results/h0/h0a_weight_distance.json`.
- Pending next interactive session: Phase 6 steps 1–3 shakedown generation
  (harness ready: `shakedown/shakedown_run.py`; runs when 7B/3B weights land;
  ~1–2 h GPU total), then PREREG "Measured before G0" refresh.
- Last gates: G1-Spark passed; H0 b/c/d passed; GRPO trial lane green;
  **G0 not requested yet**.
- `STOP — waiting for operator review of PREREG.md and the message "G0 approved"`
  (H0-a + shakedown numbers will land automatically/next session before that).

## 2. Machine

- Linux 7.0.0-1019-nvidia, aarch64, 20 cores (Cortex-X925/A725), 121 GB RAM,
  GB10 GPU, 3.5 TB free (`notes/LOG.md` D0 entry; `spark_report.json.machine`).
- EDA (pinned `oss-cad-suite-linux-arm64-20261016.tgz`, 686,594,072 bytes
  exact): Yosys 0.70+145, Icarus 14.0 (devel), Verilator 5.053 (devel),
  SymbiYosys 0.70.
- Containers: docker 29.2.1, daemon accessible via `sg docker` (agent shells
  predate the usermod). **vLLM image pulled**: `nvcr.io/nvidia/vllm@sha256:94e21552f644e0c1627464ba89d2f7a4ce7442e196f72afa0bb5d7fba23cbb03`
  (20.4 GB). PyTorch `25.11-py3` pulling (digest recorded on arrival).
  In-container stack: torch 2.12.0a0+5aff3928d8.nv26.05, vLLM 0.21.0+2325b6f0,
  trl 1.15.0, peft 0.21.2.
- Host venv `~/.venvs/host`: huggingface_hub 2.2.0, hf-xet 1.7.0, datasketch
  2.0.0, pyyaml 6.0.3, opentimestamps-client 0.7.2 (no apt needed — venv works
  without `python3-venv`; deviation recorded). `ots` CLI present for G0.

## 3. G1-Spark (frozen at `scorer-v1`, commit `4e49950`)

- 290/290 RTLLM-shipped GPT rows match Appendix B testbench verdicts; equiv
  columns 280/290 (the 10 `synchronizer` rows: pilot "error" vs null — same
  two-clock-domain Yosys limit, recording only). Totals GPT-4 60/39/14/7,
  GPT-3.5 37/25/4/8. Files: `~/runs/deep/gpt_summary.json`, `DEEP_REPORT.md` §5.
- Deep gates (soundness/power/independence/spec/anchor) all passed;
  `DEEP_REPORT.md` + `deep_report.json`. Notably: strict kill 438/438 on
  formally-different mutants; 0 flips on the 64 pilot-equivalent official
  passes; zero pass/fail disagreements Icarus vs Verilator (340 + 156 rows).
- Scorer hashes: `results/pilot_repro/SCORER_SHA256`
  (file sha256 `3428447f263d36e741a00d8d8a6bb50c4929a32b033b5e080ce43eb1f76d484e`).

## 4. Models (Phase 4 — in progress)

- 8 pinned arms queued in `models/fetch.sh` (smallest-first; pins unchanged);
  both GRPO datasets downloaded at pinned revisions (1,149 + 743 rows).
- Verification: `models/verify_weights.py` checks every `*.safetensors`
  sha256 against `?blobs=true` `lfs.sha256`, copies card text files into
  `models/cards/<id>/`, writes `models.yaml` + `results/h0/weights_sha256.tsv`.
  At report time: **no model fully verified yet** (downloads running); the TSV
  and `models.yaml` carry per-arm `status` and will say `verified` per arm as
  each completes. Exit check (8×verified) is NOT met yet.
- Licence notes: as PREREG "Licences"; 3B family non-commercial
  (Qwen Research License); CodeV-R1-RL has no LICENSE file (card text copied).

## 5. H0 answers

See `results/h0/H0.md` for the version with all file pointers.

- **H0-a (3B SFT parent)**: PENDING — needs the pinned PyTorch container;
  docker blocked. Script ready (`h0/h0a_weight_distance.py`), pre-registered
  decision rule included. No number computed.
- **H0-b (CodeV protocol)**: copied into `PREREG.md` §"Fidelity gate G1b" with
  source URLs and the runner-conflict note.
- **H0-c (prompts)**: system-prompt sha256s recomputed from pinned sources —
  both match Appendix D1/D2 exactly. 412 prompt rows built with per-row
  `prompt_sha256` (`prompts/built/*.jsonl`, `prompts/SHA256SUMS`). RTLLM v2.1
  vs CodeV v2.0: 41/50 identical, 9 differ
  (`results/h0/h0c_rtllm_diff.json`).
- **H0-d (GRPO data)**: reward oracle 30/30 seeded rows reproduce `tb_result`
  byte-exactly; contamination 0/1,149 and 0/743 (closest pair J < 0.3,
  positive control green). Nothing to exclude from GRPO prompts.

## 6. Shakedown

| item | value | evidence |
|---|---|---|
| scoring speed (proxy, 20 GPT-4 t1 designs, WORKERS=18) | 42.9 s total → 0.466 samples/s ≈ 2.1 s/sample; formal 96% of EDA time; mix 8 pass/8 fail/4 compile_error | `results/shakedown/scoring_speed.json`, `results/shakedown/README.md` |
| GRPO two-step (vLLM-container lane) | **PASSED**: trl 1.15.0 + peft 0.21.2 on vLLM 0.21.0; train 171.3 s (2 steps; 88.6/73.7 s per step); reward 17.1 s / 128 calls (~0.13 s/call); zero-advantage 0.812 (13/16 groups, matches TRL frac_reward_zero_std); mean reward 0.016→0.047; peak GPU 52.25 GiB | `results/shakedown/grpo_trial_S.json`, `grpo/train_grpo.py`, `grpo/reward.py` |
| machinery smoke (gen_vllm.py, 1.5B, 2 prompts) | rows match §8 schema; seed + prompt_sha256 verified in-container | `~/runs/shakedown/machinery_smoke.jsonl` (deleted with phase) |
| 7B/3B generation throughput, cap hits, extraction rate | pending weights (harness ready) | `shakedown/shakedown_run.py` |
| overnight projection | cannot be pre-computed; adaptive check at Phase 8 step 4 proposed | `PREREG.md` §"Measured before G0" |

## 7. Deviations from the brief (each with reason)

1. apt packages + docker group not installed (no passwordless sudo; Phase 1
   operator leftover) → venv built without apt python3-venv (works),
   containers/H0-a/Phase 6 steps 1–4 blocked.
2. `HF_HUB_ENABLE_HF_TRANSFER` deprecated in hub 2.2.0; high-performance xet
   (`HF_XET_HIGH_PERFORMANCE=1`) stalls on this network → downloads use
   default xet; `~/.bashrc` exports the new variable name for documentation.
3. Model fetch reordered smallest-first (operational; pins unchanged).
4. Phase 6 step 5 timed on RTLLM-shipped GPT-4 designs instead of shakedown
   samples (which require vLLM) — timing proxy, never a result.
5. VE gate 149/156 and RTLLM usable 40 (38+multi_8bit+multi_pipe_8bit) used in
   PREREG instead of the brief's 143/38, per the frozen deep-scorer results
   (operator instruction, this session; evidence files cited in PREREG).
6. koder/STATE.md written with current facts instead of the brief's literal
   template text (Phases 2–3 were already complete when koder was initialized).
7. `_simple` dataset's data file is `processed_entries.jsonl` (not
   `train_tb_filtered.jsonl`); rows/columns match §3.3 (743, same keys).
8. `h0/` and `shakedown/` script directories added to the layout (brief §4
   names no home for H0/phase-6 harness code).

## 8. Open questions for the operator

1. **docker group + apt** (Phase 1): needed for H0-a, Phase 6 steps 1–4, and
   Phase 8. `sudo usermod -aG docker unnitools` + the apt list in Phase 1 §1.
2. **G0 sequencing** (see PREREG "Measured before G0"): fix docker and run the
   generation shakedown before approving G0, or approve G0 with the adaptive
   throughput check in Phase 8 step 4?
3. **H0-a timing**: if docker stays blocked, authorise torch-cpu in the host
   venv as a substitute for the pinned PyTorch container, or run H0-a later on
   the Halo (the decision rule is pre-registered either way).
4. **Phase 4 completion**: downloads will finish after this STOP;
   `models/verify_weights.py` reruns and the exit check is "8×verified" in
   `models.yaml`. No operator action needed unless a hash mismatches.

STOP — waiting for operator review of PREREG.md and the message "G0 approved" (plus docker/apt from §8)
