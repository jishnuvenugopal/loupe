# Pre-registration: strict re-scoring of open RL-for-Verilog checkpoints

Draft (Phase 7), 18 Oct 2026. To be committed and pushed before any evaluation
sample exists. At G0: tag `g0-prereg` → commit <sha>, content hash timestamped
with OpenTimestamps (`PREREG.md.ots`, verify with `ots verify PREREG.md.ots`).
Date: <date at G0>.

## Question
For each released checkpoint, what share of its official-testbench passes is
**not proved correct** — that is, lacks an unbounded formal equivalence proof
against the reference from reset? Reported beside it: the share **not correct
within depth d**, and the share **proved wrong** by a counterexample.

## Arms
Engine for every arm: **vLLM 0.21.0+2325b6f0.nvinternal.26.05.post1, container
nvcr.io/nvidia/vllm@sha256:94e21552f644e0c1627464ba89d2f7a4ce7442e196f72afa0bb5d7fba23cbb03,
one DGX Spark (arm64)** (A16: single machine; no second engine, no Halo block).
Overnight generation order (A16 §3 step 4): CodeV RL → CodeV Distill → 3B RL →
3B base → Qwen 7B base (base arms last because they are cut first).
CodeV family: `Qwen/Qwen2.5-Coder-7B-Instruct@c03e6d3` →
`zhuyaoyu/CodeV-R1-Distill-Qwen-7B@8fdb92e` →
`zhuyaoyu/CodeV-R1-RL-Qwen-7B@286cf43`.
VeriReason family: `Qwen/Qwen2.5-Coder-3B-Instruct@488639f` (3B base arm; the
raw `Qwen/Qwen2.5-Coder-3B@09d9bc5` is an H0 reference only, never generated)
→ `Nellyw888/Qwen2.5-3b-sft-reasoning@1f0b7fa` **[H0-a: DROPPED — not confirmed as the
RL parent; median RL↔SFT 4.50e-3 vs RL↔3B-Instruct 3.45e-3 (rule required 10×
smaller); `results/h0/h0a_weight_distance.json`; the checkpoint is fp32 on the
hub and would be loaded cast to bfloat16 — recorded for completeness, not
scored]** →
`Nellyw888/VeriReason-Qwen2.5-3b-RTLCoder-Verilog-GRPO-reasoning-tb@3b93ce1`.
H0-a rule (pre-registered, executed 18 Oct): the SFT checkpoint is the RL model's
parent iff the median RL↔SFT relative tensor distance is at least 10× smaller
than RL↔(each Qwen 3B); otherwise the 3B family drops its SFT arm and the 3B
contrast becomes SFT+RL vs Instruct. Outcome: dropped. 3B arms scored: 3B-RL and 3B-Instruct
(base); the fp32 SFT checkpoint is still downloaded + verified but not scored.
3B lane settings (A16 §3 step 3): same container, `dtype="bfloat16"`,
`generation_config="vllm"`, `seed=0`, `enable_prefix_caching=True`,
`max_model_len=4096` (= largest rendered 3B prompt 1,279 tok + 2,048 + 64 →
3,584 → floored up to the 4,096 minimum; both 3B tokenizers agree).
Cut order under time pressure (A16 §3 step 5): (1) VerilogEval seeded subset of
60, (2) n 3 → 2, (3) drop base arms, 7B base first, then 3B base. Never max
tokens, never an SFT arm.

## Tasks [A14, accepted 17 Oct 2026; gate counts updated 18 Oct 2026 per the
frozen deep-scorer results, operator instruction; **A17 item 2: references with
unbounded proofs only**]
Generate: VerilogEval v2 spec-to-RTL (156, `c498220`), RTLLM v2.1 @`51ed553` (50).
Official pass@1 for G1b runs on all 156 / 50 tasks. **Every strict metric runs
on the committed gate lists only** (`scoring/gates/`):
- `ve_strict.txt` — **144** tasks: reference self-equivalence class `UNBOUNDED-EQ`,
  reference passes its own testbench under Icarus, reads in Yosys. From the
  156: out go the 6 Yosys read-errors (Prob095, 096, 137, 146, 152, 155),
  Prob099 (official TB does not compile; self-equivalence nevertheless proved),
  and the 5 BMC-only references (Prob001_zero, Prob002_m2014_q4i,
  Prob003_step_one, Prob046_dff8p, Prob078_dualedge) — `wide_bmc.txt`.
