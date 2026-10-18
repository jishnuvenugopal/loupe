# Phase 6 — shakedown status (18 Oct 2026)

**Blocked on the operator for steps 1–4**: every generation/GRPO step needs a
container (`nvcr.io/nvidia/vllm:26.05.post1-py3`, `nvcr.io/nvidia/pytorch:25.11-py3`);
docker on this machine is installed (29.2.1) but the agent user is not in the
`docker` group and has no passwordless sudo (Phase 1 apt/docker leftover).
Neither image has been pulled; `docker run` is untested here.

## Step 5 — scoring speed: measured via timing proxy

`shakedown/score_timing.py` + `shakedown/run_score_timed.py` →
`results/shakedown/scoring_speed.json`.

- **DEVIATION**: the brief times 20 shakedown samples (vLLM generations of the
  study arms). Those cannot exist before docker works and G0. Instead, the
  first 20 (sorted) RTLLM-shipped GPT-4 `t1` designs were scored — pilot
  inputs, not study-arm samples, never a result, nothing deleted that matters
  (work dirs under `~/runs/shakedown_timing/`).
- Result (20 samples, WORKERS = 18 = nproc−2): total wall **42.9 s → 0.466
  samples/s ≈ 2.1 s/sample** at production parallelism. Per-sample wall:
  mean 2.49 s, p50 0.17 s, p95 1.46 s, max 42.9 s (one formal-timeout case).
  Stage split of aggregate EDA time: **formal 47.4 s (96%)**, testbench 0.5 s,
  synth+lint 1.1 s. Verdict mix in the proxy set: 8 pass / 8 fail / 4
  compile_error.
- Planning number for the overnight scoring projection (Halo lane or, if
  Spark takes over, here): ~2.1 s/sample × 18-worker parallelism already
  included; i.e. ≈ 1,550 samples/hour on this machine.

Steps 1–4 (7B generation throughput, cap-hit rate, extraction success,
overnight projection; 3B fallback lane; GRPO two-step) and the required
deletion of shakedown generations remain **not run** — no shakedown generation
exists. PREREG.md flags this in "Measured before G0".
