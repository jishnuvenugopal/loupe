# A19 §4 sensitivity: 3B arms with generation headroom (supplementary, never merged into the primary)

Settings changed (PREREG-A19 §4, only for these arms): max_new_tokens 2048→3072,
max_model_len 4096→5120. Everything else pinned as the primary. Arms scored as
`3b-rl-cap` / `3b-base-cap` from `~/runs/gen_sens/` into `scores_sens/`;
generation sha256s in `GEN_SHA256`.

## G2 under the A19 §2 alias

| file | share | threshold | verdict |
|---|---|---|---|
| 3b-rl-cap_ve | 0.9594 | 0.95 | **pass** (primary: 0.9487 waived) |
| 3b-rl-cap_rtllm | 0.9867 | 0.95 | **pass** (primary: 0.9600) |
| 3b-base-cap_ve | 0.9637 | 0.95 | pass (primary: 0.9679) |
| 3b-base-cap_rtllm | 0.9400 | 0.95 | **still below** — all 9 failures are length hits at 3072 (primary: 0.9400, 9 length) |

The 3b-rl primary shortfall was cap-driven and clears with headroom; 3b-base's
rtllm shortfall persists even at 3072 (the base model exceeds the raised cap on
the same tasks). Reported as-is per PREREG-A19 §4; no further amendment.

## Side-by-side (official all-task pass@1 / strict pass@1, gated task sets)

| arm | bench | primary @2048 | sens @3072 | Δ official |
|---|---|---|---|---|
| 3b-rl | ve | 0.2949 / 0.2940 | 0.3077 / 0.3102 | +1.3 pp |
| 3b-rl | rtllm | 0.2800 / 0.2222 | 0.3333 / 0.2222 | +5.3 pp |
| 3b-base | ve | 0.1197 / 0.1204 | 0.1368 / 0.1366 | +1.7 pp |
| 3b-base | rtllm | 0.2133 / 0.1616 | 0.2133 / 0.1616 | 0 |

Reading: headroom lifts 3b-rl's rtllm official pass@1 (more completions finish
the TB) without moving its strict pass@1 (the extra finishes are not proved
correct: classes different 14, bounded-only 5 on the gated 33). 3b-base is
essentially unchanged on rtllm and gains little on ve. The primary conclusions
are insensitive to the 3B cap. Full cells: `stats.json` (this directory) vs
`results/main/stats.json`.
