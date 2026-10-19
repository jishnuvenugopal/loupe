#!/usr/bin/env python3
"""Phase 8 overnight generation runner (ONLY after the G0 steps; A16 §5; run
inside the overnight chain's tmux). Docker-driven version (A18): every arm x
benchmark runs in its own vLLM container with the pinned flags.

Order per A16 §3 step 4: 7B RL -> 7B Distill -> 3B RL -> 3B base -> Qwen 7B base
(base arms last because they are cut first; 3B SFT dropped by H0-a).
Resumable: gen_vllm.py skips (task_id, sample_idx) already written.

Cuts are applied ONLY as PREREG states (the ladder result is written by the
chain to gen/cut.txt after A18 §8 C4): ve-subset-60, n-3-to-2, drop-7b-base,
drop-3b-base, or none. Never max tokens, never an SFT arm.

Throughput checks (A16 §5 step 3): 30 minutes into generation, and again when
the first 3B arm starts -> gen/throughput_check.py, recorded in
~/runs/gen/throughput_checks.jsonl (copied into the repo at the end).

Usage: python3 gen/run_overnight.py            (host, from the repo root)
Env:  CHAIN_LOG (optional) — notes/LOG.md path for timestamped entries.
"""
import json
import os
import subprocess
import sys
import time

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RUNS = os.path.expanduser("~/runs/gen")
HF = os.path.expanduser("~/hf")
IMAGE = "nvcr.io/nvidia/vllm:26.05.post1-py3"
LOGMD = os.environ.get("CHAIN_LOG", os.path.join(REPO, "notes/LOG.md"))

REV = {
    "7b-rl": "286cf433f596f1b8525529c1163eb81c19425c22",
    "7b-sft": "8fdb92e328cb2a98ef9a3f9dcd82995a2112bd9c",
    "7b-base": "c03e6d358207e414f1eca0bb1891e29f1db0e242",
    "3b-rl": "3b93ce1bd7e5d90dae8761363a9c6862d0ed583a",
    "3b-base": "488639f1ff808d1d3d0ba301aef8c11461451ec5",
}
ID = {
    "7b-rl": "zhuyaoyu/CodeV-R1-RL-Qwen-7B",
    "7b-sft": "zhuyaoyu/CodeV-R1-Distill-Qwen-7B",
    "7b-base": "Qwen/Qwen2.5-Coder-7B-Instruct",
    "3b-rl": "Nellyw888/VeriReason-Qwen2.5-3b-RTLCoder-Verilog-GRPO-reasoning-tb",
    "3b-base": "Qwen/Qwen2.5-Coder-3B-Instruct",
}
TEMP = {"7b-rl": 1.0, "7b-sft": 0.6, "7b-base": 1.0, "3b-rl": 0.2, "3b-base": 0.2}
MAXTOK = {"7b-rl": 16384, "7b-sft": 16384, "7b-base": 16384, "3b-rl": 2048, "3b-base": 2048}
MML = {"7b-rl": 20480, "7b-sft": 20480, "7b-base": 20480, "3b-rl": 4096, "3b-base": 4096}
TOP_P = {"ve": 1.0, "rtllm": 0.95}          # CodeV paper; VeriReason 0.95 both
ORDER = ["7b-rl", "7b-sft", "3b-rl", "3b-base", "7b-base"]


def log(msg):
    line = f"- {time.strftime('%Y-%m-%d %H:%M')} — {msg}"
    print(line, flush=True)
    with open(LOGMD, "a") as f:
        f.write(line + "\n")


def cut():
    p = os.path.join(REPO, "gen/cut.txt")
    return open(p).read().strip() if os.path.isfile(p) else "none"


def ve_prompts_file(family, cut_step):
    src = os.path.join(REPO, f"prompts/built/{family}_ve.jsonl")
    if cut_step in ("ve-subset-60", "n-3-to-2", "drop-7b-base", "drop-3b-base"):
        sub = set(open(os.path.join(REPO, "gen/ve_subset60.txt")).read().split())
        dst = os.path.join(RUNS, f"prompts_{family}_ve_60.jsonl")
        os.makedirs(RUNS, exist_ok=True)
        with open(dst, "w") as f:
            for l in open(src):
                if json.loads(l)["task_id"] in sub:
                    f.write(l)
        return dst, 60
    return src, 156


def in_container(path):
    """Map a host path to the container view: REPO->/work, ~/runs/gen->/runs."""
    if path.startswith(REPO):
        return "/work/" + os.path.relpath(path, REPO)
    if path.startswith(RUNS):
        return "/runs/" + os.path.relpath(path, RUNS)
    raise SystemExit(f"path not mounted in container: {path}")


def complete(arm, bench, n):
    """True if <arm>_<bench>.jsonl already holds every (task_id, sample_idx)
    cell (Phase 8 resume skip; keeps timing.json / effective_params intact)."""
    out = os.path.join(RUNS, f"{arm}_{bench}.jsonl")
    if not os.path.isfile(out):
        return False
    family = "codev" if arm.startswith("7b") else "verireason"
    if bench == "ve":
        prompts, _ = ve_prompts_file(family, cut())
    else:
        prompts = os.path.join(REPO, f"prompts/built/{family}_rtllm.jsonl")
    ids = [json.loads(l)["task_id"] for l in open(prompts, encoding="utf-8")]
    want = {(t, s) for t in ids for s in range(n)}
    have = set()
    with open(out, encoding="utf-8") as fh:
        for l in fh:
            r = json.loads(l)
            have.add((r["task_id"], r["sample_idx"]))
    return want <= have


