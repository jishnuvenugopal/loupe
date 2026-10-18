# HANDOFF — continuation notes for the next session (17 Oct 2026, evening)

You are the engineering agent on this DGX Spark (`spark-cff9`, aarch64, GB10, 128 GB).
Master brief: `~/Downloads/pi/halo/spark-agent-brief.md` — its §2 hard rules apply to you
unchanged. Deepening brief + results: `~/Downloads/pi/halo/deep-oracle-brief.md`,
`~/rtl-strict-eval/DEEP_REPORT.md` (also on the remote). Read all three before acting.

## Machine state (verified this evening)

- git repo `~/rtl-strict-eval`, branch `spark`, remote `origin` =
  `jishnuvenugopal/rte-strict-eval` (PRIVATE; the only private repo on the account).
  Tag `scorer-v1` pushed. Pre-push guard (Appendix G4) installed in `.git/hooks/pre-push`,
  tested 6/6. gh signed in (operator). `gh auth setup-git` done.
- `~/bench`: RTLLM `51ed553`, verilog-eval `c498220`, CodeV-R1 `277ac46`, VeriReason
  `d215b7f` — all pin-verified, see `~/bench/PINS.txt`.
- `~/eda/oss-cad-suite` (pinned 2026-10-16 arm64, byte-size verified): Yosys 0.70+145,
  Icarus 14.0, Verilator 5.053, sby 0.70. `export PATH=~/eda/oss-cad-suite/bin:$PATH`.
- Evidence trees under `~/runs/deep/` (refs, gpt, mut, spec, ve), `~/runs/pilot`,
  `~/runs/directed`, `~/runs/score_smoke`. Keep `notes/LOG.md` current (one timestamped
  entry per step) and push at every STOP.

## What is already done (do not redo)

- Deep oracle runs: soundness (41/50 refs UNBOUNDED-EQ; pilot's 6 VE timeouts proved),
  power (528 mutants: TB false-pass 17.1%, strict kill 100.0%), anchor (290/290 TB rows,
  0 flips), spec oracle (accu/LIFObuffer reference bugs + width_8to16/fsm GPT bugs +
  square_wave vacuity, all machine-checked with traces).
- Phase 2 complete (incl. VE harness fix (a), CodeV task-id equality).
- Phase 3 deep complete: `scorer/score.py` frozen + `depth.yaml` + `masks/`, Appendix F
  suite 7/7 green. Tagged `scorer-v1`.
- Phase 1b push side done (remote, guard, first push). koder scaffold NOT created — that
  part of Phase 1b is yours.

## Results that change later phases (use these, not Appendix C verbatim)

- VerilogEval gate keeps **149/156** (not 143): `results/pilot_repro/ve_gate_summary.json`.
  Still excluded: Prob095, 096, 137, 146, 152, 155 (Yosys read errors) + Prob099 (official
  TB does not compile; self-eq nevertheless proved).
- RTLLM usable set: pilot's 38 **plus** `multi_8bit`, `multi_pipe_8bit` (proved unbounded);
  still out: the pilot's 12 minus nothing new, but re-derive from
  `~/runs/deep/refs_summary.json` if in doubt.
- Initial-state policy for the formal engines (documented in `deep/common.py`):
  memories mapped, Z resolved, FFs zero-initialised in BOTH copies; matches official-TB
  operational semantics. Do not change it without re-running the self-equivalence gate.

## What remains (parent brief order)

1. Phase 1 leftovers: apt packages + docker group need the operator (no passwordless sudo
   here). docker binary exists; `docker run --gpus all` untested. pip + venv work.
2. Phase 1b: koder scaffold (Appendix G) + adapter symlinks + `.git/info/exclude`
   (`koder/ AGENTS.md CLAUDE.md .claude/ .agents/ .pi/`), koder's own local git. Commit the
   brief copy to `koder/docs/brief-spark-v1.md`.
3. Phase 4: 8 models (~80 GB) per §3.2, verify every safetensors sha256 against
   `?blobs=true`, write `models.yaml`, `results/h0/weights_sha256.tsv`. HF needs no token.
4. Phase 5 H0: H0-a in the pytorch container (once docker works); H0-b copy §3.4; H0-c build
   prompts (`prompts/`) + sha256 vs Appendix D (sources already cloned); H0-d dataset check
   + MinHash contamination (datasketch not installed — pip install --user or pure python).
5. Phase 6 shakedown (vLLM container), Phase 7 PREREG draft → **STOP — waiting for operator
   review and "G0 approved"**. Nothing may generate a sample before that (rule 3).
6. Phase 8/9 only on the operator's exact messages.

## Standing cautions

- Rules §2 of the master brief are absolute: no force-push/ref deletion/repo changes; no
  koder/ or weights in the pushed repo; no numbers without file pointers; pin mismatches
  get reported, never silently substituted.
- If a VE/RTLLM gate verdict surprises you, cross-check with the second simulator
  (`deep/common.py: tb_verdict_verilator`) and the unbounded engines before suspecting
  the design.
- Verilator wrapper gotchas already fixed in `deep/common.py` (top-module regex anchored,
  `extra_src` for `ref.sv`, Verilator's own pass-string) — reuse it, don't rewrite it.

First command to orient yourself:
  cd ~/rtl-strict-eval && git status && git log --oneline -3 && tail -30 notes/LOG.md
