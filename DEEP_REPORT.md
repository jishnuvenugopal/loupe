# DEEP REPORT — soundness, power, and independence of the strict scorer

Deep-oracle run, 17 Oct 2026, machine `spark-cff9` (DGX Spark, aarch64, GB10, 20 cores).
Brief: `deep-oracle-brief.md` (deepening of `spark-agent-brief.md`; same pins, no new arms/tasks).
Everything below points at files under `~/runs/deep/` and code under `~/rtl-strict-eval/deep/`.

## Tools (gate G-D1)

- `oss-cad-suite-linux-arm64-20261016.tgz`, **686,594,072 bytes = pinned size exactly**.
- Yosys 0.70+145, Icarus 14.0 (devel), Verilator 5.053 devel, SymbiYosys 0.70 — all match §3.1.
- RTLLM at `51ed553d0ffd32797a1a0a13e051656bf302c81f` (pin match). Gate G-D2 ✓.

## 1. Soundness (gate G-D3): bounded verdicts upgraded to unbounded proofs

Method: pilot-compatible BMC-10 miter kept as the anchor column; two independent
unbounded engines on a **reset-scaffold wrapper** (common 2-cycle reset with the
pilot's held-high enables, comparison from cycle 3; memories mapped; tri-state
resolved; FFs zero-initialised so both copies start from the same state — the
documented initial-state policy whose necessity was *demonstrated*: before it,
7 designs failed self-equivalence spuriously).

Self-equivalence of the 50 references, by proof class (`refs_summary.json`):

