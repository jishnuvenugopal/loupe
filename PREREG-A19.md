# PREREG-A19 — G2 resolution: primary preserved with waivers, typo alias, 3B sensitivity regeneration

Issued 20 Oct 2026 ~23:00 +08 at the A18 §8 G2 stop, under the operator's
instruction ("do everything which best suits the rules"). **Decided before any
testbench scoring ran**: at fixing time not one official pass@1, strict-correct,
H1/H1-floor/H2 or blind-40 number existed — only extraction shares, truncation
counts and module-name misses (input-side facts recorded in `notes/LOG.md`
18:23–18:31). `PREREG.md` stays byte-identical to tag `g0-prereg` and its
OpenTimestamps stamp; this amendment is a separate, independently stamped file.

## 1. The stop being resolved

G2 (`scoring/extract.py`, threshold ≥ 95 % per generation file):

| file | share | verdict |
|---|---|---|
| 7b-rl_ve | 0.9936 | pass |
| 7b-rl_rtllm | 0.9800 → **1.0000** under §2 | pass |
| 7b-sft_ve | 0.9872 | pass |
| 7b-sft_rtllm | 0.9733 → **0.9933** under §2 | pass |
| 7b-base_ve | 0.9615 | pass |
| 7b-base_rtllm | 0.9800 → **1.0000** under §2 | pass |
| 3b-rl_ve | **0.9487** (444/468) | §3 waiver |
| 3b-rl_rtllm | 0.9400 → **0.9600** under §2 | pass |
| 3b-base_ve | 0.9679 | pass |
| 3b-base_rtllm | **0.9200 → 0.9400** under §2 | §3 waiver |

Operator decision (recorded verbatim in `notes/LOG.md`): do all three —
primary preserved (§3), typo alias (§2), sensitivity regeneration (§4).

## 2. Glue fix: the benchmark's own task-name typo (G2 gate only)

RTLLM task `fixed_point_substractor` (sic) is misspelled in the benchmark;
every model in every arm emits the correctly spelled `fixed_point_subtractor`
(all 15 samples across the 5 arms: `finish_reason=stop`, design intact). The
strict `task_id in code` check therefore fails a well-formed design on a
benchmark typo, uniformly across arms.

Rule (exact): in `scoring/extract.py::module_name_ok`, for RTLLM rows with
`task_id == "fixed_point_substractor"` only, the module name
`fixed_point_subtractor` additionally counts as correct. No other task, no
fuzzy matching, no VE change (`TopModule` rule untouched).

Scope and limits, explicitly:
- The alias applies **only** to the G2 gate. The frozen scorer
  (`scorer-v1`, `results/pilot_repro/SCORER_SHA256`) is untouched: its own
  module-name check and testbench keep the misspelled name, so this task's
  official passes fail **uniformly for every arm** — reported, not corrected.
- **Rejected**: renaming the module in extracted code before scoring, or
  patching the testbench. Either would touch the frozen scorer and change
  official passes. Not done.

## 3. Primary analysis: preserved, with pinned G2 waivers

The primary analysis is the A16/A18-pinned run (5 arms, original settings,
original generations). Two files remain below 0.95 after §2, dominated by
`finish_reason=length` at the A16-pinned 3B cap of 2,048:

- `3b-rl_ve.jsonl` — 444/468 = 0.9487 (18 length + 6 genuine name misses)
- `3b-base_rtllm.jsonl` — 141/150 = 0.9400 (9 length + 0 after §2)

Operator decision: report, do not correct (the item-7 pattern, now for G2).
Extraction failures count as non-passes in official pass@1. The waivers are
pinned to the exact pass counts above (equality guard on immutable files — if
a recomputation ever differs, G2 fails hard again). `phase10.py` carries this
list; the waiver is logged per file in `notes/LOG.md`.

## 4. Sensitivity regeneration: 3B arms with generation headroom

Question: do the 3B arms clear G2 and score differently with completion
headroom? Pre-specified now, run under this amendment:

- Arms: `3b-rl`, `3b-base` (both benches), scored as `3b-rl-cap`, `3b-base-cap`.
- Unchanged: models/revisions, prompts, system prompts, n = 3, per-task seed
  rule (`int(sha256(task_id)[:8], 16)`), T = 0.2, top_p = 0.95, `top_k=-1`,
  `min_p=0`, `repetition_penalty=1.0`.
- Changed (both documented, sensitivity only): `max_new_tokens` 2,048 → 3,072
  and `max_model_len` 4,096 → 5,120 (the longest RTLLM prompt is ~1.5 k tokens;
  5,120 gives the full raised cap plus margin).
- Storage: `~/runs/gen_sens/` and `scores_sens/` — **never** merged into
  `~/runs/gen/`, `scores/`, the primary `stats.py` invocations, the blind-40
  population, or any primary contrast. G2 re-runs on these files under the §2
  rule. If they still miss 0.95, that is reported as-is — no further amendment.
- Reported side-by-side in `results/sens/` next to the primary cells.

## 5. Code pins (A19 revision)

- `scoring/extract.py` sha256 `9f626ebc6808a0a140cbffbc3645bf9faaa003bfe605825c31edfb910b251b2a` — A16/A18 value
  `e36b36e78fde106d02d4dd38a22237ed8a4a0d77dd787fe4c2fed5f0811aa195`
  superseded by the §2 alias.
- `tests/test_a19_extract_alias.py` sha256 `b8b4e6fe546220c7555a9af3b6c8f4a1cfed7d1e9013ea8205b6fe0f99fb8e69` —
  alias scope tests (only the typo task; no other task; VE untouched; scorer
  unaffected). Added to the freeze-check pinned-adds list beside the two A18
  test files.
- `scoring/phase10.py` (orchestrator, not analysis-pinned): §3 waiver list,
  §2-consistent G2 re-check, freeze-check pinned-adds extension.
- `gen/run_sens.py` (new, harness): the §4 runner.

## 6. What does not change

`scorer/` (byte-identical to `scorer-v1`), prompts, models, primary-arm
sampling, G1b/G3 thresholds and anchors, dedup rules, contamination rules,
blind-40 spec and population, `scoring/stats.py`, `scoring/run_scoring.py`,
`scoring/dedup.py`, `scoring/blind40.py`, `scoring/contamination.py`, and the
primary generations (`results/main/releases/` tarballs and their sha256s).
