#!/usr/bin/env python3
"""Phase 8 step 5: build gen/manifests/<arm>.json from ~/runs/gen/<arm>_*.jsonl.

Manifest fields (brief): row counts, sha256 of each jsonl, truncation count
(finish_reason == 'length'), extraction success rate (CodeV extractor, non-empty
code), module-name pass rate per benchmark convention, cap-hit token stats.
Run on the host after generation; only the manifests are committed.
"""
import glob
import hashlib
import json
import os
import sys

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
GEN = os.path.expanduser("~/runs/gen")
sys.path.insert(0, os.path.expanduser("~/bench/CodeV-R1/test/utils"))
from verilog_extractor import extract_verilog_code


def main():
    arms = sorted({os.path.basename(p).split("_")[0] for p in glob.glob(os.path.join(GEN, "*.jsonl"))}
                  - {"gen"})
    for arm in arms:
        files = sorted(glob.glob(os.path.join(GEN, f"{arm}_*.jsonl")))
        man = {"arm": arm, "files": []}
        tot = trunc = ext_ok = name_ok = 0
        toks = []
        for f in files:
            rows = [json.loads(l) for l in open(f, encoding="utf-8")]
            h = hashlib.sha256(open(f, "rb").read()).hexdigest()
            t = e = n = 0
            for r in rows:
                code = extract_verilog_code(r["completion"])
                want = "TopModule" if r["bench"] == "ve" else r["task_id"]
                t += r["finish_reason"] == "length"
                e += bool(code.strip())
                n += bool(code.strip()) and want in code
                toks.append(r["n_completion_tokens"])
            man["files"].append({"file": os.path.basename(f), "rows": len(rows), "sha256": h,
                                 "truncated": t, "extracted": e, "module_name_ok": n})
            tot += len(rows); trunc += t; ext_ok += e; name_ok += n
        man.update({"rows_total": tot, "truncated_total": trunc,
                    "extraction_rate": round(ext_ok / tot, 4) if tot else None,
                    "module_name_ok_rate": round(name_ok / tot, 4) if tot else None,
                    "completion_tokens": {"mean": round(sum(toks) / len(toks)) if toks else 0,
                                          "max": max(toks) if toks else 0}})
        os.makedirs(os.path.join(REPO, "gen/manifests"), exist_ok=True)
        out = os.path.join(REPO, f"gen/manifests/{arm}.json")
        with open(out, "w") as fh:
            json.dump(man, fh, indent=1)
        print(json.dumps({k: man[k] for k in ("arm", "rows_total", "truncated_total",
                                              "extraction_rate", "module_name_ok_rate")}))


if __name__ == "__main__":
    main()
