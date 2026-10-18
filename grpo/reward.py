#!/usr/bin/env python3
"""GRPO reward (brief Phase 6 step 4 / Phase 9).

W (weak)  : official-testbench verdict only.
S (strict): testbench + non-vacuity + formal equivalence against the dataset's
            golden code, formal capped at 10 s, falling back to a 10,000-vector
            random differential simulation when formal is inconclusive.

The dataset rows (H0-d verified: tb_result reproduces 30/30) carry their own
testbench + expected output, so the "official testbench" here is the row's `tb`
compared byte-exactly against `tb_result`; non-vacuity = tb_result is non-empty
AND the comparison actually ran (>=1 vector line). The formal check reuses the
frozen scorer machinery (deep/common.py, the same code path score.py uses),
invoked with a 10 s cap — this is the "calls score.py's formal check" clause;
dataset tasks have no benchmark task entry, so score.py's CLI cannot be used
directly (interpretation recorded 18 Oct 2026).

reward_for_row(row, completion, mode) -> float in {0.0, 1.0}
"""
import os
import re
import subprocess
import sys
import tempfile

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(REPO, "deep"))
sys.path.insert(0, os.path.expanduser("~/bench/CodeV-R1/test/utils"))
import common as C  # frozen scorer machinery (scorer-v1)
from verilog_extractor import extract_verilog_code

EDA = C.EDA if hasattr(C, "EDA") else os.path.expanduser("~/eda/oss-cad-suite/bin")
FORMAL_CAP_S = 10
SIM_VECTORS = 10000


def tb_verdict(work, code, tb, tb_res):
    """Compile+run the row's testbench against extracted code; compare the
    written vector file byte-exactly with the row's expected tb_result."""
    open(os.path.join(work, "gen.v"), "w").write(code)
    open(os.path.join(work, "tb.v"), "w").write(tb)
    rc, out = C.run(["iverilog", "-g2012", "-o", "sim", "gen.v", "tb.v"], work, 60)
    if rc != 0:
        return "compile_error", None
    rc, out = C.run(["vvp", "-n", "sim"], work, 120)
    if rc == "timeout":
        return "timeout", None
    vec = os.path.join(work, "test_vectors.txt")
    if not os.path.isfile(vec):
        return "no_output", None
    got = open(vec).read()
    return ("pass" if got == tb_res else "fail"), got


def reward_for_row(row, completion, mode="strict"):
    """row: dataset dict with instruction/output/tb/tb_result. Returns (reward, info)."""
    code = extract_verilog_code(completion)
    if not code.strip():
        return 0.0, {"reason": "extract_fail"}
    tb_res = row["tb_result"] or ""
    with tempfile.TemporaryDirectory(dir=os.path.expanduser("~/runs/grpo")) as work:
        verdict, got = tb_verdict(work, code, row["tb"], tb_res)
        info = {"tb": verdict}
        if verdict != "pass" or not tb_res.strip():
            return 0.0, info  # fails TB, or vacuous TB (no expected vectors)
        exact = got == tb_res
        info["tb_exact"] = exact
        if not exact:
            return 0.0, info
        if mode == "weak":
            return 1.0, info
        # strict: formal vs golden code, capped
        golden = extract_verilog_code(row["output"])
        if not golden.strip():
            return 1.0, {**info, "formal": "no_golden"}
        open(os.path.join(work, "gold.v"), "w").write(golden)
        top = top_module(code)
        if top is None or top_module(golden) != top:
            top = top_module(golden)
        if top is None:
            return 1.0, {**info, "formal": "no_top"}
        p = C.ports(work, "gold.v", top)
        if p is None:
            return 1.0, {**info, "formal": "read_error"}
        ropts, rinfo = C.reset_opts(p)
        C.BMC_TIMEOUT = C.PDR_TIMEOUT = FORMAL_CAP_S
        r = C.equiv_all(work, "gold.v", "gen.v", top, ropts, rinfo, p, "grpo")
        info["formal"] = r["class"]
        if r["class"] == "DIFFERENT":
            return 0.0, info
        if r["class"] in ("UNBOUNDED-EQ", "BMC-10-EQ-ONLY"):
            return 1.0, info
        # inconclusive -> differential random simulation fallback
        ok = diff_sim(work, "gold.v", "gen.v", top, p)
        info["sim_fallback"] = ok
        return (1.0 if ok else 0.0), info


def top_module(src):
    m = re.search(r"\bmodule\s+(\w+)", src)
    return m.group(1) if m else None


def diff_sim(work, gold, gate, top, ports_d):
    """10,000-vector random differential simulation (combinational-friendly):
    build a miter-style SV testbench driving shared inputs with $random and
    comparing outputs each vector; run under Icarus."""
    ins = [(n, w) for n, (d, w) in ports_d.items() if d == "input"]
    outs = [(n, w) for n, (d, w) in ports_d.items() if d == "output"]
    decl = " ".join(f"{'reg' if d == 'i' else 'wire'} [{max(w - 1, 0)}:0] {n};"
                    for n, w, d in [(n, w, 'i') for n, w in ins] + [(n, w, 'o') for n, w in outs])
    tb = f"""module diffsim; integer i; integer bad = 0;
{decl}
gold g(.clk(1'b0), {', '.join(f'.{n}({n})' for n, _ in ins + outs)});
gate t(.clk(1'b0), {', '.join(f'.{n}({n})' for n, _ in ins + outs)});
initial begin
  for (i = 0; i < {SIM_VECTORS}; i = i + 1) begin
"""
    for n, w in ins:
        tb += f"    {n} = $random;\n"
    tb += "    #1;\n"
    for n, _ in outs:
        tb += f"    if (g.{n} !== t.{n}) bad = bad + 1;\n"
    tb += """  end
  $display("DIFFSIM bad=%0d", bad);
  $finish;
end endmodule"""
    src = (open(os.path.join(work, gold)).read().replace(f"module {top}", "module gold", 1) + "\n" +
           open(os.path.join(work, gate)).read().replace(f"module {top}", "module gate", 1))
    open(os.path.join(work, "diffsim_src.v"), "w").write(src + "\n" + tb)
    rc, out = C.run(["iverilog", "-g2012", "-o", "dsim", "diffsim_src.v"], work, 60)
    if rc != 0:
        return False
    rc, out = C.run(["vvp", "-n", "dsim"], work, 300)
    m = re.search(r"DIFFSIM bad=(\d+)", out or "")
    return bool(m and m.group(1) == "0")


if __name__ == "__main__":
    import json
    row = json.load(open(sys.argv[1]))
    completion = open(sys.argv[2]).read()
    mode = sys.argv[3] if len(sys.argv) > 3 else "strict"
    os.makedirs(os.path.expanduser("~/runs/grpo"), exist_ok=True)
    print(json.dumps(reward_for_row(row, completion, mode)))
