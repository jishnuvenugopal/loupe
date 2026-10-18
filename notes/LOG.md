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

## 2026-10-17 21:15-22:10 — continuation: Phase 2 completion + Phase 3 (deep) + freeze
- Phase 2: verilog-eval @c498220, CodeV-R1 @277ac46, VeriReason @d215b7f cloned; PINS.txt written.
  Exit check: 156/156/156 task files; 156 CodeV task_ids == VE set exactly; rtllm2.jsonl 50 rows. PASS.
- Harness fix (a) applied to test copies (all 156 need the tb_mismatch patch).
- Deep VE gate (156 tasks): 145 UNBOUNDED-EQ + 5 BMC-only + 6 read-errors (UNKNOWN).
  Pilot's 6 timeout/error exclusions (Prob021, 030, 108, 124, 144, 153) now PROVED by PDR
  (5 also by SMT-induction). Deep gate keeps 149/156 vs pilot 143. Prob099 still out (TB
  compile_error; its self-equivalence is nevertheless proven).
- Cross-sim VE: after fixing top-module detection (comments!) and the ref.sv argument and
  the Verilator pass-string, 155 pass / 1 compile-error; ZERO pass/fail disagreements.
- score.py (rtllm+ve) smoke-tested: pe t2 UNBOUNDED-EQ; fsm t2 DIFFERENT with cex VCD;
  Prob031_dff UNBOUNDED-EQ. depth.yaml + masks/ written.
- Appendix F directed tests: all 7 reproduce documented behaviour
  (F.1 106/10; F.2 gate MATCH; F.3 held valid_out; F.4 rise+down; F.5 200/200; F.6 TB passes
  const-0; F.7 FULL stays 1).
- Freeze: SCORER_SHA256 written; commit + local tag scorer-v1 (push awaits operator repo).

## 2026-10-17 22:20 — Phase 1b (push side) completed for the deep session
- gh signed in (operator). REPO = jishnuvenugopal/rte-strict-eval (PRIVATE, was empty; the only
  private repo on the account — name recorded as-is per rule 9).
- .gitignore (brief §4) added; __pycache__ untracked before first push.
- Appendix G4 pre-push guard installed at .git/hooks/pre-push and tested in scratch repos:
  6/6 (koder refused, 60MB refused, safetensors refused, text-only allowed, main refused,
  wrong-URL refused).
- First push: spark (5 commits) + tag scorer-v1. ls-remote confirms both refs.
- koder/ scaffold NOT created here (the other session owns Phase 1b's koder part; nothing of
  it is committed, per the local-exclude rule).

## 2026-10-18 14:55-15:00 — Phase 1b (koder scaffold) completed
- .git/info/exclude appended: koder/ AGENTS.md CLAUDE.md .claude/ .agents/ .pi/ (local only).
- koder/ scaffolded per Appendix G, byte-for-byte templates: AGENTS.md (Project section filled:
  strict re-scoring of CodeV-R1 7B / VeriReason 3B on RTLLM v2.1 + VerilogEval v2, product code
  scorer/ + deep/), STATE.md, issues/, skills/open/ + skills/close/ (SKILL.md + references,
  bin/scratch-invariant.sh executable, gate run: clean), docs/brief-spark-v1.md = copy of master brief.
- Adapter symlinks: AGENTS.md -> koder/AGENTS.md, CLAUDE.md -> koder/AGENTS.md,
  .claude|.agents|.pi/skills/{open,close} -> ../../koder/skills/{open,close}.
- DEVIATION (recorded): koder/STATE.md written with current facts (Phases 0-3 already done when
  koder was initialized) instead of the brief's literal Phase-2/3-in-Future template text; same shape.
- koder local git: `git -C koder init -b main`, commit 5f8d398 "koder init". No remote added.
- Exit checks: git ls-files | grep -E '^(koder/|AGENTS.md|CLAUDE.md)' -> empty; scratch gate clean;
  git -C koder log shows 5f8d398; ls-remote origin shows refs/heads/spark (verified earlier today).
- Machine note for later phases: docker daemon NOT accessible (user not in docker group; no
  passwordless sudo) -> H0-a and Phase 6 container steps blocked on operator. python3 -m venv works
  without apt python3-venv (tested in /tmp; pip 24.0). Disk 3.5T free.
