#!/usr/bin/env python3
"""e1/make_prompts.py — build the E1 gated prompt files (PREREG-A20 B4).

E1 generates on the gated sets only: VerilogEval 144 (scoring/gates/
ve_strict.txt) and RTLLM 33 (scoring/gates/rtllm_strict.txt minus the four
reported-apart designs in rtllm_apart.txt — the headline set). Rows are taken
verbatim from the committed primary built files (prompts/built/
verireason_{ve,rtllm}.jsonl), so the prompt-building code is exactly the
primary arms'; only the task list is filtered, deterministically, from the
committed gate lists. Outputs prompts/built_e1/*.jsonl + SHA256SUMS.

Usage (host): python3 e1/make_prompts.py
"""
import hashlib
import json
import os
import sys

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def load_ids(name):
    p = os.path.join(REPO, "scoring/gates", name)
    ids = [l.strip() for l in open(p) if l.strip()]
    if not ids:
        sys.exit(f"empty gate file: {p}")
    return ids


def main():
    ve_ids = set(load_ids("ve_strict.txt"))            # 144
    rtllm_ids = set(load_ids("rtllm_strict.txt"))      # 37
    apart = set(load_ids("rtllm_apart.txt"))           # 4
    rtllm_headline = rtllm_ids - apart                 # 33
    out_dir = os.path.join(REPO, "prompts/built_e1")
    os.makedirs(out_dir, exist_ok=True)
    sums = []
    for bench, ids in (("ve", ve_ids), ("rtllm", rtllm_headline)):
        src = os.path.join(REPO, f"prompts/built/verireason_{bench}.jsonl")
        dst = os.path.join(out_dir, f"verireason_gated_{bench}.jsonl")
        kept = skipped = 0
        with open(dst, "w", encoding="utf-8") as out:
            for l in open(src, encoding="utf-8"):
                r = json.loads(l)
                if r["task_id"] in ids:
                    out.write(l)
                    kept += 1
                else:
                    skipped += 1
        h = hashlib.sha256(open(dst, "rb").read()).hexdigest()
        sums.append(f"{h}  prompts/built_e1/verireason_gated_{bench}.jsonl")
        print(f"{bench}: kept {kept} (gate={len(ids)}), skipped {skipped}, sha256={h}")
        if kept != len(ids):
            sys.exit(f"error: {bench} kept {kept} != gate {len(ids)}")
    with open(os.path.join(out_dir, "SHA256SUMS"), "w") as f:
        f.write("\n".join(sums) + "\n")
    print("wrote prompts/built_e1/SHA256SUMS")


if __name__ == "__main__":
    main()
