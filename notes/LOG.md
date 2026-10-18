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

## 2026-10-18 15:05-15:30 — Phase 4 (models) started; network is the bottleneck
- Host venv built without apt (python3 -m venv works; pip 24.0): huggingface_hub 2.2.0 +
  hf_transfer 0.1.9 + hf-xet 1.7.0 + pyyaml + datasketch 2.0.0 + opentimestamps-client 0.7.2.
  HF_HOME=~/hf set in ~/.bashrc. NOTE: HF_HUB_ENABLE_HF_TRANSFER is a no-op in hub 2.2.0
  (deprecated); high-performance xet (HF_XET_HIGH_PERFORMANCE=1) STALLS on this network
  (0-byte incompletes); default xet is the working config.
- Throughput measured: single stream 0.13-0.4 MB/s (HF + GitHub); parallel streams do NOT
  aggregate (16x8MB curl test = 0.35 MB/s total); earlier runs peaked ~5 MB/s. Link fluctuates.
- models/fetch.sh: sequential resumable fetch of all 8 pinned revisions, smallest-first
  (1.5B, 3B, 3B-Instruct, 3B RL, 3B SFT, 7B base, 7B Distill, 7B RL), 60s retry loop.
  Operational ordering choice only; pins unchanged. Running as pid file ~/runs/fetch.pid.
- Incident: a dlbench child process survived its kill and a second fetch loop ran concurrently
  15:16-15:29 (split bandwidth, shared log); all fetchers killed by explicit PID at 15:29,
  single fetcher restarted. Blobs use atomic renames; every file will be sha256-verified vs
  the ?blobs=true API regardless, so no integrity risk carries forward.
- Both GRPO datasets downloaded at pinned revisions (1149 + 743 rows; _simple's file is
  processed_entries.jsonl, not train_tb_filtered.jsonl - recorded).

## 2026-10-18 15:25-15:45 — Phase 5: H0-b/c/d done; H0-a blocked on docker
- H0-c (prompts/build_prompts.py): system prompt sha256s recomputed from pinned sources MATCH
  Appendix D1/D2 exactly. Built prompts/built/{codev,verireason}_{ve,rtllm}.jsonl (156+50 rows
  each, prompt_sha256 per row) + prompts/SHA256SUMS. RTLLM v2.1 vs CodeV v2.0: 41/50 identical,
  9 differ (alu, barrel_shifter, freq_divbyeven, freq_divbyfrac, freq_divbyodd, radix2_div,
  sequence_detector, serial2parallel, signal_generator) -> results/h0/h0c_rtllm_diff.json.
- H0-d oracle (h0/h0d_oracle.py): 30 seeded rows (random.Random(0)), CodeV extractor + Icarus:
  30/30 reproduce tb_result byte-exactly -> tb_result is a valid reward oracle.
  results/h0/h0d_oracle.json; per-row evidence ~/runs/h0d_oracle/.
- H0-d contamination (h0/h0d_contamination.py): MinHash 5-gram/128perm/J>=0.8 + normalized
  exact, both datasets vs 206 specs; positive control green; 0 overlaps in both datasets;
  closest pair J < 0.3. results/h0/h0d_contamination.json + h0d_closest_pairs.json.
- H0-a: BLOCKED - docker daemon inaccessible (user not in docker group; no passwordless sudo;
  Phase 1 operator leftover). Script h0/h0a_weight_distance.py is written and ready; it runs in
  the pinned pytorch container. No H0-a number exists yet. results/h0/H0.md records all four
  answers with file pointers.

## 2026-10-18 15:45-16:05 — Phase 6 (partial) + Phase 7 (PREREG draft)
- Phase 6 steps 1-4: BLOCKED on docker (see above). Step 5 scoring speed measured via timing
  proxy (DEVIATION): shakedown/run_score_timed.py wraps score.py with a per-EDA-command timing
  classifier; shakedown/score_timing.py ran the first 20 sorted RTLLM GPT-4 t1 designs at
  WORKERS=18: 42.9s wall -> 0.466 samples/s (~2.1 s/sample); formal = 96% of EDA time; verdict
  mix 8/8/4. results/shakedown/scoring_speed.json + README.md. These are pilot inputs, NOT
  study-arm samples, never scored as results.
- models/verify_weights.py written and run (incremental): safetensors sha256 vs ?blobs=true,
  card copies, models.yaml, results/h0/weights_sha256.tsv. Currently 0/8 verified (downloads
  running); statuses update per arm as shards land.
- Phase 7: PREREG.md drafted from Appendix E with: arms + pending H0-a bracket, tasks = A14
  with gate counts updated to the FROZEN deep results (VE 149/156; RTLLM 40 = pilot 38 +
  multi_8bit + multi_pipe_8bit; div_16bit stays out), prompt/sampling sections with measured
  hashes (system prompts = Appendix D1/D2; prompts/SHA256SUMS a0d46591...), scorer-v1 evidence
  (290/290, kill 438/438, TB false-pass 17.1%), contamination 0, shakedown status incl. the
  docker-blocked generation throughput and the two operator options at G0.
- SPARK_REPORT.md + spark_report.json written per §8 (8 sections / 8 keys). STOP line at end.

