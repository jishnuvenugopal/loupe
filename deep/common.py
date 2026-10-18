"""Deep-oracle scorer: pilot-compatible preprocessing + three proof engines.

Engines per equivalence question:
  bmc    : yosys `sat -seq N` (pilot baseline, depth 10)
  pdr    : SymbiYosys `prove` mode, engine `abc pdr` (unbounded)
  tind   : yosys `sat -tempinduct` (k-induction, second unbounded witness)

Verdict classes (never a bare "equivalent"):
  DIFFERENT        — any engine produced a counterexample
  UNBOUNDED-EQ     — pdr or tind proved equivalence unbounded
  BMC-N-EQ-ONLY    — bmc says equivalent at N, no unbounded witness
  UNKNOWN          — no engine concluded
"""
import os, re, subprocess, json, shutil, glob
from concurrent.futures import ProcessPoolExecutor, as_completed

EDA = os.path.expanduser("~/eda/oss-cad-suite/bin")
ENV = dict(os.environ, PATH=EDA + ":" + os.environ["PATH"])
RTLLM = os.path.expanduser("~/bench/RTLLM")
OUT = os.environ.get("DEEP_OUT", os.path.expanduser("~/runs/deep"))
NMUT = int(os.environ.get("NMUT", "12"))
BMC_DEPTH = int(os.environ.get("BMC_DEPTH", "10"))
BMC_TIMEOUT = int(os.environ.get("BMC_TIMEOUT", "60"))
PDR_TIMEOUT = int(os.environ.get("PDR_TIMEOUT", "300"))
PASS_RE = re.compile(r"Your Design Passed", re.I)

def run(cmd, cwd, timeout, env=None):
    try:
        p = subprocess.run(cmd, cwd=cwd, env=env or ENV, capture_output=True,
                           text=True, timeout=timeout)
        return p.returncode, (p.stdout or "") + (p.stderr or "")
    except subprocess.TimeoutExpired:
        return "timeout", ""

# ---------- pilot-compatible pieces (rtllm_audit.py) ----------

def tb_verdict(cwd, design, tb, tag):
    rc, out = run(["iverilog", "-g2012", "-o", f"sim_{tag}", design, tb], cwd, 60)
    if rc != 0:
        return "compile_error"
    rc, out = run(["vvp", "-n", f"sim_{tag}"], cwd, 60)
    if rc == "timeout":
        return "timeout"
    return "pass" if PASS_RE.search(out) else "fail"

def tb_verdict_verilator(cwd, design, tb, tag, extra_src=None):
    """Independent second simulator (top module parsed from the testbench;
    RTLLM names vary: test_alu, t, tb...). Binary lands under -Mdir."""
    mods = re.findall(r"^\s*module\s+(\w+)", open(os.path.join(cwd, tb)).read(), re.M)
    top = "tb" if "tb" in mods else (mods[-1] if mods else "tb")
    mdir = f"vlb_{tag}"
    rc, out = run(["verilator", "--binary", "--timing", "-Wno-fatal", "-Wno-WIDTHEXPAND",
                   "-Wno-WIDTHTRUNC", "-Wno-UNOPTFLAT", "-Wno-MULTIDRIVEN", "-Wno-lint",
                   "--top-module", top, "--Mdir", mdir, "-o", f"vSim_{tag}", design, tb]
                   + ([extra_src] if extra_src else []), cwd, 180)
    if rc != 0:
        return "vl_compile_error"
    rc, out = run([os.path.join(mdir, f"vSim_{tag}")], cwd, 60)
    if rc == "timeout":
        return "timeout"
    if PASS_RE.search(out):
        return "pass"
    m = re.search(r"Mismatches: (\d+) in (\d+) samples", out or "")
    if m:
        return "pass" if (m.group(1) == "0" and int(m.group(2)) >= 1) else "fail"
    m = re.search(r"Total mismatched samples is (\d+) out of (\d+) samples", out or "")
    if m:
        return "pass" if (m.group(1) == "0" and int(m.group(2)) >= 1) else "fail"
    return "fail"

def ports(cwd, ref, top):
    rc, out = run(["yosys", "-q", "-p",
                   f"read_verilog -sv {ref}; hierarchy -top {top}; proc; write_json ports.json"],
                   cwd, 120)
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

