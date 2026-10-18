# SPARK REPORT — strict re-scoring, DGX Spark lane

Updated 19 Oct 2026, 00:51 UTC+08 (A18 overnight chain).
`jishnuvenugopal/rte-strict-eval` (PRIVATE), branch `spark`, tag `scorer-v1` pushed.

## 1. Status

- [00:51] C2: FAILED: forced failure (dry run)
- [00:51] C1: FAILED: code/PREREG/push consistency check failed (see log above)
- Session completed: Phase 1b (koder scaffold), **Phase 5 complete (H0 a–d)**,
  Phase 6 step 4 (GRPO trial, PASSED), step 3 first half (3B-RL lane, DONE),
  step 5 (scoring-speed proxy), Phase 7 PREREG draft (updated for H0-a).
  **Phase 1 exit check PASSED** after the operator's docker fix.
- In progress (background, tmux): **A18 §8 overnight chain**
  (`shakedown/overnight_chain.sh`): C2 weights already verified (8/8 at 18 Oct
  23:58 — §12), then C3 7B shakedown, C4 projection+cut, C5 PREREG final, G0
  steps (tag + `ots stamp`), Phase 8 generation, Phase 10 scoring/analysis,
  `ots upgrade` at T_stamp+6h. Every stop path updates this report and pushes.
- Pending next interactive session: 7B shakedown steps 1–2 when the 7Bs land
  (harness proven on the 3B-RL lane), 3B-SFT-loaded-as-bf16 throughput check
  (weights already verified), PREREG "Measured before G0" refresh.
- Last gates: G1-Spark passed; **H0 complete**; GRPO trial lane green;
  **G0 not requested yet**.
- `STOP — waiting for operator review of PREREG.md and the message "G0 approved"`
  superseded by **A18 §8** (the operator's G0 approval, conditional on C1–C5,
  executed autonomously tonight by the chain).

## 2. Machine

- Linux 7.0.0-1019-nvidia, aarch64, 20 cores (Cortex-X925/A725), 121 GB RAM,
  GB10 GPU, 3.5 TB free (`notes/LOG.md` D0 entry; `spark_report.json.machine`).
- EDA (pinned `oss-cad-suite-linux-arm64-20261016.tgz`, 686,594,072 bytes
  exact): Yosys 0.70+145, Icarus 14.0 (devel), Verilator 5.053 (devel),
  SymbiYosys 0.70.
- Containers: docker 29.2.1, daemon accessible via `sg docker` (agent shells
  predate the usermod). **vLLM image pulled**: `nvcr.io/nvidia/vllm@sha256:94e21552f644e0c1627464ba89d2f7a4ce7442e196f72afa0bb5d7fba23cbb03`
  (20.4 GB). PyTorch image pulled:
  `nvcr.io/nvidia/pytorch@sha256:417cbf33f87b5378849df37983552cd1f8bc8b62fe1ceabe004de816a55dff21`.
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

- **H0-a (3B SFT parent)**: **DONE — NOT CONFIRMED; SFT arm dropped** per the
  pre-registered rule. Medians over 434 shared tensors (fp32, CPU, pinned
  pytorch container): RL↔SFT 4.50e-3, RL↔3B-Instruct 3.45e-3, RL↔3B 2.06e-2,
  SFT↔3B-Instruct 3.09e-3, SFT↔3B 2.05e-2. Tokenizer groups `{RL}`, `{SFT, 3B
  raw}`, `{3B-Instruct}`. Evidence: `results/h0/h0a_weight_distance.json`,
  `results/h0/H0.md`. (First watcher attempt OOM-killed by overlap with the
  vLLM shakedown on unified memory — recorded; successful run with GPU idle.)
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
| 3B-RL lane (step 3 first half) | 16 seeded tasks n=1: tokens mean 812 / p95 1930, cap 1/16; extraction 15/16, name 15/16; TB 8 pass/3 fail/5 compile_error; strict on passes 5 UNBOUNDED-EQ / 2 DIFFERENT / 1 UNKNOWN; throughput (batched, 66 concurrent) VE 182 tok/s, RTLLM 354 tok/s | `results/shakedown/3b-rl.json` |
| 7B generation throughput, cap hits, extraction rate | pending 7B weights (harness proven on 3B lane) | `shakedown/shakedown_run.py` |
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

1. **G0 sequencing** (see PREREG "Measured before G0"): the 7B shakedown +
   overlap probe complete when the three 7B downloads land (~overnight); G0
   review can follow in the morning. (docker/apt and H0-a are RESOLVED.)
2. **Phase 4 completion**: downloads will finish after this STOP;
   `models/verify_weights.py` reruns and the exit check is "8×verified" in
   `models.yaml`. No operator action needed unless a hash mismatches.

## 9. Generation (A16 §7 — filled by Phase 8)

Manifests, 30-minute throughput checks, any cut applied: pending G0 and the
overnight run. Order (A16 §3 step 4): CodeV RL → Distill → 3B RL → 3B base →
Qwen 7B base. No rsync step (single machine).

## 10. Build day (A16 §7 — filled by Phase 10)