- `rtllm_strict.txt` — **37** designs: the usable-40 minus the 3 BMC-only
  references `alu`, `freq_divbyfrac`, `freq_divbyodd`. (`clkgenerator` is also
  BMC-only in `refs_summary.json` but was already outside the usable-40: its
  reference fails its own Icarus testbench.) `div_16bit` stays out (frozen
  operator decision, brief §9).
- `rtllm_apart.txt` — the 4 reported-apart designs; **headline RTLLM tables use
  the other 33**, sensitivity row on all 37 (`--rtllm-all37`).
- `wide_bmc.txt` — the 5 + 3 BMC-only ids; `--wide-gate` puts them back for the
  within-depth-d companion on the wider 149 / 40 gate (no extra compute: these
  tasks are generated and scored anyway).
Gate sha256 (A17 item 2): `ve_strict.txt`
`3ed7e4e18d70c5f1b50f849db061ec61b6b82749d218e8067903f4a42dfe99ed`,
`rtllm_strict.txt`
`45c6db375efab345864d9f3701a81efa65bf06734033d0ff7a58443dbe6ff339`,
`rtllm_apart.txt`
`3f0cdb53c5304e30ddacd68ab6237b17d096e45be624195d51e7e0c901743a7f`,
`wide_bmc.txt`
`1254b1ed0ba62c558fa5b4a23b285f5a4454c320a063c0b9483f2ec92173f486`.
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
  template sha256 recorded per arm in `models.yaml`. **Template file provenance**
  (A17 item 9): 3B-RL ships `chat_template.jinja` (standalone file); 3B base /
  3B SFT / raw 3B / 1.5B embed the template in `tokenizer_config.json`; the
  three 7B arms' provenance is recorded at weight verification (downloads were
  in flight at draft time).
- Extraction: CodeV-R1's extractor (`test/utils/verilog_extractor.py` @ `277ac46`);
  module must be `TopModule` (VE) or the task name (RTLLM). Gate G2 ≥ 95%.

## Sampling [A13, accepted 17 Oct 2026; A16: all arms on vLLM]
Each CodeV checkpoint at its authors' published protocol (arXiv 2505.24183 v5):
base T 1.0; Distill T 0.6; RL T 1.0. VeriReason 3B arms at T 0.2 (model card).
top_p: VE 1.0, RTLLM 0.95 (CodeV paper), VeriReason 0.95 both. max new tokens
16,384 (7B) / 2,048 (3B). n = 3 per task (n = 5 on RTLLM only if the night
allows). `top_k=-1`, `min_p=0.0`, `repetition_penalty=1.0` everywhere; fixed
per-task seed `seed = int(sha256(task_id)[:8], 16)` — **the same seed rule for
the VeriReason rows as for the CodeV rows**; `generation_config="vllm"`
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
as equivalent). Reproduced on this machine (G1-Spark + deep run;
evidence committed under `results/deep/` — A17 item 7):
- 290/290 RTLLM-shipped GPT rows match Appendix B testbench verdicts — the
  independent anchor; equiv 280/290 (`synchronizer`'s 10 rows are recorded
  differently, not judged differently); totals GPT-4 60 pass / 39 equivalent /
  14 different / 7 error, GPT-3.5 37/25/4/8 (`results/deep/gpt_summary.json`,
  `DEEP_REPORT.md` §5).
- Scorer power: 528 seeded mutants, 438 formally different, **official-TB false
  passes 75/438 = 17.1%** (the power result; `results/deep/mut/mut_summary.json`).
  "Strict kill 438/438 = 100%" is true by construction — the strict verdict uses
  the same engines that define "formally different" — and is NOT cited as
  evidence of power. The independent checks are the 290-row anchor above and
  cross-simulator agreement (zero Icarus/Verilator pass-fail disagreements).