def gen_arm_bench(arm, bench, n):
    if complete(arm, bench, n):
        log(f"phase8: {arm}/{bench} output complete — resume skip "
            f"(timing/log/params untouched)")
        return 0, os.path.join(RUNS, f"log_{arm}_{bench}.txt")
    family = "codev" if arm.startswith("7b") else "verireason"
    top_p = 0.95 if family == "verireason" else TOP_P[bench]
    cut_step = cut()
    if bench == "ve":
        prompts, _ = ve_prompts_file(family, cut_step)
    else:
        prompts = os.path.join(REPO, f"prompts/built/{family}_rtllm.jsonl")
    model = f"/models-hf/hub/models--{ID[arm].replace('/', '--')}/snapshots/{REV[arm]}"
    out = os.path.join(RUNS, f"{arm}_{bench}.jsonl")
    logf = os.path.join(RUNS, f"log_{arm}_{bench}.txt")
    sysp = f"/work/prompts/system_prompts/{family}.txt"
    cmd = ("sg docker -c 'docker run --rm --gpus all --ipc=host "
           "--ulimit memlock=-1 --ulimit stack=67108864 "
           f"-v {HF}:/models-hf -v {REPO}:/work -v {RUNS}:/runs {IMAGE} "
           f"python3 /work/gen/gen_vllm.py --arm {arm} --model {model} --revision {REV[arm]} "
           f"--prompts {in_container(prompts)} --system {sysp} "
           f"--n {n} --max-tokens {MAXTOK[arm]} --temperature {TEMP[arm]} --top-p {top_p} "
           f"--max-model-len {MML[arm]} "
           f"--log-effective-params /runs/{arm}_{bench}_effective_params.json "
           f"--timing-out /runs/{arm}_{bench}.timing.json --out /runs/{os.path.basename(out)}'"
           + f" > {logf} 2>&1")
    log(f"phase8: generating {arm}/{bench} (T={TEMP[arm]}, top_p={top_p}, n={n}, "
        f"max_tokens={MAXTOK[arm]}, mml={MML[arm]}, cut={cut_step})")
    t0 = time.time()
    p = subprocess.run(["bash", "-c", cmd])
    log(f"phase8: {arm}/{bench} rc={p.returncode} wall={(time.time() - t0) / 60:.1f} min "
        f"log={logf}")
    return p.returncode, logf


def check(label, logf, gen_file):
    subprocess.run([sys.executable, os.path.join(REPO, "gen/throughput_check.py"),
                    "--log", logf, "--label", label, "--gen-file", gen_file],
                   check=False)


def main():
    cut_step = cut()
    n = 2 if cut_step in ("n-3-to-2", "drop-7b-base", "drop-3b-base") else 3
    arms = [a for a in ORDER
            if not (cut_step == "drop-7b-base" and a == "7b-base")
            and not (cut_step == "drop-3b-base" and a == "3b-base")]
    log(f"phase8 start: arms={arms} n={n} cut={cut_step} "
        f"(RTLLM n=5: no — A18 §8 C4; overlap probe skipped — score nothing "
        f"until generation ends)")
    os.makedirs(RUNS, exist_ok=True)
    t_start = time.time()
    first_3b_check_done = False
    rc_all = 0
    for arm in arms:
        if arm.startswith("3b") and not first_3b_check_done:
            # A16 §5 step 3: throughput check again when the first 3B arm starts
            # (skip on resume when that arm's generation is already complete,
            # so a re-launch never duplicates the check entry)
            prev = [a for a in arms if arms.index(a) < arms.index(arm)]
            if prev and not complete(arm, "ve", n):
                lg = os.path.join(RUNS, f"log_{prev[-1]}_rtllm.txt")
                check("first-3B-arm check", lg,
                      os.path.join(RUNS, f"{prev[-1]}_rtllm.jsonl"))
            first_3b_check_done = True
        for bench in ("ve", "rtllm"):
            rc, logf = gen_arm_bench(arm, bench, n)
            rc_all |= rc
            if rc != 0:
                log(f"phase8: {arm}/{bench} FAILED rc={rc} — stopping the arm ladder")
                return rc
    log("phase8: all generation done")
    return rc_all


if __name__ == "__main__":
    # 30-min check while the first batch generates: spawn the watcher first
    import threading

    def thirty_min_check():
        time.sleep(1800)
        import glob
        cands = sorted(glob.glob(os.path.join(RUNS, "log_*.txt")), key=os.path.getmtime)
        if cands:
            lg = cands[-1]
            base = os.path.basename(lg)[len("log_"):-len(".txt")]
            check("30-min check", lg, os.path.join(RUNS, f"{base}.jsonl"))

    threading.Thread(target=thirty_min_check, daemon=True).start()
    raise SystemExit(main())
