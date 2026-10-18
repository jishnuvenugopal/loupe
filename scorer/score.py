#!/usr/bin/env python3
"""score.py — one CLI, one JSON verdict per sample (brief §5, extended with
proof classes from the deep engines).

Usage:
  score.py --bench {rtllm,ve} --task <name> --sample <file.v> --out <dir>
           [--depth N] [--formal-timeout S]

Output JSON keys (pilot schema first, deep extensions after):
  task, bench, extract_ok, module_name_ok,
  tb (pass|fail|compile_error|timeout), nonvacuous,
  equiv (equivalent|different|timeout|error|skipped),
  depth, reset, lint_warnings, synth, cex, scorer_sha256,
  bmc, pdr, tind, class (DIFFERENT|UNBOUNDED-EQ|BMC-N-EQ-ONLY|UNKNOWN)
"""
import os, sys, json, re, shutil, argparse, hashlib, subprocess

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "deep"))
import common as C

RTLLM_DIRS = {os.path.basename(d): d for d in
              __import__("glob").glob(os.path.join(C.RTLLM, "*", "*", "*"))
              if __import__("glob").glob(os.path.join(d, "verified_*.v"))}
VE = os.path.expanduser("~/bench/verilog-eval/dataset_spec-to-rtl")

def sha256_file(p):
    h = hashlib.sha256()
    with open(p, "rb") as f:
        for chunk in iter(lambda: f.read(1 << 16), b""):
            h.update(chunk)
    return h.hexdigest()

def lint_count(path, work):
    rc, out = C.run(["verilator", "--lint-only", "-Wall", "-Wno-fatal", "--top-module",
                     "*", path], work, 60)
    return out.count("%Warning")

def synth_stats(path, top, work):
    rc, out = C.run(["yosys", "-q", "-p",
        f"read_verilog -sv {path}; hierarchy -top {top}; proc; flatten; memory_map; "
        f"opt_clean; stat"], work, 120)
    if rc != 0:
        return None
    st = {}
    for k, reg in (("cells", r"Number of cells:\s+(\d+)"), ("ffs", r"\\\$dff\s+(\d+)"),
                   ("luts", r"\\\$lut\s+(\d+)")):
        m = re.search(reg, out)
        if m: st[k] = int(m.group(1))
    st["latch"] = bool(re.search(r"\\\$dlatch", out))
    return st or None

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--bench", required=True, choices=["rtllm", "ve"])
    ap.add_argument("--task", required=True)
    ap.add_argument("--sample", required=True)
    ap.add_argument("--out", required=True)
    ap.add_argument("--depth", type=int, default=int(os.environ.get("BMC_DEPTH", "10")))
    ap.add_argument("--formal-timeout", type=int, default=None)
    args = ap.parse_args()
    if args.formal_timeout:
        C.PDR_TIMEOUT = C.BMC_TIMEOUT = args.formal_timeout
    C.BMC_DEPTH = args.depth

    work = args.out
    shutil.rmtree(work, ignore_errors=True); os.makedirs(work)
    rec = {"task": args.task, "bench": args.bench}
    src = open(args.sample).read()
    open(os.path.join(work, "gen.v"), "w").write(src)

    if args.bench == "rtllm":
        ddir = RTLLM_DIRS.get(args.task)
        if ddir is None:
            rec.update(tb="no_task", equiv="skipped"); print(json.dumps(rec)); return
        top = C.prep_design_src(ddir, work, gen_src=args.sample)
        want = args.task
        rec["module_name_ok"] = bool(re.search(rf"\bmodule\s+{re.escape(want)}\b", src))
        rec["tb"] = C.tb_verdict(work, "gen.v", "tb.v", "gen")
        rec["nonvacuous"] = (rec["tb"] == "pass" and C.PASS_RE.search(
            open(os.path.join(work, "gen.log"), errors="ignore").read() or "") is not None) \
            if os.path.exists(os.path.join(work, "gen.log")) else (rec["tb"] == "pass")
        gold, gate = "ref.v", "gen.v"
    else:
        top = "TopModule"
        ref = open(os.path.join(VE, args.task + "_ref.sv")).read()
        open(os.path.join(work, "ref.sv"), "w").write(ref)
        open(os.path.join(work, "top_gold.sv"), "w").write(
            re.sub(r"\bmodule\s+RefModule\b", "module TopModule", ref))
        shutil.copy(os.path.join(work, "gen.v"), os.path.join(work, "top.sv"))
        t = open(os.path.join(VE, args.task + "_test.sv")).read()
        t = t.replace("$dumpvars(1, stim1.clk, tb_mismatch ,", "$dumpvars(1, stim1.clk,")
        open(os.path.join(work, "test.sv"), "w").write(t)
        rec["module_name_ok"] = bool(re.search(r"\bmodule\s+TopModule\b", src))
        rc, out = C.run(["iverilog", "-Wall", "-Winfloop", "-Wno-timescale", "-g2012",
                         "-s", "tb", "-o", "sim", "gen.v", "test.sv", "ref.sv"], work, 120)
        if rc != 0:
            rec["tb"] = "compile_error"
        else:
            rc, out = C.run(["vvp", "-n", "sim"], work, 120)
            m = re.search(r"Mismatches: (\d+) in (\d+) samples", out or "")
            rec["tb"] = "timeout" if rc == "timeout" else (
                "pass" if (m and m.group(1) == "0" and int(m.group(2)) >= 1) else "fail")
            rec["samples"] = int(m.group(2)) if m else 0
        rec["nonvacuous"] = bool(rec.get("samples"))
        gold, gate = "top_gold.sv", "top.sv"

    rec["extract_ok"] = bool(re.search(r"\bmodule\b", src))
    rec["lint_warnings"] = lint_count("gen.v", work)
    rec["synth"] = synth_stats("gen.v", top, work)

    p = C.ports(work, gold, top)
    if p is None:
        rec.update(equiv="error", depth=args.depth)
    elif rec["tb"] != "pass":
        rec.update(equiv="skipped", depth=args.depth, reset=None)
    else:
        ropts, rinfo = C.reset_opts(p)
        rec["reset"] = rinfo
        r = C.equiv_all(work, gold, gate, top, ropts, rinfo, p, "gen")
        rec.update({k: r[k] for k in ("bmc", "pdr", "tind", "class")})
        rec["equiv"] = ("different" if r["class"] == "DIFFERENT"
                        else "equivalent" if r["class"] in ("UNBOUNDED-EQ",)
                        else "timeout" if "timeout" in (r["bmc"], r["pdr"], r["tind"])
                        else "error")
        rec["depth"] = args.depth
        cdx = os.path.join(work, "cex")
        if rec["equiv"] == "different":
            os.makedirs(cdx, exist_ok=True)
            for f in os.listdir(work):
                if "engine_0" in f: pass
            vd = r.get("pdr_dir")
            if vd and os.path.isdir(vd):
                for root, _, files in os.walk(vd):
                    for f in files:
                        if f.endswith(".vcd"):
                            shutil.copy(os.path.join(root, f), os.path.join(cdx, f))
            rec["cex"] = cdx if os.listdir(cdx) else None
        else:
            rec["cex"] = None
    rec["scorer_sha256"] = sha256_file(os.path.abspath(__file__))
    print(json.dumps(rec))
    json.dump(rec, open(os.path.join(work, "verdict.json"), "w"), indent=1)

if __name__ == "__main__":
    main()
