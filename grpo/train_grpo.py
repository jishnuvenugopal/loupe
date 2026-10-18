#!/usr/bin/env python3
"""GRPO driver (brief Phase 6 step 4 trial / Phase 9 arms W and S).

Runs INSIDE a container with: ~/hf -> /models-hf, ~/rtl-strict-eval -> /work,
~/eda -> /eda (and /root/eda), ~/runs -> /runs.

TRL 1.16.0 / PEFT 0.21.2 on vLLM 0.21.0 (nvcr.io/nvidia/vllm:26.05.post1-py3)
was the "newest TRL in the vLLM container" lane; the fallback image pins
trl==0.26.1 with use_vllm=False (brief). GRPOConfig values are the brief's
verbatim; one extra operational arg is set: max_prompt_length=1024 (TRL's
default 512 would truncate dataset instructions mid-spec).

Measurements recorded (brief step 4): step time, reward wall time per step,
peak memory, zero-advantage fraction (groups of num_generations where every
completion got the same reward). Writes /runs/grpo/trial_<arm>_metrics.json.
"""
import argparse
import json
import os
import re
import subprocess
import time

os.environ.setdefault("EDA_BIN", "/eda/oss-cad-suite/bin")
import sys
sys.path.insert(0, "/work")
sys.path.insert(0, "/work/grpo")
import reward as R  # noqa: E402  (sets EDA via env above through common.py import? see below)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--arm", default="S", choices=["W", "S"])
    ap.add_argument("--steps", type=int, default=2)
    ap.add_argument("--model", default="/models-hf/hub/models--Qwen--Qwen2.5-Coder-1.5B-Instruct/snapshots/2e1fd397ee46e1388853d2af2c993145b0f1098a")
    ap.add_argument("--dataset", default="/models-hf/hub/datasets--Nellyw888--VeriReason-RTL-Coder_7b_reasoning_tb/snapshots/42823db968114c25da260dece0e4bea8ab20d573/train_tb_filtered.jsonl")
    ap.add_argument("--out", default="/runs/grpo")
    args = ap.parse_args()
    mode = "weak" if args.arm == "W" else "strict"

    # make the frozen scorer machinery find the EDA tools inside the container
    import common as C
    if os.path.isdir(os.environ["EDA_BIN"]):
        C.EDA = os.environ["EDA_BIN"]
        C.ENV = dict(os.environ, PATH=C.EDA + ":" + os.environ["PATH"])

    from datasets import Dataset
    from trl import GRPOConfig, GRPOTrainer
    from peft import LoraConfig

    rows = [json.loads(l) for l in open(args.dataset)]
    SYSTEM = open("/work/prompts/system_prompts/verireason.txt", encoding="utf-8").read()
    ds = Dataset.from_list([
        {"prompt": [{"role": "system", "content": SYSTEM},
                    {"role": "user", "content": r["instruction"]}],
         "row_idx": i}
        for i, r in enumerate(rows)])

    reward_log = {"calls": 0, "wall_s": 0.0, "rewards": [], "t_call": []}

    def reward_fn(completions, row_idx=None, **kw):
        t0 = time.time()
        out = []
        for comp, ri in zip(completions, row_idx):
            text = comp if isinstance(comp, str) else comp[0]["content"]
            r, _info = R.reward_for_row(rows[ri], text, mode)
            out.append(float(r))
        dt = time.time() - t0
        reward_log["calls"] += len(out)
        reward_log["wall_s"] += dt
        reward_log["rewards"].extend(out)
        reward_log["t_call"].append(round(dt, 2))
        print(f"[reward] n={len(out)} wall={dt:.1f}s mean={sum(out)/len(out):.3f}", flush=True)
        return out

    cfg_kwargs = dict(
        use_vllm=True, vllm_mode="colocate", vllm_gpu_memory_utilization=0.3,
        num_generations=8, per_device_train_batch_size=8, gradient_accumulation_steps=8,
        max_completion_length=768, learning_rate=1e-6, bf16=True, seed=0,
        max_steps=args.steps, output_dir=os.path.join(args.out, f"trial_{args.arm}"),
        logging_steps=1, report_to=[],
    )
    from trl import GRPOConfig as _GC
    if "max_prompt_length" in _GC.__dataclass_fields__:  # extra op arg when offered
        cfg_kwargs["max_prompt_length"] = 1024
    cfg = GRPOConfig(**cfg_kwargs)
    lora = LoraConfig(r=16, lora_alpha=32, target_modules="all-linear", task_type="CAUSAL_LM")

    t0 = time.time()
    trainer = GRPOTrainer(model=args.model, args=cfg, train_dataset=ds,
                          reward_funcs=reward_fn, peft_config=lora)
    load_s = time.time() - t0
    t0 = time.time()
    trainer.train()
    train_s = time.time() - t0

    # zero-advantage fraction: groups of num_generations with identical rewards
    g = cfg.num_generations
    rewards = reward_log["rewards"]
    groups = [rewards[i:i + g] for i in range(0, len(rewards), g)]
    zero_adv = sum(1 for grp in groups if len(grp) == g and len(set(grp)) == 1)

    import torch
    peak_gpu_alloc = torch.cuda.max_memory_allocated() / 2**30
    nsm = subprocess.run(["nvidia-smi", "--query-gpu=memory.used,total",
                          "--format=csv,noheader"], capture_output=True, text=True).stdout.strip()
    freeg = subprocess.run(["free", "-g"], capture_output=True, text=True).stdout.splitlines()[1]

    metrics = {
        "arm": args.arm, "mode": mode, "steps": args.steps,
        "trl": __import__("trl").__version__, "peft": __import__("peft").__version__,
        "vllm": __import__("vllm").__version__, "torch": torch.__version__,
        "trainer_load_s": round(load_s, 1), "train_s": round(train_s, 1),
        "reward_calls": reward_log["calls"], "reward_wall_s": round(reward_log["wall_s"], 1),
        "reward_wall_per_call_s": round(reward_log["wall_s"] / max(1, reward_log["calls"]), 2),
        "groups": len(groups), "zero_advantage_groups": zero_adv,
        "zero_advantage_fraction": round(zero_adv / max(1, len(groups)), 3),
        "peak_gpu_alloc_gib": round(peak_gpu_alloc, 2),
        "nvidia_smi": nsm, "free_g": freeg,
        "log_history": trainer.state.log_history,
        "reward_call_times": reward_log["t_call"],
    }
    os.makedirs(args.out, exist_ok=True)
    with open(os.path.join(args.out, f"trial_{args.arm}_metrics.json"), "w") as f:
        json.dump(metrics, f, indent=1, default=str)
    print(json.dumps({k: metrics[k] for k in
                      ("train_s", "reward_calls", "reward_wall_s", "zero_advantage_fraction",
                       "peak_gpu_alloc_gib", "nvidia_smi")}, indent=1))


if __name__ == "__main__":
    main()
