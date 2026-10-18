#!/usr/bin/env python3
"""H0-a: is `Nellyw888/Qwen2.5-3b-sft-reasoning` the parent of the 3B RL model?

Weight distance on CPU in fp32 (brief Phase 5, H0-a). To be run inside the
pinned PyTorch container (nvcr.io/nvidia/pytorch:25.11-py3) because that is the
pinned torch environment; the script itself needs only torch + safetensors.

For every tensor name two checkpoints share, compute the relative distance
    d(A, B) = ||A - B|| / ||B||
and report the median and 95th percentile for the pairs:
  RL<->SFT, RL<->3B-Instruct, RL<->3B, SFT<->3B-Instruct, SFT<->3B.
Also compares tokenizer files and chat templates.

Pre-registered decision rule (brief §5 Phase 5): the SFT checkpoint is
confirmed as the RL model's parent if median d(RL,SFT) <= 1/10 of the median
distance from RL to either Qwen 3B checkpoint. Otherwise the 3B family drops
its SFT arm and the 3B contrast becomes SFT+RL vs Instruct.

Usage:
  python3 h0a_weight_distance.py  (weights resolved from HF_HOME snapshots)
Writes results/h0/h0a_weight_distance.json.
"""
import glob
import hashlib
import json
import os
import statistics

MODELS = {
    "RL":          ("Nellyw888/VeriReason-Qwen2.5-3b-RTLCoder-Verilog-GRPO-reasoning-tb",
                    "3b93ce1bd7e5d90dae8761363a9c6862d0ed583a"),
    "SFT":         ("Nellyw888/Qwen2.5-3b-sft-reasoning",
                    "1f0b7fac9c057b32cba9107a854518be92e45c91"),
    "3B-Instruct": ("Qwen/Qwen2.5-Coder-3B-Instruct",
                    "488639f1ff808d1d3d0ba301aef8c11461451ec5"),
    "3B":          ("Qwen/Qwen2.5-Coder-3B",
                    "09d9bc5d376b0cfa0100a0694ea7de7232525803"),
}
PAIRS = [("RL", "SFT"), ("RL", "3B-Instruct"), ("RL", "3B"),
         ("SFT", "3B-Instruct"), ("SFT", "3B")]

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def snapshot(repo_id, rev):
    base = os.path.expanduser(f"~/hf/hub/models--{repo_id.replace('/', '--')}/snapshots/{rev}")
    if not os.path.isdir(base):
        raise SystemExit(f"missing snapshot: {base}")
    return base


def load_state_dict(path):
    import torch
    from safetensors.torch import load_file
    sd = {}
    for f in sorted(glob.glob(os.path.join(path, "*.safetensors"))):
        sd.update(load_file(f))
    return {k: v.to(torch.float32) for k, v in sd.items()}


def rel_distances(A, B):
    out = {}
    for k in sorted(set(A) & set(B)):
        b = B[k]
        nb = float(b.norm())
        if nb == 0.0:
            out[k] = 0.0 if float((A[k] - b).norm()) == 0.0 else float("inf")
        else:
            out[k] = float((A[k] - b).norm()) / nb
    return out


def main():
    snaps = {name: snapshot(repo, rev) for name, (repo, rev) in MODELS.items()}
    sds = {name: load_state_dict(p) for name, p in snaps.items()}

    report = {"pairs": {}, "tensor_counts": {n: len(sd) for n, sd in sds.items()}}
    for a, b in PAIRS:
        d = rel_distances(sds[a], sds[b])
        vals = sorted(d.values())
        report["pairs"][f"{a}<->{b}"] = {
            "shared_tensors": len(vals),
            "median": statistics.median(vals),
            "p95": vals[max(0, int(0.95 * len(vals)) - 1)],
            "mean": sum(vals) / len(vals),
        }
        print(f"{a}<->{b}: n={len(vals)} median={report['pairs'][f'{a}<->{b}']['median']:.3e} "
              f"p95={report['pairs'][f'{a}<->{b}']['p95']:.3e}")

    m = lambda p: report["pairs"][p]["median"]
    confirmed = (m("RL<->SFT") <= 0.1 * m("RL<->3B-Instruct") and
                 m("RL<->SFT") <= 0.1 * m("RL<->3B"))
    nearer = "3B-Instruct" if m("SFT<->3B-Instruct") <= m("SFT<->3B") else "3B"
    report["decision"] = {"sft_confirmed_as_rl_parent": confirmed,
                          "sft_nearer_to": nearer,
                          "rule": "median RL<->SFT <= 0.1 * median RL<->(each Qwen 3B)"}
    print("SFT confirmed as RL parent:", confirmed, "| SFT nearer to:", nearer)

    # tokenizer / chat template comparison
    tok = {}
    for name, p in snaps.items():
        tc = os.path.join(p, "tokenizer_config.json")
        tok[name] = {"tokenizer_config_sha256": hashlib.sha256(open(tc, "rb").read()).hexdigest() if os.path.isfile(tc) else None,
                     "chat_template_present": bool(json.load(open(tc)).get("chat_template")) if os.path.isfile(tc) else False,
                     "tokenizer_json_sha256": hashlib.sha256(open(os.path.join(p, "tokenizer.json"), "rb").read()).hexdigest()
                     if os.path.isfile(os.path.join(p, "tokenizer.json")) else None}
    report["tokenizer"] = tok
    groups = {}
    for name, t in tok.items():
        groups.setdefault(t["tokenizer_config_sha256"], []).append(name)
    print("tokenizer_config groups:", groups)

    with open(os.path.join(REPO, "results/h0/h0a_weight_distance.json"), "w") as f:
        json.dump(report, f, indent=1)


if __name__ == "__main__":
    main()
