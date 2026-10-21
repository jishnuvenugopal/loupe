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

## 2026-10-18 19:00 — CORRECTION + re-run: GRPO trial version record
- Discovered via requirements.lock that the first successful GRPO trial had actually run on
  trl 1.13.0 (my version-stepping loop's last install), not 1.15.0 as reported. The metrics
  JSON recorded the truth (trl 1.13.0). Per the brief's "newest TRL whose stated support
  covers the container's vLLM" (= 1.15.0, range 0.21.0-0.31.0), reinstalled trl==1.15.0 and
  RE-RAN the 2-step trial: exit 0, train_s 172.6, reward_wall_s 21.6 (128 calls),
  zero_advantage_fraction 0.812, peak_gpu_alloc matches. grpo_trial_S.json now holds the
  1.15.0 run; requirements.lock refreshed from the container (trl==1.15.0, peft==0.21.2).
  Earlier LOG wording implied the first run was on 1.15.0 — it was not; both runs green.

## 2026-10-18 19:05-19:20 — prep while transfers run
- requirements.lock: host venv + vllm-container pip freeze (trl 1.15.0/peft 0.21.2);
  pytorch-container freeze pending image arrival.
- gen_vllm.py resume verified in-container (already_done=2 todo=0, no dupes).
- shakedown extract+score path dry-run on machinery smoke: found + fixed a real bug
  (score.py rmtree's --out, so sample inputs now live in samples_<arm>/ outside it);
  end-to-end verdicts behave correctly (lowercase top_module -> name_ok False ->
  compile_error: the G2 name gate working as designed on a truncated smoke completion).
- gen/make_manifest.py (Phase 8 step 5 manifests) + gen/README.md (rsync prep, do-not-run).

## 2026-10-18 19:05-19:45 — Phase 6 step 3 (3B lane, first half): 3B-RL shakedown DONE
- Weights 3b-rl verified (4/8 total). shakedown_run.py --arm 3b-rl (VeriReason protocol
  T 0.2, top_p 0.95, max 2048, n 1): 16 seeded tasks (Random(42); 8 VE gated + 8 RTLLM usable).
- Results (results/shakedown/3b-rl.json): completion tokens mean 812 / p95 1930 / max 2048,
  cap hits 1/16; extraction 15/16, module-name 15/16 (G2 note: 93.75% on this lane);
  official TB 8 pass / 3 fail / 5 compile_error; strict on passes: 5 UNBOUNDED-EQ,
  2 DIFFERENT, 1 UNKNOWN -> the false-pass phenomenon is present on this arm (shakedown
  evidence only, never a result).
- Throughput (batched driver, 22 prompts x n=3 = 66 concurrent, wall includes model load):
  VE 182.1 tok/s (154.3 s, 28,087 tok); RTLLM 354.1 tok/s (161.7 s, 57,264 tok).
- Fixed en route: gen_vllm.py now batches ALL pending tasks in one llm.generate call with
  per-task SamplingParams seeds (the old sequential loop measured latency, not throughput;
  first VE number 66.8 tok/s was sequential-mode -> superseded); shakedown subset writers
  emitted JSON arrays where the driver reads JSONL -> now JSONL; sample inputs moved outside
  score.py --out (it rmtree's the dir). All fixes verified by re-run.

## 2026-10-18 19:30-19:50 — H0-a DONE (SFT arm dropped); Phase 5 complete; 6/8 weights verified
- PyTorch image landed: nvcr.io/nvidia/pytorch@sha256:417cbf33f87b...dff21.
- Watcher fired at 19:22 but the H0-a run was OOM-killed (137): it overlapped the 3B-RL
  vLLM shakedown holding 85% of unified GB10 memory. Lesson recorded: no CPU-heavy container
  work while vLLM holds the GPU. Re-ran with GPU idle: SUCCESS.
- H0-a (pinned container, CPU fp32, 434 tensors): median RL<->SFT 4.50e-3 is NOT <= 0.1x
  median RL<->3B-Instruct 3.45e-3 -> NOT CONFIRMED -> 3B family DROPS the SFT arm
  (pre-registered consequence); contrast becomes SFT+RL vs Instruct. SFT nearer to
  3B-Instruct (matches SFT YAML) but tokenizer groups are {RL}, {SFT, 3B raw}, {3B-Instruct}.
  results/h0/h0a_weight_distance.json; H0.md + PREREG.md updated with the bracket resolved.
- Weights verified 6/8: 1.5B, 3B raw, 3B-Instruct, 3B-RL, 3B-SFT(fp32 3/3) + grpo-base.
  Only the three 7Bs remain (7B-RL at 1/4 shards; ~7h at current uplink).
- PHASE 5 EXIT CHECK: all four H0 answers written with evidence (results/h0/H0.md).

## 2026-10-18 19:50 — AMENDMENT A16 received (Spark-only lane); applied
- Operator issued A16 (no second machine; Spark does generation+scoring+stats+blind
  packet+GRPO; `Spark runs 3B` standing; messages list trimmed). Copied verbatim to
  `koder/docs/brief-spark-addendum-A16.md`. Phase at receipt: 6 of 9 (Phases 0-5 exit
  checks passed; STOP for PREREG review maintained). §0.5 check: G0 NOT reached, zero
  evaluation samples exist -> clean apply, no stop-and-report.
- Conflicts found & resolved: (1) 3B-SFT-as-bf16 shakedown had just been started under
  the old brief's "machinery check even though dropped" reading -> killed (log empty,
  no results); A16 §3 step 3 skips it because H0-a dropped the arm. (2) The completed
  3B-RL shakedown had run at max_model_len=20480 (driver default) and 66-concurrent
  throughput -> superseded; re-run below at the A16-pinned settings, old JSON kept as
  `results/shakedown/3b-rl.pre-a16.json`. (3) PREREG cut order said "raw-base arm";
  A16 ladder is "drop base arms, 7B base first, then 3B base" -> updated. (4) 3B base
  redefined = Qwen2.5-Coder-3B-Instruct@488639f (raw 3B stays H0-reference only).

## 2026-10-18 20:00-20:10 — A16 §2: guard self-tests re-run (one fresh scratch repo per test)
- Old run (17 Oct) stacked the four content commits in ONE scratch repo, so the 60MB and
  safetensors tests were refused with `koder/x.md` present in the pushed tree (wrong
  reason), and its `mk()` helper had clobbered big.bin to 2 bytes ("60MB refused" was
  vacuous). Re-run: 6/6 in ~/runs/guard_selftest_a16/, each test in its own fresh repo —
  T1 koder/x.md -> "contains koder/x.md"; T2 REAL 62,914,560-byte blob -> "blob over
  50 MB"; T3 w.safetensors -> "contains w.safetensors"; T4 text-only -> exit 0;
  T5 refs/heads/main -> "remote ref not allowed"; T6 wrong URL -> "remote URL ... is
  not ...". (One transient `gh` visibility 'unknown' on T1's first attempt — re-ran clean.)

## 2026-10-18 20:05-20:35 — A16 §3 step 3: 3B lane (primary); §3 step 8: analysis code pinned
- max_model_len computed per A16 formula: largest rendered 3B prompt = 1,279 tok
  (rtllm asyn_fifo; both 3B tokenizers agree, chat template applied) + 2,048 + 64 =
  3,391 -> roundup256 = 3,584 -> floored at the 4,096 minimum -> **4096** pinned in
  shakedown_run.py (MAX_MODEL_LEN_3B).
- shakedown_run.py: 3b-base arm added (Qwen/Qwen2.5-Coder-3B-Instruct@488639f,
  VeriReason protocol); docker_gen now passes --max-model-len (4096 for 3B, 20480 for
  7B) and --log-effective-params; throughput changed 22x3=66 -> 32x2 = exactly 64
  concurrent; BUG FIX: throughput out files are now deleted before each run (resume
  mixed stale rows into the batch and divided old+new tokens by the new batch's wall —
  found via the first polluted 3b-rl re-run, numbers superseded).
- 3b-base (new primary arm): mean 793 tok / p95 2048 / cap hits 2; extraction+name
  14/16; official TB 4 pass / 3 fail / 9 compile_error; strict on passes 2 UNBOUNDED-EQ
  + 2 BMC-10-EQ-ONLY; VE 193.9 / RTLLM 315.8 tok/s at 64 concurrent; effective
  SamplingParams logged (T 0.2, top_p 0.95, max_tokens 2048, n=1, per-task seed).
- 3b-rl re-run clean at pinned settings: completions byte-identical to the first run
  (deterministic per-task seeds — recorded as a reproducibility check); verdicts
  unchanged (8/3/5; 5 UNBOUNDED-EQ, 2 DIFFERENT, 1 UNKNOWN); throughput at 4096 +
  64-concurrent: VE 363.2 / RTLLM 500.0 tok/s (supersedes 182/354).
- Pinned analysis code (§3 step 8), committed this session:
  - scoring/extract.py: CodeV-R1 extract_verilog_code @277ac46 vendored VERBATIM
    (file sha256 7c52795e...) + module-name check (TopModule/task) + G2 CLI.
  - scoring/stats.py: task-clustered bootstrap (10k, default_rng(0), percentile 95),
    false-pass share as ratio of sums, a16 classes, H1/H2 paired on shared task
    draws, wilson(); adapters for scores/ + pilot + shakedown. TESTED on the pilot's
    290 verdicts (GPT-4: op 53 / strict 40 / FP 24.5% [8 different, 5 error];
    GPT-3.5: op 34 / strict 25 / FP 26.5%; H1/H2 run, both "not resolved") and on the
    3b-rl shakedown verdicts (VE 5/4/20%, RTLLM 3/1/67% — matches the LOG tally).
  - scoring/run_scoring.py: resumable driver over ~/runs/gen/<arm>.jsonl ->
    scores/<arm>.jsonl, scorer-v1 commit + sha256 in every row, WORKERS/SAT_TIMEOUT
    env, cex tables via scoring/showcex.py (VCDs stay in ~/runs). 1-sample smoke OK;
    resume verified (already_done=1 todo=0).
  - scoring/showcex.py: brief Appendix A.8 VERBATIM, homed in scoring/ so scorer/
    stays byte-identical to tag scorer-v1 (Phase 10 freeze checks depend on that).
- shakedown/projection.py (§3 steps 5-6 machinery): 3B half measured (3B-RL 0.36 h +
  3B base 0.64 h at n=3; RTLLM n=5 option +0.12 h); scoring projection (156+50)x3x5
  = 3,090 TB runs of which (143+38)x3x5 = 2,715 formal -> 1.84 h measured-rate vs the
  4.5 h morning window (RTLLM n=5: 2.14 h). 7B generation numbers pending weights.

## 2026-10-18 20:35 — A16 §4/§5/§7: PREREG + reports + overnight runner
- PREREG.md: engine line (vLLM 0.21.0+2325b6f0.nvinternal.26.05.post1, container
  nvcr.io/nvidia/vllm@sha256:94e2155..., one DGX Spark arm64); overnight arm order +
  A16 cut ladder; VeriReason-on-vLLM sampling note (same seed rule); 3B lane settings
  incl. max_model_len=4096; SFT fp32->bf16 cast recorded on the dropped entry; new
  "Analysis code" (sha256 at commit) + "Analysis plan" sections; "Measured before G0"
  refreshed (scoring projection, 3B tok/s; 7B + overlap probe marked PENDING);
  Deviations: single-machine note. No Halo block.
- gen/run_overnight.sh: A16 order (7b-rl, 7b-sft, 3b-rl, 3b-base, 7b-base) with the
  VeriReason protocol rows for the 3B arms (T 0.2, top_p 0.95, max 2048, mml 4096);
  gen/README.md: rsync section replaced by the A16 no-transfer note.
- SPARK_REPORT.md: sections 9-11 added (Generation / Build day / Amendment A16 with
  what-was-redone), stale docker/apt open questions closed, STOP line + exact message
  list updated (Spark runs 3B retired). spark_report.json: keys generation/g1b/g2/
  results/contamination/blind40/amendments added.
- CORRECTION (20:55): the 20:05 "polluted" 3b-rl re-run had todo=0 — it REUSED the
  original 20480 rows, which is why its verdicts matched; that was not a determinism
  result. The clean 4096 re-generation differs: mean 709 (vs 812), verdicts 8 pass /
  6 fail / 2 compile_error (vs 8/3/5), strict 6 UNBOUNDED-EQ / 1 DIFFERENT / 1 UNKNOWN
  (vs 5/2/1). Lesson recorded: vLLM per-request seeds do NOT give bitwise determinism
  across max_model_len / kernel-shape changes (fp associativity); determinism holds
  only at fixed settings, which is what G0 pins. Operative numbers are the 4096 ones.
- 3b-rl final (A16 settings): throughput VE 167.0 / RTLLM 378.2 tok/s at 64
  concurrent (32x2, fresh files; wall includes model load). 3B projection refreshed:
  3B-RL ~0.63 h + 3B base ~0.64 h at n=3.

## 2026-10-18 21:30 — AMENDMENT A17 received (analysis-code + PREREG fixes pre-G0)
- G0 stays blocked. scorer/ + prompts + pins untouched. Copy at
  `koder/docs/brief-spark-addendum-A17.md`. Items 1-9 done this session; item 10
  instructions attached to the 7B shakedown; item 11: power analysis only as the MDE
  line, canaries rejected (limitation "blind labels: single rater, the study author"
  added instead), bias terms covered by the nested shares.
- Item 2 gates (rule applied to evidence, divergence checked): VE 145 UNBOUNDED-EQ
  refs − Prob099 (its own TB does not compile) = **144**; removed Prob001_zero,
  Prob002_m2014_q4i, Prob003_step_one, Prob046_dff8p, Prob078_dualedge (BMC-10-only).
  RTLLM usable-40 − alu, freq_divbyfrac, freq_divbyodd = **37**; headline 33.
  DIVERGENCE FOUND & RESOLVED: refs_summary.json lists a 4th BMC-only design,
  `clkgenerator`, but it was already outside the usable-40 (its reference FAILS its
  own Icarus testbench) — removal set is the expected 3. Gate lists committed with
  sha256 in PREREG; wide_bmc.txt (5+3) for the 149/40 companion sensitivity.
- Item 1/3/4 (stats.py rewritten, run_scoring.py class import updated): classes read
  the frozen verdict["class"] (UNBOUNDED-EQ / BMC-N-EQ-ONLY / DIFFERENT / UNKNOWN;
  equiv "error" stays from port/read failures; score.py mapping BMC-only→equiv
  "error" KEPT and now stated in PREREG); proved correct / correct-within-d /
  proved-wrong definitions; three nested shares with official-pass denominators in
  the point estimate AND the bootstrap draws; vacuous as a flag-class; dedup keyed
  (arm, bench, task, sample_idx); --rtllm-all38 renamed --rtllm-all37; --wide-gate
  added; official pass@1 computed on all tasks, strict metrics gate-filtered.
- Item 2 re-run smokes on the new gates (33-design headline):
    pilot GPT-4:  op 47, npc 14.89% CI[2.13,33.33] (7 different), ncwd=pw=14.89%
    pilot GPT-3.5: op 29, npc 13.79% CI[0,29.41] (4 different), ncwd=pw=13.79%
    (old 24.5%/26.5% included synchronizer's 5 error passes — now outside the gate;
     pilot failures are all DIFFERENT, so floor=companion=primary there)
    3b-rl: VE op 5 npc 20% (1 error) | RTLLM op 3 npc 33.3% (1 different)
    3b-base: VE op 2, RTLLM op 2 — npc 50%, ncwd 0%, pw 0% (1 bounded-only each:
     the primary/companion step made visible on real data)
  Nesting pw ≤ ncwd ≤ npc verified in every cell. H1 pilot (primary) +1.4pp
  "not resolved"; floor contrast +1.3pp "not resolved".
- Item 5: projection GATED 144/37 ((144+37)×3×5 = 2,715 formal — number unchanged,
  1.84 h); Tasks/analysis-plan/flag/MDE made consistent; MDE line replaced by the
  underpowering sentence; H1/H2 marked CodeV-family-only, VeriReason descriptive.
- Item 6: freeze check verified live — plain git diff rc=1 (__pycache__), the
  ':(exclude)scorer/__pycache__' form rc=0, SCORER_SHA256 all-OK; exact commands in
  PREREG Scorer section.
- Item 7: results/deep/{gpt_summary,refs_summary,mut/mut_summary,spec/
  spec_results}.json committed; PREREG citations repointed.
- Item 8: six deviations added (deep scorer, gate change, A17 definitions, Phase 4
  6/8 + watcher timestamp at G0, anchor synchronizer detail).
- Item 9: scorer section reworded (strict kill 438/438 true-by-construction, NOT
  cited as power; 75/438 = 17.1% official-TB false passes is the power result;
  independent checks = 290-row anchor + cross-simulator agreement); H0-a "at least
  10× smaller"; template provenance recorded (3B-RL ships chat_template.jinja;
  3B base/SFT/raw + 1.5B embed in tokenizer_config.json; 7Bs at verification).
- Item 10 (3B parts done now): 3b-base's 9/16 compile errors investigated — 7/9 are
  finish=stop with an UNCLOSED <think> and no ```verilog fence (the extractor's
  module-regex fallback then lifts draft module text out of the reasoning region);
  2/9 are genuine 2048-token cap hits mid-think. Nothing changed (operator decides
  at G2 if it ever matters there). Bounded-only share of shakedown passes:
  3b-base 2/4 = 50%; 3b-rl 0/8. Steady-state vs load split + "no cut only if
  ≤9 h steady-state" + release-of-generations note attached to the 7B shakedown
  instructions (PREREG "Measured before G0" updated accordingly; the untested
  "determinism holds at the pinned settings" sentence removed).

## 2026-10-19 00:05 — AMENDMENT A18 received (last fixes + conditional G0); applied
- Operator verified A17 independently (pilot shares GPT-4 7/47, GPT-3.5 4/29; gates
  match proof classes; PREREG sha256s match). A18 = items 1-7 now + §8 conditional
  G0 tonight (C1-C5 in order, then G0 steps, Phase 8, Phase 10, ots upgrade at
  T_stamp+6h). Copy at koder/docs/brief-spark-addendum-A18.md. Phase at receipt:
  6 of 9, 7B downloads outstanding, G0 NOT reached, zero evaluation samples -> clean.
- Dead background jobs from the crashed session cleaned: `grpo-trial` container
  (6 h idle, results already recorded) stopped+removed; old A16 watcher (pid 263525)
  killed — superseded by shakedown/overnight_chain.sh.

## 2026-10-18 23:52–00:05 — A18 item 6: the 7B download (root cause found; already complete)
- Two byte readings 5 min apart (~/runs/7b_bytes_readings.log), per repo (bytes,
  incomplete blobs): 7B-Instruct 2,835,735,867 / 23; Distill 5,097,785 / 7;
  RL 1,211,605,047 / 4 — FLAT between 23:56 and 00:01.
- Cause 1 (why nothing was moving): NO download process was alive — the earlier
  session's fetch jobs died with it (last blob write 22:16). Disk fine (3.4 T free).
- Cause 2 (why du looked stuck at ~2.7/15.2 GB all evening): hub 2.2.0's xet
  backend reconstructs blobs into a SHARED content-addressed store at
  ~/hf/hub/blobs/xx/… OUTSIDE each models--*/ tree; per-repo du therefore
  undercounts (the model dir holds only symlinks + orphaned .incomplete partials
  from the dead concurrent fetches A and B).
- Restarted models/fetch.sh 23:56 to be sure: hf download returned rc=0 instantly
  for all three 7Bs (snapshot symlinks all resolve). Then models/verify_weights.py:
  **all 8 weight sets verified (8 of 8) at 18 Oct 23:58** — every 7B shard sha256
  matches the Hub lfs.sha256 (results/h0/weights_sha256.tsv). No hf_transfer needed;
  no restart of actual transfers was needed. Orphaned *.incomplete partials deleted.
- Consequence: A18 §8 C2's evidence already exists; the chain re-verifies at C2.

## 2026-10-19 00:05–00:50 — A18 items 1-4 (stats.py) + tests
- Item 1: bootstrap_official() added; analyze() now emits ci95_all_tasks (task-
  clustered bootstrap of official pass@1 over ALL tasks, tm_all) beside the gated
  ci95. PREREG G1b section states: anchor tested against official_pass_at_1_all_tasks
  + ci95_all_tasks. Tested on a sets-differ case (RTLLM 33/50; gated 40% pass,
  non-gated 100%): all-task point 0.60 vs gated 0.40; interval centred on the
  all-task point (tests/test_a18_stats.py, 5 checks).
- Item 2: dedup keys str(sample_idx) both sides (map parse + row lookup); analyze
  reports dedup {map_keys, rows_in, rows_matched, rows_after, rows_collapsed};
  a map matching no row exits with an error. Tested: 60 identical-sample rows ->
  20 after (40 collapsed, all matched); int-row/str-key cross case; no-match error.
- Item 3: load_gates hard-errors on missing OR empty gate file (all four required);
  tested both cases + real gates (144/37/4/8).
- Item 4: a16_class keeps each pass in its PROOF class (vacuous DIFFERENT ->
  'different'); 'vacuous' returned only when the proof is fine (UNBOUNDED-EQ) and
  vacuity is the sole failure; metrics adds vacuous_passes (flag count) beside
  classes. Verified: class counts sum to official_pass_count - proved_correct_count;
  floor includes vacuous DIFFERENT; nesting holds. run_scoring rows inherit the new
  per-row class (same import).
- Pilot smoke re-run on the A18 code: GPT-4 op 47 npc 14.89% (7 different),
  GPT-3.5 op 29 npc 13.79% (4 different) — unchanged from A17; vacuous_passes 0
  (pilot rows assume nonvacuous); ci95_all_tasks now present and distinct from the
  gated interval. H1/H1-floor/H2 paired contrasts (h2_pass1_gap added) run on the
  pilot pair: all 'not resolved'.

## 2026-10-19 00:50–01:20 — A18 item 5: scoring/dedup.py + scoring/blind40.py (+ contamination)
- dedup.py: exact rule (comments+all-whitespace stripped sha256 of extracted code)
  + normalised rule (yosys read_verilog -sv; hierarchy -top; proc; opt_clean;
  rename -enumerate; write_rtlil; 'attribute \src' lines removed), union-find
  within arm x task, design keys namespaced by task (identical code across tasks
  never merges), keys 'arm|bench|task|sample_idx' (str). Verified the normalised
  rule joins a formatting-variant AND an explicit-wire-declaration variant of the
  same design (identical RTLIL hash) while a genuinely different design stays
  separate. yosys failures reported, never silent.
- blind40.py: population = unique official passes of class different/vacuous
  (dedup-keyed), apart designs excluded, SORTED by (arm, bench, task, sample_idx)
  BEFORE sampling; strata arm x bench; largest-remainder allocation; single
  random.Random(0) for stratum draws and ids; packets (spec/reference/extracted
  code/TB result/cex table) scrubbed against arm/model/family/index tokens;
  labels_template.csv; --unblind with Wilson 95% (overall + per family).
- tests/test_a18_dedup_blind40.py: synthetic (60->20; allocation/determinism/scrub/
  apart-exclusion/ordering) + END-TO-END on the pilot 290 rows (real gen.v code,
  real specs/references) and the 3B shakedown 32 rows: dedup 322/322 keys; packets
  blind + complete; unblind round-trip with Wilson intervals. ALL PASS.
- contamination.py written per PREREG rules (MinHash 5-gram/128-perm LSH@0.8 +
  exact Jaccard>=0.8 + whitespace-collapsed exact; statements-vs-specs primary,
  code-vs-references secondary; five datasets, eight files, three pinned sha256s
  verified byte-exact). Machinery run on the real data: 0 overlap rows over
  ~97k dataset rows; positive controls green (exact VE spec, exact RTLLM spec,
  code-vs-reference; one-word mutant correctly still flagged at J 0.95 per the
  pre-registered threshold). Re-runs inside Phase 10.

## 2026-10-19 01:20–01:45 — A18 §8 machinery (chain, C3/C4/C5 helpers, runners)
- shakedown_run.py: official_passes_from_length recorded (item 7); throughput runs
  now write load_s/gen_wall_s/steady_tok_per_s via gen_vllm.py --timing-out
  (measurement only, sampling unchanged); --skip-score mode for the 3B steady
  refresh. gen_vllm.py timing hook (load_s, gen_wall_s, tokens).
- shakedown/c3_check.py: per-arm hard checks (effective SamplingParams == §6.2;
  >=14/16 module+name; <=4/16 cap hits; no scorer crash; 16 samples), --force-fail
  for the dry run.
- shakedown/projection.py rewritten: steady-state tok/s + per-arm(-per-bench) load;
  ladder none -> ve-subset-60 -> n-3-to-2 -> drop-7b-base -> drop-3b-base until
  <= 9 h; cut written to results/shakedown/projection.json (+ gen/cut.txt by the
  chain). VE subset rule pinned pre-G0: gen/ve_subset60.txt =
  random.Random(0).sample(sorted(ve_ids), 60).
- gen/run_overnight.py (+ .sh wrapper): docker-driven per arm x bench with pinned
  flags; cut applied only from gen/cut.txt; throughput checks at 30 min (watcher
  thread) and at the first 3B arm; resumable; logs per run.
- scoring/phase10.py: freeze checks -> G2 -> contamination -> per-arm run_scoring
  in A16 order with G1b checked per CodeV arm (all-task point+interval) ->
  stats/sensitivities (all37, wide, dedup, drop-tasks, H1/H2 pairs) -> apart table
  -> blind40 packets+key sha -> summary.md + official_vs_strict.{csv,png}.
- shakedown/prereg_finalize.py (C5): fills date/7B numbers/overlap-probe skip/cut/
  verification time/7B template provenance/G0 sentence; fails on leftovers.
  Dry-run validated against the current PREREG (only measured inputs pending).
- shakedown/overnight_chain.sh: the whole §8 chain from C2 (C1 verified at entry)
  under tmux; hard checks logged to notes/LOG.md; every stop path writes
  SPARK_REPORT.md via shakedown/report_status.py and pushes; CHAIN_FORCE_FAIL=<C>
  for the dry run; ots upgrade scheduled at T_stamp+6h as a detached job.
- 2026-10-19 00:51 — [chain] A18 §8 chain start (pid 270642, force_fail=C2, C2 deadline 09:00)
- 2026-10-19 00:51 — [chain] C1: working tree not clean
- 2026-10-19 00:51 — [chain] STOP — C1 failed: code/PREREG/push consistency check failed (see log above)
- 2026-10-19 00:51 — [chain] A18 §8 chain start (pid 270854, force_fail=C2, C2 deadline 09:00)
- 2026-10-19 00:51 — [chain] C1 PASS: items 1-5+7 committed, pushed, PREREG sha256 final
- 2026-10-19 00:51 — [chain] STOP — C2 failed: forced failure (dry run)
- 2026-10-19 00:52 — [chain] A18 §8 chain start (pid 271081, force_fail=none, C2 deadline 09:00)
- 2026-10-19 00:52 — [chain] C1 PASS: items 1-5+7 committed, pushed, PREREG sha256 final
- 2026-10-19 00:52 — [chain] C2: waiting for 8/8 weight verification (cut-off 09:00)
- 2026-10-19 00:52 — [chain] C2 PASS: all 8 weight sets hash-verified (8 of 8) at 2026-10-19 00:52
- 2026-10-19 00:53 — [chain] pushed: A18 C2: 8/8 weights verified at 2026-10-19 00:52
- 2026-10-19 00:53 — [chain] C3: shakedown 7b-rl (Phase 6 step 1)
- 2026-10-19 00:55 — [chain-fix] run_overnight.py: container path mapping made explicit (REPO->/work, ~/runs/gen->/runs); the cut-subset prompt file lives under ~/runs/gen and the old /work-relative join produced the wrong in-container path. Unit-checked both mappings. run_overnight.py is machinery, not in the PREREG 'Analysis code' pin list.
- 2026-10-19 01:08 — [chain-fix] projection.py: hard guard added — no cut decision while any arm lacks shakedown numbers (C4 needs every arm); --allow-pending for tests only. ots CLI smoke-tested (stamp+verify OK on a scratch file).
{
 "arm": "7b-rl",
 "module_name_ok": 16,
 "cap_hits": 0,
 "crashes": 0,
 "effective_params": {
  "temperature": "1.0",
  "top_p": "1.0",
  "top_k": "-1",
  "min_p": "0.0",
  "repetition_penalty": "1.0",
  "max_tokens": "16384",
  "n": "1",
  "seed": "670498303"
 },
 "official_passes_from_length": 0,
 "verdicts": {
  "pass": 15,
  "fail": 1,
  "compile_error": 0,
  "timeout": 0
 },
 "strict": {
  "DIFFERENT": 3,
  "UNBOUNDED-EQ": 12,
  "BMC-10-EQ-ONLY": 0,
  "UNKNOWN": 0
 },
 "throughput": {
  "ve": {
   "wall_s": 823.5,
   "tokens": 172288,
   "tok_per_s": 209.2,
   "load_s": 145.6,
   "gen_wall_s": 665.4,
   "steady_tok_per_s": 258.9
  },
  "rtllm": {
   "wall_s": 1826.5,
   "tokens": 504706,
   "tok_per_s": 276.3,
   "load_s": 160.9,
   "gen_wall_s": 1641.1,
   "steady_tok_per_s": 307.5
  }
 }
}
C3 PASS 7b-rl
- 2026-10-19 02:15 — [chain] C3: 7b-rl PASS (params/§6.2, extraction, cap, no scorer crash; 
- 2026-10-19 02:15 — [chain] C3: shakedown 7b-sft (Phase 6 step 1)
{
 "arm": "7b-sft",
 "module_name_ok": 16,
 "cap_hits": 0,
 "crashes": 0,
 "effective_params": {
  "temperature": "0.6",
  "top_p": "1.0",
  "top_k": "-1",
  "min_p": "0.0",
  "repetition_penalty": "1.0",
  "max_tokens": "16384",
  "n": "1",
  "seed": "670498303"
 },
 "official_passes_from_length": 0,
 "verdicts": {
  "pass": 12,
  "fail": 2,
  "compile_error": 2,
  "timeout": 0
 },
 "strict": {
  "DIFFERENT": 2,
  "UNBOUNDED-EQ": 10,
  "BMC-10-EQ-ONLY": 0,
  "UNKNOWN": 0
 },
 "throughput": {
  "ve": {
   "wall_s": 508.7,
   "tokens": 55900,
   "tok_per_s": 109.9,
   "load_s": 161.6,
   "gen_wall_s": 326.4,
   "steady_tok_per_s": 171.3
  },
  "rtllm": {
   "wall_s": 1764.6,
   "tokens": 397244,
   "tok_per_s": 225.1,
   "load_s": 142.8,
   "gen_wall_s": 1600.0,
   "steady_tok_per_s": 248.3
  }
 }
}
C3 PASS 7b-sft
- 2026-10-19 03:19 — [chain] C3: 7b-sft PASS (params/§6.2, extraction, cap, no scorer crash; 
- 2026-10-19 03:19 — [chain] C3: shakedown 7b-base (Phase 6 step 1)
{
 "arm": "7b-base",
 "module_name_ok": 16,
 "cap_hits": 0,
 "crashes": 0,
 "effective_params": {
  "temperature": "1.0",
  "top_p": "1.0",
  "top_k": "-1",
  "min_p": "0.0",
  "repetition_penalty": "1.0",
  "max_tokens": "16384",
  "n": "1",
  "seed": "670498303"
 },
 "official_passes_from_length": 0,
 "verdicts": {
  "pass": 5,
  "fail": 5,
  "compile_error": 6,
  "timeout": 0
 },
 "strict": {
  "DIFFERENT": 1,
  "UNBOUNDED-EQ": 4,
  "BMC-10-EQ-ONLY": 0,
  "UNKNOWN": 0
 },
 "throughput": {
  "ve": {
   "wall_s": 206.1,
   "tokens": 11455,
   "tok_per_s": 55.6,
   "load_s": 146.5,
   "gen_wall_s": 37.4,
   "steady_tok_per_s": 306.3
  },
  "rtllm": {
   "wall_s": 487.3,
   "tokens": 34536,
   "tok_per_s": 70.9,
   "load_s": 153.6,
   "gen_wall_s": 309.7,
   "steady_tok_per_s": 111.5
  }
 }
}
C3 PASS 7b-base
- 2026-10-19 03:38 — [chain] C3: 7b-base PASS (params/§6.2, extraction, cap, no scorer crash; 
- 2026-10-19 03:38 — [chain] C3 (C4 prep): throughput-only refresh 3b-rl
- 2026-10-19 03:43 — [chain] C3 (C4 prep): throughput-only refresh 3b-base
- 2026-10-19 03:49 — [chain] PUSH FAILED (A18 C3: 7B shakedowns done + checked (params, extraction, cap, scorer); 3B steady refresh); retry in 60s
- 2026-10-19 03:50 — [chain] STOP — PUSH failed: git push failed twice: A18 C3: 7B shakedowns done + checked (params, extraction, cap, scorer); 3B steady refresh
- 2026-10-19 10:35 — [chain] PUSH-failure stop diagnosed: transient network at 03:49-03:50 (the stop path worked as designed; commits 795fa8a+1680b0f pushed manually at resume). Chain made resumable: C3 arms with a green report are skipped (idempotent), the 3B steady refresh skips when the split exists, push retries 5x120s before stopping. All three 7B C3 checks re-verified green at resume: 7b-rl 16/16 name, 0 cap, 15 pass (12 UNB-EQ/3 DIFF); 7b-sft 16/16, 0 cap, 12 pass (10/2, 2 compile_error); 7b-base 16/16, 0 cap, 5 pass (4/1, 6 compile_error); official_passes_from_length = 0 on all three arms (A18 item 7). Relaunching.
- 2026-10-19 10:35 — [chain] A18 §8 chain start (pid 292000, force_fail=none, C2 deadline 09:00)
- 2026-10-19 10:36 — [chain] C1 PASS: items 1-5+7 committed, pushed, PREREG sha256 final
- 2026-10-19 10:36 — [chain] C2: waiting for 8/8 weight verification (cut-off 09:00)
- 2026-10-19 10:37 — [chain] C2 PASS: all 8 weight sets hash-verified (8 of 8) at 2026-10-19 10:37
- 2026-10-19 10:37 — [chain] pushed: A18 C2: 8/8 weights verified at 2026-10-19 10:37
- 2026-10-19 10:37 — [chain] C3: 7b-rl already green (report present, checks pass) — resume skip
- 2026-10-19 10:37 — [chain] C3: 7b-sft already green (report present, checks pass) — resume skip
- 2026-10-19 10:37 — [chain] C3: 7b-base already green (report present, checks pass) — resume skip
- 2026-10-19 10:37 — [chain] C3 (C4 prep): 3b-rl steady split already present — resume skip
- 2026-10-19 10:37 — [chain] C3 (C4 prep): 3b-base steady split already present — resume skip
- 2026-10-19 10:37 — [chain] pushed: A18 C3: 7B shakedowns done + checked (params, extraction, cap, scorer); 3B steady refresh
- 2026-10-19 10:37 — [chain] C3: shakedown generations deleted from ~/runs/shakedown (reports kept in repo)
--- steady-state projection [none] ---
  7b-rl     mean_tok= 5486 -> 3.58 h
  7b-sft    mean_tok= 2939 -> 2.81 h
  3b-rl     mean_tok=  709 -> 0.33 h
  3b-base   mean_tok=  793 -> 0.35 h
  7b-base   mean_tok=  388 -> 0.39 h
  TOTAL 7.46 h of 9.0 h window -> FITS

CUT APPLIED: none (RTLLM n=5: no (A18 §8 C4 fixed choice); overlap probe: skipped — score nothing until generation ends)
--- scoring projection [n=3, after cut 'none'] ---
  official TB runs: 3090 (2715 also formal) across 5 arms
  measured-rate: 1.84 h | pessimistic: 0.26 h | window 4.5 h
--- scoring projection [RTLLM n=5, after cut 'none'] ---
  official TB runs: 3590 (3085 also formal) across 5 arms
  measured-rate: 2.14 h | pessimistic: 0.29 h | window 4.5 h
wrote /home/unnitools/rtl-strict-eval/results/shakedown/projection.json
- 2026-10-19 10:37 — [chain] C4 PASS: cut applied = none (RTLLM n=5: no; overlap probe skipped)
- 2026-10-19 10:37 — [chain] pushed: A18 C4: steady-state projection done; cut applied = none
PREREG FINALIZE FAILED:
  - cut-record anchor not found
- 2026-10-19 10:37 — [chain] STOP — C5 failed: placeholders unresolved (see notes/LOG.md)
- 2026-10-19 10:40 — [chain] A18 §8 chain start (pid 292488, force_fail=none, C2 deadline 09:00)
- 2026-10-19 10:40 — [chain] C1 PASS: items 1-5+7 committed, pushed, PREREG sha256 final
- 2026-10-19 10:40 — [chain] C2: waiting for 8/8 weight verification (cut-off 09:00)
- 2026-10-19 10:41 — [chain] C2 PASS: all 8 weight sets hash-verified (8 of 8) at 2026-10-19 10:41
- 2026-10-19 10:41 — [chain] pushed: A18 C2: 8/8 weights verified at 2026-10-19 10:41
- 2026-10-19 10:41 — [chain] C3: 7b-rl already green (report present, checks pass) — resume skip
- 2026-10-19 10:41 — [chain] C3: 7b-sft already green (report present, checks pass) — resume skip
- 2026-10-19 10:41 — [chain] C3: 7b-base already green (report present, checks pass) — resume skip
- 2026-10-19 10:41 — [chain] C3 (C4 prep): 3b-rl steady split already present — resume skip
- 2026-10-19 10:41 — [chain] C3 (C4 prep): 3b-base steady split already present — resume skip
- 2026-10-19 10:41 — [chain] pushed: A18 C3: 7B shakedowns done + checked (params, extraction, cap, scorer); 3B steady refresh
- 2026-10-19 10:41 — [chain] C3: shakedown generations deleted from ~/runs/shakedown (reports kept in repo)
--- steady-state projection [none] ---
  7b-rl     mean_tok= 5486 -> 3.58 h
  7b-sft    mean_tok= 2939 -> 2.81 h
  3b-rl     mean_tok=  709 -> 0.33 h
  3b-base   mean_tok=  793 -> 0.35 h
  7b-base   mean_tok=  388 -> 0.39 h
  TOTAL 7.46 h of 9.0 h window -> FITS

CUT APPLIED: none (RTLLM n=5: no (A18 §8 C4 fixed choice); overlap probe: skipped — score nothing until generation ends)
--- scoring projection [n=3, after cut 'none'] ---
  official TB runs: 3090 (2715 also formal) across 5 arms
  measured-rate: 1.84 h | pessimistic: 0.26 h | window 4.5 h
--- scoring projection [RTLLM n=5, after cut 'none'] ---
  official TB runs: 3590 (3085 also formal) across 5 arms
  measured-rate: 2.14 h | pessimistic: 0.29 h | window 4.5 h
wrote /home/unnitools/rtl-strict-eval/results/shakedown/projection.json
- 2026-10-19 10:41 — [chain] C4 PASS: cut applied = none (RTLLM n=5: no; overlap probe skipped)
- 2026-10-19 10:41 — [chain] pushed: A18 C4: steady-state projection done; cut applied = none
PREREG finalized (2026-10-19 10:41)
- 2026-10-19 10:41 — [chain] pushed: A18 C5: PREREG finalized (7B numbers, cut none, verification time, G0 sentence)
- 2026-10-19 10:41 — [chain] G0 step 1 PASS: tag g0-prereg = f8f23aaa87b53a9eb9357fa9ffe962430d26642c pushed and visible via ls-remote
- 2026-10-19 10:41 — [chain] G0 step 2 PASS: PREREG.md.ots stamped (10:41)
- 2026-10-19 10:41 — [chain] pushed: A18 G0 steps: tag g0-prereg pushed (ls-remote verified) + PREREG.md.ots stamped
- 2026-10-19 10:41 — [chain] ots upgrade scheduled for 16:41 (background, pid 293226)
- 2026-10-19 10:41 — [chain] phase 8: overnight generation starts (cut=none, order 7b-rl 7b-sft 3b-rl 3b-base 7b-base)
- 2026-10-19 10:41 — phase8 start: arms=['7b-rl', '7b-sft', '3b-rl', '3b-base', '7b-base'] n=3 cut=none (RTLLM n=5: no — A18 §8 C4; overlap probe skipped — score nothing until generation ends)
- 2026-10-19 10:41 — phase8: generating 7b-rl/ve (T=1.0, top_p=1.0, n=3, max_tokens=16384, mml=20480, cut=none)
- 2026-10-19 10:41 — phase8: 7b-rl/ve rc=2 wall=0.0 min log=/home/unnitools/runs/gen/log_7b-rl_ve.txt
- 2026-10-19 10:41 — phase8: 7b-rl/ve FAILED rc=2 — stopping the arm ladder
- 2026-10-19 10:41 — [chain] STOP — PHASE8 failed: generation runner rc!=0 (see notes/LOG.md and ~/runs/gen/log_*)
- 2026-10-19 10:45 — [chain] PHASE8 stop diagnosed: quoting bug in gen_arm_bench (doubled quote before the log redirect -> bash EOF error, no generation attempted, nothing generated). Fixed. Also made the chain fully resumable: prereg_finalize idempotent (already-filled placeholders skipped, incl. the header date), ots stamp skipped when PREREG.md.ots exists and verifies, ots upgrade launched as a detached setsid job (the first scheduled job died with its tmux session; marker removed and rescheduled from the original stamp time). G0 steps from the first run stand: tag g0-prereg pushed + PREREG.md.ots stamped 10:41.
- 2026-10-19 10:45 — [chain] A18 §8 chain start (pid 293558, force_fail=none, C2 deadline 09:00)
- 2026-10-19 10:45 — [chain] C1 PASS: items 1-5+7 committed, pushed, PREREG sha256 final
- 2026-10-19 10:45 — [chain] C2: waiting for 8/8 weight verification (cut-off 09:00)
- 2026-10-19 10:46 — [chain] C2 PASS: all 8 weight sets hash-verified (8 of 8) at 2026-10-19 10:46
- 2026-10-19 10:46 — [chain] pushed: A18 C2: 8/8 weights verified at 2026-10-19 10:46
- 2026-10-19 10:46 — [chain] C3: 7b-rl already green (report present, checks pass) — resume skip
- 2026-10-19 10:46 — [chain] C3: 7b-sft already green (report present, checks pass) — resume skip
- 2026-10-19 10:46 — [chain] C3: 7b-base already green (report present, checks pass) — resume skip
- 2026-10-19 10:46 — [chain] C3 (C4 prep): 3b-rl steady split already present — resume skip
- 2026-10-19 10:46 — [chain] C3 (C4 prep): 3b-base steady split already present — resume skip
- 2026-10-19 10:46 — [chain] pushed: A18 C3: 7B shakedowns done + checked (params, extraction, cap, scorer); 3B steady refresh
- 2026-10-19 10:46 — [chain] C3: shakedown generations deleted from ~/runs/shakedown (reports kept in repo)
--- steady-state projection [none] ---
  7b-rl     mean_tok= 5486 -> 3.58 h
  7b-sft    mean_tok= 2939 -> 2.81 h
  3b-rl     mean_tok=  709 -> 0.33 h
  3b-base   mean_tok=  793 -> 0.35 h
  7b-base   mean_tok=  388 -> 0.39 h
  TOTAL 7.46 h of 9.0 h window -> FITS

CUT APPLIED: none (RTLLM n=5: no (A18 §8 C4 fixed choice); overlap probe: skipped — score nothing until generation ends)
--- scoring projection [n=3, after cut 'none'] ---
  official TB runs: 3090 (2715 also formal) across 5 arms
  measured-rate: 1.84 h | pessimistic: 0.26 h | window 4.5 h
--- scoring projection [RTLLM n=5, after cut 'none'] ---
  official TB runs: 3590 (3085 also formal) across 5 arms
  measured-rate: 2.14 h | pessimistic: 0.29 h | window 4.5 h
wrote /home/unnitools/rtl-strict-eval/results/shakedown/projection.json
- 2026-10-19 10:46 — [chain] C4 PASS: cut applied = none (RTLLM n=5: no; overlap probe skipped)
- 2026-10-19 10:46 — [chain] pushed: A18 C4: steady-state projection done; cut applied = none
PREREG finalized (2026-10-19 10:46)
- 2026-10-19 10:46 — [chain] pushed: A18 C5: PREREG finalized (7B numbers, cut none, verification time, G0 sentence)
- 2026-10-19 10:46 — [chain] tag g0-prereg already exists (reusing)
- 2026-10-19 10:46 — [chain] G0 step 1 PASS: tag g0-prereg = f8f23aaa87b53a9eb9357fa9ffe962430d26642c pushed and visible via ls-remote
- 2026-10-19 10:46 — [chain] STOP — OTS failed: ots stamp PREREG.md failed
- 2026-10-19 10:51 — [chain] OTS stop diagnosed: the 10:46 resume re-ran finalize and DUPLICATED the cut-record line (insertion lacked an idempotency guard), so PREREG.md changed after the 10:41 stamp ('File does not match original'). Resolution: PREREG.md restored byte-identical to tag g0-prereg (= the stamped digest eec18735...); the .ots is valid for it (two calendars already show Bitcoin txs: cf3d8a9c…, 99ff0841…). Cut-record insertion now idempotent; ots re-stamp skip now keys on the ots-info digest match (ots verify rc=1 is normal while confirmations are pending). No pre-registration content was altered — the restored file is exactly the operator-approved conditional-G0 text.
- 2026-10-19 10:51 — [chain] A18 §8 chain start (pid 294274, force_fail=none, C2 deadline 09:00)
- 2026-10-19 10:51 — [chain] C1 PASS: items 1-5+7 committed, pushed, PREREG sha256 final
- 2026-10-19 10:51 — [chain] C2: waiting for 8/8 weight verification (cut-off 09:00)
- 2026-10-19 10:51 — [chain] C2 PASS: all 8 weight sets hash-verified (8 of 8) at 2026-10-19 10:51
- 2026-10-19 10:51 — [chain] pushed: A18 C2: 8/8 weights verified at 2026-10-19 10:51
- 2026-10-19 10:51 — [chain] C3: 7b-rl already green (report present, checks pass) — resume skip
- 2026-10-19 10:51 — [chain] C3: 7b-sft already green (report present, checks pass) — resume skip
- 2026-10-19 10:51 — [chain] C3: 7b-base already green (report present, checks pass) — resume skip
- 2026-10-19 10:51 — [chain] C3 (C4 prep): 3b-rl steady split already present — resume skip
- 2026-10-19 10:51 — [chain] C3 (C4 prep): 3b-base steady split already present — resume skip
- 2026-10-19 10:51 — [chain] pushed: A18 C3: 7B shakedowns done + checked (params, extraction, cap, scorer); 3B steady refresh
- 2026-10-19 10:51 — [chain] C3: shakedown generations deleted from ~/runs/shakedown (reports kept in repo)
--- steady-state projection [none] ---
  7b-rl     mean_tok= 5486 -> 3.58 h
  7b-sft    mean_tok= 2939 -> 2.81 h
  3b-rl     mean_tok=  709 -> 0.33 h
  3b-base   mean_tok=  793 -> 0.35 h
  7b-base   mean_tok=  388 -> 0.39 h
  TOTAL 7.46 h of 9.0 h window -> FITS

CUT APPLIED: none (RTLLM n=5: no (A18 §8 C4 fixed choice); overlap probe: skipped — score nothing until generation ends)
--- scoring projection [n=3, after cut 'none'] ---
  official TB runs: 3090 (2715 also formal) across 5 arms
  measured-rate: 1.84 h | pessimistic: 0.26 h | window 4.5 h
--- scoring projection [RTLLM n=5, after cut 'none'] ---
  official TB runs: 3590 (3085 also formal) across 5 arms
  measured-rate: 2.14 h | pessimistic: 0.29 h | window 4.5 h
wrote /home/unnitools/rtl-strict-eval/results/shakedown/projection.json
- 2026-10-19 10:51 — [chain] C4 PASS: cut applied = none (RTLLM n=5: no; overlap probe skipped)
- 2026-10-19 10:51 — [chain] pushed: A18 C4: steady-state projection done; cut applied = none
PREREG finalized (2026-10-19 10:51)
- 2026-10-19 10:51 — [chain] pushed: A18 C5: PREREG finalized (7B numbers, cut none, verification time, G0 sentence)
- 2026-10-19 10:51 — [chain] tag g0-prereg already exists (reusing)
- 2026-10-19 10:51 — [chain] G0 step 1 PASS: tag g0-prereg = f8f23aaa87b53a9eb9357fa9ffe962430d26642c pushed and visible via ls-remote
- 2026-10-19 10:51 — [chain] G0 step 2: PREREG.md.ots already stamps THIS content (digest match) — skipping re-stamp (resume)
- 2026-10-19 10:51 — [chain] G0 step 2 PASS: PREREG.md.ots stamped (10:51)
- 2026-10-19 10:52 — [chain] pushed: A18 G0 steps: tag g0-prereg pushed (ls-remote verified) + PREREG.md.ots stamped
- 2026-10-19 10:52 — [chain] ots upgrade scheduled for 16:41 (detached job)
- 2026-10-19 10:52 — [chain] phase 8: overnight generation starts (cut=none, order 7b-rl 7b-sft 3b-rl 3b-base 7b-base)
- 2026-10-19 10:52 — phase8 start: arms=['7b-rl', '7b-sft', '3b-rl', '3b-base', '7b-base'] n=3 cut=none (RTLLM n=5: no — A18 §8 C4; overlap probe skipped — score nothing until generation ends)
- 2026-10-19 10:52 — phase8: generating 7b-rl/ve (T=1.0, top_p=1.0, n=3, max_tokens=16384, mml=20480, cut=none)
- 2026-10-19 14:55 — phase8: 7b-rl/ve rc=0 wall=243.5 min log=/home/unnitools/runs/gen/log_7b-rl_ve.txt
- 2026-10-19 14:55 — phase8: generating 7b-rl/rtllm (T=1.0, top_p=0.95, n=3, max_tokens=16384, mml=20480, cut=none)
- 2026-10-19 15:05 — [monitor] deviation note: 7b-rl/ve actual 243.5 min vs 3.58 h arm projection (ve leg 2.79 h). Cause: real mean completion 6,537 tok/sample vs shakedown 5,486 (+19%) and realized steady rate 212 tok/s vs 258.9 (-18%); compounding = 1.46x. Revised generation-end estimate ~20:30-21:30 (total ~10 h, above the 9 h window the C4 ladder targeted). No action: cut=none is the pre-registered C5 decision and mid-run cuts are not permitted; other arms projected shorter (7b-sft 2.81 h; 3b arms + 7b-base ~0.35 h each), so the overshoot is dominated by the first arm. Recorded for the run report.
- 2026-10-19 15:49 — phase8: 7b-rl/rtllm rc=0 wall=53.8 min log=/home/unnitools/runs/gen/log_7b-rl_rtllm.txt
- 2026-10-19 15:49 — phase8: generating 7b-sft/ve (T=0.6, top_p=1.0, n=3, max_tokens=16384, mml=20480, cut=none)
- 2026-10-19 16:42 — [chain] ots upgrade committed and pushed
- 2026-10-19 16:58 — phase8: 7b-sft/ve rc=0 wall=68.7 min log=/home/unnitools/runs/gen/log_7b-sft_ve.txt
- 2026-10-19 16:58 — phase8: generating 7b-sft/rtllm (T=0.6, top_p=0.95, n=3, max_tokens=16384, mml=20480, cut=none)
- 2026-10-19 17:40 — phase8: 7b-sft/rtllm rc=0 wall=42.7 min log=/home/unnitools/runs/gen/log_7b-sft_rtllm.txt
- 2026-10-19 17:40 — phase8: generating 3b-rl/ve (T=0.2, top_p=0.95, n=3, max_tokens=2048, mml=4096, cut=none)
- 2026-10-19 17:45 — phase8: 3b-rl/ve rc=0 wall=4.6 min log=/home/unnitools/runs/gen/log_3b-rl_ve.txt
- 2026-10-19 17:45 — phase8: generating 3b-rl/rtllm (T=0.2, top_p=0.95, n=3, max_tokens=2048, mml=4096, cut=none)
- 2026-10-19 17:48 — phase8: 3b-rl/rtllm rc=0 wall=3.3 min log=/home/unnitools/runs/gen/log_3b-rl_rtllm.txt
- 2026-10-19 17:48 — phase8: generating 3b-base/ve (T=0.2, top_p=0.95, n=3, max_tokens=2048, mml=4096, cut=none)
- 2026-10-19 17:52 — phase8: 3b-base/ve rc=0 wall=3.8 min log=/home/unnitools/runs/gen/log_3b-base_ve.txt
- 2026-10-19 17:52 — phase8: generating 3b-base/rtllm (T=0.2, top_p=0.95, n=3, max_tokens=2048, mml=4096, cut=none)
- 2026-10-19 17:55 — phase8: 3b-base/rtllm rc=0 wall=2.8 min log=/home/unnitools/runs/gen/log_3b-base_rtllm.txt
- 2026-10-19 17:55 — phase8: generating 7b-base/ve (T=1.0, top_p=1.0, n=3, max_tokens=16384, mml=20480, cut=none)
- 2026-10-19 18:02 — phase8: 7b-base/ve rc=0 wall=7.6 min log=/home/unnitools/runs/gen/log_7b-base_ve.txt
- 2026-10-19 18:02 — phase8: generating 7b-base/rtllm (T=1.0, top_p=0.95, n=3, max_tokens=16384, mml=20480, cut=none)
- 2026-10-19 18:09 — phase8: 7b-base/rtllm rc=0 wall=6.2 min log=/home/unnitools/runs/gen/log_7b-base_rtllm.txt
- 2026-10-19 18:09 — phase8: all generation done
{"arm": "3b-base", "rows_total": 618, "truncated_total": 21, "extraction_rate": 0.966, "module_name_ok_rate": 0.9563}
{"arm": "3b-rl", "rows_total": 618, "truncated_total": 24, "extraction_rate": 0.9628, "module_name_ok_rate": 0.9466}
{"arm": "7b-base", "rows_total": 618, "truncated_total": 0, "extraction_rate": 0.9984, "module_name_ok_rate": 0.966}
{"arm": "7b-rl", "rows_total": 618, "truncated_total": 1, "extraction_rate": 1.0, "module_name_ok_rate": 0.9903}
{"arm": "7b-sft", "rows_total": 618, "truncated_total": 7, "extraction_rate": 0.9935, "module_name_ok_rate": 0.9838}
Traceback (most recent call last):
  File "/home/unnitools/rtl-strict-eval/gen/make_manifest.py", line 57, in <module>
    main()
  File "/home/unnitools/rtl-strict-eval/gen/make_manifest.py", line 34, in main
    code = extract_verilog_code(r["completion"])
                                ~^^^^^^^^^^^^^^
KeyError: 'completion'
- 2026-10-19 18:09 — [chain] STOP — PHASE8 failed: make_manifest failed
- 2026-10-19 18:35 — [chain-fix] make_manifest crashed after writing all 5 manifests (rc=1 via KeyError 'completion'): its arm glob matched throughput_checks.jsonl as a phantom "throughput" arm. Fixed: arm set derived from *_ve.jsonl only. Also added a Phase 8 resume skip to gen/run_overnight.py (skip (arm,bench) when every (task_id,sample_idx) cell is already written) so the relaunch cannot overwrite the real timing.json records, and guarded the first-3B-arm throughput check against duplicate entries on resume. All 5 arms verified complete (618 rows each); relaunching the chain to continue at make_manifest -> releases -> Phase 10.
- 2026-10-19 18:15 — [chain] A18 §8 chain start (pid 308458, force_fail=none, C2 deadline 09:00)
- 2026-10-19 18:15 — [chain] C1 PASS: items 1-5+7 committed, pushed, PREREG sha256 final
- 2026-10-19 18:15 — [chain] C2: waiting for 8/8 weight verification (cut-off 09:00)
- 2026-10-19 18:17 — [chain] C2 PASS: all 8 weight sets hash-verified (8 of 8) at 2026-10-19 18:17
- 2026-10-19 18:17 — [chain] pushed: A18 C2: 8/8 weights verified at 2026-10-19 18:17
- 2026-10-19 18:17 — [chain] C3: 7b-rl already green (report present, checks pass) — resume skip
- 2026-10-19 18:17 — [chain] C3: 7b-sft already green (report present, checks pass) — resume skip
- 2026-10-19 18:17 — [chain] C3: 7b-base already green (report present, checks pass) — resume skip
- 2026-10-19 18:17 — [chain] C3 (C4 prep): 3b-rl steady split already present — resume skip
- 2026-10-19 18:17 — [chain] C3 (C4 prep): 3b-base steady split already present — resume skip
- 2026-10-19 18:17 — [chain] pushed: A18 C3: 7B shakedowns done + checked (params, extraction, cap, scorer); 3B steady refresh
- 2026-10-19 18:17 — [chain] C3: shakedown generations deleted from ~/runs/shakedown (reports kept in repo)
--- steady-state projection [none] ---
  7b-rl     mean_tok= 5486 -> 3.58 h
  7b-sft    mean_tok= 2939 -> 2.81 h
  3b-rl     mean_tok=  709 -> 0.33 h
  3b-base   mean_tok=  793 -> 0.35 h
  7b-base   mean_tok=  388 -> 0.39 h
  TOTAL 7.46 h of 9.0 h window -> FITS

CUT APPLIED: none (RTLLM n=5: no (A18 §8 C4 fixed choice); overlap probe: skipped — score nothing until generation ends)
--- scoring projection [n=3, after cut 'none'] ---
  official TB runs: 3090 (2715 also formal) across 5 arms
  measured-rate: 1.84 h | pessimistic: 0.26 h | window 4.5 h
--- scoring projection [RTLLM n=5, after cut 'none'] ---
  official TB runs: 3590 (3085 also formal) across 5 arms
  measured-rate: 2.14 h | pessimistic: 0.29 h | window 4.5 h
wrote /home/unnitools/rtl-strict-eval/results/shakedown/projection.json
- 2026-10-19 18:17 — [chain] C4 PASS: cut applied = none (RTLLM n=5: no; overlap probe skipped)
- 2026-10-19 18:17 — [chain] pushed: A18 C4: steady-state projection done; cut applied = none
PREREG finalized (2026-10-19 18:17)
- 2026-10-19 18:17 — [chain] pushed: A18 C5: PREREG finalized (7B numbers, cut none, verification time, G0 sentence)
- 2026-10-19 18:17 — [chain] tag g0-prereg already exists (reusing)
- 2026-10-19 18:17 — [chain] G0 step 1 PASS: tag g0-prereg = f8f23aaa87b53a9eb9357fa9ffe962430d26642c pushed and visible via ls-remote
- 2026-10-19 18:17 — [chain] G0 step 2: PREREG.md.ots already stamps THIS content (digest match) — skipping re-stamp (resume)
- 2026-10-19 18:17 — [chain] G0 step 2 PASS: PREREG.md.ots stamped (18:17)
- 2026-10-19 18:17 — [chain] pushed: A18 G0 steps: tag g0-prereg pushed (ls-remote verified) + PREREG.md.ots stamped
- 2026-10-19 18:17 — [chain] ots upgrade already scheduled (marker present) — not duplicating
- 2026-10-19 18:17 — [chain] phase 8: overnight generation starts (cut=none, order 7b-rl 7b-sft 3b-rl 3b-base 7b-base)
- 2026-10-19 18:17 — phase8 start: arms=['7b-rl', '7b-sft', '3b-rl', '3b-base', '7b-base'] n=3 cut=none (RTLLM n=5: no — A18 §8 C4; overlap probe skipped — score nothing until generation ends)
- 2026-10-19 18:17 — phase8: 7b-rl/ve output complete — resume skip (timing/log/params untouched)
- 2026-10-19 18:17 — phase8: 7b-rl/rtllm output complete — resume skip (timing/log/params untouched)
- 2026-10-19 18:17 — phase8: 7b-sft/ve output complete — resume skip (timing/log/params untouched)
- 2026-10-19 18:17 — phase8: 7b-sft/rtllm output complete — resume skip (timing/log/params untouched)
- 2026-10-19 18:17 — phase8: 3b-rl/ve output complete — resume skip (timing/log/params untouched)
- 2026-10-19 18:17 — phase8: 3b-rl/rtllm output complete — resume skip (timing/log/params untouched)
- 2026-10-19 18:17 — phase8: 3b-base/ve output complete — resume skip (timing/log/params untouched)
- 2026-10-19 18:17 — phase8: 3b-base/rtllm output complete — resume skip (timing/log/params untouched)
- 2026-10-19 18:17 — phase8: 7b-base/ve output complete — resume skip (timing/log/params untouched)
- 2026-10-19 18:17 — phase8: 7b-base/rtllm output complete — resume skip (timing/log/params untouched)
- 2026-10-19 18:17 — phase8: all generation done
{"arm": "3b-base", "rows_total": 618, "truncated_total": 21, "extraction_rate": 0.966, "module_name_ok_rate": 0.9563}
{"arm": "3b-rl", "rows_total": 618, "truncated_total": 24, "extraction_rate": 0.9628, "module_name_ok_rate": 0.9466}
{"arm": "7b-base", "rows_total": 618, "truncated_total": 0, "extraction_rate": 0.9984, "module_name_ok_rate": 0.966}
{"arm": "7b-rl", "rows_total": 618, "truncated_total": 1, "extraction_rate": 1.0, "module_name_ok_rate": 0.9903}
{"arm": "7b-sft", "rows_total": 618, "truncated_total": 7, "extraction_rate": 0.9935, "module_name_ok_rate": 0.9838}
- 2026-10-19 18:17 — [chain] pushed: A18 phase 8: generation done; manifests + release archives + throughput checks committed
- 2026-10-19 18:17 — [chain] phase 10: scoring + analysis (freeze checks, G2, G1b, strict, dedup, contamination, stats, blind40)
- 2026-10-19 18:17 — phase10: start (freeze checks first)
- 2026-10-19 18:17 — phase10: git -C /home/unnitools/rtl-strict-eval diff --quiet scorer-v1 ...
- 2026-10-19 18:17 — phase10: sha256sum -c results/pilot_repro/SCORER_SHA256
- 2026-10-19 18:17 — phase10 freeze check: diff rc=1 sha256 rc=0 FAILED
- 2026-10-19 18:17 — scorer/pilot_llm_outputs.py: OK
scorer/rtllm_audit.py: OK
scorer/score.py: OK
deep/analyze.py: OK
deep/common.py: OK
deep/fault_grade.py: OK
deep/run_deep.py: OK
deep/spec_oracle.py: OK
deep/ve_gate.py: OK
scorer/depth.yaml: OK

- 2026-10-19 18:17 — [chain] STOP — PHASE10 failed: phase10.py rc=0 (its STOP line names the failing gate)
- 2026-10-19 18:22 — phase10: git -C /home/unnitools/rtl-strict-eval diff --quiet scorer-v1 ...
- 2026-10-19 18:22 — phase10: sha256sum -c results/pilot_repro/SCORER_SHA256
- 2026-10-19 18:22 — phase10 freeze check: diff rc=0 sha256 rc=0 a18-test pins ok=True
- 2026-10-19 18:23 — [chain-fix] phase10 freeze check failed on first real run: A18's own pre-G0 test additions (tests/test_a18_stats.py, tests/test_a18_dedup_blind40.py, committed in c83f842) postdate tag scorer-v1. Fixed in scoring/phase10.py (not sha-pinned in PREREG — only the seven analysis scripts are): the two files are excluded from the scorer-v1 diff AND pinned by sha256 to their c83f842 content, so the exclusion cannot smuggle changes. scorer/ itself remains byte-identical to scorer-v1 (SCORER_SHA256 all OK). Verified: freeze check now rc=0 + pins ok. Relaunching the chain.
- 2026-10-19 18:22 — [chain] A18 §8 chain start (pid 309299, force_fail=none, C2 deadline 09:00)
- 2026-10-19 18:22 — [chain] C1 PASS: items 1-5+7 committed, pushed, PREREG sha256 final
- 2026-10-19 18:22 — [chain] C2: waiting for 8/8 weight verification (cut-off 09:00)
- 2026-10-19 18:23 — [chain] C2 PASS: all 8 weight sets hash-verified (8 of 8) at 2026-10-19 18:23
- 2026-10-19 18:23 — [chain] pushed: A18 C2: 8/8 weights verified at 2026-10-19 18:23
- 2026-10-19 18:23 — [chain] C3: 7b-rl already green (report present, checks pass) — resume skip
- 2026-10-19 18:23 — [chain] C3: 7b-sft already green (report present, checks pass) — resume skip
- 2026-10-19 18:23 — [chain] C3: 7b-base already green (report present, checks pass) — resume skip
- 2026-10-19 18:23 — [chain] C3 (C4 prep): 3b-rl steady split already present — resume skip
- 2026-10-19 18:23 — [chain] C3 (C4 prep): 3b-base steady split already present — resume skip
- 2026-10-19 18:23 — [chain] pushed: A18 C3: 7B shakedowns done + checked (params, extraction, cap, scorer); 3B steady refresh
- 2026-10-19 18:23 — [chain] C3: shakedown generations deleted from ~/runs/shakedown (reports kept in repo)
--- steady-state projection [none] ---
  7b-rl     mean_tok= 5486 -> 3.58 h
  7b-sft    mean_tok= 2939 -> 2.81 h
  3b-rl     mean_tok=  709 -> 0.33 h
  3b-base   mean_tok=  793 -> 0.35 h
  7b-base   mean_tok=  388 -> 0.39 h
  TOTAL 7.46 h of 9.0 h window -> FITS

CUT APPLIED: none (RTLLM n=5: no (A18 §8 C4 fixed choice); overlap probe: skipped — score nothing until generation ends)
--- scoring projection [n=3, after cut 'none'] ---
  official TB runs: 3090 (2715 also formal) across 5 arms
  measured-rate: 1.84 h | pessimistic: 0.26 h | window 4.5 h
--- scoring projection [RTLLM n=5, after cut 'none'] ---
  official TB runs: 3590 (3085 also formal) across 5 arms
  measured-rate: 2.14 h | pessimistic: 0.29 h | window 4.5 h
wrote /home/unnitools/rtl-strict-eval/results/shakedown/projection.json
- 2026-10-19 18:23 — [chain] C4 PASS: cut applied = none (RTLLM n=5: no; overlap probe skipped)
- 2026-10-19 18:23 — [chain] pushed: A18 C4: steady-state projection done; cut applied = none
PREREG finalized (2026-10-19 18:23)
- 2026-10-19 18:23 — [chain] pushed: A18 C5: PREREG finalized (7B numbers, cut none, verification time, G0 sentence)
- 2026-10-19 18:23 — [chain] tag g0-prereg already exists (reusing)
- 2026-10-19 18:23 — [chain] G0 step 1 PASS: tag g0-prereg = f8f23aaa87b53a9eb9357fa9ffe962430d26642c pushed and visible via ls-remote
- 2026-10-19 18:23 — [chain] G0 step 2: PREREG.md.ots already stamps THIS content (digest match) — skipping re-stamp (resume)
- 2026-10-19 18:23 — [chain] G0 step 2 PASS: PREREG.md.ots stamped (18:23)
- 2026-10-19 18:23 — [chain] pushed: A18 G0 steps: tag g0-prereg pushed (ls-remote verified) + PREREG.md.ots stamped
- 2026-10-19 18:23 — [chain] ots upgrade already scheduled (marker present) — not duplicating
- 2026-10-19 18:23 — [chain] phase 8: overnight generation starts (cut=none, order 7b-rl 7b-sft 3b-rl 3b-base 7b-base)
- 2026-10-19 18:23 — phase8 start: arms=['7b-rl', '7b-sft', '3b-rl', '3b-base', '7b-base'] n=3 cut=none (RTLLM n=5: no — A18 §8 C4; overlap probe skipped — score nothing until generation ends)
- 2026-10-19 18:23 — phase8: 7b-rl/ve output complete — resume skip (timing/log/params untouched)
- 2026-10-19 18:23 — phase8: 7b-rl/rtllm output complete — resume skip (timing/log/params untouched)
- 2026-10-19 18:23 — phase8: 7b-sft/ve output complete — resume skip (timing/log/params untouched)
- 2026-10-19 18:23 — phase8: 7b-sft/rtllm output complete — resume skip (timing/log/params untouched)
- 2026-10-19 18:23 — phase8: 3b-rl/ve output complete — resume skip (timing/log/params untouched)
- 2026-10-19 18:23 — phase8: 3b-rl/rtllm output complete — resume skip (timing/log/params untouched)
- 2026-10-19 18:23 — phase8: 3b-base/ve output complete — resume skip (timing/log/params untouched)
- 2026-10-19 18:23 — phase8: 3b-base/rtllm output complete — resume skip (timing/log/params untouched)
- 2026-10-19 18:23 — phase8: 7b-base/ve output complete — resume skip (timing/log/params untouched)
- 2026-10-19 18:23 — phase8: 7b-base/rtllm output complete — resume skip (timing/log/params untouched)
- 2026-10-19 18:23 — phase8: all generation done
{"arm": "3b-base", "rows_total": 618, "truncated_total": 21, "extraction_rate": 0.966, "module_name_ok_rate": 0.9563}
{"arm": "3b-rl", "rows_total": 618, "truncated_total": 24, "extraction_rate": 0.9628, "module_name_ok_rate": 0.9466}
{"arm": "7b-base", "rows_total": 618, "truncated_total": 0, "extraction_rate": 0.9984, "module_name_ok_rate": 0.966}
{"arm": "7b-rl", "rows_total": 618, "truncated_total": 1, "extraction_rate": 1.0, "module_name_ok_rate": 0.9903}
{"arm": "7b-sft", "rows_total": 618, "truncated_total": 7, "extraction_rate": 0.9935, "module_name_ok_rate": 0.9838}
- 2026-10-19 18:23 — [chain] pushed: A18 phase 8: generation done; manifests + release archives + throughput checks committed
- 2026-10-19 18:23 — [chain] phase 10: scoring + analysis (freeze checks, G2, G1b, strict, dedup, contamination, stats, blind40)
- 2026-10-19 18:23 — phase10: start (freeze checks first)
- 2026-10-19 18:23 — phase10: git -C /home/unnitools/rtl-strict-eval diff --quiet scorer-v1 ...
- 2026-10-19 18:23 — phase10: sha256sum -c results/pilot_repro/SCORER_SHA256
- 2026-10-19 18:23 — phase10 freeze check: diff rc=0 sha256 rc=0 a18-test pins ok=True
- 2026-10-19 18:23 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/extract.py --gen /home/unnitools/runs/gen/7b-rl_rtllm.jsonl
- 2026-10-19 18:23 — phase10 G2 7b-rl 7b-rl_rtllm.jsonl: rc=0 0.98
- 2026-10-19 18:23 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/extract.py --gen /home/unnitools/runs/gen/7b-rl_ve.jsonl
- 2026-10-19 18:23 — phase10 G2 7b-rl 7b-rl_ve.jsonl: rc=0 0.9936
- 2026-10-19 18:23 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/extract.py --gen /home/unnitools/runs/gen/7b-sft_rtllm.jsonl
- 2026-10-19 18:23 — phase10 G2 7b-sft 7b-sft_rtllm.jsonl: rc=0 0.9733
- 2026-10-19 18:23 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/extract.py --gen /home/unnitools/runs/gen/7b-sft_ve.jsonl
- 2026-10-19 18:23 — phase10 G2 7b-sft 7b-sft_ve.jsonl: rc=0 0.9872
- 2026-10-19 18:23 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/extract.py --gen /home/unnitools/runs/gen/3b-rl_rtllm.jsonl
- 2026-10-19 18:23 — phase10 G2 3b-rl 3b-rl_rtllm.jsonl: rc=1 0.94
- 2026-10-19 18:23 — G2 FAILED for 3b-rl — output:
{"file": "/home/unnitools/runs/gen/3b-rl_rtllm.jsonl", "samples": 150, "extract_and_name_ok": 141, "share": 0.94, "g2_threshold": 0.95, "g2_pass": false}
first 10 failing samples:
  rtllm/adder_32bit/1
  rtllm/adder_pipe_64bit/2
  rtllm/asyn_fifo/2
  rtllm/barrel_shifter/2
  rtllm/comparator_3bit/0
  rtllm/fixed_point_substractor/0
  rtllm/fixed_point_substractor/1
  rtllm/fixed_point_substractor/2
  rtllm/multi_8bit/1
- 2026-10-19 18:23 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/extract.py --gen /home/unnitools/runs/gen/3b-rl_ve.jsonl
- 2026-10-19 18:23 — phase10 G2 3b-rl 3b-rl_ve.jsonl: rc=1 0.9487
- 2026-10-19 18:23 — G2 FAILED for 3b-rl — output:
{"file": "/home/unnitools/runs/gen/3b-rl_ve.jsonl", "samples": 468, "extract_and_name_ok": 444, "share": 0.9487, "g2_threshold": 0.95, "g2_pass": false}
first 10 failing samples:
  ve/Prob018_mux256to1/2
  ve/Prob021_mux256to1v/1
  ve/Prob030_popcount255/0
  ve/Prob052_gates100/0
  ve/Prob082_lfsr32/0
  ve/Prob089_ece241_2014_q5a/2
  ve/Prob102_circuit3/2
  ve/Prob123_bugs_addsubz/0
  ve/Prob123_bugs_addsubz/1
  ve/Prob123_bugs_addsubz/2
- 2026-10-19 18:23 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/extract.py --gen /home/unnitools/runs/gen/3b-base_rtllm.jsonl
- 2026-10-19 18:23 — phase10 G2 3b-base 3b-base_rtllm.jsonl: rc=1 0.92
- 2026-10-19 18:23 — G2 FAILED for 3b-base — output:
{"file": "/home/unnitools/runs/gen/3b-base_rtllm.jsonl", "samples": 150, "extract_and_name_ok": 138, "share": 0.92, "g2_threshold": 0.95, "g2_pass": false}
first 10 failing samples:
  rtllm/accu/1
  rtllm/adder_pipe_64bit/0
  rtllm/adder_pipe_64bit/1
  rtllm/adder_pipe_64bit/2
  rtllm/div_16bit/1
  rtllm/fixed_point_substractor/0
  rtllm/fixed_point_substractor/1
  rtllm/fixed_point_substractor/2
  rtllm/float_multi/2
  rtllm/radix2_div/2
- 2026-10-19 18:23 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/extract.py --gen /home/unnitools/runs/gen/3b-base_ve.jsonl
- 2026-10-19 18:23 — phase10 G2 3b-base 3b-base_ve.jsonl: rc=0 0.9679
- 2026-10-19 18:23 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/extract.py --gen /home/unnitools/runs/gen/7b-base_rtllm.jsonl
- 2026-10-19 18:23 — phase10 G2 7b-base 7b-base_rtllm.jsonl: rc=0 0.98
- 2026-10-19 18:23 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/extract.py --gen /home/unnitools/runs/gen/7b-base_ve.jsonl
- 2026-10-19 18:23 — phase10 G2 7b-base 7b-base_ve.jsonl: rc=0 0.9615
- 2026-10-19 18:23 — [chain] STOP — PHASE10 failed: phase10.py rc=0 (its STOP line names the failing gate)
- 2026-10-19 18:31 — [monitor] G2 stop evidence, cause breakdown of all 45 failing samples: 33 finish_reason=length at the A16-pinned 2048-token 3B cap (3b-rl/ve 18, 3b-rl/rtllm 6, 3b-base/rtllm 9 — mirrors the item-7 3B format-failure pattern); 12 module-name misses, concentrated on fixed_point_substractor (6: all 3 samples of both 3B arms) and Prob123_bugs_addsubz (3), plus Prob131_mt2015_q4, comparator_3bit style singles. Margins: 3b-rl/ve 444/468 vs 445 needed; 3b-rl/rtllm 141/150 vs 143; 3b-base/rtllm 138/150 vs 143. All 7B files pass (>= 0.9615). Awaiting operator decision on the glue fix per PREREG; no scoring run, nothing post-G2 executed.
- 2026-10-20 22:59 — phase10: git -C /home/unnitools/rtl-strict-eval diff --quiet scorer-v1 ...
- 2026-10-20 22:59 — phase10: sha256sum -c results/pilot_repro/SCORER_SHA256
- 2026-10-20 22:59 — phase10 freeze check: diff rc=0 sha256 rc=0 a18-test pins ok=True
- 2026-10-20 23:00 — [A19] operator decision on the G2 stop (verbatim instruction: "Lets do all? Lets do everything which best suits the rules we set in A19"): all three — primary preserved with pinned waivers, typo alias as the glue fix, 3B sensitivity regeneration. PREREG-A19.md written and committed BEFORE any testbench scoring ran (blind to every official pass@1 / strict-correct / H-contrast number). extract.py alias verified against all 10 primary files: shares exactly as pinned in A19 §1 (7b rtllm 1.0/0.9933/1.0; 3b-rl rtllm 0.96; waivers 3b-rl_ve 444, 3b-base_rtllm 141). Freeze check green with the A19 test pin.
- 2026-10-20 22:59 — sens: generating 3b-rl-cap/ve (T=0.2, top_p=0.95, n=3, max_tokens=3072, mml=5120)
- 2026-10-20 23:00 — [chain] A18 §8 chain start (pid 318672, force_fail=none, C2 deadline 09:00)
- 2026-10-20 23:00 — [chain] C1: extract.py pin superseded by A19 (e36b36e78fde106d02d4dd38a22237ed8a4a0d77dd787fe4c2fed5f0811aa195 -> 9f626ebc6808a0a140cbffbc3645bf9faaa003bfe605825c31edfb910b251b2a)
- 2026-10-20 23:00 — [chain] C1 PASS: items 1-5+7 committed, pushed, PREREG sha256 final
- 2026-10-20 23:00 — [chain] C2: waiting for 8/8 weight verification (cut-off 09:00)
- 2026-10-20 23:03 — [chain] C2 PASS: all 8 weight sets hash-verified (8 of 8) at 2026-10-20 23:03
- 2026-10-20 23:03 — [chain] pushed: A18 C2: 8/8 weights verified at 2026-10-20 23:03
- 2026-10-20 23:03 — [chain] C3: 7b-rl already green (report present, checks pass) — resume skip
- 2026-10-20 23:03 — [chain] C3: 7b-sft already green (report present, checks pass) — resume skip
- 2026-10-20 23:03 — [chain] C3: 7b-base already green (report present, checks pass) — resume skip
- 2026-10-20 23:03 — [chain] C3 (C4 prep): 3b-rl steady split already present — resume skip
- 2026-10-20 23:03 — [chain] C3 (C4 prep): 3b-base steady split already present — resume skip
- 2026-10-20 23:03 — [chain] pushed: A18 C3: 7B shakedowns done + checked (params, extraction, cap, scorer); 3B steady refresh
- 2026-10-20 23:03 — [chain] C3: shakedown generations deleted from ~/runs/shakedown (reports kept in repo)
--- steady-state projection [none] ---
  7b-rl     mean_tok= 5486 -> 3.58 h
  7b-sft    mean_tok= 2939 -> 2.81 h
  3b-rl     mean_tok=  709 -> 0.33 h
  3b-base   mean_tok=  793 -> 0.35 h
  7b-base   mean_tok=  388 -> 0.39 h
  TOTAL 7.46 h of 9.0 h window -> FITS

CUT APPLIED: none (RTLLM n=5: no (A18 §8 C4 fixed choice); overlap probe: skipped — score nothing until generation ends)
--- scoring projection [n=3, after cut 'none'] ---
  official TB runs: 3090 (2715 also formal) across 5 arms
  measured-rate: 1.84 h | pessimistic: 0.26 h | window 4.5 h
--- scoring projection [RTLLM n=5, after cut 'none'] ---
  official TB runs: 3590 (3085 also formal) across 5 arms
  measured-rate: 2.14 h | pessimistic: 0.29 h | window 4.5 h
wrote /home/unnitools/rtl-strict-eval/results/shakedown/projection.json
- 2026-10-20 23:03 — [chain] C4 PASS: cut applied = none (RTLLM n=5: no; overlap probe skipped)
- 2026-10-20 23:03 — [chain] pushed: A18 C4: steady-state projection done; cut applied = none
PREREG finalized (2026-10-20 23:03)
- 2026-10-20 23:03 — [chain] pushed: A18 C5: PREREG finalized (7B numbers, cut none, verification time, G0 sentence)
- 2026-10-20 23:03 — [chain] tag g0-prereg already exists (reusing)
- 2026-10-20 23:03 — [chain] G0 step 1 PASS: tag g0-prereg = f8f23aaa87b53a9eb9357fa9ffe962430d26642c pushed and visible via ls-remote
- 2026-10-20 23:03 — [chain] G0 step 2: PREREG.md.ots already stamps THIS content (digest match) — skipping re-stamp (resume)
- 2026-10-20 23:03 — [chain] G0 step 2 PASS: PREREG.md.ots stamped (23:03)
- 2026-10-20 23:03 — [chain] pushed: A18 G0 steps: tag g0-prereg pushed (ls-remote verified) + PREREG.md.ots stamped
- 2026-10-20 23:03 — [chain] ots upgrade already scheduled (marker present) — not duplicating
- 2026-10-20 23:03 — [chain] phase 8: overnight generation starts (cut=none, order 7b-rl 7b-sft 3b-rl 3b-base 7b-base)
- 2026-10-20 23:03 — phase8 start: arms=['7b-rl', '7b-sft', '3b-rl', '3b-base', '7b-base'] n=3 cut=none (RTLLM n=5: no — A18 §8 C4; overlap probe skipped — score nothing until generation ends)
- 2026-10-20 23:03 — phase8: 7b-rl/ve output complete — resume skip (timing/log/params untouched)
- 2026-10-20 23:03 — phase8: 7b-rl/rtllm output complete — resume skip (timing/log/params untouched)
- 2026-10-20 23:03 — phase8: 7b-sft/ve output complete — resume skip (timing/log/params untouched)
- 2026-10-20 23:03 — phase8: 7b-sft/rtllm output complete — resume skip (timing/log/params untouched)
- 2026-10-20 23:03 — phase8: 3b-rl/ve output complete — resume skip (timing/log/params untouched)
- 2026-10-20 23:03 — phase8: 3b-rl/rtllm output complete — resume skip (timing/log/params untouched)
- 2026-10-20 23:03 — phase8: 3b-base/ve output complete — resume skip (timing/log/params untouched)
- 2026-10-20 23:03 — phase8: 3b-base/rtllm output complete — resume skip (timing/log/params untouched)
- 2026-10-20 23:03 — phase8: 7b-base/ve output complete — resume skip (timing/log/params untouched)
- 2026-10-20 23:03 — phase8: 7b-base/rtllm output complete — resume skip (timing/log/params untouched)
- 2026-10-20 23:03 — phase8: all generation done
{"arm": "3b-base", "rows_total": 618, "truncated_total": 21, "extraction_rate": 0.966, "module_name_ok_rate": 0.9563}
{"arm": "3b-rl", "rows_total": 618, "truncated_total": 24, "extraction_rate": 0.9628, "module_name_ok_rate": 0.9466}
{"arm": "7b-base", "rows_total": 618, "truncated_total": 0, "extraction_rate": 0.9984, "module_name_ok_rate": 0.966}
{"arm": "7b-rl", "rows_total": 618, "truncated_total": 1, "extraction_rate": 1.0, "module_name_ok_rate": 0.9903}
{"arm": "7b-sft", "rows_total": 618, "truncated_total": 7, "extraction_rate": 0.9935, "module_name_ok_rate": 0.9838}
- 2026-10-20 23:03 — [chain] pushed: A18 phase 8: generation done; manifests + release archives + throughput checks committed
- 2026-10-20 23:03 — [chain] phase 10: scoring + analysis (freeze checks, G2, G1b, strict, dedup, contamination, stats, blind40)
- 2026-10-20 23:03 — phase10: start (freeze checks first)
- 2026-10-20 23:03 — phase10: git -C /home/unnitools/rtl-strict-eval diff --quiet scorer-v1 ...
- 2026-10-20 23:03 — phase10: sha256sum -c results/pilot_repro/SCORER_SHA256
- 2026-10-20 23:03 — phase10 freeze check: diff rc=0 sha256 rc=0 a18-test pins ok=True
- 2026-10-20 23:03 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/extract.py --gen /home/unnitools/runs/gen/7b-rl_rtllm.jsonl
- 2026-10-20 23:03 — phase10 G2 7b-rl 7b-rl_rtllm.jsonl: rc=0 1.0
- 2026-10-20 23:03 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/extract.py --gen /home/unnitools/runs/gen/7b-rl_ve.jsonl
- 2026-10-20 23:03 — phase10 G2 7b-rl 7b-rl_ve.jsonl: rc=0 0.9936
- 2026-10-20 23:03 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/extract.py --gen /home/unnitools/runs/gen/7b-sft_rtllm.jsonl
- 2026-10-20 23:03 — phase10 G2 7b-sft 7b-sft_rtllm.jsonl: rc=0 0.9933
- 2026-10-20 23:03 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/extract.py --gen /home/unnitools/runs/gen/7b-sft_ve.jsonl
- 2026-10-20 23:03 — phase10 G2 7b-sft 7b-sft_ve.jsonl: rc=0 0.9872
- 2026-10-20 23:03 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/extract.py --gen /home/unnitools/runs/gen/3b-rl_rtllm.jsonl
- 2026-10-20 23:03 — phase10 G2 3b-rl 3b-rl_rtllm.jsonl: rc=0 0.96
- 2026-10-20 23:03 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/extract.py --gen /home/unnitools/runs/gen/3b-rl_ve.jsonl
- 2026-10-20 23:03 — phase10 G2 3b-rl 3b-rl_ve.jsonl: rc=1 0.9487
- 2026-10-20 23:03 — phase10 G2 3b-rl 3b-rl_ve.jsonl: below threshold but 444 == A19 §3 pinned count — waiver applied (reported, not corrected)
- 2026-10-20 23:03 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/extract.py --gen /home/unnitools/runs/gen/3b-base_rtllm.jsonl
- 2026-10-20 23:03 — phase10 G2 3b-base 3b-base_rtllm.jsonl: rc=1 0.94
- 2026-10-20 23:03 — phase10 G2 3b-base 3b-base_rtllm.jsonl: below threshold but 141 == A19 §3 pinned count — waiver applied (reported, not corrected)
- 2026-10-20 23:03 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/extract.py --gen /home/unnitools/runs/gen/3b-base_ve.jsonl
- 2026-10-20 23:03 — phase10 G2 3b-base 3b-base_ve.jsonl: rc=0 0.9679
- 2026-10-20 23:03 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/extract.py --gen /home/unnitools/runs/gen/7b-base_rtllm.jsonl
- 2026-10-20 23:03 — phase10 G2 7b-base 7b-base_rtllm.jsonl: rc=0 1.0
- 2026-10-20 23:03 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/extract.py --gen /home/unnitools/runs/gen/7b-base_ve.jsonl
- 2026-10-20 23:03 — phase10 G2 7b-base 7b-base_ve.jsonl: rc=0 0.9615
- 2026-10-20 23:03 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/contamination.py
- 2026-10-20 23:05 — sens: 3b-rl-cap/ve rc=0 wall=5.5 min log=/home/unnitools/runs/gen_sens/log_3b-rl-cap_ve.txt
- 2026-10-20 23:05 — sens: generating 3b-rl-cap/rtllm (T=0.2, top_p=0.95, n=3, max_tokens=3072, mml=5120)
- 2026-10-20 23:08 — sens: 3b-rl-cap/rtllm rc=0 wall=3.5 min log=/home/unnitools/runs/gen_sens/log_3b-rl-cap_rtllm.txt
- 2026-10-20 23:08 — sens: generating 3b-base-cap/ve (T=0.2, top_p=0.95, n=3, max_tokens=3072, mml=5120)
- 2026-10-20 23:13 — sens: 3b-base-cap/ve rc=0 wall=4.9 min log=/home/unnitools/runs/gen_sens/log_3b-base-cap_ve.txt
- 2026-10-20 23:13 — sens: generating 3b-base-cap/rtllm (T=0.2, top_p=0.95, n=3, max_tokens=3072, mml=5120)
- 2026-10-20 23:16 — sens: 3b-base-cap/rtllm rc=0 wall=3.4 min log=/home/unnitools/runs/gen_sens/log_3b-base-cap_rtllm.txt
- 2026-10-20 23:16 — sens: all sensitivity generation done
- 2026-10-20 23:25 — phase10 contamination rc=0: erlaps": 0, "ref_overlaps_secondary": 0}}, "total_overlaps": 0}
verireason_tb_simple {"files": {"processed_entries.jsonl": {"sha256": "(not pinned)", "pin_ok": true, "size_bytes": 7673835, "rows": 743, "spec_overlaps": 0, "ref_overlaps_secondary": 0}}, "total_overlaps": 0}
overlap rows: 0; overlapping statement tasks: 0
wrote /home/unnitools/rtl-strict-eval/results/main/contamination/overlaps.csv

- 2026-10-20 23:25 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/run_scoring.py --arm 7b-rl --gen /home/unnitools/runs/gen/7b-rl_rtllm.jsonl ...
- 2026-10-20 23:20 — [A19 §4] sensitivity generation done (17 min, 4 files, ~/runs/gen_sens/). G2 under the §2 alias: 3b-rl-cap ve 0.9594 PASS, rtllm 0.9867 PASS — the 3b-rl primary shortfall was cap-driven and clears with headroom. 3b-base-cap ve 0.9637 PASS, rtllm 0.9400 STILL BELOW — all 9 remaining failures are length hits at the raised 3072 cap (truncations: ve 14, rtllm 9; 3b-rl-cap: ve 12, rtllm 2). Per PREREG-A19 §4: reported as-is, no further amendment. Sens arms are supplementary only; never merged into primary stats or blind-40.
- 2026-10-20 23:48 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/run_scoring.py --arm 7b-rl --gen /home/unnitools/runs/gen/7b-rl_ve.jsonl ...
- 2026-10-21 00:25 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/stats.py --scores /home/unnitools/rtl-strict-eval/scores/7b-rl.jsonl --out /home/unnitools/rtl-strict-eval/results/main/stats.json
- 2026-10-21 00:25 — phase10 G1b 7b-rl/ve: point=0.679 CI=[0.611, 0.744] anchor=0.688 -> PASS (rtllm loose: 0.7066666666666667 vs 0.68)
- 2026-10-21 00:25 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/run_scoring.py --arm 7b-sft --gen /home/unnitools/runs/gen/7b-sft_rtllm.jsonl ...
- 2026-10-21 00:33 — [A19 exec] run_scoring.py (pinned) is sequential per sample; at the observed proof-heavy pace the remaining ~2400 primary rows would take 10+ h. Parallelized ACROSS arms (never within an arm — one writer per scores/<arm>.jsonl): five helper run_scoring processes launched under tmux for 3b-rl, 3b-base, 7b-base (into scores/, exactly the phase10 invocation) and the two sens arms (into scores_sens/, cex under results/sens/). Same pinned script, same args, deterministic verdicts, no code change; the chain's score_arm resume-skips pre-completed rows (its done-set logic). Order of scoring does not enter any result.
- 2026-10-21 00:39 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/run_scoring.py --arm 7b-sft --gen /home/unnitools/runs/gen/7b-sft_ve.jsonl ...
- 2026-10-21 00:55 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/stats.py --scores /home/unnitools/rtl-strict-eval/scores/7b-base.jsonl /home/unnitools/rtl-strict-eval/scores/7b-rl.jsonl /home/unnitools/rtl-strict-eval/scores/3b-rl.jsonl ...
- 2026-10-21 00:55 — phase10 G1b 7b-rl/ve: point=0.679 CI=[0.611, 0.744] anchor=0.688 -> PASS (rtllm loose: 0.7066666666666667 vs 0.68)
- 2026-10-21 00:55 — phase10 G1b 7b-sft/ve: point=0.637 CI=[0.566, 0.705] anchor=0.652 -> PASS (rtllm loose: 0.6266666666666666 vs 0.572)
- 2026-10-21 00:55 — phase10 G1b 7b-base/ve: point=0.661 CI=[0.539, 0.778] anchor=0.313 -> FAIL (rtllm loose: 0.3466666666666666 vs 0.361)
- 2026-10-21 00:55 — [chain] STOP — PHASE10 failed: phase10.py rc=0 (its STOP line names the failing gate)
- 2026-10-21 01:30 — [monitor] the 00:55 G1b FAIL for 7b-base was a race artifact, not a result: the chain's stats step globbed scores/7b-base.jsonl while the arm-level scoring helper (00:33) was still appending it — stats.json for 7b-base/ve was computed from 27 tasks / 80 samples (partial file), giving point 0.661. All seven score files now verify 618/618 unique rows and are static (helpers exited). Full-data value: 7b-base ve official all-task pass@1 = 135/468 = 0.2885 vs anchor 0.313 (2.45 pp, inside ±8 pp); rtllm 52/150 = 0.3467 vs 0.361 (loose, pass). No data was corrupted; relaunching the chain to recompute stats on the complete files (score_arm resume-skips 618/618; no concurrent writers this time).
- 2026-10-21 01:20 — [chain] A18 §8 chain start (pid 588518, force_fail=none, C2 deadline 09:00)
- 2026-10-21 01:20 — [chain] C1: extract.py pin superseded by A19 (e36b36e78fde106d02d4dd38a22237ed8a4a0d77dd787fe4c2fed5f0811aa195 -> 9f626ebc6808a0a140cbffbc3645bf9faaa003bfe605825c31edfb910b251b2a)
- 2026-10-21 01:20 — [chain] C1: working tree not clean (excluding notes/LOG.md, which this chain writes)
- 2026-10-21 01:20 — [chain] STOP — C1 failed: code/PREREG/push consistency check failed (see log above)
- 2026-10-21 01:20 — [chain] A18 §8 chain start (pid 588734, force_fail=none, C2 deadline 09:00)
- 2026-10-21 01:20 — [chain] C1: extract.py pin superseded by A19 (e36b36e78fde106d02d4dd38a22237ed8a4a0d77dd787fe4c2fed5f0811aa195 -> 9f626ebc6808a0a140cbffbc3645bf9faaa003bfe605825c31edfb910b251b2a)
- 2026-10-21 01:20 — [chain] C1 PASS: items 1-5+7 committed, pushed, PREREG sha256 final
- 2026-10-21 01:20 — [chain] C2: waiting for 8/8 weight verification (cut-off 09:00)
- 2026-10-21 01:22 — [chain] C2 PASS: all 8 weight sets hash-verified (8 of 8) at 2026-10-21 01:22
- 2026-10-21 01:22 — [chain] pushed: A18 C2: 8/8 weights verified at 2026-10-21 01:22
- 2026-10-21 01:22 — [chain] C3: 7b-rl already green (report present, checks pass) — resume skip
- 2026-10-21 01:22 — [chain] C3: 7b-sft already green (report present, checks pass) — resume skip
- 2026-10-21 01:22 — [chain] C3: 7b-base already green (report present, checks pass) — resume skip
- 2026-10-21 01:22 — [chain] C3 (C4 prep): 3b-rl steady split already present — resume skip
- 2026-10-21 01:22 — [chain] C3 (C4 prep): 3b-base steady split already present — resume skip
- 2026-10-21 01:22 — [chain] pushed: A18 C3: 7B shakedowns done + checked (params, extraction, cap, scorer); 3B steady refresh
- 2026-10-21 01:22 — [chain] C3: shakedown generations deleted from ~/runs/shakedown (reports kept in repo)
--- steady-state projection [none] ---
  7b-rl     mean_tok= 5486 -> 3.58 h
  7b-sft    mean_tok= 2939 -> 2.81 h
  3b-rl     mean_tok=  709 -> 0.33 h
  3b-base   mean_tok=  793 -> 0.35 h
  7b-base   mean_tok=  388 -> 0.39 h
  TOTAL 7.46 h of 9.0 h window -> FITS

CUT APPLIED: none (RTLLM n=5: no (A18 §8 C4 fixed choice); overlap probe: skipped — score nothing until generation ends)
--- scoring projection [n=3, after cut 'none'] ---
  official TB runs: 3090 (2715 also formal) across 5 arms
  measured-rate: 1.84 h | pessimistic: 0.26 h | window 4.5 h
--- scoring projection [RTLLM n=5, after cut 'none'] ---
  official TB runs: 3590 (3085 also formal) across 5 arms
  measured-rate: 2.14 h | pessimistic: 0.29 h | window 4.5 h
wrote /home/unnitools/rtl-strict-eval/results/shakedown/projection.json
- 2026-10-21 01:22 — [chain] C4 PASS: cut applied = none (RTLLM n=5: no; overlap probe skipped)
- 2026-10-21 01:22 — [chain] pushed: A18 C4: steady-state projection done; cut applied = none
PREREG finalized (2026-10-21 01:22)
- 2026-10-21 01:22 — [chain] pushed: A18 C5: PREREG finalized (7B numbers, cut none, verification time, G0 sentence)
- 2026-10-21 01:22 — [chain] tag g0-prereg already exists (reusing)
- 2026-10-21 01:22 — [chain] G0 step 1 PASS: tag g0-prereg = f8f23aaa87b53a9eb9357fa9ffe962430d26642c pushed and visible via ls-remote
- 2026-10-21 01:22 — [chain] G0 step 2: PREREG.md.ots already stamps THIS content (digest match) — skipping re-stamp (resume)
- 2026-10-21 01:22 — [chain] G0 step 2 PASS: PREREG.md.ots stamped (01:22)
- 2026-10-21 01:22 — [chain] pushed: A18 G0 steps: tag g0-prereg pushed (ls-remote verified) + PREREG.md.ots stamped
- 2026-10-21 01:22 — [chain] ots upgrade already scheduled (marker present) — not duplicating
- 2026-10-21 01:22 — [chain] phase 8: overnight generation starts (cut=none, order 7b-rl 7b-sft 3b-rl 3b-base 7b-base)
- 2026-10-21 01:22 — phase8 start: arms=['7b-rl', '7b-sft', '3b-rl', '3b-base', '7b-base'] n=3 cut=none (RTLLM n=5: no — A18 §8 C4; overlap probe skipped — score nothing until generation ends)
- 2026-10-21 01:22 — phase8: 7b-rl/ve output complete — resume skip (timing/log/params untouched)
- 2026-10-21 01:22 — phase8: 7b-rl/rtllm output complete — resume skip (timing/log/params untouched)
- 2026-10-21 01:22 — phase8: 7b-sft/ve output complete — resume skip (timing/log/params untouched)
- 2026-10-21 01:22 — phase8: 7b-sft/rtllm output complete — resume skip (timing/log/params untouched)
- 2026-10-21 01:22 — phase8: 3b-rl/ve output complete — resume skip (timing/log/params untouched)
- 2026-10-21 01:22 — phase8: 3b-rl/rtllm output complete — resume skip (timing/log/params untouched)
- 2026-10-21 01:22 — phase8: 3b-base/ve output complete — resume skip (timing/log/params untouched)
- 2026-10-21 01:22 — phase8: 3b-base/rtllm output complete — resume skip (timing/log/params untouched)
- 2026-10-21 01:22 — phase8: 7b-base/ve output complete — resume skip (timing/log/params untouched)
- 2026-10-21 01:22 — phase8: 7b-base/rtllm output complete — resume skip (timing/log/params untouched)
- 2026-10-21 01:22 — phase8: all generation done
{"arm": "3b-base", "rows_total": 618, "truncated_total": 21, "extraction_rate": 0.966, "module_name_ok_rate": 0.9563}
{"arm": "3b-rl", "rows_total": 618, "truncated_total": 24, "extraction_rate": 0.9628, "module_name_ok_rate": 0.9466}
{"arm": "7b-base", "rows_total": 618, "truncated_total": 0, "extraction_rate": 0.9984, "module_name_ok_rate": 0.966}
{"arm": "7b-rl", "rows_total": 618, "truncated_total": 1, "extraction_rate": 1.0, "module_name_ok_rate": 0.9903}
{"arm": "7b-sft", "rows_total": 618, "truncated_total": 7, "extraction_rate": 0.9935, "module_name_ok_rate": 0.9838}
- 2026-10-21 01:22 — [chain] pushed: A18 phase 8: generation done; manifests + release archives + throughput checks committed
- 2026-10-21 01:22 — [chain] phase 10: scoring + analysis (freeze checks, G2, G1b, strict, dedup, contamination, stats, blind40)
- 2026-10-21 01:22 — phase10: start (freeze checks first)
- 2026-10-21 01:22 — phase10: git -C /home/unnitools/rtl-strict-eval diff --quiet scorer-v1 ...
- 2026-10-21 01:22 — phase10: sha256sum -c results/pilot_repro/SCORER_SHA256
- 2026-10-21 01:22 — phase10 freeze check: diff rc=0 sha256 rc=0 a18-test pins ok=True
- 2026-10-21 01:22 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/extract.py --gen /home/unnitools/runs/gen/7b-rl_rtllm.jsonl
- 2026-10-21 01:22 — phase10 G2 7b-rl 7b-rl_rtllm.jsonl: rc=0 1.0
- 2026-10-21 01:22 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/extract.py --gen /home/unnitools/runs/gen/7b-rl_ve.jsonl
- 2026-10-21 01:22 — phase10 G2 7b-rl 7b-rl_ve.jsonl: rc=0 0.9936
- 2026-10-21 01:22 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/extract.py --gen /home/unnitools/runs/gen/7b-sft_rtllm.jsonl
- 2026-10-21 01:22 — phase10 G2 7b-sft 7b-sft_rtllm.jsonl: rc=0 0.9933
- 2026-10-21 01:22 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/extract.py --gen /home/unnitools/runs/gen/7b-sft_ve.jsonl
- 2026-10-21 01:22 — phase10 G2 7b-sft 7b-sft_ve.jsonl: rc=0 0.9872
- 2026-10-21 01:22 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/extract.py --gen /home/unnitools/runs/gen/3b-rl_rtllm.jsonl
- 2026-10-21 01:22 — phase10 G2 3b-rl 3b-rl_rtllm.jsonl: rc=0 0.96
- 2026-10-21 01:22 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/extract.py --gen /home/unnitools/runs/gen/3b-rl_ve.jsonl
- 2026-10-21 01:22 — phase10 G2 3b-rl 3b-rl_ve.jsonl: rc=1 0.9487
- 2026-10-21 01:22 — phase10 G2 3b-rl 3b-rl_ve.jsonl: below threshold but 444 == A19 §3 pinned count — waiver applied (reported, not corrected)
- 2026-10-21 01:22 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/extract.py --gen /home/unnitools/runs/gen/3b-base_rtllm.jsonl
- 2026-10-21 01:22 — phase10 G2 3b-base 3b-base_rtllm.jsonl: rc=1 0.94
- 2026-10-21 01:22 — phase10 G2 3b-base 3b-base_rtllm.jsonl: below threshold but 141 == A19 §3 pinned count — waiver applied (reported, not corrected)
- 2026-10-21 01:22 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/extract.py --gen /home/unnitools/runs/gen/3b-base_ve.jsonl
- 2026-10-21 01:22 — phase10 G2 3b-base 3b-base_ve.jsonl: rc=0 0.9679
- 2026-10-21 01:22 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/extract.py --gen /home/unnitools/runs/gen/7b-base_rtllm.jsonl
- 2026-10-21 01:22 — phase10 G2 7b-base 7b-base_rtllm.jsonl: rc=0 1.0
- 2026-10-21 01:22 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/extract.py --gen /home/unnitools/runs/gen/7b-base_ve.jsonl
- 2026-10-21 01:22 — phase10 G2 7b-base 7b-base_ve.jsonl: rc=0 0.9615
- 2026-10-21 01:22 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/contamination.py
- 2026-10-21 01:45 — phase10 contamination rc=0: erlaps": 0, "ref_overlaps_secondary": 0}}, "total_overlaps": 0}
verireason_tb_simple {"files": {"processed_entries.jsonl": {"sha256": "(not pinned)", "pin_ok": true, "size_bytes": 7673835, "rows": 743, "spec_overlaps": 0, "ref_overlaps_secondary": 0}}, "total_overlaps": 0}
overlap rows: 0; overlapping statement tasks: 0
wrote /home/unnitools/rtl-strict-eval/results/main/contamination/overlaps.csv

- 2026-10-21 01:45 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/run_scoring.py --arm 7b-rl --gen /home/unnitools/runs/gen/7b-rl_rtllm.jsonl ...
- 2026-10-21 01:45 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/run_scoring.py --arm 7b-rl --gen /home/unnitools/runs/gen/7b-rl_ve.jsonl ...
- 2026-10-21 01:45 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/stats.py --scores /home/unnitools/rtl-strict-eval/scores/7b-base.jsonl /home/unnitools/rtl-strict-eval/scores/7b-rl.jsonl /home/unnitools/rtl-strict-eval/scores/3b-rl.jsonl ...
- 2026-10-21 01:46 — phase10 G1b 7b-rl/ve: point=0.679 CI=[0.611, 0.744] anchor=0.688 -> PASS (rtllm loose: 0.7066666666666667 vs 0.68)
- 2026-10-21 01:46 — phase10 G1b 7b-sft/ve: point=0.637 CI=[0.566, 0.705] anchor=0.652 -> PASS (rtllm loose: 0.6266666666666666 vs 0.572)
- 2026-10-21 01:46 — phase10 G1b 7b-base/ve: point=0.288 CI=[0.233, 0.346] anchor=0.313 -> PASS (rtllm loose: 0.3466666666666666 vs 0.361)
- 2026-10-21 01:46 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/run_scoring.py --arm 7b-sft --gen /home/unnitools/runs/gen/7b-sft_rtllm.jsonl ...
- 2026-10-21 01:46 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/run_scoring.py --arm 7b-sft --gen /home/unnitools/runs/gen/7b-sft_ve.jsonl ...
- 2026-10-21 01:46 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/stats.py --scores /home/unnitools/rtl-strict-eval/scores/7b-base.jsonl /home/unnitools/rtl-strict-eval/scores/7b-rl.jsonl /home/unnitools/rtl-strict-eval/scores/3b-rl.jsonl ...
- 2026-10-21 01:46 — phase10 G1b 7b-rl/ve: point=0.679 CI=[0.611, 0.744] anchor=0.688 -> PASS (rtllm loose: 0.7066666666666667 vs 0.68)
- 2026-10-21 01:46 — phase10 G1b 7b-sft/ve: point=0.637 CI=[0.566, 0.705] anchor=0.652 -> PASS (rtllm loose: 0.6266666666666666 vs 0.572)
- 2026-10-21 01:46 — phase10 G1b 7b-base/ve: point=0.288 CI=[0.233, 0.346] anchor=0.313 -> PASS (rtllm loose: 0.3466666666666666 vs 0.361)
- 2026-10-21 01:46 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/run_scoring.py --arm 3b-rl --gen /home/unnitools/runs/gen/3b-rl_rtllm.jsonl ...
- 2026-10-21 01:46 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/run_scoring.py --arm 3b-rl --gen /home/unnitools/runs/gen/3b-rl_ve.jsonl ...
- 2026-10-21 01:46 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/run_scoring.py --arm 3b-base --gen /home/unnitools/runs/gen/3b-base_rtllm.jsonl ...
- 2026-10-21 01:46 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/run_scoring.py --arm 3b-base --gen /home/unnitools/runs/gen/3b-base_ve.jsonl ...
- 2026-10-21 01:46 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/run_scoring.py --arm 7b-base --gen /home/unnitools/runs/gen/7b-base_rtllm.jsonl ...
- 2026-10-21 01:46 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/run_scoring.py --arm 7b-base --gen /home/unnitools/runs/gen/7b-base_ve.jsonl ...
- 2026-10-21 01:46 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/stats.py --scores /home/unnitools/rtl-strict-eval/scores/7b-base.jsonl /home/unnitools/rtl-strict-eval/scores/7b-rl.jsonl /home/unnitools/rtl-strict-eval/scores/3b-rl.jsonl ...
- 2026-10-21 01:46 — phase10 G1b 7b-rl/ve: point=0.679 CI=[0.611, 0.744] anchor=0.688 -> PASS (rtllm loose: 0.7066666666666667 vs 0.68)
- 2026-10-21 01:46 — phase10 G1b 7b-sft/ve: point=0.637 CI=[0.566, 0.705] anchor=0.652 -> PASS (rtllm loose: 0.6266666666666666 vs 0.572)
- 2026-10-21 01:46 — phase10 G1b 7b-base/ve: point=0.288 CI=[0.233, 0.346] anchor=0.313 -> PASS (rtllm loose: 0.3466666666666666 vs 0.361)
- 2026-10-21 01:46 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/stats.py --scores /home/unnitools/rtl-strict-eval/scores/7b-base.jsonl /home/unnitools/rtl-strict-eval/scores/7b-rl.jsonl /home/unnitools/rtl-strict-eval/scores/3b-rl.jsonl ...
- 2026-10-21 01:47 — phase10 G1b 7b-rl/ve: point=0.679 CI=[0.611, 0.744] anchor=0.688 -> PASS (rtllm loose: 0.7066666666666667 vs 0.68)
- 2026-10-21 01:47 — phase10 G1b 7b-sft/ve: point=0.637 CI=[0.566, 0.705] anchor=0.652 -> PASS (rtllm loose: 0.6266666666666666 vs 0.572)
- 2026-10-21 01:47 — phase10 G1b 7b-base/ve: point=0.288 CI=[0.233, 0.346] anchor=0.313 -> PASS (rtllm loose: 0.3466666666666666 vs 0.361)
- 2026-10-21 01:47 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/stats.py --scores /home/unnitools/rtl-strict-eval/scores/7b-base.jsonl /home/unnitools/rtl-strict-eval/scores/7b-rl.jsonl /home/unnitools/rtl-strict-eval/scores/3b-rl.jsonl ...
- 2026-10-21 01:47 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/stats.py --scores /home/unnitools/rtl-strict-eval/scores/7b-base.jsonl /home/unnitools/rtl-strict-eval/scores/7b-rl.jsonl /home/unnitools/rtl-strict-eval/scores/3b-rl.jsonl ...
- 2026-10-21 01:48 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/dedup.py --gen /home/unnitools/runs/gen/7b-rl_rtllm.jsonl /home/unnitools/runs/gen/7b-rl_ve.jsonl /home/unnitools/runs/gen/7b-sft_rtllm.jsonl ...
- 2026-10-21 01:48 — phase10 dedup rc=0: ys_failures": 281,
 "extraction_empty": 49,
 "per_arm": {
  "3b-base": {
   "rows": 618,
   "unique": 552
  },
  "3b-rl": {
   "rows": 618,
   "unique": 541
  },
  "7b-base": {
   "rows": 618,
   "unique": 567
  },
  "7b-rl": {
   "rows": 618,
   "unique": 472
  },
  "7b-sft": {
   "rows": 618,
   "unique": 460
  }
 }
}
wrote /home/unnitools/rtl-strict-eval/results/main/dedup_map.json (3090 keys)

- 2026-10-21 01:48 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/stats.py --scores /home/unnitools/rtl-strict-eval/scores/7b-base.jsonl /home/unnitools/rtl-strict-eval/scores/7b-rl.jsonl /home/unnitools/rtl-strict-eval/scores/3b-rl.jsonl ...
- 2026-10-21 01:49 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/stats.py --scores /home/unnitools/rtl-strict-eval/scores/7b-base.jsonl /home/unnitools/rtl-strict-eval/scores/7b-rl.jsonl /home/unnitools/rtl-strict-eval/scores/3b-rl.jsonl ...
- 2026-10-21 01:49 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/stats.py --scores /home/unnitools/rtl-strict-eval/scores/7b-base.jsonl /home/unnitools/rtl-strict-eval/scores/7b-rl.jsonl /home/unnitools/rtl-strict-eval/scores/3b-rl.jsonl ...
- 2026-10-21 01:50 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/blind40.py --scores /home/unnitools/rtl-strict-eval/scores/7b-base.jsonl /home/unnitools/rtl-strict-eval/scores/7b-rl.jsonl /home/unnitools/rtl-strict-eval/scores/3b-rl.jsonl ...
- 2026-10-21 01:50 — phase10 blind40 rc=0: },
  "3b-rl|rtllm": {
   "population": 6,
   "drawn": 3
  },
  "7b-base|rtllm": {
   "population": 9,
   "drawn": 5
  },
  "7b-base|ve": {
   "population": 3,
   "drawn": 2
  },
  "7b-rl|rtllm": {
   "population": 25,
   "drawn": 13
  },
  "7b-rl|ve": {
   "population": 5,
   "drawn": 3
  },
  "7b-sft|rtllm": {
   "population": 20,
   "drawn": 11
  },
  "7b-sft|ve": {
   "population": 1,
   "drawn": 0
  }
 }
}
key: /home/unnitools/runs/blind40_key.json (outside the repo; commit only its sha256)

- 2026-10-21 01:50 — phase10 blind40 key sha256=cdb4a18bd1dc38abf126f4a904fec1297812b681f60da105636145829692c317 (key stays outside the repo)
- 2026-10-21 01:50 — [chain] STOP — PHASE10 failed: phase10.py rc=0 (its STOP line names the failing gate)
- 2026-10-21 02:04 — [chain] A18 §8 chain start (pid 601606, force_fail=none, C2 deadline 09:00)
- 2026-10-21 02:04 — [chain] C1: extract.py pin superseded by A19 (e36b36e78fde106d02d4dd38a22237ed8a4a0d77dd787fe4c2fed5f0811aa195 -> 9f626ebc6808a0a140cbffbc3645bf9faaa003bfe605825c31edfb910b251b2a)
- 2026-10-21 02:04 — [chain] C1 PASS: items 1-5+7 committed, pushed, PREREG sha256 final
- 2026-10-21 02:04 — [chain] C2: waiting for 8/8 weight verification (cut-off 09:00)
- 2026-10-21 02:04 — [chain] C2 PASS: all 8 weight sets hash-verified (8 of 8) at 2026-10-21 02:04
- 2026-10-21 02:05 — [chain] pushed: A18 C2: 8/8 weights verified at 2026-10-21 02:04
- 2026-10-21 02:05 — [chain] C3: 7b-rl already green (report present, checks pass) — resume skip
- 2026-10-21 02:05 — [chain] C3: 7b-sft already green (report present, checks pass) — resume skip
- 2026-10-21 02:05 — [chain] C3: 7b-base already green (report present, checks pass) — resume skip
- 2026-10-21 02:05 — [chain] C3 (C4 prep): 3b-rl steady split already present — resume skip
- 2026-10-21 02:05 — [chain] C3 (C4 prep): 3b-base steady split already present — resume skip
- 2026-10-21 02:05 — [chain] pushed: A18 C3: 7B shakedowns done + checked (params, extraction, cap, scorer); 3B steady refresh
- 2026-10-21 02:05 — [chain] C3: shakedown generations deleted from ~/runs/shakedown (reports kept in repo)
--- steady-state projection [none] ---
  7b-rl     mean_tok= 5486 -> 3.58 h
  7b-sft    mean_tok= 2939 -> 2.81 h
  3b-rl     mean_tok=  709 -> 0.33 h
  3b-base   mean_tok=  793 -> 0.35 h
  7b-base   mean_tok=  388 -> 0.39 h
  TOTAL 7.46 h of 9.0 h window -> FITS

CUT APPLIED: none (RTLLM n=5: no (A18 §8 C4 fixed choice); overlap probe: skipped — score nothing until generation ends)
--- scoring projection [n=3, after cut 'none'] ---
  official TB runs: 3090 (2715 also formal) across 5 arms
  measured-rate: 1.84 h | pessimistic: 0.26 h | window 4.5 h
--- scoring projection [RTLLM n=5, after cut 'none'] ---
  official TB runs: 3590 (3085 also formal) across 5 arms
  measured-rate: 2.14 h | pessimistic: 0.29 h | window 4.5 h
wrote /home/unnitools/rtl-strict-eval/results/shakedown/projection.json
- 2026-10-21 02:05 — [chain] C4 PASS: cut applied = none (RTLLM n=5: no; overlap probe skipped)
- 2026-10-21 02:05 — [chain] pushed: A18 C4: steady-state projection done; cut applied = none
PREREG finalized (2026-10-21 02:05)
- 2026-10-21 02:05 — [chain] pushed: A18 C5: PREREG finalized (7B numbers, cut none, verification time, G0 sentence)
- 2026-10-21 02:05 — [chain] tag g0-prereg already exists (reusing)
- 2026-10-21 02:05 — [chain] G0 step 1 PASS: tag g0-prereg = f8f23aaa87b53a9eb9357fa9ffe962430d26642c pushed and visible via ls-remote
- 2026-10-21 02:05 — [chain] G0 step 2: PREREG.md.ots already stamps THIS content (digest match) — skipping re-stamp (resume)
- 2026-10-21 02:05 — [chain] G0 step 2 PASS: PREREG.md.ots stamped (02:05)
- 2026-10-21 02:05 — [chain] pushed: A18 G0 steps: tag g0-prereg pushed (ls-remote verified) + PREREG.md.ots stamped
- 2026-10-21 02:05 — [chain] ots upgrade already scheduled (marker present) — not duplicating
- 2026-10-21 02:05 — [chain] phase 8: overnight generation starts (cut=none, order 7b-rl 7b-sft 3b-rl 3b-base 7b-base)
- 2026-10-21 02:05 — phase8 start: arms=['7b-rl', '7b-sft', '3b-rl', '3b-base', '7b-base'] n=3 cut=none (RTLLM n=5: no — A18 §8 C4; overlap probe skipped — score nothing until generation ends)
- 2026-10-21 02:05 — phase8: 7b-rl/ve output complete — resume skip (timing/log/params untouched)
- 2026-10-21 02:05 — phase8: 7b-rl/rtllm output complete — resume skip (timing/log/params untouched)
- 2026-10-21 02:05 — phase8: 7b-sft/ve output complete — resume skip (timing/log/params untouched)
- 2026-10-21 02:05 — phase8: 7b-sft/rtllm output complete — resume skip (timing/log/params untouched)
- 2026-10-21 02:05 — phase8: 3b-rl/ve output complete — resume skip (timing/log/params untouched)
- 2026-10-21 02:05 — phase8: 3b-rl/rtllm output complete — resume skip (timing/log/params untouched)
- 2026-10-21 02:05 — phase8: 3b-base/ve output complete — resume skip (timing/log/params untouched)
- 2026-10-21 02:05 — phase8: 3b-base/rtllm output complete — resume skip (timing/log/params untouched)
- 2026-10-21 02:05 — phase8: 7b-base/ve output complete — resume skip (timing/log/params untouched)
- 2026-10-21 02:05 — phase8: 7b-base/rtllm output complete — resume skip (timing/log/params untouched)
- 2026-10-21 02:05 — phase8: all generation done
{"arm": "3b-base", "rows_total": 618, "truncated_total": 21, "extraction_rate": 0.966, "module_name_ok_rate": 0.9563}
{"arm": "3b-rl", "rows_total": 618, "truncated_total": 24, "extraction_rate": 0.9628, "module_name_ok_rate": 0.9466}
{"arm": "7b-base", "rows_total": 618, "truncated_total": 0, "extraction_rate": 0.9984, "module_name_ok_rate": 0.966}
{"arm": "7b-rl", "rows_total": 618, "truncated_total": 1, "extraction_rate": 1.0, "module_name_ok_rate": 0.9903}
{"arm": "7b-sft", "rows_total": 618, "truncated_total": 7, "extraction_rate": 0.9935, "module_name_ok_rate": 0.9838}
- 2026-10-21 02:05 — [chain] pushed: A18 phase 8: generation done; manifests + release archives + throughput checks committed
- 2026-10-21 02:05 — [chain] phase 10: scoring + analysis (freeze checks, G2, G1b, strict, dedup, contamination, stats, blind40)
- 2026-10-21 02:05 — phase10: start (freeze checks first)
- 2026-10-21 02:05 — phase10: git -C /home/unnitools/rtl-strict-eval diff --quiet scorer-v1 ...
- 2026-10-21 02:05 — phase10: sha256sum -c results/pilot_repro/SCORER_SHA256
- 2026-10-21 02:05 — phase10 freeze check: diff rc=0 sha256 rc=0 a18-test pins ok=True
- 2026-10-21 02:05 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/extract.py --gen /home/unnitools/runs/gen/7b-rl_rtllm.jsonl
- 2026-10-21 02:05 — phase10 G2 7b-rl 7b-rl_rtllm.jsonl: rc=0 1.0
- 2026-10-21 02:05 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/extract.py --gen /home/unnitools/runs/gen/7b-rl_ve.jsonl
- 2026-10-21 02:05 — phase10 G2 7b-rl 7b-rl_ve.jsonl: rc=0 0.9936
- 2026-10-21 02:05 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/extract.py --gen /home/unnitools/runs/gen/7b-sft_rtllm.jsonl
- 2026-10-21 02:05 — phase10 G2 7b-sft 7b-sft_rtllm.jsonl: rc=0 0.9933
- 2026-10-21 02:05 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/extract.py --gen /home/unnitools/runs/gen/7b-sft_ve.jsonl
- 2026-10-21 02:05 — phase10 G2 7b-sft 7b-sft_ve.jsonl: rc=0 0.9872
- 2026-10-21 02:05 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/extract.py --gen /home/unnitools/runs/gen/3b-rl_rtllm.jsonl
- 2026-10-21 02:05 — phase10 G2 3b-rl 3b-rl_rtllm.jsonl: rc=0 0.96
- 2026-10-21 02:05 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/extract.py --gen /home/unnitools/runs/gen/3b-rl_ve.jsonl
- 2026-10-21 02:05 — phase10 G2 3b-rl 3b-rl_ve.jsonl: rc=1 0.9487
- 2026-10-21 02:05 — phase10 G2 3b-rl 3b-rl_ve.jsonl: below threshold but 444 == A19 §3 pinned count — waiver applied (reported, not corrected)
- 2026-10-21 02:05 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/extract.py --gen /home/unnitools/runs/gen/3b-base_rtllm.jsonl
- 2026-10-21 02:05 — phase10 G2 3b-base 3b-base_rtllm.jsonl: rc=1 0.94
- 2026-10-21 02:05 — phase10 G2 3b-base 3b-base_rtllm.jsonl: below threshold but 141 == A19 §3 pinned count — waiver applied (reported, not corrected)
- 2026-10-21 02:05 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/extract.py --gen /home/unnitools/runs/gen/3b-base_ve.jsonl
- 2026-10-21 02:05 — phase10 G2 3b-base 3b-base_ve.jsonl: rc=0 0.9679
- 2026-10-21 02:05 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/extract.py --gen /home/unnitools/runs/gen/7b-base_rtllm.jsonl
- 2026-10-21 02:05 — phase10 G2 7b-base 7b-base_rtllm.jsonl: rc=0 1.0
- 2026-10-21 02:05 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/extract.py --gen /home/unnitools/runs/gen/7b-base_ve.jsonl
- 2026-10-21 02:05 — phase10 G2 7b-base 7b-base_ve.jsonl: rc=0 0.9615
- 2026-10-21 02:05 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/contamination.py
- 2026-10-21 02:27 — phase10 contamination rc=0: erlaps": 0, "ref_overlaps_secondary": 0}}, "total_overlaps": 0}
verireason_tb_simple {"files": {"processed_entries.jsonl": {"sha256": "(not pinned)", "pin_ok": true, "size_bytes": 7673835, "rows": 743, "spec_overlaps": 0, "ref_overlaps_secondary": 0}}, "total_overlaps": 0}
overlap rows: 0; overlapping statement tasks: 0
wrote /home/unnitools/rtl-strict-eval/results/main/contamination/overlaps.csv

- 2026-10-21 02:27 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/run_scoring.py --arm 7b-rl --gen /home/unnitools/runs/gen/7b-rl_rtllm.jsonl ...
- 2026-10-21 02:27 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/run_scoring.py --arm 7b-rl --gen /home/unnitools/runs/gen/7b-rl_ve.jsonl ...
- 2026-10-21 02:27 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/stats.py --scores /home/unnitools/rtl-strict-eval/scores/7b-base.jsonl /home/unnitools/rtl-strict-eval/scores/7b-rl.jsonl /home/unnitools/rtl-strict-eval/scores/3b-rl.jsonl ...
- 2026-10-21 02:28 — phase10 G1b 7b-rl/ve: point=0.679 CI=[0.611, 0.744] anchor=0.688 -> PASS (rtllm loose: 0.7066666666666667 vs 0.68)
- 2026-10-21 02:28 — phase10 G1b 7b-sft/ve: point=0.637 CI=[0.566, 0.705] anchor=0.652 -> PASS (rtllm loose: 0.6266666666666666 vs 0.572)
- 2026-10-21 02:28 — phase10 G1b 7b-base/ve: point=0.288 CI=[0.233, 0.346] anchor=0.313 -> PASS (rtllm loose: 0.3466666666666666 vs 0.361)
- 2026-10-21 02:28 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/run_scoring.py --arm 7b-sft --gen /home/unnitools/runs/gen/7b-sft_rtllm.jsonl ...
- 2026-10-21 02:28 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/run_scoring.py --arm 7b-sft --gen /home/unnitools/runs/gen/7b-sft_ve.jsonl ...
- 2026-10-21 02:28 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/stats.py --scores /home/unnitools/rtl-strict-eval/scores/7b-base.jsonl /home/unnitools/rtl-strict-eval/scores/7b-rl.jsonl /home/unnitools/rtl-strict-eval/scores/3b-rl.jsonl ...
- 2026-10-21 02:28 — phase10 G1b 7b-rl/ve: point=0.679 CI=[0.611, 0.744] anchor=0.688 -> PASS (rtllm loose: 0.7066666666666667 vs 0.68)
- 2026-10-21 02:28 — phase10 G1b 7b-sft/ve: point=0.637 CI=[0.566, 0.705] anchor=0.652 -> PASS (rtllm loose: 0.6266666666666666 vs 0.572)
- 2026-10-21 02:28 — phase10 G1b 7b-base/ve: point=0.288 CI=[0.233, 0.346] anchor=0.313 -> PASS (rtllm loose: 0.3466666666666666 vs 0.361)
- 2026-10-21 02:28 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/run_scoring.py --arm 3b-rl --gen /home/unnitools/runs/gen/3b-rl_rtllm.jsonl ...
- 2026-10-21 02:28 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/run_scoring.py --arm 3b-rl --gen /home/unnitools/runs/gen/3b-rl_ve.jsonl ...
- 2026-10-21 02:28 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/run_scoring.py --arm 3b-base --gen /home/unnitools/runs/gen/3b-base_rtllm.jsonl ...
- 2026-10-21 02:28 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/run_scoring.py --arm 3b-base --gen /home/unnitools/runs/gen/3b-base_ve.jsonl ...
- 2026-10-21 02:28 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/run_scoring.py --arm 7b-base --gen /home/unnitools/runs/gen/7b-base_rtllm.jsonl ...
- 2026-10-21 02:28 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/run_scoring.py --arm 7b-base --gen /home/unnitools/runs/gen/7b-base_ve.jsonl ...
- 2026-10-21 02:28 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/stats.py --scores /home/unnitools/rtl-strict-eval/scores/7b-base.jsonl /home/unnitools/rtl-strict-eval/scores/7b-rl.jsonl /home/unnitools/rtl-strict-eval/scores/3b-rl.jsonl ...
- 2026-10-21 02:28 — phase10 G1b 7b-rl/ve: point=0.679 CI=[0.611, 0.744] anchor=0.688 -> PASS (rtllm loose: 0.7066666666666667 vs 0.68)
- 2026-10-21 02:28 — phase10 G1b 7b-sft/ve: point=0.637 CI=[0.566, 0.705] anchor=0.652 -> PASS (rtllm loose: 0.6266666666666666 vs 0.572)
- 2026-10-21 02:28 — phase10 G1b 7b-base/ve: point=0.288 CI=[0.233, 0.346] anchor=0.313 -> PASS (rtllm loose: 0.3466666666666666 vs 0.361)
- 2026-10-21 02:28 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/stats.py --scores /home/unnitools/rtl-strict-eval/scores/7b-base.jsonl /home/unnitools/rtl-strict-eval/scores/7b-rl.jsonl /home/unnitools/rtl-strict-eval/scores/3b-rl.jsonl ...
- 2026-10-21 02:29 — phase10 G1b 7b-rl/ve: point=0.679 CI=[0.611, 0.744] anchor=0.688 -> PASS (rtllm loose: 0.7066666666666667 vs 0.68)
- 2026-10-21 02:29 — phase10 G1b 7b-sft/ve: point=0.637 CI=[0.566, 0.705] anchor=0.652 -> PASS (rtllm loose: 0.6266666666666666 vs 0.572)
- 2026-10-21 02:29 — phase10 G1b 7b-base/ve: point=0.288 CI=[0.233, 0.346] anchor=0.313 -> PASS (rtllm loose: 0.3466666666666666 vs 0.361)
- 2026-10-21 02:29 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/stats.py --scores /home/unnitools/rtl-strict-eval/scores/7b-base.jsonl /home/unnitools/rtl-strict-eval/scores/7b-rl.jsonl /home/unnitools/rtl-strict-eval/scores/3b-rl.jsonl ...
- 2026-10-21 02:29 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/stats.py --scores /home/unnitools/rtl-strict-eval/scores/7b-base.jsonl /home/unnitools/rtl-strict-eval/scores/7b-rl.jsonl /home/unnitools/rtl-strict-eval/scores/3b-rl.jsonl ...
- 2026-10-21 02:30 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/dedup.py --gen /home/unnitools/runs/gen/7b-rl_rtllm.jsonl /home/unnitools/runs/gen/7b-rl_ve.jsonl /home/unnitools/runs/gen/7b-sft_rtllm.jsonl ...
- 2026-10-21 02:30 — phase10 dedup rc=0: ys_failures": 281,
 "extraction_empty": 49,
 "per_arm": {
  "3b-base": {
   "rows": 618,
   "unique": 552
  },
  "3b-rl": {
   "rows": 618,
   "unique": 541
  },
  "7b-base": {
   "rows": 618,
   "unique": 567
  },
  "7b-rl": {
   "rows": 618,
   "unique": 472
  },
  "7b-sft": {
   "rows": 618,
   "unique": 460
  }
 }
}
wrote /home/unnitools/rtl-strict-eval/results/main/dedup_map.json (3090 keys)

- 2026-10-21 02:30 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/stats.py --scores /home/unnitools/rtl-strict-eval/scores/7b-base.jsonl /home/unnitools/rtl-strict-eval/scores/7b-rl.jsonl /home/unnitools/rtl-strict-eval/scores/3b-rl.jsonl ...
- 2026-10-21 02:31 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/stats.py --scores /home/unnitools/rtl-strict-eval/scores/7b-base.jsonl /home/unnitools/rtl-strict-eval/scores/7b-rl.jsonl /home/unnitools/rtl-strict-eval/scores/3b-rl.jsonl ...
- 2026-10-21 02:31 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/stats.py --scores /home/unnitools/rtl-strict-eval/scores/7b-base.jsonl /home/unnitools/rtl-strict-eval/scores/7b-rl.jsonl /home/unnitools/rtl-strict-eval/scores/3b-rl.jsonl ...
- 2026-10-21 02:32 — phase10: /home/unnitools/.venvs/host/bin/python /home/unnitools/rtl-strict-eval/scoring/blind40.py --scores /home/unnitools/rtl-strict-eval/scores/7b-base.jsonl /home/unnitools/rtl-strict-eval/scores/7b-rl.jsonl /home/unnitools/rtl-strict-eval/scores/3b-rl.jsonl ...
- 2026-10-21 02:32 — phase10 blind40 rc=0: },
  "3b-rl|rtllm": {
   "population": 6,
   "drawn": 3
  },
  "7b-base|rtllm": {
   "population": 9,
   "drawn": 5
  },
  "7b-base|ve": {
   "population": 3,
   "drawn": 2
  },
  "7b-rl|rtllm": {
   "population": 25,
   "drawn": 13
  },
  "7b-rl|ve": {
   "population": 5,
   "drawn": 3
  },
  "7b-sft|rtllm": {
   "population": 20,
   "drawn": 11
  },
  "7b-sft|ve": {
   "population": 1,
   "drawn": 0
  }
 }
}
key: /home/unnitools/runs/blind40_key.json (outside the repo; commit only its sha256)

- 2026-10-21 02:32 — phase10 blind40 key sha256=cdb4a18bd1dc38abf126f4a904fec1297812b681f60da105636145829692c317 (key stays outside the repo)
- 2026-10-21 02:32 — phase10 summary written: results/main/summary.md
- 2026-10-21 02:32 — phase10: complete — summary.md written; waiting for G3 review and blind labels
- 2026-10-21 02:32 — [chain] pushed: A18 phase 10: scoring + analysis complete (results/main/summary.md)
- 2026-10-21 02:32 — [chain] pushed: A18: phase 10 report status (STOP waiting for G3 review + blind labels)
- 2026-10-21 02:55 — [chain] PHASE10 DONE (02:32): G2 pass (alias + waivers), G1b PASS all anchors on complete data, strict/dedup/contamination/stats/blind40 complete; summary.md + figure written; pushed. A19 §4 sensitivity: stats + side-by-side in results/sens/summary.md (3b-rl clears G2 with headroom; 3b-base rtllm still 0.94, all length; conclusions insensitive to the cap). Full A18 §8 + A19 run complete; awaiting G3 review + blind labels.

## 2026-10-21 ~12:20–13:00 — A20 session opens: Part A close-out (operator present)
- A6 blind-40 key: sha256 of ~/runs/blind40_key.json == results/main/blind40/KEY_SHA256
  (cdb4a18bd1dc38abf126f4a904fec1297812b681f60da105636145829692c317); read-only backup
  ~/runs/blind40_key.backup.json created, same sha256 verified. Contents never printed.
- Housekeeping: stale orphaned yosys-smtbmc worker (pid 325034, 0 CPU, futex-wait since the
  Oct-20 arm-parallel scoring era, cwd ~/runs/scoring/7b-rl/rtllm_adder_bcd_0) killed.
- A2 ots: `ots upgrade PREREG-A19.md.ots` SUCCESS (Bitcoin attestations blocks 972344/972346/
  972355/972387); `ots upgrade PREREG.md.ots` re-run SUCCESS (3 Bitcoin attestations, blocks
  972099/972100/972115; the 4th calendar branch remains a pending remote attestation — the
  timestamp is complete with on-chain evidence; `ots verify` needs a local bitcoind, absent
  here, so `ots info` block attestations are the recorded evidence, as at G0). Both .ots to be
  committed this Part A.
- A1: results/main/g2.txt written — final G2 gate output regenerated by running the pinned
  scoring/extract.py (A19 alias in force) over all 10 primary generation files; all 10 shares
  reproduce the PREREG-A19 §1 table exactly; the two waivers named with pinned counts
  (3b-rl_ve 444/468=0.9487, 3b-base_rtllm 141/150=0.9400).
- A3: results/sens/releases/{3b-rl-cap,3b-base-cap}.tar.gz built with the same deterministic
  recipe as the main arms (tar czf --transform); inner file sha256s verified equal to
  results/sens/GEN_SHA256 (all 4); per-arm manifests written beside them
  (<arm>.manifest.json, same fields as gen/manifests/<arm>.json + release_tar_sha256:
  3b-rl-cap fb3ef315fe78dc7f..., 3b-base-cap d991533ab99b6d1d...).
- A4: notes/runlogs/ — overnight_chain.log + all 10 ~/runs/gen/log_* + all 4
  ~/runs/gen_sens/log_* gzipped in (token-pattern scan of the sources: no matches).
- Pre-push guard (local hook): tag allow-list extended with refs/tags/phase10-results for the
  A20-mandated tag (cause fixed, not bypassed; --no-verify forbidden and unused). Self-tested
  the Phase-1b way with synthetic stdin lines against the correct remote URL:
  refs/tags/phase10-results -> exit 0; refs/tags/other-tag -> exit 1 "not allowed";
  refs/heads/main -> exit 1 "not allowed".
- 2026-10-21 14:17 — e1: merging adapter /home/unnitools/runs/smoke_S_lr6/final_adapter -> /home/unnitools/runs/e1_models/smoke_s6
- 2026-10-21 14:17 — e1: merge smoke_s6 rc=1 (log ~/runs/e1_merge_smoke_s6.log)
- 2026-10-21 14:17 — e1: merge failed for smoke_s6 rc=1 — skipping arm
- 2026-10-21 14:42 — e1: merging adapter /home/unnitools/runs/smoke_fix_W/final_adapter -> /home/unnitools/runs/e1_models/smoke_fixw
- 2026-10-21 14:43 — e1: merge smoke_fixw rc=0 (log ~/runs/e1_merge_smoke_fixw.log)
- 2026-10-21 14:43 — e1: generating e1-smoke_fixw/ve (T=0.2, top_p=0.95, n=1, max_tokens=2048, mml=4096)
- 2026-10-21 14:44 — e1: e1-smoke_fixw/ve rc=0 log=/home/unnitools/runs/gen_e1_smoke/log_e1-smoke_fixw_ve.txt
- 2026-10-21 14:44 — e1: generating e1-smoke_fixw/rtllm (T=0.2, top_p=0.95, n=1, max_tokens=2048, mml=4096)
- 2026-10-21 14:46 — e1: e1-smoke_fixw/rtllm rc=0 log=/home/unnitools/runs/gen_e1_smoke/log_e1-smoke_fixw_rtllm.txt

## 2026-10-21 13:00–15:10 — A20 Part B: Phase 9 + E1 code, smoke, PREREG-A20
- Code built (grpo/train_grpo.py extended: --lr, --heldout-seed + pinned-list hard check,
  10-step checkpoints, --resume-from-checkpoint, B2 CSV callback incl. both held-out rates;
  new e1/{make_prompts,merge_adapter,run_e1,report}.py; new a20/{supervisor,plot,smoke.sh,
  run_supervisor.sh}). scorer/ and scoring/ untouched; gen/gen_vllm.py untouched (E1 uses the
  merge path). E1 prompt lists: prompts/built_e1/ VE 144 + RTLLM 33 from the committed gates.
- Smoke (a20/smoke.sh): 4 runs (W/S x lr 1e-6/1e-5, 2 steps, callback-every 1, save-steps 1,
  full 64-row held-out eval) + resume check + E1 path check. All four B6 checks PASS. Three
  defects found and fixed pre-stamp: (1) TRL's end-of-train summary arrives via on_log and
  wrote a duplicate empty-window final CSV row -> on_log now acts only on per-step logs
  (smoke_fix_W proves the fix: step-2 row stays full); (2) merge container lacked peft ->
  pip install peft==0.21.2 added; (3) E1 smoke mount shadowing -> gen dir mounted at /genout,
  ~/runs at /runs. Facts: held-out eval ~6.5 min; step ~66-70 s; brief arm ~3.2 h, ext arm
  ~8.5-9 h projected; reward wall 0.15 s/call (S); peak GPU ~43 GiB.
- PREREG-A20.md written (settings, dataset pin: train_tb_filtered.jsonl rev 42823db...,
  sha256 ca03fa1b..., 1149 rows; held-out 64 indices via random.Random(20261021) listed and
  committed as grpo/heldout_indices.txt; B2 columns; KL null by construction (beta=0, entropy
  logged); extension setting; E1 spec; run rules incl. deadline 30 Oct 20:00 +08 and the
  between-jobs deadline check; 14 code+artifact pins verified file-by-file).
- 2026-10-21 14:54 — [a20] supervisor up (pid 830881, inhibitor pid 830887); deadline 2026-10-30 20:00:00, end of mission 2026-10-31 23:59:00
- 2026-10-21 14:54 — [a20] Part C starts: brief W -> brief S -> E1(base,w100,s100) -> ext W -> ext S -> E1(wext,sext) -> final
- 2026-10-21 14:54 — [a20] grpo_brief_W: starting (steps=100 lr=1e-06 resume=none)
- 2026-10-21 14:54 — [a20] heartbeat ots upgrade PREREG.md.ots: Success! Timestamp complete
- 2026-10-21 14:54 — [a20] heartbeat ots upgrade PREREG-A19.md.ots: Success! Timestamp complete
- 2026-10-21 14:54 — [a20] heartbeat ots upgrade PREREG-A20.md.ots: Failed! Timestamp not complete
- 2026-10-21 14:54 — [a20] grpo_brief_W: INCOMPLETE — rc=2 with no checkpoint to resume from
