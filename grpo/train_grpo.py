#!/usr/bin/env python3
"""GRPO stretch driver (brief Phase 6 step 4 trial / Phase 9).

Runs INSIDE a container with ~/eda mounted (formal reward) and ~/hf (weights).
Two-step shakedown: python3 train_grpo.py --steps 2
Phase 9 arms: --arm W (testbench-only reward) | --arm S (strict reward).

TRL version note (recorded at run time): the brief says to pick the newest TRL
release whose stated vLLM support covers the container's vLLM version; the
fallback image pins trl==0.26.1 with use_vllm=False. The GRPOConfig below is
the brief's verbatim; LoRA r16 alpha32 on all linear layers.
"""
import argparse
import json
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import reward as R


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--arm", default="S", choices=["W", "S"])
    ap.add_argument("--steps", type=int, default=2)
    ap.add_argument("--model", default=os.path.expanduser(
        "~/hf/hub/models--Qwen--Qwen2.5-Coder-1.5B-Instruct/snapshots/"
        "2e1fd397ee46e1388853d2af2c993145b0f1098a"))
    ap.add_argument("--dataset", default=os.path.expanduser(
        "~/hf/hub/datasets--Nellyw888--VeriReason-RTL-Coder_7b_reasoning_tb/snapshots/"
        "42823db968114c25da260dece0e4bea8ab20d573/train_tb_filtered.jsonl"))
    ap.add_argument("--out", default=os.path.expanduser("~/runs/grpo"))
    args = ap.parse_args()
    mode = "weak" if args.arm == "W" else "strict"

    import torch
    from datasets import Dataset
    from trl import GRPOConfig, GRPOTrainer
    from peft import LoraConfig

    rows = [json.loads(l) for l in open(args.dataset)]
    ds = Dataset.from_list([{"prompt": r["instruction"], "__row": i} for i, r in enumerate(rows)])

    SYSTEM = open(os.path.expanduser(
        "~/rtl-strict-eval/prompts/system_prompts/verireason.txt"), encoding="utf-8").read()

    def reward_fn(completions, __row=None, **kw):
        out = []
        for comp, ri in zip(completions, __row):
            r, _info = R.reward_for_row(rows[ri], comp, mode)
            out.append(r)
        return out

    cfg = GRPOConfig(
        use_vllm=True, vllm_mode="colocate", vllm_gpu_memory_utilization=0.3,
        num_generations=8, per_device_train_batch_size=8, gradient_accumulation_steps=8,
        max_completion_length=768, learning_rate=1e-6, bf16=True, seed=0,
        max_steps=args.steps, output_dir=os.path.join(args.out, f"arm_{args.arm}"),
        logging_steps=1, report_to=[],
    )
    lora = LoraConfig(r=16, lora_alpha=32, target_modules="all-linear",
                      task_type="CAUSAL_LM")

    trainer = GRPOTrainer(
        model=args.model, args=cfg, train_dataset=ds,
        reward_funcs=reward_fn, peft_config=lora,
    )
    # attach the row indices so the reward can find tb/tb_result
    trainer.train_dataset = ds.map(lambda x: {"__row": x["__row"]})
    trainer.train()
    print("GRPO trial done:", args.arm, args.steps)


if __name__ == "__main__":
    main()
