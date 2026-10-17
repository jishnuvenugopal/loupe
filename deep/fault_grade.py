"""D3 power: fault-grade the official testbench AND the strict scorer itself.

For each usable design: 12 seeded mutants (`yosys mutate -list 12 -seed 1`, the
pilot's own recipe). Per mutant:
  - official TB verdict, Icarus            (pilot baseline)
  - official TB verdict, Verilator         (independent witness)
  - strict verdict = formal check: BMC-10 + unbounded PDR/smtbmc-ind

Classifications:
  formally-different : any engine produced a counterexample
  TB false pass      : formally different AND Icarus TB passes   (pilot metric)
  strict survivor    : formally different? no engine says so -> impossible by
                       definition; the interesting set is engines-UNKNOWN, which
                       is reported separately as the scorer's measured blind spot.
  X-semantics split  : engines PROVE equivalent (unbounded) but TB kills the
                       mutant -> the TB kill must come from behaviour outside the
                       from-reset 2-valued semantic (pre-reset checks, X-pessimism
                       in 4-valued sim). Counted and explained, not hidden.
"""
import os, sys, json, glob, shutil
from concurrent.futures import ProcessPoolExecutor, as_completed
sys.path.insert(0, os.path.dirname(__file__))
import common as C

OUT = os.path.expanduser("~/runs/deep/mut")
DESIGNS = {os.path.basename(d): d for d in
           glob.glob(os.path.join(C.RTLLM, "*", "*", "*"))
           if glob.glob(os.path.join(d, "verified_*.v"))}
NMUT = int(os.environ.get("NMUT", "12"))

def mutate_design(design):
    ddir = DESIGNS[design]
    work = os.path.join(OUT, design)
    shutil.rmtree(work, ignore_errors=True); os.makedirs(work)
    top = C.prep_design_src(ddir, work)
    rec = {"design": top, "mutants": []}
    p = C.ports(work, "ref.v", top)
    if p is None:
        rec["error"] = "ports"; return rec
    ropts, rinfo = C.reset_opts(p)
    prep = f"read_verilog -sv ref.v; hierarchy -top {top}; proc; flatten; opt_clean"
    rc, _ = C.run(["yosys", "-q", "-p", f"{prep}; mutate -list {NMUT} -seed 1 -o muts.ys"], work, 120)
    muts = [l.strip() for l in open(os.path.join(work, "muts.ys"))] if rc == 0 else []
    for i, m in enumerate(muts):
        mv = f"mut_{i:02d}.v"
        rc, _ = C.run(["yosys", "-q", "-p",
                       f"{prep}; {m}; opt_clean; write_verilog -noattr {mv}"], work, 120)
        if rc != 0:
            rec["mutants"].append({"id": i, "tb": "gen_error", "bmc": "gen_error",
                                   "pdr": "gen_error", "tind": "gen_error"}); continue
        # module name inside mutant netlist is still `top`
        tb = C.tb_verdict(work, mv, "tb.v", f"m{i}")
        tvb = C.tb_verdict_verilator(work, mv, "tb.v", f"m{i}")
        r = C.equiv_all(work, "ref.v", mv, top, ropts, rinfo, p, f"m{i}")
        rec["mutants"].append({"id": i, "mutation": m[:80], "tb": tb, "tb_v": tvb,
                               "bmc": r["bmc"], "pdr": r["pdr"], "tind": r["tind"],
                               "class": r["class"]})
    json.dump(rec, open(os.path.join(work, "result.json"), "w"), indent=1)
    return rec

if __name__ == "__main__":
    # usable set: pilot's 38 + the two designs the deep harness newly proved
    # self-equivalent (multi_8bit, multi_pipe_8bit) minus what still fails
    want = sys.argv[1:] or None
    designs = sorted(DESIGNS) if not want else [d for d in want if d in DESIGNS]
    workers = max(2, (os.cpu_count() or 4) - 2)
    os.makedirs(OUT, exist_ok=True)
    recs, done = [], set()
    donefile = os.path.join(OUT, "_done.txt")
    if os.path.exists(donefile):
        done = set(open(donefile).read().split())
    todo = [d for d in designs if d not in done]
    with ProcessPoolExecutor(max_workers=workers) as ex:
        futs = {ex.submit(mutate_design, d): d for d in todo}
        for f in as_completed(futs):
            try: r = f.result()
            except Exception as e: r = {"design": futs[f], "error": repr(e)}
            recs.append(r)
            s = r.get("summary") or {}
            print(json.dumps({"design": r["design"], "error": r.get("error"),
                              "n": len(r.get("mutants", []))}), flush=True)
            with open(donefile, "a") as fh: fh.write(r["design"] + "\n")
    # merge with previously done
    for d in done:
        jf = os.path.join(OUT, d, "result.json")
        if os.path.exists(jf): recs.append(json.load(open(jf)))
    json.dump(sorted(recs, key=lambda r: r.get("design", "")),
              open(os.path.join(OUT, "mut_summary.json"), "w"), indent=1)
