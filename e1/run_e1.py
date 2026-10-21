#!/usr/bin/env python3
"""e1/run_e1.py — E1 driver (PREREG-A20 B4): generation + G2 + scoring.

Host-side, from the repo root. One heavy job at a time (generation in the
vLLM container, scoring on the host with WORKERS like Phase 10).

E1 arms: e1-base (the raw GRPO-stretch base), e1-w100 / e1-s100 (brief
setting finals), e1-wext / e1-sext (extension finals). Trained arms are
merged LoRA→bf16 copies under ~/runs/e1_models/ (e1/merge_adapter.py; weights
never in git, sha256 records under results/e1/models/).

Generation (B4): the gated sets only — prompts/built_e1/verireason_gated_ve
(144) and _rtllm (33, headline); the same system prompt as in training
(verireason.txt); the same prompt-building code as the primary arms
(gen/gen_vllm.py over the committed built rows); the 3B arms' sampling
settings (T 0.2, top_p 0.95, n 3, per-task seed rule, max_model_len 4096) but
max_tokens 2048 for every arm. Output rows land in ~/runs/gen_e1/ (arm names
e1-*), scores in scores_e1/ (committed like scores/), cex under results/e1/.

Usage:
  python3 e1/run_e1.py --arms base w100 s100
  python3 e1/run_e1.py --arms w100 --merge w100:/runs/grpo_brief_W/final_adapter
  python3 e1/run_e1.py --arms base --smoke   (2 tasks, n=1, smoke dirs)
"""
import argparse
import glob
import json
import os
import subprocess
import sys
import time

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RUNS = os.path.expanduser("~/runs/gen_e1")
HF = os.path.expanduser("~/hf")
MODELS = os.path.expanduser("~/runs/e1_models")
IMAGE = "nvcr.io/nvidia/vllm:26.05.post1-py3"
BASE_SNAP = ("/models-hf/hub/models--Qwen--Qwen2.5-Coder-1.5B-Instruct/snapshots/"
             "2e1fd397ee46e1388853d2af2c993145b0f1098a")
BASE_REV = "2e1fd397ee46e1388853d2af2c993145b0f1098a"
LOGMD = os.environ.get("A20_LOG", os.path.join(REPO, "notes/LOG.md"))


def log(msg):
    line = f"- {time.strftime('%Y-%m-%d %H:%M')} — {msg}"
    print(line, flush=True)
    with open(LOGMD, "a") as f:
        f.write(line + "\n")


def model_path(arm):
    return BASE_SNAP if arm == "base" else f"/runs/e1_models/{arm}"


def revision(arm):
    return BASE_REV if arm == "base" else f"e1-merged-{arm}"


def docker_gen(arm, bench, n, limit, runs_dir, out_root):
    out_arm = f"e1-{arm}"
    out = os.path.join(runs_dir, f"{out_arm}_{bench}.jsonl")
    logf = os.path.join(runs_dir, f"log_{out_arm}_{bench}.txt")
    prompts = f"/work/prompts/built_e1/verireason_gated_{bench}.jsonl"
    cmd = ("sg docker -c 'docker run --rm --gpus all --ipc=host "
           "--ulimit memlock=-1 --ulimit stack=67108864 "
           f"-v {HF}:/models-hf -v {REPO}:/work -v {os.path.expanduser('~/runs')}:/runs "
           f"-v {runs_dir}:/genout {IMAGE} "
           f"python3 /work/gen/gen_vllm.py --arm {out_arm} --model {model_path(arm)} "
           f"--revision {revision(arm)} --prompts {prompts} "
           "--system /work/prompts/system_prompts/verireason.txt "
           f"--n {n} --max-tokens 2048 --temperature 0.2 --top-p 0.95 "
           "--max-model-len 4096 "
           f"--log-effective-params /genout/{out_arm}_{bench}_effective_params.json "
           f"--timing-out /genout/{out_arm}_{bench}.timing.json --out /genout/{os.path.basename(out)}"
           + (f" --limit {limit}" if limit else "")
           + f"' > {logf} 2>&1")
    log(f"e1: generating {out_arm}/{bench} (T=0.2, top_p=0.95, n={n}, max_tokens=2048, mml=4096)")
    p = subprocess.run(["bash", "-c", cmd])
    log(f"e1: {out_arm}/{bench} rc={p.returncode} log={logf}")
    return p.returncode, out


def complete(arm, bench, n, runs_dir):
    out = os.path.join(runs_dir, f"e1-{arm}_{bench}.jsonl")
    if not os.path.isfile(out):
        return False
    prompts = os.path.join(REPO, f"prompts/built_e1/verireason_gated_{bench}.jsonl")
    ids = [json.loads(l)["task_id"] for l in open(prompts, encoding="utf-8")]
    want = {(t, s) for t in ids for s in range(n)}
    have = set()
    with open(out, encoding="utf-8") as fh:
        for l in fh:
            r = json.loads(l)
            have.add((r["task_id"], r["sample_idx"]))
    return want <= have