def copy_side_files(design_dir, work):
    for f in os.listdir(design_dir):
        if f.endswith(".v") or f in ("design_description.txt", "makefile"):
            continue
        src = os.path.join(design_dir, f)
        if os.path.isfile(src):
            shutil.copy(src, os.path.join(work, f))

def prep_design_src(design_dir, work, gen_src=None):
    """Reference (renamed) into ref.v, optional candidate into gen.v, testbench + side files."""
    top = os.path.basename(design_dir)
    ref_src = glob.glob(os.path.join(design_dir, "verified_*.v"))[0]
    txt = open(ref_src).read()
    txt = re.sub(rf"\bmodule\s+verified_{top}\b", f"module {top}", txt)
    open(os.path.join(work, "ref.v"), "w").write(txt)
    if gen_src is not None:
        shutil.copy(gen_src, os.path.join(work, "gen.v"))
    shutil.copy(os.path.join(design_dir, "testbench.v"), os.path.join(work, "tb.v"))
    copy_side_files(design_dir, work)
    return top

# ---------- the shared miter front-end ----------

MITER_SCRIPT = """read_verilog -sv {gold}; hierarchy -top {top}; proc; flatten; rename {top} gold; hierarchy -top gold; design -stash g;
read_verilog -sv {gate}; hierarchy -top {top}; proc; flatten; rename {top} gate; hierarchy -top gate; design -stash t;
design -copy-from g -as gold gold; design -copy-from t -as gate gate; memory; opt_clean; async2sync;
miter -equiv -flatten -make_outputs -ignore_gold_x gold gate miter; hierarchy -top miter;
"""

def _miter_script(gold, gate, top, make_assert=False):
    m = ("miter -equiv -flatten -make_assert -ignore_gold_x gold gate miter; "
         "hierarchy -top miter; opt_clean;" if make_assert else
         "miter -equiv -flatten -make_outputs -ignore_gold_x gold gate miter; "
         "hierarchy -top miter;")
    return MITER_SCRIPT.format(gold=gold, gate=gate, top=top) .replace(
        "miter -equiv -flatten -make_outputs -ignore_gold_x gold gate miter; hierarchy -top miter;", m)

def bmc_check(work, gold, gate, top, rst_opts, tag, depth=BMC_DEPTH):
    """Pilot baseline: bounded sat. Returns (verdict, log_path)."""
    script = _miter_script(gold, gate, top) + (
        f"sat -verify -seq {depth} -set-init-undef -enable_undef -set-def-inputs "
        f"{' '.join(rst_opts)} -prove trigger 0 miter")
    log = os.path.join(work, f"bmc_{tag}.log")
    rc, out = run(["yosys", "-q", "-l", log, "-p", script], work, BMC_TIMEOUT)
    txt = open(log).read() if os.path.exists(log) else out
    if rc == "timeout":
        return "timeout", log
    if rc == 0:
        return "equivalent", log          # proven within `depth` steps
    if "model found: FAIL" in txt or "FAIL" in txt and "SAT proof finished" in txt:
        return "different", log
    return "error", log

def _sby_task(work, gold, gate, top, tag, script_body, mode, engine, timeout, extra_opts=""):
    """Run one SymbiYosys task. Returns (status, taskdir)."""
    tdir = os.path.join(work, f"sby_{tag}_{mode}_{engine.split()[0].replace('_','')}")
    shutil.rmtree(tdir, ignore_errors=True)
    gold_ab, gate_ab = os.path.join(work, gold), os.path.join(work, gate)
    sby = f"""[options]
mode {mode}
{extra_opts}

[engines]
{engine}

[script]
{script_body}

[files]
{gold_ab}
{gate_ab}
"""
    sp = os.path.join(work, f"{tag}.sby")
    open(sp, "w").write(sby)
    rc, out = run(["sby", "-f", "-d", tdir, sp], work, timeout)
    logf = os.path.join(tdir, "logfile.txt")
    txt = open(logf).read() if os.path.exists(logf) else out
    status = "UNKNOWN"
    if "Status: PASS" in txt or "DONE (PROVE, PASS)" in txt or "DONE (COVER, PASS)" in txt:
        status = "PASS"
    elif "Status: FAIL" in txt or "DONE (PROVE, FAIL)" in txt or "DONE (COVER, NEVER)" in txt:
        status = "FAIL"
    elif rc == "timeout":
        status = "TIMEOUT"
    elif "Status: UNKNOWN" in txt or "DONE (PROVE, UNKNOWN)" in txt or "ERROR" in txt:
        status = "UNKNOWN"
    return status, tdir

