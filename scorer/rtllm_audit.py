"""Audit RTLLM testbenches with mutation testing + bounded formal equivalence.

For each design: (1) the official testbench must pass the reference; (2) the reference must be
formally equivalent to itself (scorer sanity); (3) for N seeded mutants of the reference, record
whether the testbench kills the mutant and whether the mutant is formally different from the
reference within a bounded depth from reset. A testbench "false pass" = a formally different mutant
that the testbench passes.
"""
import json, os, re, subprocess, sys, shutil, glob
from concurrent.futures import ProcessPoolExecutor, as_completed

EDA = os.path.expanduser("~/eda/oss-cad-suite/bin")
ENV = dict(os.environ, PATH=EDA + ":" + os.environ["PATH"])
RTLLM = os.path.expanduser("~/bench/RTLLM")
OUT = os.environ.get("AUDIT_OUT", "/home/claude/work/audit/rtllm")
NMUT = int(os.environ.get("NMUT", "24"))
DEPTH = int(os.environ.get("DEPTH", "20"))
SAT_TIMEOUT = int(os.environ.get("SAT_TIMEOUT", "90"))
PASS_RE = re.compile(r"Your Design Passed", re.I)

def run(cmd, cwd, timeout):
    try:
        p = subprocess.run(cmd, cwd=cwd, env=ENV, capture_output=True, text=True, timeout=timeout)
        return p.returncode, (p.stdout or "") + (p.stderr or "")
    except subprocess.TimeoutExpired:
        return "timeout", ""

def tb_verdict(cwd, design, tb, tag):
    rc, out = run(["iverilog", "-g2012", "-o", f"sim_{tag}", design, tb], cwd, 60)
    if rc != 0:
        return "compile_error"
    rc, out = run(["vvp", "-n", f"sim_{tag}"], cwd, 60)
    if rc == "timeout":
        return "timeout"
    return "pass" if PASS_RE.search(out) else "fail"

def ports(cwd, ref, top):
    rc, out = run(["yosys", "-q", "-p", f"read_verilog -sv {ref}; hierarchy -top {top}; proc; write_json ports.json"], cwd, 120)
    if rc != 0:
        return None
    m = json.load(open(os.path.join(cwd, "ports.json")))["modules"][top]["ports"]
    return {n: (p["direction"], len(p["bits"])) for n, p in m.items()}

def reset_opts(p):
    ins = {n: w for n, (d, w) in p.items() if d == "input"}
    opts, info = [], {}
    rst = [n for n in ins if re.search(r"rst|reset|clr|clear", n, re.I)]
    if rst:
        n = rst[0]
        low = bool(re.search(r"(_n|_b|n)$", n, re.I)) and not n.lower().endswith("en")
        val = 0 if low else 1
        info = {"reset": n, "active": val}
        for t in (1, 2):
            opts += ["-set-at", str(t), f"in_{n}", str(val)]
        for e in ins:
            if e != n and ins[e] == 1 and re.search(r"^(en|enable|ce|valid|.*_en|en_.*)$", e, re.I):
                for t in (1, 2):
                    opts += ["-set-at", str(t), f"in_{e}", "1"]
                info.setdefault("held_high_during_reset", []).append(e)
        opts += ["-prove-skip", "2"]
    else:
        info = {"reset": None}
    return opts, info

def equiv(cwd, gold, gate, top, rst_opts, tag):
    script = (
        f"read_verilog -sv {gold}; hierarchy -top {top}; proc; flatten; rename {top} gold; hierarchy -top gold; design -stash g; "
        f"read_verilog -sv {gate}; hierarchy -top {top}; proc; flatten; rename {top} gate; hierarchy -top gate; design -stash t; "
        f"design -copy-from g -as gold gold; design -copy-from t -as gate gate; "
        f"memory; opt_clean; async2sync; "
        f"miter -equiv -flatten -make_outputs -ignore_gold_x gold gate miter; hierarchy -top miter; "
        f"sat -verify -seq {DEPTH} -set-init-undef -enable_undef -set-def-inputs {' '.join(rst_opts)} -prove trigger 0 miter"
    )
    log = f"eq_{tag}.log"
    rc, out = run(["yosys", "-q", "-l", log, "-p", script], cwd, SAT_TIMEOUT)
    if rc == "timeout":
        return "timeout"
    txt = open(os.path.join(cwd, log)).read() if os.path.exists(os.path.join(cwd, log)) else out
    if rc == 0:
        return "equivalent"
    if "model found: FAIL" in txt:
        return "different"
    return "error"