## 2026-10-18 15:50-16:40 — operator unblocked docker/apt; container lane prep
- Operator did step 1: apt packages present (tmux/jq/htop/git-lfs OK); user added to docker
  group. Agent shells predate usermod -> `sg docker -c` used (works: Server 29.2.1, systemd
  cgroup v2, nvidia-smi 580.173.02 CUDA 13.0).
- models/pull_images.sh started (background, ~/runs/image_pulls.log): vLLM 26.05.post1-py3
  then pytorch 25.11-py3, digests to be recorded on completion.
- grpo-base (Qwen2.5-Coder-1.5B-Instruct) VERIFIED (1/1 shards sha256 = API lfs.sha256).
  3B raw downloading (xet chunks share storage with ~/.cache; du undercounts - hash is the
  real check). verify_weights.py reruns incrementally.
- Harness written for Phase 6 (ready to run when images+weights land):
  gen/gen_vllm.py (§6.2 row format, resumable, per-task seed, explicit SamplingParams,
  generation_config="vllm", chat template via model tokenizer); shakedown/shakedown_run.py
  (16 seeded tasks = Random(42).sample of 8 VE-gated + 8 RTLLM-usable, n=1, per-arm protocol
  incl. VeriReason top_p 0.95 both; extraction + score.py verdicts; 22x3 throughput mode);
  grpo/reward.py (W/S rewards; dataset TB vs tb_result + non-vacuity + formal capped 10 s
  via frozen deep/common.py + 10k-vector differential sim fallback) and grpo/train_grpo.py
  (brief's GRPOConfig verbatim, LoRA r16 a32 all-linear, 1.5B base).
- reward.py smoke-tested on dataset row 0: golden completion -> 1.0 (tb pass exact, formal
  UNBOUNDED-EQ); mangled completion (dropped VNB term) -> 0.0 (tb fail). Both controls green.

## 2026-10-18 17:20-18:10 — docker lane live
- vLLM image pulled: nvcr.io/nvidia/vllm:26.05.post1-py3 (20.4GB). Digest recorded above/SPARK_REPORT.
- PHASE 1 EXIT CHECK PASSED via `sg docker -c 'docker run --rm --gpus all ...'`:
  torch 2.12.0a0+5aff3928d8.nv26.05, cuda available True, device "NVIDIA GB10",
  vllm 0.21.0+2325b6f0.dev. (Container prints recommended flags: --ipc=host
  --ulimit memlock=-1 --ulimit stack=67108864 — will use for generation runs.)
- Weights verified so far: grpo-base (1.5B) + 3b-base-raw (Qwen2.5-Coder-3B), both sha256=API.
  3B-Instruct downloading; pytorch image queued after vLLM in pull script.
- Shakedown harness dry-run: seeded task selection OK (8 VE-gated + 8 RTLLM-usable,
  Random(42); pools 149/40); requirements.lock written (host venv).

## 2026-10-18 18:20-18:55 — machinery smoke + GRPO two-step trial (Phase 6 step 4) PASSED
- gen_vllm.py end-to-end smoke in the vLLM container with the verified 1.5B (2 VE prompts,
  T 0.6, max 512, n 1, labelled machinery-smoke): rows match the §8 schema exactly, per-task
  seed set, prompt_sha256 = prompts/built values, finish_reason 'stop', <think> format OK.
- TRL pick per brief rule: trl 1.16.0 declares vLLM 0.22.0-0.31.0 (container has 0.21.0) ->
  stepped down: 1.15.0 declares 0.21.0-0.31.0 = the newest covering release. RECORDED:
  trl 1.15.0 + peft 0.21.2 + vllm 0.21.0+2325b6f0.nvinternal.26.05.post1 + torch 2.12.0a0+nv26.05.
- GRPO trial (arm S, 2 steps, brief's GRPOConfig verbatim; max_prompt_length not offered in
  trl 1.15 -> not set): train_runtime 171.3 s (step 88.6/73.7 s); 128 reward calls, reward wall
  17.1 s (7.7 + 9.4 s/step, ~0.13 s/call — TB+formal via frozen scorer machinery in-container);
  zero-advantage fraction 0.812 (13/16 groups; TRL frac_reward_zero_std 0.875/0.75 agrees);
  mean reward 0.016 -> 0.047; peak GPU alloc 52.25 GiB. results/shakedown/grpo_trial_S.json.
  Lane verdict: vLLM-container colocate WORKS; pytorch+trl==0.26.1 fallback not needed.
  Fixes en route (recorded): /bench + /root/eda mounts for in-container reward; GRPO_WORK_DIR
  resolution; conditional max_prompt_length.

## 2026-10-18 18:55-19:00 — interim close after docker unblock
- H0-a watcher armed (h0/watch_h0a.sh, pid ~/runs/h0a_watcher.pid): waits for the pytorch
  image + all four 3B checkpoints, runs h0/h0a_weight_distance.py in the pinned container,
  commits+pushes if the tree is otherwise clean. Log: ~/runs/h0a_watcher.log.
- Remaining for next interactive session: shakedown steps 1-3 once 7B/3B-RL weights land
  (shakedown/shakedown_run.py, ~1-2h GPU total), PREREG "Measured before G0" refresh,
  pytorch image digest record, 8x weights verification.
- SPARK_REPORT.md + spark_report.json updated (docker lane results, deviations, open items).
