#!/usr/bin/env python3
"""scoring/run_scoring.py — pinned strict-scoring driver (A16 §3 step 8 / §6 step 3).

Drives scorer/score.py over a generation file, one output row per sample,
RESUMABLE on (bench, task_id, sample_idx), recording the scorer commit AND the
scorer sha256 in every row. Uses scoring/extract.py (pinned) for extraction and
the module-name check, so G2 and the scorer see the same glue.

Usage (Phase 10 §6 step 3):
  python3 scoring/run_scoring.py --arm 7b-rl --gen ~/runs/gen/7b-rl.jsonl \
      --out scores/7b-rl.jsonl [--sat-timeout 60] [--workers N] [--cex-out results/main/cex]

Environment for score.py is inherited; WORKERS/SAT_TIMEOUT are set explicitly
from --workers/--sat-timeout (defaults: WORKERS=nproc-2, SAT_TIMEOUT=60).
Freeze checks (git diff --quiet scorer-v1 -- scorer tests; sha256sum -c
results/pilot_repro/SCORER_SHA256) are the caller's Phase 10 pre-steps.
"""
import argparse
import json
import os
import subprocess
import sys

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(REPO, "scoring"))
from extract import extract_record  # pinned extractor


def scorer_commit():
    c = subprocess.run(["git", "-C", REPO, "rev-parse", "scorer-v1^{commit}"],
                       capture_output=True, text=True)
    return c.stdout.strip() if c.returncode == 0 else "scorer-v1-tag-missing"


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--arm", required=True)
    ap.add_argument("--gen", required=True, help="~/runs/gen/<arm>.jsonl")
    ap.add_argument("--out", required=True, help="scores/<arm>.jsonl")
    ap.add_argument("--sat-timeout", type=int, default=60)
    ap.add_argument("--workers", type=int, default=max(1, os.cpu_count() - 2))
    ap.add_argument("--cex-out", default="", help="dir for counterexample tables")
    ap.add_argument("--limit", type=int, default=0)
    args = ap.parse_args()

    commit = scorer_commit()
    env = dict(os.environ, WORKERS=str(args.workers), SAT_TIMEOUT=str(args.sat_timeout),
               BMC_DEPTH="10")

    rows = [json.loads(l) for l in open(args.gen, encoding="utf-8")]
    if args.limit:
        rows = rows[: args.limit]

    done = set()
    if os.path.isfile(args.out):
        for l in open(args.out, encoding="utf-8"):
            r = json.loads(l)
            done.add((r["bench"], r["task_id"], r["sample_idx"]))
    todo = [r for r in rows if (r["bench"], r["task_id"], r["sample_idx"]) not in done]
    print(f"samples total={len(rows)} already_done={len(rows) - len(todo)} todo={len(todo)} "
          f"scorer-v1={commit[:12]}", flush=True)

    os.makedirs(os.path.dirname(args.out) or ".", exist_ok=True)
    sam_dir = os.path.join(os.path.dirname(args.out) or ".", f"samples_{args.arm}")
    work_root = os.path.expanduser(f"~/runs/scoring/{args.arm}")
    os.makedirs(sam_dir, exist_ok=True)
    os.makedirs(work_root, exist_ok=True)

    with open(args.out, "a", encoding="utf-8") as out:
        for i, r in enumerate(todo):
            key = f'{r["bench"]}_{r["task_id"]}_{r["sample_idx"]}'
            ex = extract_record(r["completion"], r["bench"], r["task_id"])
            sf = os.path.join(sam_dir, f"{key}.v")
            open(sf, "w").write(ex["code"] if ex["code"].strip() else "// extraction failed\n")
            wdir = os.path.join(work_root, key)  # outside score.py --out is impossible;
            # score.py rmtree's its --out, so give each sample its own --out under ~/runs.
            p = subprocess.run(
                [sys.executable, os.path.join(REPO, "scorer", "score.py"),
                 "--bench", r["bench"], "--task", r["task_id"], "--sample", sf,
                 "--out", wdir],
                capture_output=True, text=True, timeout=3600, env=env)
            try:
                verdict = json.loads(p.stdout.strip().splitlines()[-1])
            except Exception:
                verdict = {"tb": "error", "equiv": "error", "error": p.stderr[-300:]}
            tb, equiv, nv = verdict.get("tb"), verdict.get("equiv"), bool(verdict.get("nonvacuous"))
            strict = (tb == "pass" and nv and equiv == "equivalent")
            from stats import a16_class  # pinned classifier
            row = {"arm": args.arm, "bench": r["bench"], "task_id": r["task_id"],
                   "sample_idx": r["sample_idx"], "seed": r.get("seed"),
                   "extract_ok": ex["extract_ok"], "module_name_ok": ex["module_name_ok"],
                   "tb": tb, "equiv": equiv, "nonvacuous": nv,
                   "strict_correct": strict, "class": a16_class(tb, equiv, nv),
                   "formally_different": equiv == "different",
                   "depth": verdict.get("depth"),
                   "scorer_commit": commit,
                   "scorer_sha256": verdict.get("scorer_sha256"),
                   "verdict": verdict}
            out.write(json.dumps(row, ensure_ascii=False) + "\n")
            out.flush()
            if args.cex_out and equiv == "different":
                cd = os.path.join(args.cex_out, args.arm)
                os.makedirs(cd, exist_ok=True)
                dst = os.path.join(cd, f'{r["task_id"]}__{r["sample_idx"]}.txt')
                # showcex formats a yosys 'sat -show-ports' log; the deep engines
                # leave VCDs (which stay in ~/runs per A16). Write the table when a
                # sat log exists, else a pointer to the VCD counterexamples.
                cands = [os.path.join(wdir, "cex.log"), os.path.join(wdir, "sat.log")]
                cands += [os.path.join(wdir, f) for f in os.listdir(wdir)
                          if f.endswith(".log")] if os.path.isdir(wdir) else []
                vcds = []
                cexd = os.path.join(wdir, "cex")
                if os.path.isdir(cexd):
                    vcds = [os.path.join(cexd, f) for f in os.listdir(cexd) if f.endswith(".vcd")]
                with open(dst, "w") as f:
                    wrote = False
                    for sl in cands:
                        if os.path.isfile(sl) and open(sl, errors="ignore").read(1):
                            f.write(subprocess.run([sys.executable,
                                                    os.path.join(REPO, "scoring", "showcex.py"), sl],
                                                   capture_output=True, text=True).stdout)
                            wrote = True
                            break
                    if not wrote:
                        f.write("# no sat log; VCD counterexamples (stay in ~/runs):\n"
                                + "\n".join(vcds) + "\n")
            print(f"[{i + 1}/{len(todo)}] {key} tb={tb} equiv={equiv} strict={strict}",
                  flush=True)
    print("DONE", flush=True)


if __name__ == "__main__":
    main()
