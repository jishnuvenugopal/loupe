#!/usr/bin/env python3
"""gen_vllm.py — generation driver for the study (brief §6.2, Phase 8 row format).

Runs INSIDE the vLLM container. Renders each task's chat with the model's own
tokenizer (add_generation_prompt=True), generates with every sampling field set
explicitly (generation_config="vllm" so the model's generation_config.json is
not applied), and writes one JSON row per sample:

  arm, model, revision, bench, task_id, sample_idx, seed, prompt_sha256,
  completion, finish_reason, n_completion_tokens, started_at, finished_at

Resumable: existing (task_id, sample_idx) rows in the output are skipped.
Usage:
  python3 gen_vllm.py --arm 7b-rl --model /models/7b-rl --revision 286cf43... \
      --prompts /work/prompts/built/codev_ve.jsonl --system /work/prompts/system_prompts/codev.txt \
      --n 3 --max-tokens 16384 --temperature 1.0 --top-p 1.0 --out /runs/gen/7b_rl_ve.jsonl
"""
import argparse
import hashlib
import json
import os
import time


def task_seed(task_id: str) -> int:
    return int(hashlib.sha256(task_id.encode()).hexdigest()[:8], 16)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--arm", required=True)
    ap.add_argument("--model", required=True, help="local snapshot path")
    ap.add_argument("--revision", required=True)
    ap.add_argument("--prompts", required=True, help="jsonl with task_id,user rows")
    ap.add_argument("--system", required=True, help="system prompt txt")
    ap.add_argument("--out", required=True)
    ap.add_argument("--n", type=int, default=3)
    ap.add_argument("--max-tokens", type=int, default=16384)
    ap.add_argument("--temperature", type=float, required=True)
    ap.add_argument("--top-p", type=float, required=True)
    ap.add_argument("--max-model-len", type=int, default=20480)
    ap.add_argument("--gpu-mem", type=float, default=0.85)
    ap.add_argument("--limit", type=int, default=0, help="only first K tasks (shakedown)")
    ap.add_argument("--log-effective-params", default="")
    args = ap.parse_args()

    from transformers import AutoTokenizer
    from vllm import LLM, SamplingParams

    system = open(args.system, encoding="utf-8").read()
    rows = [json.loads(l) for l in open(args.prompts, encoding="utf-8")]
    if args.limit:
        rows = rows[: args.limit]

    done = set()
    if os.path.isfile(args.out):
        for l in open(args.out, encoding="utf-8"):
            r = json.loads(l)
            done.add((r["task_id"], r["sample_idx"]))
    todo = [r for r in rows if (r["task_id"], 0) not in done]
    print(f"tasks total={len(rows)} already_done={len(rows) - len(todo)} todo={len(todo)}", flush=True)
    if not todo:
        return

    tok = AutoTokenizer.from_pretrained(args.model)
    rendered = []
    for r in todo:
        msgs = [{"role": "system", "content": system}, {"role": "user", "content": r["user"]}]
        text = tok.apply_chat_template(msgs, add_generation_prompt=True, tokenize=False)
        rendered.append((r, text))

    llm = LLM(model=args.model, dtype="bfloat16", max_model_len=args.max_model_len,
              gpu_memory_utilization=args.gpu_mem, seed=0,
              enable_prefix_caching=True, generation_config="vllm")

    os.makedirs(os.path.dirname(args.out), exist_ok=True)
    # batched generation: all pending tasks in ONE llm.generate call so vLLM
    # schedules them concurrently (throughput mode per brief Phase 6 step 1);
    # per-task seeds via one SamplingParams per prompt.
    texts = [t for _, t in rendered]
    sps = [SamplingParams(
              temperature=args.temperature, top_p=args.top_p, top_k=-1, min_p=0.0,
              repetition_penalty=1.0, max_tokens=args.max_tokens, n=args.n,
              seed=task_seed(r["task_id"])) for r, _ in rendered]
    if args.log_effective_params and not os.path.isfile(args.log_effective_params):
        with open(args.log_effective_params, "w") as f:
            json.dump({"SamplingParams": str(sps[0]), "task_id": rendered[0][0]["task_id"],
                       "seed": task_seed(rendered[0][0]["task_id"]), "arm": args.arm,
                       "note": "one SamplingParams per task; seed = int(sha256(task_id)[:8],16)"},
                     f, indent=1)
    t0 = time.time()
    results = llm.generate(texts, sps)
    t1 = time.time()
    with open(args.out, "a", encoding="utf-8") as out:
        for (r, _), res in zip(rendered, results):
            seed = task_seed(r["task_id"])
            for i, o in enumerate(res.outputs):
                out.write(json.dumps({
                    "arm": args.arm, "model": args.model, "revision": args.revision,
                    "bench": r["bench"], "task_id": r["task_id"], "sample_idx": i,
                    "seed": seed, "prompt_sha256": r["prompt_sha256"],
                    "completion": o.text, "finish_reason": o.finish_reason,
                    "n_completion_tokens": len(o.token_ids),
                    "started_at": t0, "finished_at": t1,
                }, ensure_ascii=False) + "\n")
                out.flush()
            print(f"done {r['task_id']} ({len(res.outputs)} samples)", flush=True)
    print(f"batch wall: {t1 - t0:.1f}s for {len(texts)} prompts x n={args.n}", flush=True)


if __name__ == "__main__":
    main()
