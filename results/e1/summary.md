# E1 — exploratory evaluation (PREREG-A20 B4)

Written by e1/report.py. Arms: e1-base, e1-s100, e1-w100. Scores: `scores_e1/` (pinned scoring/run_scoring.py; frozen scorer-v1; same task-clustered bootstrap as the primary table). Exploratory: never feeds the primary results.

## Per-arm table (gated sets: VE 144, RTLLM 33 headline)

| arm | bench | tasks | official pass@1 | not proved correct % [CI] | not correct within d % [CI] | proved wrong % [CI] | classes |

|---|---|---|---|---|---|---|---|
| e1-base | rtllm | 33 | 15.2 | 26.7 [7.1, 57.1] | 20.0 [0.0, 50.0] | 20.0 [0.0, 50.0] | diff 3, bnd 1, tmo 0, err 0, vac 0 |
| e1-base | ve | 144 | 11.8 | 2.0 [0.0, 6.5] | 2.0 [0.0, 6.5] | 0.0 [0.0, 0.0] | diff 0, bnd 0, tmo 0, err 1, vac 0 |
| e1-s100 | rtllm | 33 | 14.1 | 35.7 [7.7, 100.0] | 28.6 [0.0, 77.8] | 28.6 [0.0, 77.8] | diff 4, bnd 1, tmo 0, err 0, vac 0 |
| e1-s100 | ve | 144 | 10.9 | 0.0 [0.0, 0.0] | 0.0 [0.0, 0.0] | 0.0 [0.0, 0.0] | diff 0, bnd 0, tmo 0, err 0, vac 0 |
| e1-w100 | rtllm | 33 | 15.2 | 20.0 [0.0, 57.1] | 20.0 [0.0, 57.1] | 20.0 [0.0, 57.1] | diff 3, bnd 0, tmo 0, err 0, vac 0 |
| e1-w100 | ve | 144 | 9.5 | 2.4 [0.0, 8.8] | 2.4 [0.0, 8.8] | 0.0 [0.0, 0.0] | diff 0, bnd 0, tmo 0, err 1, vac 0 |

Source: `results/e1/stats.json`.

## Contrasts (paired, same task draws)

| contrast | bench | official pass@1 diff [CI] | not-proved-correct diff [CI] |

|---|---|---|---|
| w100_minus_base (e1-w100 − e1-base) | ve | -2.3 pp [-4.4, -0.5] | 0.6 pp [0.0, 2.5] |
| w100_minus_base (e1-w100 − e1-base) | rtllm | 0.0 pp [-5.1, 6.1] | -5.8 pp [-28.6, 18.3] |
| s100_minus_base (e1-s100 − e1-base) | ve | -0.9 pp [-2.8, 0.9] | -1.9 pp [-6.4, 0.0] |
| s100_minus_base (e1-s100 − e1-base) | rtllm | -1.0 pp [-5.1, 3.0] | 11.1 pp [-11.4, 46.0] |
| s100_minus_w100 (e1-s100 − e1-w100) | ve | 1.4 pp [-0.2, 3.2] | -2.5 pp [-8.8, 0.0] |
| s100_minus_w100 (e1-s100 − e1-w100) | rtllm | -1.0 pp [-7.1, 4.0] | 16.9 pp [0.0, 48.2] |

An interval that includes zero is reported as not resolved.

## G2 extraction check (reported as-is; exploratory — no waivers)

- e1-base_rtllm.jsonl: share 0.9091 (below 0.95 — flagged)
- e1-base_ve.jsonl: share 0.9259 (below 0.95 — flagged)
- e1-s100_rtllm.jsonl: share 0.9192 (below 0.95 — flagged)
- e1-s100_ve.jsonl: share 0.919 (below 0.95 — flagged)
- e1-w100_rtllm.jsonl: share 0.8788 (below 0.95 — flagged)
- e1-w100_ve.jsonl: share 0.9306 (below 0.95 — flagged)

