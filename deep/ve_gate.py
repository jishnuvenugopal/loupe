"""Phase 3 (deep): VerilogEval v2 spec-to-RTL scorer gate.

Per task (pilot A.5/A.6 flow, upgraded with the deep engines):
  1. ref.sv (RefModule) + top.sv (renamed copy) + patched test.sv
     (harness fix (a): drop undeclared tb_mismatch from $dumpvars) in a work dir.
  2. official TB verdict under Icarus (VerilogEval compile line) and Verilator.
  3. non-vacuity: `Mismatches: 0 in N samples` with N >= 1.
  4. self-equivalence of TopModule with proof classes (BMC-10 + PDR + SMT-ind).
Compare against Appendix C's 13 excluded tasks; count exclusions resolved.
"""
import os, sys, json, glob, re, shutil
from concurrent.futures import ProcessPoolExecutor, as_completed
sys.path.insert(0, os.path.dirname(__file__))
import common as C

VE = os.path.expanduser("~/bench/verilog-eval/dataset_spec-to-rtl")
OUT = os.path.expanduser("~/runs/deep/ve")

def gate(prompt_path):
    name = os.path.basename(prompt_path).replace("_prompt.txt", "")
    work = os.path.join(OUT, name)
    shutil.rmtree(work, ignore_errors=True); os.makedirs(work)
    r = {"task": name}
    ref = open(os.path.join(VE, name + "_ref.sv")).read()
    open(os.path.join(work, "ref.sv"), "w").write(ref)
    open(os.path.join(work, "top.sv"), "w").write(
        re.sub(r"\bmodule\s+RefModule\b", "module TopModule", ref))
    t = open(os.path.join(VE, name + "_test.sv")).read()
    t = t.replace("$dumpvars(1, stim1.clk, tb_mismatch ,", "$dumpvars(1, stim1.clk,")
    open(os.path.join(work, "test.sv"), "w").write(t)
    # official compile line (pilot A.6)
    rc, out = C.run(["iverilog", "-Wall", "-Winfloop", "-Wno-timescale", "-g2012",
                     "-s", "tb", "-o", "sim", "top.sv", "test.sv", "ref.sv"], work, 120)
    if rc != 0:
        r["tb_icarus"] = "compile_error"
    else:
        rc, out = C.run(["vvp", "-n", "sim"], work, 120)
        m = re.search(r"Mismatches: (\d+) in (\d+) samples", out or "")
        r["tb_icarus"] = "timeout" if rc == "timeout" else (
            "pass" if (m and m.group(1) == "0" and int(m.group(2)) >= 1) else "fail")
        r["samples"] = int(m.group(2)) if m else 0
        r["nonvacuous"] = bool(m and int(m.group(2)) >= 1)
    # second simulator
    r["tb_verilator"] = C.tb_verdict_verilator(work, "top.sv", "test.sv", "ve")
    # self-equivalence with proof classes
    p = C.ports(work, "top.sv", "TopModule")
    if p is None:
        r["equiv"] = "read_error"; r["class"] = "UNKNOWN"
    else:
        ropts, rinfo = C.reset_opts(p)
        r["reset"] = rinfo.get("reset")
        r["sequential"] = any(re.search(r"clk|clock", n, re.I) for n in p)
        e = C.equiv_all(work, "top.sv", "top.sv", "TopModule", ropts, rinfo, p, "self")
        r.update({k: e[k] for k in ("bmc", "pdr", "tind", "class")})
    json.dump(r, open(os.path.join(work, "result.json"), "w"), indent=1)
    return r

if __name__ == "__main__":
    os.makedirs(OUT, exist_ok=True)
    prompts = sorted(glob.glob(os.path.join(VE, "*_prompt.txt")))
    workers = max(2, (os.cpu_count() or 4) - 2)
    recs = []
    with ProcessPoolExecutor(max_workers=workers) as ex:
        futs = {ex.submit(gate, pr): pr for pr in prompts}
        for f in as_completed(futs):
            try: r = f.result()
            except Exception as e:
                r = {"task": os.path.basename(futs[f]), "error": repr(e)}
            recs.append(r)
            print(json.dumps({k: r.get(k) for k in
                  ("task", "tb_icarus", "tb_verilator", "samples", "bmc", "pdr", "tind", "class")}),
                  flush=True)
    recs.sort(key=lambda r: r["task"])
    json.dump(recs, open(os.path.join(OUT, "ve_gate_summary.json"), "w"), indent=1)
    ok = [r for r in recs if r.get("tb_icarus") == "pass" and r.get("class") in ("UNBOUNDED-EQ", "BMC-10-EQ-ONLY")]
    print("TOTAL", len(recs), "| gate-pass (tb ok + equiv):", len(ok))
