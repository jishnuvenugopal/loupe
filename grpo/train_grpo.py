#!/usr/bin/env python3
"""GRPO driver (brief Phase 6 step 4 trial / Phase 9 arms W and S; A20 revision).

Runs INSIDE a container with: ~/hf -> /models-hf, ~/rtl-strict-eval -> /work,
~/eda -> /eda (and /root/eda), ~/bench -> /bench, ~/runs -> /runs.
Env: EDA_BIN=/eda/oss-cad-suite/bin, GRPO_WORK_DIR=/runs/grpo.

TRL 1.15.0 / PEFT 0.21.2 on vLLM 0.21.0 (nvcr.io/nvidia/vllm:26.05.post1-py3),
installed in-container with `pip install trl==1.15.0 peft==0.21.2` (the
passed 2-step trial's lane; requirements.lock). GRPOConfig values are the
trial's verbatim (`results/shakedown/grpo_trial_S.json`) with only the A20
operational additions: --lr (brief 1e-6 / extension 1e-5), periodic
checkpoints every --save-steps (10), --resume-from-checkpoint, a 64-row
held-out split excluded from training (--heldout-seed 20261021, verified
against grpo/heldout_indices.txt), and a B2 CSV callback every
--callback-every (10) steps.

B2 CSV columns (fixed, PREREG-A20):
  step, mean_reward, kl, entropy, mean_completion_length, zero_advantage_rate,
  heldout_tb_pass_rate, heldout_strict_pass_rate, lr, wall_s, timestamp
kl is null by construction: the trial's GRPOConfig leaves beta at the trl
1.15.0 default (0.0), so no reference model / KL term exists; the policy
entropy (mean over the window) is logged beside it. Held-out rates are the
share of the 64 held-out rows whose completion scores reward 1.0 under the W
reward (row-testbench verdict as grpo/reward.py implements it) and under the
S reward (strict) respectively — both are logged for BOTH arms. Held-out
generation: the current policy (PEFT model), greedy decoding, batch 16,
max_new_tokens 768, the training system prompt.
"""
import argparse
import csv
import datetime
import hashlib
import json
import os
import sys
import time

os.environ.setdefault("EDA_BIN", "/eda/oss-cad-suite/bin")
sys.path.insert(0, "/work")
sys.path.insert(0, "/work/grpo")
import reward as R  # noqa: E402

CSV_COLUMNS = ["step", "mean_reward", "kl", "entropy", "mean_completion_length",
               "zero_advantage_rate", "heldout_tb_pass_rate",
               "heldout_strict_pass_rate", "lr", "wall_s", "timestamp"]

HELDOUT_SEED = 20261021
HELDOUT_N = 64


