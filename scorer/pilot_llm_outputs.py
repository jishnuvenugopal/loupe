"""Pilot of the strict scorer on real LLM outputs shipped in the RTLLM repo (_chatgpt4, _chatgpt35).
For each generated design: run the RTLLM v2.1 testbench; if it passes, run bounded formal equivalence
against the v2.1 reference. 'False pass' = testbench passes but the design differs from the reference."""
import glob, json, os, re, shutil, sys
from concurrent.futures import ProcessPoolExecutor, as_completed
sys.path.insert(0, os.path.dirname(__file__))
import rtllm_audit as A

OUT = os.environ.get("PILOT_OUT", os.environ.get("PILOT_OUT", os.path.expanduser("~/runs/pilot")))
DIRS = {os.path.basename(d): d for d in glob.glob(os.path.join(A.RTLLM, "*", "*", "*")) if glob.glob(os.path.join(d, "verified_*.v"))}

def score(gen_path):
    model, trial, fname = gen_path.split(os.sep)[-3:]
    top = os.path.splitext(fname)[0]
    rec = {"model": model.strip("_"), "trial": trial, "design": top}
    if top not in DIRS:
        rec["status"] = "no_task"; return rec
    work = os.path.join(OUT, model.strip("_"), trial, top)
    shutil.rmtree(work, ignore_errors=True); os.makedirs(work)
    ref_txt = open(glob.glob(os.path.join(DIRS[top], "verified_*.v"))[0]).read()
    ref_txt = re.sub(rf"\bmodule\s+verified_{top}\b", f"module {top}", ref_txt)
    open(os.path.join(work, "ref.v"), "w").write(ref_txt)
    shutil.copy(gen_path, os.path.join(work, "gen.v"))
    shutil.copy(os.path.join(DIRS[top], "testbench.v"), os.path.join(work, "tb.v"))
    A.copy_side_files(DIRS[top], work)
    rec["tb"] = A.tb_verdict(work, "gen.v", "tb.v", "gen")
    if rec["tb"] == "pass":
        p = A.ports(work, "ref.v", top)
        ropts, rinfo = A.reset_opts(p) if p else ([], {})
        rec["reset"] = rinfo
        rec["equiv"] = A.equiv(work, "ref.v", "gen.v", top, ropts, "gen")
    json.dump(rec, open(os.path.join(work, "result.json"), "w"))
    return rec

if __name__ == "__main__":
    files = sorted(glob.glob(os.path.join(A.RTLLM, "_chatgpt*", "t*", "*.v")))
    os.makedirs(OUT, exist_ok=True)
    recs = []
    with ProcessPoolExecutor(max_workers=int(os.environ.get("WORKERS", "1"))) as ex:
        for f in as_completed([ex.submit(score, p) for p in files]):
            r = f.result(); recs.append(r); print(json.dumps(r), flush=True)
    json.dump(recs, open(os.path.join(OUT, "all.json"), "w"), indent=1)