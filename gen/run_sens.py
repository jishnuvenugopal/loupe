#!/usr/bin/env python3
"""gen/run_sens.py — A19 §4: sensitivity regeneration of the two 3B arms with
generation headroom. NOT part of the primary run: outputs go to
~/runs/gen_sens/ and are scored as 3b-rl-cap / 3b-base-cap into scores_sens/.
Never merged into ~/runs/gen/, scores/, the primary stats invocations, the
blind-40 population, or any primary contrast.

Changed vs the pinned 3B settings (both documented in PREREG-A19 §4):
max_new_tokens 2048 -> 3072, max_model_len 4096 -> 5120.
Unchanged: models/revisions, prompts, system prompts, n=3, per-task seed rule,
T=0.2, top_p=0.95, top_k=-1, min_p=0, repetition_penalty=1.0.

Usage: python3 gen/run_sens.py           (host, from the repo root)
"""
import os
import subprocess
import sys
import time

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SENS = os.path.expanduser("~/runs/gen_sens")
HF = os.path.expanduser("~/hf")
IMAGE = "nvcr.io/nvidia/vllm:26.05.post1-py3"
LOGMD = os.environ.get("CHAIN_LOG", os.path.join(REPO, "notes/LOG.md"))

REV = {
    "3b-rl": "3b93ce1bd7e5d90dae8761363a9c6862d0ed583a",
    "3b-base": "488639f1ff808d1d3d0ba301aef8c11461451ec5",
}
ID = {
    "3b-rl": "Nellyw888/VeriReason-Qwen2.5-3b-RTLCoder-Verilog-GRPO-reasoning-tb",
    "3b-base": "Qwen/Qwen2.5-Coder-3B-Instruct",
}
MAXTOK = 3072   # A19 §4 (was 2048)
MML = 5120      # A19 §4 (was 4096; longest rtllm prompt ~1.5k tokens)


def log(msg):
    line = f"- {time.strftime('%Y-%m-%d %H:%M')} — {msg}"
    print(line, flush=True)
    with open(LOGMD, "a") as fh:
        fh.write(line + "\n")


def main():
    os.makedirs(SENS, exist_ok=True)
    rc_all = 0
    for arm in ("3b-rl", "3b-base"):
        model = f"/models-hf/hub/models--{ID[arm].replace('/', '--')}/snapshots/{REV[arm]}"
        for bench in ("ve", "rtllm"):
            out_arm = f"{arm}-cap"
            prompts = f"/work/prompts/built/verireason_{bench}.jsonl"
            logf = os.path.join(SENS, f"log_{out_arm}_{bench}.txt")
            cmd = (
                "sg docker -c 'docker run --rm --gpus all --ipc=host "
                "--ulimit memlock=-1 --ulimit stack=67108864 "
                f"-v {HF}:/models-hf -v {REPO}:/work -v {SENS}:/runs {IMAGE} "
                f"python3 /work/gen/gen_vllm.py --arm {out_arm} --model {model} "
                f"--revision {REV[arm]} --prompts {prompts} "
                "--system /work/prompts/system_prompts/verireason.txt "
                f"--n 3 --max-tokens {MAXTOK} --temperature 0.2 --top-p 0.95 "
                f"--max-model-len {MML} "
                f"--log-effective-params /runs/{out_arm}_{bench}_effective_params.json "
                f"--timing-out /runs/{out_arm}_{bench}.timing.json "
                f"--out /runs/{out_arm}_{bench}.jsonl'"
                + f" > {logf} 2>&1")
            log(f"sens: generating {out_arm}/{bench} (T=0.2, top_p=0.95, n=3, "
                f"max_tokens={MAXTOK}, mml={MML})")
            t0 = time.time()
            p = subprocess.run(["bash", "-c", cmd])
            log(f"sens: {out_arm}/{bench} rc={p.returncode} "
                f"wall={(time.time() - t0) / 60:.1f} min log={logf}")
            rc_all |= p.returncode
            if p.returncode != 0:
                return rc_all
    log("sens: all sensitivity generation done")
    return rc_all


if __name__ == "__main__":
    raise SystemExit(main())