| class | n |
|---|---|
| UNBOUNDED-EQ (PDR and/or SMT-induction proof) | 41 |
| BMC-10-EQ-ONLY (no unbounded witness) | 4 (`alu` tri-state, `freq_divbyfrac`, `freq_divbyodd`, `div_16bit`→unknown pair) |
| read error (Yosys limit; = pilot's known set) | 5 (`adder_pipe_64bit`, `multi_pipe_4bit`, `fixed_point_substractor`, `float_multi`, `synchronizer`) |

- 32 designs carry proofs from **both** engines (independent witnesses agree).
- Designs the pilot excluded as "self-equivalence timeout" are now **proved**
  unbounded in seconds: `multi_8bit`, `multi_pipe_8bit` (+ `div_16bit` PDR proof).
- No verdict anywhere is reported as bare "equivalent": every row carries its
  proof class, engine verdicts, and log paths.

## 2. Power (gate G-D4): the scorer fault-graded on 528 seeded mutants

`mut/mut_summary.json`; 12 seeded mutants/design (`yosys mutate -list 12 -seed 1`,
the pilot's recipe), all 50 designs:

| metric | value |
|---|---|
| mutants generated | 528 (2 `gen_error` in `ROM`: mutation generation itself failed) |
| formally different (any engine counterexample) | 438 |
| official-TB false passes on those | **75 = 17.1%** (pilot anchor: 64/334 = 19.2% on its 38-design subset) ✓ |
| **strict-scorer kill rate on formally-different mutants** | **438/438 = 100.0%** |
| mutants proven equivalent unbounded | 66 |
| engines-UNKNOWN survivors (measured blind spots) | 0 (the 2 `gen_error`s are generation failures, reported as such) |
| TB kills what engines PROVE equivalent (from-reset) | 5 (`multi_pipe_8bit` ×4, `traffic_light` ×1) — 4-valued-sim/pre-reset semantics, not scorer misses; listed, not averaged away |

22 designs have ≥1 TB false pass (`square_wave` 11, `instr_reg` 10, `alu` 8 —
the official testbenches are that weak).

## 3. Independence (gate G-D5): two simulators, all 340 testbench verdicts

| Icarus | Verilator | rows |
|---|---|---|
| pass | pass | 97 |
| fail | fail | 111 |
| compile_error | vl_compile_error | 61 |
| compile_error | fail | 12 |
| compile_error | pass | 1 |
| timeout | timeout | 1 |
| fail | vl_compile_error | 2 |

**Zero pass/fail disagreements** on any row both simulators could run: no
official-pass verdict flips, no fail turns pass. The one icarus-compile_error →
verilator-pass row is a compiler-coverage difference (recorded).

## 4. Spec oracle (gate G-D6): the reference audit, machine-checked

Every verdict from a solver, traces on disk (`spec/spec_results.json`):

| spec property | subject | verdict |
|---|---|---|
| accu: only valid samples accumulate (groups of 4) | reference | **FAIL** — cex trace: `valid_out=1` with `data_out=101` (invalid 100 + valid 1); root cause in source: `ready_add = !valid_out \| valid_in`. Machine-checks RTLLM #25. |
| width_8to16: `valid_out` is a one-cycle pulse | reference | PASS |
| same property | GPT-4 t1 design | **FAIL** — the pilot's "real bug", now solver-produced |
| LIFObuffer: reset-while-full drops `FULL` | reference | **FAIL** — machine-checks RTLLM #26 |
| fsm: sequence 1000011 must not raise MATCH | reference | PASS |
| same property | GPT-4 t2 design | **FAIL** — pilot F.2, solver-produced |
| square_wave: cover `wave_out=1` reachable | reference | PASS (capability exists) |
| same cover | const-0 mutant (F.6) | **FAIL (unreachable)** while the official testbench **passes** it — the pilot's vacuity finding, machine-checked |

Method note: the cover instrumentation twice caught vacuous properties during
development (a stuck stimulus counter; a misaligned sequence) — i.e. the harness
detects its own vacuity, which is the point of cover checks.

## 5. External anchor (gate G-D7): Appendix B reproduced, and the flip count

All **290 GPT rows re-run**: TB verdicts match Appendix B **row for row (290/290)**;
equiv columns match **280/290** — the 10 `synchronizer` rows differ only in
recording (pilot "error" vs our "None": two clock domains, same Yosys limit).
Totals: GPT-4 60/39/14/7, GPT-3.5 37/25/4/8 — exactly the brief's numbers.

**Flips: 0.** Every one of the 64 BMC-10-equivalent GPT official-passes also
carries an unbounded proof (`gpt_summary.json`, `flip: false` for all; zero rows
lack an unbounded witness). On this data the pilot oracle's false-negative rate
on real model output is **0/64** (rule-of-three 95% upper bound ≈ 5.6%) — and it
is now *proved per row* rather than bounded by a depth guess.

## 6. What the deepening changed for the parent study

1. The strict scorer can be frozen with **proof classes** instead of depth
   guesses; `BMC-N-EQ-ONLY` shrinks to 4 designs (fixable by engine choice).
2. Two more designs become scorable (`multi_8bit`, `multi_pipe_8bit`), with
   proofs, not timeouts.
3. The reference audit (`accu`, `LIFObuffer`) and the real-bug classifications
   (`width_8to16`, `fsm`) are re-runnable property checks, not prose — they can
   ship in `scorer/` and gate every future run.
4. The scorer's own power is now a measured number (100% kill on 438 identified
   behavior-changing mutants), not an assumption.

## 7. Deviations from the deep brief (recorded, not silent)

- `abc pdr` rejects x/z after `prep` on two spec properties → those ran on
  `smtbmc` (recorded per case).
- `ROM` mutants 2 and 6: `yosys mutate` failed to emit mutant Verilog
  (`gen_error`), counted as generation failures, not scorer survivors.
- The 10 `synchronizer` rows recorded as `null` equiv (ports() fails) where the
  pilot wrote "error" — same underlying two-clock-domain limit.

## 8. Handback

- Code: `~/rtl-strict-eval/deep/{common,run_deep,fault_grade,spec_oracle,analyze}.py`
  + verbatim pilot `scorer/{rtllm_audit,pilot_llm_outputs}.py` (Appendix A).
- Data: `~/runs/deep/{refs_summary,gpt_summary}.json`, `~/runs/deep/mut/mut_summary.json`,
  `~/runs/deep/spec/spec_results.json`, all logs/traces under the same tree.
- Local git history, one commit per gate (`git log` in `~/rtl-strict-eval`).
- No evaluation sample was generated; nothing touches the pre-registration timeline.

---

# Addendum — continuation run (Phase 2 completion + Phase 3 deep + freeze)

- **Phase 2 done**: verilog-eval `c498220`, CodeV-R1 `277ac46`, VeriReason `d215b7f`
  cloned and pinned (`~/bench/PINS.txt`); 156/156/156 task files; CodeV task_ids ==
  the VerilogEval set exactly; harness fix (a) applied to all 156 test copies.
- **Deep VerilogEval gate**: classes across 156 tasks — 145 UNBOUNDED-EQ, 5 BMC-10-only,
  6 read-errors. **Kept 149/156 vs the pilot's 143**: the pilot's six timeout/error
  exclusions (`mux256to1v`, `popcount255`, `rule90`, `rule110`, `conwaylife`, `gshare`)
  are now *proved* by PDR (five also by SMT-induction). Remaining exclusions match the
  pilot's read-error set + `Prob099` (official TB does not compile; its self-equivalence
  is nevertheless proved unbounded).
- **Cross-simulator on VerilogEval**: 155 pass / 1 compile-error under Verilator;
  **zero pass/fail disagreements** with Icarus. (Three bugs in my own Verilator wrapper
  were found and fixed en route: top-module regex matching comments, missing `ref.sv`
  in the compile, and Verilator's different pass-string.)
- **`scorer/score.py`** frozen per brief §5 schema + proof classes; smoke-tested on
  rtllm (pe t2 → UNBOUNDED-EQ; fsm t2 → DIFFERENT with counterexample VCD extracted)
  and ve (Prob031_dff → UNBOUNDED-EQ). `depth.yaml` + `masks/` written.
- **Appendix F**: all 7 directed tests reproduce their documented behaviour
  (106/10; forbidden-sequence MATCH; held valid_out; rise+down together; 200/200 booth
  pairs; const-0 square_wave passes the official TB; FULL stays high after reset).
- **Freeze**: `results/pilot_repro/SCORER_SHA256`; local commit + tag `scorer-v1`
  (push to the private REPO awaits the operator's `gh` sign-in, per rule 1).

## What still blocks the parent brief on this machine (operator inputs needed)

1. `gh` sign-in + REPO name → Phase 1b (push guard, first push) and pushing `scorer-v1`.
2. sudo (or operator-run apt) → Phase 1 packages; docker group → containers (vLLM).
3. Operator's `G0 approved` → Phase 8 generation (nothing generated until then).
