# Pre-registration: strict re-scoring of open RL-for-Verilog checkpoints

Draft (Phase 7), 18 Oct 2026. To be committed and pushed before any evaluation
sample exists. At G0: tag `g0-prereg` → commit <sha>, content hash timestamped
with OpenTimestamps (`PREREG.md.ots`, verify with `ots verify PREREG.md.ots`).
Date: <date at G0>.

## Question
For each released checkpoint, what share of its official-testbench passes is
not functionally correct under strict scoring?

## Arms
CodeV family: `Qwen/Qwen2.5-Coder-7B-Instruct@c03e6d3` →
`zhuyaoyu/CodeV-R1-Distill-Qwen-7B@8fdb92e` →
`zhuyaoyu/CodeV-R1-RL-Qwen-7B@286cf43`.
VeriReason family: `Qwen/Qwen2.5-Coder-3B-Instruct@488639f` (declared SFT base;
the GRPO card names `Qwen/Qwen2.5-Coder-3B@09d9bc5`) →
`Nellyw888/Qwen2.5-3b-sft-reasoning@1f0b7fa` **[H0-a: DROPPED — not confirmed as the
RL parent; median RL↔SFT 4.50e-3 vs RL↔3B-Instruct 3.45e-3 (rule required 10×
smaller); `results/h0/h0a_weight_distance.json`]** →
`Nellyw888/VeriReason-Qwen2.5-3b-RTLCoder-Verilog-GRPO-reasoning-tb@3b93ce1`.
H0-a rule (pre-registered, executed 18 Oct): the SFT checkpoint is the RL model's
parent iff the median RL↔SFT relative tensor distance is ≤ 10× smaller than RL↔(each
Qwen 3B); otherwise the 3B family drops its SFT arm and the 3B contrast becomes
SFT+RL vs Instruct. Outcome: dropped. 3B arms scored: 3B-RL and 3B-Instruct
(base); the fp32 SFT checkpoint is still downloaded + verified but not scored.
Cut order under time pressure: (1) VerilogEval seeded subset of 60, (2) n 3 → 2,
(3) raw-base arm. Never max tokens, never the SFT arm.