# ---------- unbounded engines via reset-scaffold wrapper ----------

def _unbounded_script(gold, gate, top):
    """sby [script] body: build gold/gate copies in-session (no netlist
    round-trip), then the scaffolded wrapper on top.

    Initial-state policy (documented; soundness-checked by self-equivalence):
    memories mapped to FFs, tri-state Z resolved to logic, every FF zero-init
    (`setundef -zero -init`) so both copies start from the SAME state. Matches
    the operational semantics of the official testbenches (no memory preload,
    reset driven at start) and removes uncorrelated free initial bits, which
    made even self-equivalence fail (RAM/ROM/alu before this fix)."""
    pre = "proc; flatten; memory_map; tribuf -logic; opt_clean; async2sync; setundef -zero -init; "
    return (f"read_verilog -sv {gold}; hierarchy -top {top}; {pre}rename {top} top_gold; design -stash gsrc;\n"
            f"read_verilog -sv {gate}; hierarchy -top {top}; {pre}rename {top} top_gate; design -stash tsrc;\n"
            f"design -copy-from gsrc -as top_gold top_gold; design -copy-from tsrc -as top_gate top_gate;\n"
            f"read_verilog -sv wrap.sv; prep -top wrap")

def build_nets(work, gold_src, gate_src, top):
    """Kept for API compat: unbounded path no longer needs netlist files."""
    return {"top_gold": gold_src, "top_gate": gate_src}, ""

def gen_wrap(work, p, rinfo, mgold, mgate):
    """Generate wrap.sv: common inputs, a 2-cycle forced reset (with the pilot's
    held-high enables), output comparison enabled from cycle 3, assert(!bad).

    This scaffolding is the unbounded analogue of the pilot's BMC flags
    `-set-at 1/2 <rst> -set-at 1/2 <en> -prove-skip 2`: it compares only after a
    common reset has driven both copies from *uncorrelated* initial state into
    their reset state, so an unbounded proof means 'equivalent from reset, forever',
    not 'equivalent from arbitrary paired states'."""
    ins = [(n, w) for n, (d, w) in p.items() if d == "input"]
    outs = [(n, w) for n, (d, w) in p.items() if d == "output"]
    clk = next((n for n, _ in ins if re.search(r"^(clk|clock)$", n, re.I)), None)
    rst = rinfo.get("reset"); active = rinfo.get("active")
    ens = rinfo.get("held_high_during_reset", [])
    L = []
    L.append("module wrap(" + ", ".join(n for n, _ in ins) + ");")
    for n, w in ins:
        L.append(f"  input {'[%d:0] ' % (w-1) if w > 1 else ''}{n};")
    for n, w in outs:
        L.append(f"  wire {'[%d:0] ' % (w-1) if w > 1 else ''}{n}_g, {n}_m;")
    if clk and rst is not None:
        L.append("  reg [1:0] t = 2'd0;")
        L.append(f"  always @(posedge {clk}) if (t < 2'd3) t <= t + 2'd1;")
        L.append(f"  wire rst_eff = (t < 2'd2) ? 1'b{active} : {rst};")
        conns = []
        for n, w in ins:
            if n == rst:
                conns.append((n, "rst_eff"))
            elif n in ens:
                L.append(f"  wire en_{n} = (t < 2'd2) ? 1'b1 : {n};")
                conns.append((n, f"en_{n}"))
            else:
                conns.append((n, n))
        for mod in (mgold, mgate):
            suffix = "g" if mod == mgold else "m"
            L.append("  " + mod + " u_" + mod + " (" +
                     ", ".join(f".{n}({s})" for n, s in conns) + ", " +
                     ", ".join(f".{n}({n}_{suffix})" for n, _ in outs) + ");")
        cmps = " || ".join(f"({n}_g != {n}_m)" for n, _ in outs)
        L.append(f"  wire bad = (t >= 2'd3) && ({cmps});")
        L.append(f"  always @(posedge {clk}) if (t >= 2'd3) assert (!bad);")
    else:
        for mod in (mgold, mgate):
            L.append("  " + mod + " u_" + mod + " (" +
                     ", ".join(f".{n}({n})" for n, _ in ins) + ", " +
                     ", ".join(f".{n}({n}_{ 'g' if mod == mgold else 'm'})" for n, _ in outs) + ");")
        cmps = " || ".join(f"({n}_g != {n}_m)" for n, _ in outs)
        L.append(f"  wire bad = {cmps};")
        L.append("  always @* assert (!bad);")
    L.append("endmodule")
    path = os.path.join(work, "wrap.sv")
    open(path, "w").write("\n".join(L) + "\n")
    return path

