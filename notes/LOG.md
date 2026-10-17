# Deep-oracle run log (brief: deep-oracle-brief.md)

## 2026-10-17 19:27 — D0 inventory (this machine, `spark-cff9`)
- Linux 7.0.0-1019-nvidia aarch64, 20 cores (Cortex-X925/A725), 121 GB RAM, GB10 GPU, 3.5 TB free.
- Network: github.com 200, huggingface.co 200. No EDA tools preinstalled. No passwordless sudo (not needed: oss-cad-suite is self-contained under ~/eda).

## 2026-10-17 19:29 — D2 raw material
- `git clone https://github.com/hkust-zhiyao/RTLLM` → checkout `51ed553` OK. `git rev-parse HEAD` = `51ed553d0ffd32797a1a0a13e051656bf302c81f` (pin match, byte-exact prefix).
- Layout confirmed: `<Category>/<Sub>/<design>/{verified_*.v, testbench.v, design_description.txt}` — 50 each; `_chatgpt4/`, `_chatgpt35/` t1..t5 → 290 .v files.

## 2026-10-17 19:29 — D1 tools
- Downloading pinned `oss-cad-suite-linux-arm64-20261016.tgz` (expect 686,594,072 bytes).

## 2026-10-17 19:30-21:00 — deep run (brief: deep-oracle-brief.md)
- D1: pinned oss-cad-suite downloaded, byte size exact (686,594,072). Versions match §3.1.
- D2: RTLLM @ 51ed553 verified.
- Soundness harness built: reset-scaffold wrapper + PDR (abc) + SMT-induction (z3).
  Two harness bugs found by self-equivalence gate (uncorrelated init state; netlist $ff round-trip)
  and fixed (memory_map/tribuf/setundef -zero -init; in-session stashing).
- RUN1: 50 refs -> 41 UNBOUNDED-EQ (32 both engines), 4 BMC-only, 5 yosys-limit errors.
- RUN2: 290 GPT rows -> TB matches Appendix B 290/290; equiv 280/290 (10 = synchronizer recording);
  totals 60/39/14/7 and 37/25/4/8 exact; FLIPS = 0; all 64 bmc-equiv rows carry unbounded proofs.
- Cross-sim: zero pass/fail disagreements (Icarus vs Verilator).
- RUN3: 528 mutants -> 438 formally different, TB false-pass 17.1% (pilot 19.2%), strict kill 100.0%,
  0 engine-UNKNOWN survivors (2 gen_errors in ROM recorded).
- Spec oracle: accu FAIL (cex sum=101 with invalid 100), LIFObuffer FAIL, width_8to16 GPT FAIL,
  fsm GPT FAIL, square_wave const0 cover unreachable + official TB passes it. All with traces.
  Cover instrumentation caught two vacuous-property bugs during development (stuck counter; misaligned sequence).
- DEEP_REPORT.md + deep_report.json written; committed per gate.
