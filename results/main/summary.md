# Main results — strict re-scoring (Phase 10)

Written 2026-10-21 02:32 by scoring/phase10.py (analysis code pinned in PREREG; every number links to its file).

## Gate status

- G1-Spark: reproduced (PREREG Scorer; results/deep/gpt_summary.json).
- G2 (extraction ≥ 95% per arm): see `results/main/g2.txt` extraction logs.
- G1b (fidelity, A18: all-task point + ci95_all_tasks): `results/main/g1b.json`.

| arm | bench | official pass@1 (all tasks) | 95% CI (all tasks) | anchor | verdict |
|---|---|---|---|---|---|
| 7b-rl | ve | 67.9 | [61.1, 74.4] | 68.8 | PASS |
| 7b-sft | ve | 63.7 | [56.6, 70.5] | 65.2 | PASS |
| 7b-base | ve | 28.8 | [23.3, 34.6] | 31.3 | PASS |

## Primary table (not-proved-correct share; proved-wrong floor beside it)

| arm | bench | tasks | official passes | not proved correct % [CI] | not correct within d % [CI] | proved wrong % [CI] | classes | vacuous |
|---|---|---|---|---|---|---|---|---|
| 7b-rl | ve | 144 | 294 | 2.0 [0.3,4.4] | 2.0 [0.3,4.4] | 1.7 [0.0,4.0] | diff 5, bnd 0, tmo 1, err 0, vac 0 | 0 |
| 7b-rl | rtllm | 33 | 81 | 33.3 [17.1,50.6] | 33.3 [17.1,50.6] | 33.3 [17.1,50.6] | diff 27, bnd 0, tmo 0, err 0, vac 0 | 0 |
| 7b-sft | ve | 144 | 282 | 0.4 [0.0,1.2] | 0.4 [0.0,1.2] | 0.4 [0.0,1.2] | diff 1, bnd 0, tmo 0, err 0, vac 0 | 0 |
| 7b-sft | rtllm | 33 | 77 | 28.6 [14.1,45.0] | 28.6 [14.1,45.0] | 28.6 [14.1,45.0] | diff 22, bnd 0, tmo 0, err 0, vac 0 | 0 |
| 3b-rl | ve | 144 | 130 | 2.3 [0.0,7.6] | 2.3 [0.0,7.6] | 0.0 [0.0,0.0] | diff 0, bnd 0, tmo 0, err 3, vac 0 | 0 |
| 3b-rl | rtllm | 33 | 34 | 35.3 [13.5,59.3] | 26.5 [8.3,48.4] | 26.5 [8.3,48.4] | diff 9, bnd 3, tmo 0, err 0, vac 0 | 0 |
| 3b-base | ve | 144 | 54 | 3.7 [0.0,9.5] | 1.9 [0.0,6.2] | 1.9 [0.0,6.2] | diff 1, bnd 1, tmo 0, err 0, vac 0 | 0 |
| 3b-base | rtllm | 33 | 25 | 36.0 [10.0,70.0] | 24.0 [4.3,52.4] | 20.0 [4.0,42.9] | diff 5, bnd 3, tmo 0, err 1, vac 0 | 0 |
| 7b-base | ve | 144 | 127 | 4.7 [1.5,9.0] | 3.1 [0.7,6.7] | 2.4 [0.0,5.6] | diff 3, bnd 2, tmo 0, err 1, vac 0 | 0 |
| 7b-base | rtllm | 33 | 40 | 27.5 [11.4,48.6] | 22.5 [7.3,41.9] | 22.5 [7.3,41.9] | diff 9, bnd 2, tmo 0, err 0, vac 0 | 0 |

Source: `results/main/stats.json` (10,000 task-clustered bootstrap resamples, `numpy.random.default_rng(0)`, percentile 95%; denominators are official passes, including in the bootstrap).

## Secondary contrasts (exploratory; CodeV family only)

- h1_rl_vs_distill (7b-rl − 7b-sft):
  - not_proved_correct_share: mean 2.4 pp, 95% CI [0.1, 5.1] — resolved.
  - not_proved_correct_share_floor: mean 2.1 pp, 95% CI [-0.1, 4.8] — not resolved.
  - h2_pass1_gap: mean 1.9 pp, 95% CI [0.2, 3.8] — resolved.

## Sensitivity rows

- all 37 RTLLM designs (headline = 33): `results/main/stats_all37.json`
- wide 149/40 gate, within-depth-d companion only: `results/main/stats_wide.json`
- per-unique-design (dedup): `results/main/stats_dedup.json` (dedup summary: `results/main/dedup_map.json.summary.json`)
- contaminated tasks dropped: `results/main/stats_drop.json`