def pdr_check(work, gold, gate, top, tag):
    """Unbounded: sby prove + abc pdr on the scaffolded wrapper."""
    status, tdir = _sby_task2(work, tag, _unbounded_script(gold, gate, top), "prove",
                              "abc pdr", PDR_TIMEOUT, [gold, gate, "wrap.sv"])
    return {"PASS": "equivalent", "FAIL": "different",
            "TIMEOUT": "timeout", "UNKNOWN": "unknown"}.get(status, "unknown"), tdir

def tind_check(work, gold, gate, top, tag):
    """Second unbounded witness, different solver technology: sby prove + smtbmc
    (SMT-based induction with base case), on the same scaffolded wrapper."""
    status, tdir = _sby_task2(work, tag + "ind", _unbounded_script(gold, gate, top),
                              "prove", "smtbmc z3", PDR_TIMEOUT, [gold, gate, "wrap.sv"])
    return {"PASS": "equivalent", "FAIL": "different",
            "TIMEOUT": "timeout", "UNKNOWN": "unknown"}.get(status, "unknown"), tdir

def _sby_task2(work, tag, script_body, mode, engine, timeout, files):
    tdir = os.path.join(work, f"sby_{tag}_{mode}_{engine.split()[0]}")
    shutil.rmtree(tdir, ignore_errors=True)
    sby = f"[options]\nmode {mode}\n\n[engines]\n{engine}\n\n[script]\n{script_body}\n\n[files]\n"
    sby += "\n".join(os.path.join(work, f) for f in files) + "\n"
    sp = os.path.join(work, f"{tag}_w.sby")
    open(sp, "w").write(sby)
    rc, out = run(["sby", "-f", "-d", tdir, sp], work, timeout)
    logf = os.path.join(tdir, "logfile.txt")
    txt = open(logf).read() if os.path.exists(logf) else out
    if ("Status: PASS" in txt or "DONE (PROVE, PASS)" in txt or "DONE (PASS," in txt
            or "DONE (COVER, PASS)" in txt):
        return "PASS", tdir
    if ("Status: FAIL" in txt or "DONE (PROVE, FAIL)" in txt or "DONE (FAIL," in txt
            or "DONE (COVER, NEVER)" in txt):
        return "FAIL", tdir
    if rc == "timeout":
        return "TIMEOUT", tdir
    return "UNKNOWN", tdir

def equiv_all(work, gold, gate, top, rst_opts, rinfo, p, tag):
    """Full deep verdict with proof class."""
    r = {}
    r["bmc"], r["bmc_log"] = bmc_check(work, gold, gate, top, rst_opts, tag)
    werr = gen_wrap(work, p, rinfo, "top_gold", "top_gate")
    r["pdr"], r["pdr_dir"] = pdr_check(work, gold, gate, top, tag)
    r["tind"], r["tind_log"] = tind_check(work, gold, gate, top, tag)
    if "different" in (r["bmc"], r["pdr"], r["tind"]):
        r["class"] = "DIFFERENT"
    elif "equivalent" in (r["pdr"], r["tind"]):
        r["class"] = "UNBOUNDED-EQ"
    elif r["bmc"] == "equivalent":
        r["class"] = "BMC-%d-EQ-ONLY" % BMC_DEPTH
    else:
        r["class"] = "UNKNOWN"
    r["witnesses"] = {"pdr": r["pdr"], "tind": r["tind"], "bmc": r["bmc"]}
    return r