G2, G1b, the primary false-pass table, secondary contrasts, dedup,
contamination, blind sample: pending. Analysis code pinned pre-G0 under
`scoring/` (see PREREG "Analysis code").

## 11. Amendment A16

- **When**: 18 Oct 2026, ~19:50 +08, during Phase 6 (3B-SFT-as-bf16 lane had
  just been started; killed — the arm was dropped by H0-a and A16 §3 step 3
  says "3B SFT unless H0-a dropped it").
- **Phase then**: Phase 6 of 9; Phases 0–5 exit-checked; STOP for PREREG review
  maintained; G0 not reached (no evaluation sample exists — §0.5 clean).
- **What was redone**: (a) guard self-tests re-run per §2 — six tests, one
  FRESH scratch repo per test, 6/6 with the correct refusal reason (the old
  run had stacked the four content commits in one repo, so tests 2–3 were
  refused for `koder/x.md` and not their own reason; the old `mk()` helper had
  also clobbered the 60 MB blob to 2 bytes, making "60MB refused" vacuous —
  both recorded next to the old results in `notes/LOG.md`);
  (b) 3B lane re-run at the pinned A16 settings (`max_model_len=4096`, 64
  concurrent): 3B-RL superseded (`3b-rl.pre-a16.json` kept beside), 3B base
  (Qwen2.5-Coder-3B-Instruct) run for the first time as a primary arm;
  (c) `scoring/{extract,stats,run_scoring,showcex}.py` written and pinned
  (§3 step 8); (d) PREREG arms/sampling/analysis sections updated (§4);
  `gen/run_overnight.sh` and `gen/README.md` de-Halo'd (§1/§5).
- **Still pending under A16**: 7B shakedown (steps 1–2) + overlap probe (step 7)
  + full overnight projection (step 5) once the three 7B weights land.

Messages waited for (exactly): `G0 approved`; `RTLLM n = 5` or `cut <step>`
(pre-G0 only); `hold` (optional, pauses before Phase 10); `blind labels in`;
`G3 pass, start GRPO`. (`Spark runs 3B` retired — standing per A16.)

STOP — waiting for operator review of PREREG.md and the message "G0 approved"

## 12. Amendment A18 (18 Oct 2026, ~23:50 +08) — last fixes + conditional G0

- **Operator verified A17 independently** (pilot shares, gate proof classes,
  PREREG sha256s) and issued A18: items 1–7 + §8, a conditional G0 that takes
  effect only when C1–C5 pass in order. Copy: `koder/docs/brief-spark-addendum-A18.md`.
- **Item 6 root cause (7B download): the downloads were already complete.**
  Two byte readings 5 min apart were flat (`~/runs/7b_bytes_readings.log`),
  because (a) no fetch process was alive (died with the earlier session; last
  blob write 22:16), and (b) hub 2.2.0's xet backend reconstructs blobs into a
  shared CAS (`~/hf/hub/blobs/xx/`) outside each repo dir, so per-repo `du`
  undercounts — the "2.7/15.2 GB" readings were an artifact. `models/
  verify_weights.py`: **8/8 weight sets hash-verified at 18 Oct 23:58**; no
  restart or `hf_transfer` needed; orphaned `.incomplete` partials deleted.
- **Items 1–4** (`scoring/stats.py` + `tests/test_a18_stats.py`, all green):
  `ci95_all_tasks` (all-task bootstrap for G1b), dedup `str(sample_idx)` keys
  + collapsed-row report + no-match error, gate files hard-required, vacuous
  as a flag (class counts now add up). Pilot smoke unchanged (GPT-4 14.89%,
  GPT-3.5 13.79%).
- **Item 5**: `scoring/dedup.py` + `scoring/blind40.py` written, tested on
  synthetic + pilot-290 + shakedown-32 rows (`tests/test_a18_dedup_blind40.py`),
  committed, sha256 in PREREG "Analysis code" (with `scoring/contamination.py`,
  whose machinery run found 0 overlaps with positive controls green).
- **Item 7**: the 3B-base note is in PREREG "Measured before G0" verbatim;
  `shakedown_run.py` now records `official_passes_from_length` per arm (the 7B
  shakedown reports will carry it).
- **§8 machinery**: `shakedown/overnight_chain.sh` (C1 entry check → C2 → C3
  [`shakedown/c3_check.py`] → C4 [`shakedown/projection.py` steady-state +
  ladder ≤ 9 h] → C5 [`shakedown/prereg_finalize.py`] → G0 steps → Phase 8
  [`gen/run_overnight.py`, docker-driven, cuts only from `gen/cut.txt`,
  throughput checks at 30 min + first 3B arm] → Phase 10
  [`scoring/phase10.py`] → `ots upgrade` at T_stamp+6h). Every condition is a
  hard check logged to `notes/LOG.md`; every stop path writes this report and
  pushes. Dry-run with a forced failure verified before the real launch.
- Dead background jobs from the crashed session were removed (idle
  `grpo-trial` container, old A16 watcher).

STOP — C2 failed: forced failure (dry run)