- Reference audit machine-checked: accu FAIL (cex sum=101 with invalid 100),
  LIFObuffer FAIL, square_wave const-0 cover unreachable while the official TB
  passes it (`results/deep/spec/spec_results.json`).
- RTLLM gate evidence: `results/deep/refs_summary.json`.

**Freeze check before every scoring run (A17 item 6 — exact commands):**
`git diff --quiet scorer-v1 -- scorer tests ':(exclude)scorer/__pycache__'`
AND `sha256sum -c results/pilot_repro/SCORER_SHA256`; stop if either fails.
(The plain `git diff --quiet scorer-v1 -- scorer tests` fails because
`scorer/__pycache__/*.pyc` were tracked at the tag and untracked afterwards.)

## Primary outcome (A17 item 1: two definitions of correct, one primary)
Classes of an official pass, read from the frozen `score.py` verdict `class`
field (`score.py` stays frozen: `equiv = "equivalent"` only for `UNBOUNDED-EQ`;
`BMC-N-EQ-ONLY` lands in `equiv "error"` — kept, and stated here):
proved equivalent (`UNBOUNDED-EQ`) · bounded only (`BMC-N-EQ-ONLY`: equivalent
up to depth d, no unbounded proof) · proved wrong (`DIFFERENT`, has a
counterexample) · unverified (`UNKNOWN` timeout/engine error, and `equiv
"error"` port/read failures) · vacuous (**a flag, not a class slot — A18
item 4**: a vacuous pass keeps its proof class — a vacuous pass with a
counterexample counts in `different` AND in the flag; `vacuous` appears as a
class slot only when the proof itself is fine (UNBOUNDED-EQ), so the class
counts add up to official passes minus proved-correct passes; the flag count
`vacuous_passes` is reported beside the classes).
- **proved correct** = official pass AND non-vacuous AND `UNBOUNDED-EQ`
- **correct within depth d** = official pass AND non-vacuous AND (`UNBOUNDED-EQ`
  or `BMC-N-EQ-ONLY`)
- **PRIMARY — not-proved-correct share** = official passes not proved correct /
  official passes, task-clustered bootstrap 95% CI (10,000 resamples)
- **Companion — not-correct-within-depth-d share** = official passes not correct
  within depth d / official passes, same CI
- **Floor — proved-wrong share** = `DIFFERENT` official passes / official
  passes, same CI
The three nest: proved wrong ≤ not correct within depth d ≤ not proved
correct; companion→primary step = bounded-only share; floor→companion step =
unverified share (plus any vacuous passes). All three plus class counts
(`different`, `bounded-only`, `timeout`, `error`, `vacuous`) and the vacuous
flag count `vacuous_passes` (every vacuous official pass) reported for every
arm × benchmark, with every counterexample published. **Wording rule**: the
primary share is never called "false passes" or "wrong"; every headline number
appears with the proved-wrong floor beside it.

## Secondary, exploratory
**H1/H2 apply to the CodeV family only (RL vs Distill).** The VeriReason
contrast (RL vs Instruct) is reported descriptively as "SFT+RL vs Instruct",
not as H1/H2. H1: not-proved-correct share, RL vs SFT (primary metric); the
same contrast on the proved-wrong share is a pre-registered sensitivity row
(engine success can differ between arms). H2: the RL−SFT gap in official
pass@1 minus the same gap in strict pass@1, where strict pass@1 uses "proved
correct" (its companion uses "correct within depth d").
H1/H2 are likely underpowered: the task count is fixed, and verdicts cluster
by design (pilot: GPT-4's 60 passes came from 18 designs). An interval that
includes zero = "not resolved".

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
**A18 item 1**: G1b tests each anchor against the ALL-task point
`official_pass_at_1_all_tasks` and its ALL-task task-clustered bootstrap
interval `ci95_all_tasks` (a bootstrap over all 156 / 50 tasks — never over
the gated task set, whose interval belongs to the strict metrics). Pass:
anchor inside `ci95_all_tasks` or within ±8 pp of the all-task point.
Tested pre-G0 on a case where the two sets differ (`tests/test_a18_stats.py`).
No anchor exists for the VeriReason family.

## Analysis code (A16 §3 step 8 — frozen before G0; revised by A17 items 1–4
and by A18 items 1–5)
All under `scoring/`, commit `c83f842` (A18 revision; A17 revision `c336f68`; A16 originals in history at `bc02bb9`):
- `scoring/extract.py` sha256 `e36b36e78fde106d02d4dd38a22237ed8a4a0d77dd787fe4c2fed5f0811aa195` — CodeV-R1 `extract_verilog_code`
  @ `277ac46` verbatim (defaults) + the module-name check.