def docker_merge(arm, adapter):
    out = os.path.join(MODELS, arm)
    sha_out = os.path.join(REPO, f"results/e1/models/{arm}.sha256.json")
    os.makedirs(os.path.dirname(sha_out), exist_ok=True)
    adapter_c = adapter.replace(os.path.expanduser("~/runs"), "/runs")
    cmd = ("sg docker -c 'docker run --rm --gpus all --ipc=host "
           f"-v {HF}:/models-hf -v {REPO}:/work -v {os.path.expanduser('~/runs')}:/runs {IMAGE} "
           f"bash -lc \"pip install -q peft==0.21.2 && python3 /work/e1/merge_adapter.py "
           f"--base {BASE_SNAP} --adapter {adapter_c} "
           f"--out /runs/e1_models/{arm} --sha-out /work/{os.path.relpath(sha_out, REPO)}\"'"
           " > %s 2>&1" % os.path.join(os.path.expanduser("~/runs"), f"e1_merge_{arm}.log"))
    log(f"e1: merging adapter {adapter} -> {out}")
    p = subprocess.run(["bash", "-c", cmd])
    log(f"e1: merge {arm} rc={p.returncode} (log ~/runs/e1_merge_{arm}.log)")
    return p.returncode


def g2_check(files):
    """B4: run the extraction check on every E1 file; report as-is (no waivers)."""
    res = {}
    for f in files:
        p = subprocess.run([sys.executable, os.path.join(REPO, "scoring/extract.py"),
                            "--gen", f], capture_output=True, text=True)
        share = None
        for l in p.stdout.splitlines():
            if l.startswith("{") and '"share"' in l:
                try:
                    share = json.loads(l)
                except Exception:
                    pass
        res[os.path.basename(f)] = share
        log(f"e1 G2 {os.path.basename(f)}: rc={p.returncode} "
            f"share={(share or {}).get('share')} (exploratory: reported as-is, no waivers)")
    out = os.path.join(REPO, "results/e1/g2.json")
    os.makedirs(os.path.dirname(out), exist_ok=True)
    json.dump(res, open(out, "w"), indent=1)
    return res


def score_arm(arm, runs_dir):
    out_arm = f"e1-{arm}"
    out = os.path.join(REPO, f"scores_e1/{out_arm}.jsonl")
    os.makedirs(os.path.dirname(out), exist_ok=True)
    for bench in ("ve", "rtllm"):
        f = os.path.join(runs_dir, f"{out_arm}_{bench}.jsonl")
        if not os.path.isfile(f):
            continue
        p = subprocess.run([sys.executable, os.path.join(REPO, "scoring/run_scoring.py"),
                            "--arm", out_arm, "--gen", f, "--out", out,
                            "--workers", str(max(1, (os.cpu_count() or 4) - 2)),
                            "--sat-timeout", "60",
                            "--cex-out", os.path.join(REPO, "results/e1/cex")])
        if p.returncode != 0:
            log(f"e1: run_scoring {out_arm}/{bench} rc={p.returncode} — STOP")
            return False
    return True


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--arms", nargs="+", required=True,
                    help="subset of: base w100 s100 wext sext")
    ap.add_argument("--merge", action="append", default=[],
                    help="arm:/path/to/adapter — merge before generating")
    ap.add_argument("--n", type=int, default=3)
    ap.add_argument("--limit", type=int, default=0, help="smoke: only first K tasks")
    ap.add_argument("--smoke", action="store_true", help="use smoke dirs, skip scoring")
    args = ap.parse_args()

    runs_dir = os.path.expanduser("~/runs/gen_e1_smoke") if args.smoke else RUNS
    os.makedirs(runs_dir, exist_ok=True)
    os.makedirs(MODELS, exist_ok=True)

    merges = dict(m.split(":", 1) for m in args.merge)
    for arm in args.arms:
        if arm in merges:
            rc = docker_merge(arm, merges[arm])
            if rc != 0:
                log(f"e1: merge failed for {arm} rc={rc} — skipping arm")
                continue
        for bench in ("ve", "rtllm"):
            if not args.smoke and complete(arm, bench, args.n, runs_dir):
                log(f"e1: e1-{arm}/{bench} complete — resume skip")
                continue
            rc, _ = docker_gen(arm, bench, args.n, args.limit, runs_dir, RUNS)
            if rc != 0:
                log(f"e1: generation failed e1-{arm}/{bench} rc={rc} — skipping bench")
    if args.smoke:
        print("E1 smoke generation done (no scoring)")
        return 0
    files = sorted(glob.glob(os.path.join(runs_dir, "e1-*_*.jsonl")))
    if not files:
        log("e1: nothing generated — nothing to score")
        return 1
    g2_check(files)
    ok = True
    for arm in args.arms:
        if not score_arm(arm, runs_dir):
            ok = False
    log(f"e1: scoring done ok={ok}; report: python3 e1/report.py")
    return 0 if ok else 1


if __name__ == "__main__":
    raise SystemExit(main())