def sha256_file(p):
    h = hashlib.sha256()
    with open(p, "rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def heldout_indices(n_rows):
    return sorted(__import__("random").Random(HELDOUT_SEED).sample(range(n_rows), HELDOUT_N))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--arm", default="S", choices=["W", "S"])
    ap.add_argument("--steps", type=int, default=100)
    ap.add_argument("--lr", type=float, default=1e-6)
    ap.add_argument("--model", default="/models-hf/hub/models--Qwen--Qwen2.5-Coder-1.5B-Instruct/snapshots/2e1fd397ee46e1388853d2af2c993145b0f1098a")
    ap.add_argument("--dataset", default="/models-hf/hub/datasets--Nellyw888--VeriReason-RTL-Coder_7b_reasoning_tb/snapshots/42823db968114c25da260dece0e4bea8ab20d573/train_tb_filtered.jsonl")
    ap.add_argument("--out", default="/runs/grpo", help="run dir (checkpoints land under it)")
    ap.add_argument("--run-name", default="", help="e.g. grpo_brief_W; default trial_<arm>")
    ap.add_argument("--heldout-seed", type=int, default=HELDOUT_SEED)
    ap.add_argument("--heldout-list", default="/work/grpo/heldout_indices.txt")
    ap.add_argument("--save-steps", type=int, default=10)
    ap.add_argument("--callback-every", type=int, default=10)
    ap.add_argument("--resume-from-checkpoint", default="",
                    help="path, or 'auto' for the latest checkpoint under out/")
    ap.add_argument("--csv-out", default="", help="B2 CSV path (host-visible via /work)")
    ap.add_argument("--adapter-sha-out", default="")
    ap.add_argument("--metrics-out", default="")
    ap.add_argument("--heldout-batch", type=int, default=16)
    args = ap.parse_args()
    mode = "weak" if args.arm == "W" else "strict"
    run_name = args.run_name or f"trial_{args.arm}"
    out_dir = os.path.join(args.out, run_name)
    os.makedirs(out_dir, exist_ok=True)

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

    # held-out split: drawn with the pinned seed, verified against the pinned
    # list both ways (any mismatch is a hard error, never a silent difference)
    assert args.heldout_seed == HELDOUT_SEED, "PREREG-A20 pins the held-out seed"
    held = heldout_indices(len(rows))
    pinned = [int(l) for l in open(args.heldout_list) if l.strip()]
    if held != pinned:
        raise SystemExit(f"held-out mismatch: recomputed {len(held)} != pinned {len(pinned)}")
    held_set = set(held)
    train_idx = [i for i in range(len(rows)) if i not in held_set]
    print(f"rows={len(rows)} heldout={len(held)} train={len(train_idx)}", flush=True)

    ds = Dataset.from_list([
        {"prompt": [{"role": "system", "content": SYSTEM},
                    {"role": "user", "content": rows[i]["instruction"]}],
         "row_idx": i}
        for i in train_idx])

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
        max_completion_length=768, learning_rate=args.lr, bf16=True, seed=0,
        max_steps=args.steps, output_dir=out_dir,
        logging_steps=1, report_to=[],
        save_strategy="steps", save_steps=args.save_steps, save_total_limit=None,
    )
    from trl import GRPOConfig as _GC
    if "max_prompt_length" in getattr(_GC, "__dataclass_fields__", {}):
        cfg_kwargs["max_prompt_length"] = 1024
    cfg = GRPOConfig(**cfg_kwargs)
    lora = LoraConfig(r=16, lora_alpha=32, target_modules="all-linear", task_type="CAUSAL_LM")

    # ---------------- B2 CSV callback ----------------
    # Rows are written from on_log (the per-step log entry exists there), so every
    # window covers exactly the steps since the previous row, including its own
    # trigger step. Held-out eval runs at the same moment on the current policy.
    csv_path = args.csv_out
    csv_state = {"rows": {}, "logs": [], "last_reward_i": 0, "last_log_step": -1,
                 "t0": time.time()}

    def load_csv():
        if csv_path and os.path.isfile(csv_path):
            with open(csv_path) as f:
                for r in csv.DictReader(f):
                    csv_state["rows"][int(r["step"])] = r
            if csv_state["rows"]:
                csv_state["last_log_step"] = max(csv_state["rows"])

    def write_csv():
        if not csv_path:
            return
        os.makedirs(os.path.dirname(csv_path), exist_ok=True)
        tmp = csv_path + ".tmp"
        with open(tmp, "w", newline="") as f:
            w = csv.DictWriter(f, fieldnames=CSV_COLUMNS)
            w.writeheader()
            for s in sorted(csv_state["rows"]):
                w.writerow(csv_state["rows"][s])
        os.replace(tmp, csv_path)

    def window_stats(state):
        g = cfg.num_generations
        rw = reward_log["rewards"][csv_state["last_reward_i"]:]
        groups = [rw[i:i + g] for i in range(0, len(rw), g)]
        zero_adv = sum(1 for grp in groups if len(grp) == g and len(set(grp)) == 1)
        logs = [h for h in csv_state["logs"] if h.get("step", 0) > csv_state["last_log_step"]]
        mean_len = [h["completions/mean_length"] for h in logs
                    if h.get("completions/mean_length") is not None]
        ent = [h.get("entropy") for h in logs if h.get("entropy") is not None]
        kl = [h.get("kl") for h in logs if h.get("kl") is not None]  # none when beta=0
        return {
            "mean_reward": (sum(rw) / len(rw)) if rw else None,
            "kl": (sum(kl) / len(kl)) if kl else None,
            "entropy": (sum(ent) / len(ent)) if ent else None,
            "mean_completion_length": (sum(mean_len) / len(mean_len)) if mean_len else None,
            "zero_advantage_rate": (zero_adv / len(groups)) if groups else None,
        }

    def heldout_eval():
        import torch
        tok = getattr(trainer, "processing_class", None) or trainer.tokenizer
        model = trainer.model
        was_training = model.training
        model.eval()
        prompts = [tok.apply_chat_template(
            [{"role": "system", "content": SYSTEM},
             {"role": "user", "content": rows[i]["instruction"]}],
            add_generation_prompt=True, tokenize=False) for i in held]
        outs = []
        B = args.heldout_batch
        old_side = getattr(tok, "padding_side", "right")
        tok.padding_side = "left"
        pad_id = tok.pad_token_id if tok.pad_token_id is not None else tok.eos_token_id
        for i in range(0, len(prompts), B):
            enc = tok(prompts[i:i + B], return_tensors="pt", padding=True).to(model.device)
            with torch.no_grad():
                gen = model.generate(**enc, max_new_tokens=cfg.max_completion_length,
                                     do_sample=False, pad_token_id=pad_id)
            outs.extend(tok.batch_decode(gen[:, enc["input_ids"].shape[1]:],
                                         skip_special_tokens=True))
            print(f"[heldout] generated {min(i+B,len(prompts))}/{len(prompts)}", flush=True)
        tok.padding_side = old_side
        if was_training:
            model.train()
        tb_pass = strict_pass = 0
        for i, text in zip(held, outs):
            rw, _ = R.reward_for_row(rows[i], text, "weak")
            tb_pass += float(rw) == 1.0
            rs, _ = R.reward_for_row(rows[i], text, "strict")
            strict_pass += float(rs) == 1.0
        return tb_pass / len(outs), strict_pass / len(outs)

    from transformers import TrainerCallback

    class B2Callback(TrainerCallback):
        def on_log(self, targs, state, control, logs=None, **kw):
            # Only per-step training logs (they carry 'loss'); TRL also delivers
            # the end-of-train summary through on_log, which must not append a
            # row (it would overwrite the real final row with an empty window).
            if not logs or "loss" not in logs:
                return
            csv_state["logs"].append({**logs, "step": state.global_step})
            step = state.global_step
            if step % args.callback_every != 0 and step != args.steps:
                return
            t_start = time.time()
            ws = window_stats(state)
            tb_rate, st_rate = heldout_eval()
            row = {"step": step,
                   "mean_reward": ws["mean_reward"], "kl": ws["kl"], "entropy": ws["entropy"],
                   "mean_completion_length": ws["mean_completion_length"],
                   "zero_advantage_rate": ws["zero_advantage_rate"],
                   "heldout_tb_pass_rate": tb_rate, "heldout_strict_pass_rate": st_rate,
                   "lr": args.lr, "wall_s": round(time.time() - csv_state["t0"], 1),
                   "timestamp": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")}
            csv_state["rows"][step] = row
            csv_state["last_reward_i"] = len(reward_log["rewards"])
            csv_state["last_log_step"] = step
            write_csv()
            print(f"[b2] step={step} row={json.dumps(row)} "
                  f"(heldout eval took {time.time()-t_start:.0f}s)", flush=True)

        def on_train_end(self, targs, state, control, **kw):
            # final row if the last step was not a multiple of callback_every
            step = state.global_step
            if step not in csv_state["rows"] and csv_state["logs"]:
                ws = window_stats(state)
                tb_rate, st_rate = heldout_eval()
                csv_state["rows"][step] = {"step": step,
                    "mean_reward": ws["mean_reward"], "kl": ws["kl"], "entropy": ws["entropy"],
                    "mean_completion_length": ws["mean_completion_length"],
                    "zero_advantage_rate": ws["zero_advantage_rate"],
                    "heldout_tb_pass_rate": tb_rate, "heldout_strict_pass_rate": st_rate,
                    "lr": args.lr, "wall_s": round(time.time() - csv_state["t0"], 1),
                    "timestamp": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")}
                write_csv()

    load_csv()

    t0 = time.time()
    trainer = GRPOTrainer(model=args.model, args=cfg, train_dataset=ds,
                          reward_funcs=reward_fn, peft_config=lora)
    trainer.add_callback(B2Callback())
    load_s = time.time() - t0

    resume = None
    if args.resume_from_checkpoint:
        if args.resume_from_checkpoint == "auto":
            cands = sorted((d for d in os.listdir(out_dir) if d.startswith("checkpoint-")),
                           key=lambda d: int(d.split("-")[1])) if os.path.isdir(out_dir) else []
            resume = os.path.join(out_dir, cands[-1]) if cands else None
            print(f"[resume] auto -> {resume}", flush=True)
        else:
            resume = args.resume_from_checkpoint
    t0 = time.time()
    trainer.train(resume_from_checkpoint=resume)
    train_s = time.time() - t0

    # final adapter (explicit save; also the last periodic checkpoint holds it)
    final_dir = os.path.join(out_dir, "final_adapter")
    trainer.save_model(final_dir)
    adapter_files = {}
    for fn in os.listdir(final_dir):
        p = os.path.join(final_dir, fn)
        if os.path.isfile(p) and (fn.endswith(".safetensors") or fn.endswith(".json")):
            adapter_files[fn] = sha256_file(p)
    rec = {"run_name": run_name, "arm": args.arm, "mode": mode, "steps": args.steps,
           "lr": args.lr, "adapter_sha256": adapter_files,
           "trl": __import__("trl").__version__, "peft": __import__("peft").__version__,
           "vllm": __import__("vllm").__version__}
    for target, key in ((args.adapter_sha_out, "adapter_sha256"),):
        if target:
            os.makedirs(os.path.dirname(target), exist_ok=True)
            with open(target, "w") as f:
                json.dump({k: rec[k] for k in ("run_name", "arm", "steps", "lr", key)}, f, indent=1)

    # zero-advantage fraction over the whole run (trial-comparable)
    g = cfg.num_generations
    rewards = reward_log["rewards"]
    groups = [rewards[i:i + g] for i in range(0, len(rewards), g)]
    zero_adv = sum(1 for grp in groups if len(grp) == g and len(set(grp)) == 1)

    import torch
    metrics = {
        **{k: rec[k] for k in ("run_name", "arm", "mode", "steps", "lr",
                               "trl", "peft", "vllm")},
        "torch": torch.__version__,
        "trainer_load_s": round(load_s, 1), "train_s": round(train_s, 1),
        "reward_calls": reward_log["calls"], "reward_wall_s": round(reward_log["wall_s"], 1),
        "reward_wall_per_call_s": round(reward_log["wall_s"] / max(1, reward_log["calls"]), 2),
        "groups": len(groups), "zero_advantage_groups": zero_adv,
        "zero_advantage_fraction": round(zero_adv / max(1, len(groups)), 3),
        "peak_gpu_alloc_gib": round(torch.cuda.max_memory_allocated() / 2**30, 2),
        "heldout_indices": held,
        "kl_note": ("null by construction: the trial's GRPOConfig leaves beta at the trl "
                    "1.15.0 default (0.0) - no reference model, no KL term; entropy is "
                    "logged beside it (PREREG-A20 B2)"),
        "log_history": trainer.state.log_history,
        "reward_call_times": reward_log["t_call"],
    }
    if args.metrics_out:
        os.makedirs(os.path.dirname(args.metrics_out), exist_ok=True)
        with open(args.metrics_out, "w") as f:
            json.dump(metrics, f, indent=1, default=str)
    with open(os.path.join(out_dir, "metrics.json"), "w") as f:
        json.dump(metrics, f, indent=1, default=str)
    write_csv()
    print(json.dumps({k: metrics[k] for k in
                      ("run_name", "train_s", "reward_calls", "reward_wall_s",
                       "zero_advantage_fraction", "peak_gpu_alloc_gib")}, indent=1))


if __name__ == "__main__":
    main()
