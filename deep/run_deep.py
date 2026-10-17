"""Deep runs:
  RUN1 (soundness): self-equivalence of all 50 RTLLM references, three engines,
      proof class per verdict. Also Icarus + Verilator testbench verdicts for refs.
  RUN2 (anchor+flips): all 290 shipped GPT designs: Icarus TB (+Verilator TB),
      BMC-10 equivalence for TB passes (pilot anchor), then unbounded PDR +
      smtbmc-induction on every BMC-equivalent row -> count verdict flips.
"""
import os, sys, json, glob, shutil, traceback
from concurrent.futures import ProcessPoolExecutor, as_completed
sys.path.insert(0, os.path.dirname(__file__))
import common as C

RTLLM = C.RTLLM
OUT = os.path.expanduser("~/runs/deep")
DESIGNS = {os.path.basename(d): d for d in
           glob.glob(os.path.join(RTLLM, "*", "*", "*"))
           if glob.glob(os.path.join(d, "verified_*.v"))}

def run1_ref(design):
    ddir = DESIGNS[design]
    work = os.path.join(OUT, "refs", design)
    shutil.rmtree(work, ignore_errors=True); os.makedirs(work)
    top = C.prep_design_src(ddir, work)
    rec = {"run": "ref", "design": top}
    try:
        rec["tb_icarus"] = C.tb_verdict(work, "ref.v", "tb.v", "ref")
        rec["tb_verilator"] = C.tb_verdict_verilator(work, "ref.v", "tb.v", "ref")
        p = C.ports(work, "ref.v", top)
        if p is None:
            rec["error"] = "yosys read error"; return rec
        ropts, rinfo = C.reset_opts(p)
        rec["reset"] = rinfo
        r = C.equiv_all(work, "ref.v", "ref.v", top, ropts, rinfo, p, "self")
        rec.update({k: r[k] for k in ("bmc", "pdr", "tind", "class", "witnesses")})
        rec["pdr_dir"] = r.get("pdr_dir")
    except Exception as e:
        rec["error"] = repr(e); rec["tb"] = traceback.format_exc()[-400:]
    json.dump(rec, open(os.path.join(work, "result.json"), "w"), indent=1)
    return rec

def run2_gpt(path):
    model, trial, fname = path.split(os.sep)[-3:]
    top = os.path.splitext(fname)[0]
    rec = {"run": "gpt", "model": model.strip("_"), "trial": trial, "design": top}
    if top not in DESIGNS:
        rec["tb_icarus"] = "no_task"; return rec
    ddir = DESIGNS[top]
    work = os.path.join(OUT, "gpt", model.strip("_"), trial, top)
    shutil.rmtree(work, ignore_errors=True); os.makedirs(work)
    try:
        top = C.prep_design_src(ddir, work, gen_src=path)
        rec["tb_icarus"] = C.tb_verdict(work, "gen.v", "tb.v", "gen")
        rec["tb_verilator"] = C.tb_verdict_verilator(work, "gen.v", "tb.v", "gen")
        if rec["tb_icarus"] == "pass":
            p = C.ports(work, "ref.v", top)
            if p is None:
                rec["equiv"] = "read_error"; return rec
            ropts, rinfo = C.reset_opts(p)
            r = C.equiv_all(work, "ref.v", "gen.v", top, ropts, rinfo, p, "gen")
            rec.update({k: r[k] for k in ("bmc", "pdr", "tind", "class", "witnesses")})
            rec["pdr_dir"] = r.get("pdr_dir")
            rec["flip"] = (r["bmc"] == "equivalent" and "different" in (r["pdr"], r["tind"]))
    except Exception as e:
        rec["error"] = repr(e)
    json.dump(rec, open(os.path.join(work, "result.json"), "w"), indent=1)
    return rec

if __name__ == "__main__":
    which = sys.argv[1] if len(sys.argv) > 1 else "all"
    workers = max(2, (os.cpu_count() or 4) - 2)
    os.makedirs(OUT, exist_ok=True)
    if which in ("refs", "all"):
        recs = []
        with ProcessPoolExecutor(max_workers=workers) as ex:
            futs = {ex.submit(run1_ref, d): d for d in sorted(DESIGNS)}
            for f in as_completed(futs):
                try: r = f.result()
                except Exception as e: r = {"design": futs[f], "error": repr(e)}
                recs.append(r)
                print(json.dumps({k: r.get(k) for k in ("design","tb_icarus","tb_verilator","bmc","pdr","tind","class")}), flush=True)
        json.dump(sorted(recs, key=lambda r: r["design"]),
                  open(os.path.join(OUT, "refs_summary.json"), "w"), indent=1)
    if which in ("gpt", "all"):
        files = sorted(glob.glob(os.path.join(RTLLM, "_chatgpt*", "t*", "*.v")))
        recs = []
        with ProcessPoolExecutor(max_workers=workers) as ex:
            futs = {ex.submit(run2_gpt, p): p for p in files}
            for f in as_completed(futs):
                try: r = f.result()
                except Exception as e: r = {"design": os.path.basename(futs[f]), "error": repr(e)}
                recs.append(r)
                keys = ("model","trial","design","tb_icarus","tb_verilator","bmc","pdr","tind","class","flip")
                print(json.dumps({k: r.get(k) for k in keys}), flush=True)
        json.dump(recs, open(os.path.join(OUT, "gpt_summary.json"), "w"), indent=1)