## Reported apart

accu, LIFObuffer (RTLLM #25/#26 reference bugs), RAM, square_wave (#16/#23): `results/main/apart.json` (classes per arm, no headline).

## Contamination

`results/main/contamination/overlaps.csv` + `summary.json` (rules in PREREG Analysis plan).

## Exploratory AI adjudication — protocol deviation

> The planned single-author human adjudication was replaced, with operator approval on 12 Nov 2026 after AI labelling was completed, by one AI-generated review. No independent human rater assessed these 40 packets. The reviewer did not access the hidden arm key but had prior aggregate study context. The five unclear labels were retained. These exploratory labels do not change the pre-registered primary results.

**Provenance (decision `blind40-ai-2026-11-12`):** labels from AI-generated exploratory adjudication (harness-reported model `gpt-6-astra`); zero independent human raters assessed these 40 packets. Adopted artifact `results/main/blind40/labels.ai.csv` (SHA-256 `570eac0376dcacdab317d22c51ac31206ddbe802388cdc5cff33895d44055468`, 843 bytes, 40 rows) at packet revision `00a5aef7e36ca2b8d27da9a8f4241e216df83d54`. Machine-readable provenance: `results/main/blind40/labels.ai.provenance.json`. The five unclear labels were retained.

Overall (n = 40):

| class | n | share % [Wilson 95% CI] |
|---|---|---|
| real bug | 18 | 45.0 [30.7, 60.2] |
| reference wrong | 5 | 12.5 [5.5, 26.1] |
| allowed by spec | 12 | 30.0 [18.1, 45.4] |
| unclear | 5 | 12.5 [5.5, 26.1] |
| scorer artefact | 0 | 0.0 [0.0, 8.8] |

Per family (every class row shown, including zero counts):

| family | class | n | share % [Wilson 95% CI] |
|---|---|---|---|
| codev-base (n=7) | real bug | 4 | 57.1 [25.0, 84.2] |
| codev-base (n=7) | reference wrong | 1 | 14.3 [2.6, 51.3] |
| codev-base (n=7) | allowed by spec | 2 | 28.6 [8.2, 64.1] |
| codev-base (n=7) | unclear | 0 | 0.0 [0.0, 35.4] |
| codev-base (n=7) | scorer artefact | 0 | 0.0 [0.0, 35.4] |
| codev-distill (n=11) | real bug | 5 | 45.5 [21.3, 72.0] |
| codev-distill (n=11) | reference wrong | 0 | 0.0 [0.0, 25.9] |
| codev-distill (n=11) | allowed by spec | 5 | 45.5 [21.3, 72.0] |
| codev-distill (n=11) | unclear | 1 | 9.1 [1.6, 37.7] |
| codev-distill (n=11) | scorer artefact | 0 | 0.0 [0.0, 25.9] |
| codev-rl (n=16) | real bug | 4 | 25.0 [10.2, 49.5] |
| codev-rl (n=16) | reference wrong | 4 | 25.0 [10.2, 49.5] |
| codev-rl (n=16) | allowed by spec | 4 | 25.0 [10.2, 49.5] |
| codev-rl (n=16) | unclear | 4 | 25.0 [10.2, 49.5] |
| codev-rl (n=16) | scorer artefact | 0 | 0.0 [0.0, 19.4] |
| verireason-instruct (n=3) | real bug | 3 | 100.0 [43.9, 100.0] |
| verireason-instruct (n=3) | reference wrong | 0 | 0.0 [0.0, 56.1] |
| verireason-instruct (n=3) | allowed by spec | 0 | 0.0 [0.0, 56.1] |
| verireason-instruct (n=3) | unclear | 0 | 0.0 [0.0, 56.1] |
| verireason-instruct (n=3) | scorer artefact | 0 | 0.0 [0.0, 56.1] |
| verireason-rl (n=3) | real bug | 2 | 66.7 [20.8, 93.9] |
| verireason-rl (n=3) | reference wrong | 0 | 0.0 [0.0, 56.1] |
| verireason-rl (n=3) | allowed by spec | 1 | 33.3 [6.1, 79.2] |
| verireason-rl (n=3) | unclear | 0 | 0.0 [0.0, 56.1] |
| verireason-rl (n=3) | scorer artefact | 0 | 0.0 [0.0, 56.1] |

**Limitations:** the Wilson 95% intervals above describe this selected 40-packet sample only. They do not account for AI-rating error, correlated judgments, aggregate-context exposure, or blinding limitations. These are selected-sample exploratory shares, not estimates for any wider population and not changes to the pre-registered primary results. Targeted simulation observations behind individual labels are not global correctness proofs, independent replication, or inter-rater agreement.
