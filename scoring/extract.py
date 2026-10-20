#!/usr/bin/env python3
"""scoring/extract.py — pinned extraction + module-name check (A16 §3 step 8).

`extract_verilog_code` is vendored VERBATIM from CodeV-R1
(test/utils/verilog_extractor.py) at commit 277ac46e3b193aa238e7d9af5a150659e482c5e7,
file sha256 7c52795e4891c07888b25b459a4cc8913cdca6a48e758241ce82fbfbaf6ac8eb,
called with its DEFAULTS (remove_head=False, add_backtick=False) per brief
Appendix D3. Do not edit the vendored function; this file is hash-pinned in
PREREG.md ("Analysis code") before G0.

Module-name check (A16): `TopModule` for VerilogEval, the task name for RTLLM,
using the same \\b-module regex as scorer/score.py so G2 and the scorer agree.

CLI (G2, A16 §6 step 1):
  python3 scoring/extract.py --gen ~/runs/gen/<arm>.jsonl [--out extracted/<arm>.jsonl]
     [--g2 0.95]
Reads generation rows (completion, bench, task_id, sample_idx), writes one row
per sample with code/extract_ok/module_name_ok, prints the G2 share and, on
failure, the first 10 failing sample ids.
"""
import argparse
import hashlib
import json
import os
import re
import sys

# ---------------------------------------------------------------------------
# VENDORED from CodeV-R1 @ 277ac46 (test/utils/verilog_extractor.py) — verbatim.
# ---------------------------------------------------------------------------
import re

def extract_verilog_code(file_content, remove_head=False, add_backtick=False):
    """
    从文本中提取删除注释后的verilog代码，一个用途是从LLM的生成中提取代码。
    """
    # 推理模型
    pattern = r"<answer>(.*?)</answer>"
    if re.findall(pattern, file_content, re.DOTALL):
        file_content = re.findall(pattern, file_content, re.DOTALL)[-1]
    # 去除注释
    note_pattern = r"(//[^\n]*|/\*[\s\S]*?\*/)"
    file_content = re.sub(note_pattern, "", file_content)

    # 匹配 module 到 endmodule 之间的内容
    pattern1 = r"```verilog(.*?)```"
    result = re.findall(pattern1, file_content, re.DOTALL)
    result = result[-1] if len(result) else ""
    if not result:
        pattern2 = r"module\s+\w+\s*\([^)]*\)\s*;(?:[^m]|m(?!odule))*endmodule"
        result = re.findall(pattern2, file_content)
        result = result[-1] if len(result) else ""
    result = result.replace(";", ";\n").replace(";\n\n", ";\n")

    if remove_head:
        # Verilog eval v1, 匹配 module 头部
        pattern = r"module\s+\w+\s*\([^)]*\)\s*;(?:[^m]|m(?!odule))*endmodule"
        modules = re.findall(pattern, result)
        # 考虑多个module的情况，把top_module挪到最上面再删掉head
        if len(modules) >= 2 and modules[0].find("top_module") == -1 and modules[0].find("TopModule") == -1:
            for i, module in enumerate(modules):
                if module.find("top_module") != -1 or module.find("TopModule") != -1:
                    modules = [module] + modules[:i] + modules[i + 1:]
                    break
            result = '\n\n'.join(modules)
        head_pattern = r"module\s+\w+\s*\([^)]*\)\s*;"
        result = re.sub(head_pattern, "", result, count=1)

    if add_backtick:
        result = "```verilog\n" + result + "\n```"
    
    return result
# ---------------------------------------------------------------------------


# A19 §2: the RTLLM task name is misspelled in the benchmark; every arm emits
# the correctly spelled module. Alias for the G2 gate ONLY (the frozen scorer
# keeps the misspelled name, so official passes for this task fail uniformly
# for every arm — reported, not corrected). No other task, no fuzzy matching.
_NAME_ALIAS = {"fixed_point_substractor": ("fixed_point_subtractor",)}


def module_name_ok(code, bench, task_id):
    """TopModule for ve, the task name for rtllm (same regex as scorer/score.py)."""
    want = "TopModule" if bench in ("ve", "verilogeval") else task_id
    names = (want,) if bench in ("ve", "verilogeval") else (want,) + _NAME_ALIAS.get(task_id, ())
    return bool(code.strip()) and any(
        re.search(rf"\bmodule\s+{re.escape(n)}\b", code) for n in names)


def extract_record(completion, bench, task_id):
    code = extract_verilog_code(completion)
    return {"code": code, "extract_ok": bool(re.search(r"\bmodule\b", code)),
            "module_name_ok": module_name_ok(code, bench, task_id)}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--gen", required=True, help="generation jsonl (completion, bench, task_id, sample_idx)")
    ap.add_argument("--out", default="", help="optional jsonl out (adds bench/task_id/sample_idx + code + flags)")
    ap.add_argument("--g2", type=float, default=0.95, help="G2 threshold on extract+name share")
    args = ap.parse_args()

    rows = [json.loads(l) for l in open(args.gen, encoding="utf-8")]
    out, ok = [], 0
    for r in rows:
        rec = extract_record(r["completion"], r["bench"], r["task_id"])
        rec = {"bench": r["bench"], "task_id": r["task_id"], "sample_idx": r["sample_idx"],
               "n_completion_tokens": r.get("n_completion_tokens"),
               "finish_reason": r.get("finish_reason"), **rec}
        ok += rec["extract_ok"] and rec["module_name_ok"]
        out.append(rec)

    share = ok / len(rows) if rows else 1.0
    if args.out:
        os.makedirs(os.path.dirname(args.out) or ".", exist_ok=True)
        with open(args.out, "w", encoding="utf-8") as f:
            for rec in out:
                f.write(json.dumps(rec, ensure_ascii=False) + "\n")
    print(json.dumps({"file": args.gen, "samples": len(rows),
                      "extract_and_name_ok": ok, "share": round(share, 4),
                      "g2_threshold": args.g2, "g2_pass": share >= args.g2}))
    if share < args.g2:
        bad = [f'{r["bench"]}/{r["task_id"]}/{r["sample_idx"]}' for r in out
               if not (r["extract_ok"] and r["module_name_ok"])]
        print("first 10 failing samples:", *bad[:10], sep="\n  ")
        sys.exit(1)


if __name__ == "__main__":
    main()