- `scoring/stats.py` sha256 `f4c74a74df1a0974794b3b4d4da189caef9d51ba94e57cda2c2edaa3bbb0120b` — the statistics below; A18 items 1–4: `ci95_all_tasks`
  (all-task task-clustered bootstrap of official pass@1 for G1b), vacuous as a
  flag (`vacuous_passes` beside the classes; class counts add up to official
  passes minus proved-correct), gate files hard-required (missing/empty =
  error), dedup keys `str(sample_idx)` on both sides with the collapsed-row
  count reported and a no-match map an error; H1/H1-floor/H2 paired contrasts
  on the same task draws. Tested on the pilot's 290 verdicts (GPT-4 op 47 /
  npc 14.89% / GPT-3.5 op 29 / 13.79% — unchanged by A18), the shakedown
  verdicts, and `tests/test_a18_stats.py` (sets-differ case included).
- `scoring/run_scoring.py` sha256 `2ea7f37583db9320627510dade425545216cb90c31ea7f04832cf45020f4268a` — drives `scorer/score.py` over
  `~/runs/gen/<arm>.jsonl` → `scores/<arm>.jsonl`, resumable, scorer commit +
  sha256 recorded in every row.
- `scoring/showcex.py` sha256 `51d4b2cbabe7127b7de56a2ef68552222f8a42294938dc4ed1b45e56e9ef058f` — brief Appendix A.8 verbatim
  (counterexample tables; homed in `scoring/` so the frozen `scorer/` tree stays
  byte-identical to tag `scorer-v1`).
- `scoring/dedup.py` sha256 `fb2fe4ce1f186197459e786557c45898d51355d56d2d619499422cfd2d86e423` — A18 item 5: builds the dedup map
  exactly as PREREG states (exact: sha256 of the extracted code with comments
  and whitespace removed; normalised: the Yosys RTLIL recipe with
  `attribute \src` lines removed; union within arm × task), output keys in the
  documented `arm|bench|task|sample_idx` form that `stats.py` reads. Tested
  synthetic (60→20 with formatting and wire-declaration variants joining), and
  end-to-end on the pilot 290 + shakedown 32 rows (`tests/test_a18_dedup_blind40.py`).
- `scoring/blind40.py` sha256 `c6688f39d4e12ea61bb9e65ffe5bcc96c8f88d311806e468d809e0637b7c06df` — A18 item 5: the blind-40 draw and
  packet writer (population, strata, `random.Random(0)`, largest-remainder
  allocation, id assignment, packet contents, key file — all as this PREREG
  states; the population is listed sorted by (arm, bench, task, sample index)
  before sampling so the draw cannot depend on file order). Also the unblind
  step (class shares with Wilson 95%). Tested as dedup.py above.
- `scoring/contamination.py` sha256 `b362c1576c8a62d454538834fa04dc33b97b4676a0b0e4b103dbc84accf27f49` — the main contamination
  check (rules and revisions fixed in the Analysis plan; positive control
  green: exact spec, exact reference and a one-word mutant at J 0.95 all
  detected). Machinery run 18 Oct 23:40–00:05: 0 overlap rows over all eight
  dataset files; re-run as part of Phase 10.

## Analysis plan (A16 §6 steps 3–7 short form; A17 items 1–2)
- **Extraction gate G2**: `scoring/extract.py` over every arm; pass iff ≥ 95% of
  each arm's samples extract a module with the right name (`TopModule` /
  task name). On failure: stop for that arm, show 10 failing samples, operator
  decides the glue fix. Prompts never change.
