#!/usr/bin/env python3
"""e1/merge_adapter.py — merge a Phase 9 LoRA adapter into a full bf16 copy
(PRREREG-A20 B6, "E1 path" option 1: merge under ~/runs/; gen/gen_vllm.py
stays untouched and loads the merged model as any base model).

Runs INSIDE the vLLM container (trl/peft/torch present):
  python3 /work/e1/merge_adapter.py --base /models-hf/.../snapshots/<rev> \
      --adapter /runs/grpo_brief_W/final_adapter --out /runs/e1_models/w100 \
      --sha-out /work/results/e1/models/w100.sha256.json
The merged model and every file's sha256 are recorded; weights never enter git
(only the sha256 record under results/e1/models/ does).
"""
import argparse
import hashlib
import json
import os


def sha256_file(p):
    h = hashlib.sha256()
    with open(p, "rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--base", required=True, help="base model snapshot dir")
    ap.add_argument("--adapter", required=True, help="LoRA adapter dir (final or checkpoint)")
    ap.add_argument("--out", required=True, help="merged model output dir (under ~/runs/)")
    ap.add_argument("--sha-out", default="", help="where to write the sha256 record (host-visible)")
    args = ap.parse_args()

    import torch
    from transformers import AutoModelForCausalLM, AutoTokenizer
    from peft import PeftModel

    if os.path.isdir(args.out):
        print(f"[merge] {args.out} already exists — verifying files and skipping re-merge")
    else:
        os.makedirs(args.out, exist_ok=True)
        model = AutoModelForCausalLM.from_pretrained(args.base, torch_dtype=torch.bfloat16,
                                                     device_map="cuda:0")
        model = PeftModel.from_pretrained(model, args.adapter)
        model = model.merge_and_unload()
        model.save_pretrained(args.out, safe_serialization=True)
        del model
        torch.cuda.empty_cache()
        tok = AutoTokenizer.from_pretrained(args.base)
        tok.save_pretrained(args.out)
        for fn in ("generation_config.json", "chat_template.jinja"):
            src = os.path.join(args.base, fn)
            if os.path.isfile(src):
                open(os.path.join(args.out, fn), "wb").write(open(src, "rb").read())

    files = {}
    for fn in sorted(os.listdir(args.out)):
        p = os.path.join(args.out, fn)
        if os.path.isfile(p):
            files[fn] = sha256_file(p)
    rec = {"base": args.base, "adapter": args.adapter, "out": args.out,
           "dtype": "bfloat16 (merged)", "files_sha256": files}
    if args.sha_out:
        os.makedirs(os.path.dirname(args.sha_out), exist_ok=True)
        with open(args.sha_out, "w") as f:
            json.dump(rec, f, indent=1)
    print(json.dumps({k: rec[k] for k in ("base", "adapter", "out")}, indent=1))
    print(f"[merge] {len(files)} files hashed; record: {args.sha_out or '(not written)'}")


if __name__ == "__main__":
    main()