## Tasks [A14, accepted 17 Oct 2026; gate counts updated 18 Oct 2026 per the
frozen deep-scorer results, operator instruction]
Generate: VerilogEval v2 spec-to-RTL (156, `c498220`), RTLLM v2.1 @`51ed553` (50).
Strict-score: **149 gated VerilogEval tasks** (not 143; the pilot's six
timeout/error exclusions were proved unbounded by PDR/SMT-induction —
`results/pilot_repro/ve_gate_summary.json`: 145 UNBOUNDED-EQ + 5 BMC-10-only of
156; excluded: Prob095, 096, 137, 146, 152, 155 (Yosys read errors), Prob099
(official TB does not compile; self-equivalence nevertheless proved)) and
**40 usable RTLLM designs** = the pilot's 38 (Appendix C of the brief) plus
`multi_8bit` and `multi_pipe_8bit` (both proved UNBOUNDED-EQ;
`~/runs/deep/refs_summary.json`). `div_16bit` stays excluded (deep proof exists,
but the design is kept out per the frozen operator decision; divide-by-zero
spec ambiguity, brief §9).
Reported apart: accu, LIFObuffer (unreported reference bugs, RTLLM #25/#26);
RAM, square_wave (tracked, #16/#23).

## Prompts (§6.1; built by `prompts/build_prompts.py`)
- CodeV system (from `mk_prompt_codev_rl` @ CodeV-R1 `277ac46`), sha256
  `f0696dc439292af149f7a6b3f0a3f8735d53e1a4b39e36571af69e3115bd64ac` (= Appendix D1, verified 18 Oct).
- VeriReason system (YAML-parsed `GRPO/verilog_grpo_tb.yaml` @ `d215b7f`),
  sha256 `75a7d783907db0dc5e4200290dd7fb9635ef1b85d4479108559b99cdb5799228` (= Appendix D2, verified 18 Oct).
- User, VerilogEval: CodeV's transform of `fullprompt` (BEGIN/DONE sentence
  removed; `//` split with "The module head should be:" when ≥2 `//` and
  `module TopModule` present). User, RTLLM: v2.1 `design_description.txt` as
  `text.strip()+"\n"` (9 of 50 texts differ from CodeV's v2.0 copy —
  `results/h0/h0c_rtllm_diff.json`).
- Built rows with per-row `prompt_sha256`: `prompts/built/{codev,verireason}_{ve,rtllm}.jsonl`
  (156 + 50 rows each). `prompts/SHA256SUMS` sha256
  `a0d465913ab1ca7e772002a4ca90ccdb61084dccf856452181dfcb83abae6f3c`.
- Chat template: each model's own (`apply_chat_template(..., add_generation_prompt=True)`),
  template sha256 recorded per arm in `models.yaml`.
- Extraction: CodeV-R1's extractor (`test/utils/verilog_extractor.py` @ `277ac46`);
  module must be `TopModule` (VE) or the task name (RTLLM). Gate G2 ≥ 95%.

## Sampling [A13, accepted 17 Oct 2026]
Each CodeV checkpoint at its authors' published protocol (arXiv 2505.24183 v5):
base T 1.0; Distill T 0.6; RL T 1.0. VeriReason 3B arms at T 0.2 (model card).
top_p: VE 1.0, RTLLM 0.95 (CodeV paper), VeriReason 0.95 both. max new tokens
16,384 (7B) / 2,048 (3B). n = 3 per task (n = 5 on RTLLM only if the night
allows). `top_k=-1`, `min_p=0.0`, `repetition_penalty=1.0` everywhere; fixed
per-task seed `seed = int(sha256(task_id)[:8], 16)`; `generation_config="vllm"`
passed to `LLM(...)` and every sampling field set explicitly (Distill's
`generation_config.json` carries `repetition_penalty 1.1, top_k 20, top_p 0.8,
temperature 0.7` — recorded in `models.yaml`, NOT used).

## Scorer
Frozen at tag `scorer-v1` (commit `4e49950ab8a6e9c0e042bb6d91917152b5d7ad57`);
`results/pilot_repro/SCORER_SHA256` sha256
`3428447f263d36e741a00d8d8a6bb50c4929a32b033b5e080ce43eb1f76d484e`.
Strict = official testbench + non-vacuity + formal equivalence from reset
(BMC depth 10 default, `scorer/depth.yaml` overrides; unbounded engines PDR /
SMT-induction upgrade the verdict to proof classes UNBOUNDED-EQ etc.) +
reference audit. Formal timeout 60 s → "timeout" class (reported, not counted
as equivalent). Reproduced on this machine (G1-Spark + deep run):
- 290/290 RTLLM-shipped GPT rows match Appendix B testbench verdicts;
  equiv 280/290 (the 10 `synchronizer` rows differ only in recording); totals
  GPT-4 60 pass / 39 equivalent / 14 different / 7 error, GPT-3.5 37/25/4/8
  (`~/runs/deep/gpt_summary.json`, `DEEP_REPORT.md` §5).
- Scorer power: 528 seeded mutants, 438 formally different, strict kill
  438/438 = 100.0%, official-TB false passes 75/438 = 17.1%
  (`~/runs/deep/mut/mut_summary.json`).
- Reference audit machine-checked: accu FAIL (cex sum=101 with invalid 100),
  LIFObuffer FAIL, square_wave const-0 cover unreachable while the official TB
  passes it (`~/runs/deep/spec/spec_results.json`).

## Primary outcome
Per checkpoint: false-pass share = P(not strict | official pass), with a
task-clustered bootstrap 95% CI (10,000 resamples), by failure class, with
every counterexample published.

## Secondary, exploratory
H1: false-pass share RL vs SFT. H2: the RL−SFT gap in official pass@1 vs the
same gap in strict pass@1.
Minimum detectable effect: about 6–11 pp (VerilogEval v2, 149 tasks), 18–24 pp
(RTLLM, 40 designs). An interval that includes zero = "not resolved".

## Fidelity gate G1b
Official pass@1 on VerilogEval v2 spec-to-RTL brackets arXiv 2505.24183 v5
Table 2: 31.3 / 65.2 / 68.8 (95% CI or ±8 pp). Source:
<https://arxiv.org/abs/2505.24183> (v5, 23 Feb 2026), Table 2 and §3:
"During testing, we use a max context length of 16384 and a temperature of 1.0.
We set top_p to 1.0 for VerilogEval and 0.95 for RTLLM." §3.1: distillation T
0.6, RL T 1.0, 20 responses/query. Conflict recorded, not resolved: the
released runner (`test/benchmark_runner.sh` @ `277ac46`) passes T 1.0 for
VerilogEval v2 for every model and leaves top_p at the sampler default (0.95).
RTLLM v2: 36.1 / 57.2 / 68.0, loose check only (their v2.0 with VCS; ours v2.1
with Icarus — 9 of 50 spec texts differ between the versions, see Prompts).
No anchor exists for the VeriReason family.

## Classification
Dedup (exact + AST-normalised) before classification. Blind labels on a seeded
stratified sample of 40 disagreements. The automatic "formally different within
depth d" (proof classes from the deep engines) is the headline column.

## Contamination
MinHash (5-gram word shingles, 128 permutations, J ≥ 0.8) + normalised exact
match of the released GRPO training sets against both benchmarks:
**0 overlapping rows in the 1,149-row dataset and 0 in the 743-row dataset;
no pair reaches J 0.3** (`results/h0/h0d_contamination.json`,
`results/h0/h0d_closest_pairs.json`; positive control green). Nothing to
exclude from GRPO prompts. Reward-oracle check: 30/30 seeded rows reproduce
`tb_result` byte-exactly (`results/h0/h0d_oracle.json`) — `tb_result` is the
GRPO reward oracle.

## Measured before G0 (shakedown)
- Scoring speed (timing proxy on RTLLM-shipped GPT-4 designs, not study-arm
  samples): 0.466 samples/s at WORKERS=18 (≈2.1 s/sample); formal dominates
  (96% of EDA time) — `results/shakedown/scoring_speed.json`.
- Generation throughput per arm: **NOT MEASURED — docker blocked on this
  machine** (user not in docker group; Phase 1 operator leftover). The
  overnight projection (tokens / measured tok/s vs the 21:00–07:00 window) and
  the cut-order decision therefore cannot be pre-computed. Operator options at
  G0 review: (a) fix docker, run Phase 6 steps 1–3 before approving G0
  (preferred); (b) approve G0 with the projection taken adaptively at the
  30-minute throughput check in Phase 8 step 4.

## Licences
7B and 1.5B Qwen bases: Apache-2.0. Qwen2.5-Coder-3B family: Qwen Research
License, non-commercial. CodeV-R1-RL: no LICENSE file; card says derived from
Qwen-2.5 (Apache 2.0). No weights are republished.