- **Strict-correct** (A17 item 1) = official pass AND non-vacuous AND
  `UNBOUNDED-EQ`; companion = … AND (`UNBOUNDED-EQ` or `BMC-N-EQ-ONLY`).
  Classes of an official pass that is not proved correct: `different`,
  `bounded-only`, `timeout` (reported, never counted as equivalent), `error`,
  and `vacuous` as a flag reported with each class.
- **Gates (A17 item 2)**: official pass@1 for G1b on all 156 / 50 tasks; every
  strict metric on `scoring/gates/ve_strict.txt` (144) and `rtllm_strict.txt`
  (37) only. **A18 item 3**: a missing or empty gate file is a hard error in
  `stats.py` (never a silent no-gate fallback). Headline RTLLM tables use the
  **33** designs other than `accu`, `LIFObuffer`, `RAM`, `square_wave`
  (reported apart in their own table); sensitivity rows: all 37
  (`--rtllm-all37`) and the wide 149 / 40 gate for the within-depth-d
  companion (`--wide-gate`, BMC-only references back in).
- **Three nested shares** (primary / companion / floor, definitions in Primary
  outcome) with task-clustered bootstrap CIs; the steps between them are the
  bounded-only and unverified shares; class counts per arm × benchmark.
- **Dedup before classification** (within arm × task): exact duplicates by
  sha256 of extracted code with comments/whitespace removed; normalised
  duplicates by sha256 of `yosys -p "read_verilog -sv; hierarchy -top; proc;
  opt_clean; rename -enumerate; write_rtlil"` output with `attribute \src`
  lines removed. Keyed `(arm, bench, task, sample_idx)` (A17 item 4), map
  form `arm|bench|task|sample_idx` with `sample_idx` a string on both sides
  (A18 item 2); the collapsed-row count is reported, and a map matching no
  row is an error. Unique-design counts + per-unique-design shares as
  sensitivity rows; the primary metric stays per sample.
- **Contamination**: five datasets at pinned revisions (CodeV-R1-dataset
  `9ab06ff`, RTL-Coder_small `801eea7`, RTL-Coder_7b_reasoning `528eb9b`,
  VeriReason tb `42823db` 1,149 rows, tb_simple `61cc6a2` 743 rows), MinHash
  5-gram/128-perm LSH@0.8 + exact Jaccard ≥ 0.8 + whitespace-collapsed exact
  match, statements vs specs primary, code vs references secondary;
  `results/main/contamination/overlaps.csv`; secondary contrasts rerun without
  overlapping tasks.
- **Statistics**: `scoring/stats.py` (pinned). Task-clustered bootstrap, 10,000
  resamples, `numpy.random.default_rng(0)`, percentile 95%; shares are ratios
  of sums with official passes as denominator (including in the bootstrap).
  H1 on the primary share (proved-wrong contrast = sensitivity row); H2 with
  strict pass@1 = proved correct. Paired contrasts resample the same task
  draws; interval ∋ 0 → "not resolved".
- **Blind sample of 40**: population = unique official passes of class
  `different` or `vacuous`, all arms, excluding the four reported-apart
  designs (bounded-only and unverified passes have no counterexample to judge,
  so they are not in it); the population is listed sorted by (arm, bench,
  task, sample index) before sampling (A18 item 5); stratified by arm ×
  benchmark, proportional largest-remainder allocation, `random.Random(0)`;
  packets blind to arm/model/family/index; key outside the repo (sha256
  committed); operator labels `real bug` / `reference wrong` / `allowed by
  spec` / `unclear` / `scorer artefact`; class shares with Wilson 95% intervals,
  overall and per family. Limitation: blind labels are a single rater (the
  study author).

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
- 3B base: 7 of 9 shakedown compile errors were finished outputs with an
  unclosed `<think>` and no fenced code, where the extractor's fallback took
  draft module text from the reasoning; 2 were cap hits. The 3B base's
  official pass@1 therefore includes format failures; this is reported, not
  corrected. The primary shares are conditional on official passes and are
  not affected. (A18 item 7; the 7B shakedown report adds, per arm, the number
  of official passes that came from outputs with `finish_reason = length`.)