def copy_side_files(design_dir, work):
    """Testbenches that read $readmemh / $fopen data need those files in the run directory."""
    for f in os.listdir(design_dir):
        if f.endswith(".v") or f in ("design_description.txt", "makefile"):
            continue
        src = os.path.join(design_dir, f)
        if os.path.isfile(src):
            shutil.copy(src, os.path.join(work, f))

def audit(design_dir):
    top = os.path.basename(design_dir)
    work = os.path.join(OUT, top)
    shutil.rmtree(work, ignore_errors=True); os.makedirs(work)
    ref_src = glob.glob(os.path.join(design_dir, "verified_*.v"))[0]
    txt = open(ref_src).read()
    renamed = bool(re.search(rf"\bmodule\s+verified_{top}\b", txt))
    txt = re.sub(rf"\bmodule\s+verified_{top}\b", f"module {top}", txt)
    open(os.path.join(work, "ref.v"), "w").write(txt)
    shutil.copy(os.path.join(design_dir, "testbench.v"), os.path.join(work, "tb.v"))
    copy_side_files(design_dir, work)
    res = {"design": top, "category": os.path.relpath(design_dir, RTLLM), "ref_module_renamed": renamed}
    res["ref_tb"] = tb_verdict(work, "ref.v", "tb.v", "ref")
    p = ports(work, "ref.v", top)
    if p is None:
        res["error"] = "yosys could not read reference"; return res
    ropts, rinfo = reset_opts(p); res["reset"] = rinfo
    res["self_equiv"] = equiv(work, "ref.v", "ref.v", top, ropts, "self")
    prep = f"read_verilog -sv ref.v; hierarchy -top {top}; proc; flatten; opt_clean"
    rc, _ = run(["yosys", "-q", "-p", f"{prep}; mutate -list {NMUT} -seed 1 -o muts.ys"], work, 120)
    muts = [l.strip() for l in open(os.path.join(work, "muts.ys"))] if rc == 0 and os.path.exists(os.path.join(work, "muts.ys")) else []
    res["mutants"] = []
    for i, m in enumerate(muts):
        mv = f"mut_{i:02d}.v"
        rc, _ = run(["yosys", "-q", "-p", f"{prep}; {m}; opt_clean; write_verilog -noattr {mv}"], work, 120)
        if rc != 0:
            res["mutants"].append({"id": i, "mutation": m, "tb": "gen_error", "equiv": "gen_error"}); continue
        tb = tb_verdict(work, mv, "tb.v", f"m{i}")
        eq = equiv(work, "ref.v", mv, top, ropts, f"m{i}")
        res["mutants"].append({"id": i, "mutation": m, "tb": tb, "equiv": eq})
    ms = res["mutants"]
    diff = [m for m in ms if m["equiv"] == "different"]
    res["summary"] = {
        "n_mutants": len(ms),
        "killed_by_tb": sum(m["tb"] != "pass" for m in ms if m["tb"] != "gen_error"),
        "formally_different": len(diff),
        "formally_equivalent": sum(m["equiv"] == "equivalent" for m in ms),
        "equiv_unknown": sum(m["equiv"] in ("timeout", "error") for m in ms),
        "tb_false_passes": sum(m["tb"] == "pass" for m in diff),
    }
    json.dump(res, open(os.path.join(work, "result.json"), "w"), indent=1)
    return res

if __name__ == "__main__":
    dirs = sorted(d for d in glob.glob(os.path.join(RTLLM, "*", "*", "*")) if glob.glob(os.path.join(d, "verified_*.v")))
    if len(sys.argv) > 1:
        dirs = [d for d in dirs if os.path.basename(d) in sys.argv[1:]]
    os.makedirs(OUT, exist_ok=True)
    results = []
    with ProcessPoolExecutor(max_workers=int(os.environ.get("WORKERS", "2"))) as ex:
        futs = {ex.submit(audit, d): d for d in dirs}
        for f in as_completed(futs):
            try:
                r = f.result()
            except Exception as e:
                r = {"design": os.path.basename(futs[f]), "error": repr(e)}
            results.append(r)
            print(json.dumps({"design": r["design"], "ref_tb": r.get("ref_tb"), "self_equiv": r.get("self_equiv"), **r.get("summary", {})}), flush=True)
    json.dump(sorted(results, key=lambda r: r["design"]), open(os.path.join(OUT, "all_results.json"), "w"), indent=1)