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