- Scoring speed (timing proxy on RTLLM-shipped GPT-4 designs, not study-arm
  samples): 0.466 samples/s at WORKERS=18 (≈2.1 s/sample); formal dominates
  (96% of EDA time) — `results/shakedown/scoring_speed.json`.
- **Scoring-time projection (A16 §3 step 6; A17 item 5 counts)**:
  (156+50)×3×5 = 3,090 official-TB runs, of which (144+37)×3×5 = 2,715
  formal-eligible; measured-rate estimate **1.84 h**, pessimistic all-pass
  bound 0.26 h(+), vs the 4.5 h morning window → fits. RTLLM n=5 option:
  3,590 runs → 2.14 h → fits. Nothing cut for scoring time
  (`shakedown/projection.py`).
- Generation throughput, 3B lane (A16 settings, 64 concurrent, wall includes
  model load): 3B-RL VE 167 / RTLLM 378 tok/s; 3B base VE 194 / RTLLM 316 tok/s
  (`results/shakedown/{3b-rl,3b-base}.json`). 3B generation projection ≈ 1.3 h.
  Note: re-generating the 3B-RL shakedown at `max_model_len` 4096 (vs the first
  run's 20480) changed completions slightly — vLLM per-request seeds are not
  bitwise-deterministic across settings. **The generations are therefore the
  record**: the extracted designs and the completions (compressed) are released
  with the results under the manifest sha256 (A17 item 10).
- Generation throughput, 7B lane: **PENDING — weights still downloading at
  18 Oct 20:00** (7B-Instruct ~2.7/15.2 GB; Distill ~0; RL 1/4 shards). The
  overnight projection completes when the 7B shakedown runs; the projection
  script is `shakedown/projection.py` (cut ladder coded).
- Overlap probe (A16 §3 step 7): PENDING — needs a 7B arm generating at 64
  concurrent; decides only whether finished arms may be scored with WORKERS=8
  during generation.

## Deviations
- Single machine (A16): "The x86-64 reproduction of the scorer planned for a
  second machine was not run." Everything (generation, official + strict
  scoring, dedup, contamination, statistics, blind packet, tables, GRPO) runs
  on the one DGX Spark; the operator labels the blind sample elsewhere.
- The deep scorer (A17 item 8): proof classes, a reset scaffold with
  zero-initialised flip-flops, PDR and SMT induction — where brief v1 asked
  for the pilot code verbatim.
- Gate change 149 / 40 → **144 / 37** by the A17 item-2 rule (references with
  unbounded proofs only); headline RTLLM 33.
- A17 item-1 definitions: primary "not proved correct", in place of A16's
  "false-pass share".
- Phase 4 exit check: 6 of 8 weights verified when this draft was written; the
  three 7B arms are verified by the watcher (timestamp recorded at G0 from
  `~/runs/7b_watcher.log`).
- Anchor detail (A17 item 8): testbench 290/290; equiv 280/290 — the
  `synchronizer` rows are recorded differently, not judged differently.
- A18 items 1–4: G1b's interval is the all-task `ci95_all_tasks` (not the
  gated bootstrap); dedup keys are `str(sample_idx)` on both sides with the
  collapsed-row count reported and a no-match map an error; gate files are
  hard-required; `vacuous` is a flag (each pass keeps its proof class).
- A18 item 6 (7B download): the flat `du` readings were an artifact — the
  hub 2.2.0 xet backend stores reconstructed blobs in a shared CAS outside
  each repo directory, so per-repo `du` undercounts; all three 7B weight
  sets were in fact complete and hash-verified (8 of 8) at 18 Oct 23:58;
  no restart was needed (`notes/LOG.md`).

## Licences
7B and 1.5B Qwen bases: Apache-2.0. Qwen2.5-Coder-3B family: Qwen Research
License, non-commercial. CodeV-R1-RL: no LICENSE file; card says derived from
Qwen-2.5 (Apache 2.0). No weights are republished.
