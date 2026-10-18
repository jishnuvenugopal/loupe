#!/usr/bin/env python3
"""scoring/dedup.py — pinned dedup-map builder (A16 §6 step 4; written pre-G0
per A18 item 5, with the A18 item-2 key form).

Builds the dedup map exactly as PREREG states, within each (arm, task):

  exact        sha256 of the EXTRACTED code with comments and all whitespace
               removed (extraction = scoring/extract.py, the CodeV extractor
               with its defaults — it strips comments itself; we strip again,
               idempotently, then remove all whitespace).
  normalised   sha256 of the output of
                 yosys -p "read_verilog -sv <file>; hierarchy -top <top>;
                            proc; opt_clean; rename -enumerate; write_rtlil"
               with every `attribute \\src` line removed (top = TopModule for
               VerilogEval, the task id for RTLLM).

Two samples are duplicates if their exact hashes are equal OR their normalised
hashes are equal (union-find within arm x task, so chains collapse too). A
sample whose normalised hash cannot be computed (yosys fails) still groups by
its exact hash; the yosys failure count is reported.

Output: a JSON map  {"<arm>|<bench>|<task>|<sample_idx>": "<design_key>", ...}
— exactly the form scoring/stats.py --dedup reads (sample_idx is a STRING on
both sides, A18 item 2). The design_key of a group is its normalised hash
(12 hex chars) if any member normalised, else "x:" + exact hash (12 hex).
Rows whose extraction produced no code get design_key "noext:<n>" (unique per
row: they never collapse, and are reported).

Also writes <out>.summary.json with per-arm counts.

Usage:
  python3 scoring/dedup.py --gen ~/runs/gen/7b-rl_ve.jsonl ~/runs/gen/7b-rl_rtllm.jsonl \
      --out results/main/dedup_map.json [--yosys ~/eda/oss-cad-suite/bin/yosys]
"""
import argparse
import hashlib
import json
import os
import re
import subprocess
import sys
import tempfile

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(REPO, "scoring"))
from extract import extract_record  # pinned extractor (same glue as run_scoring)

COMMENT_RE = re.compile(r"//[^\n]*|/\*[\s\S]*?\*/")
YOSYS_DEFAULT = os.path.expanduser("~/eda/oss-cad-suite/bin/yosys")


def strip_code(code):
    """Comments removed, then ALL whitespace removed (PREREG exact rule)."""
    return re.sub(COMMENT_RE, "", code or "")


def exact_hash(code):
    return hashlib.sha256(strip_code(code).encode()).hexdigest()


def norm_hash(code, top, yosys, cache):
    """PREREG normalised rule: yosys read; hierarchy -top; proc; opt_clean;
    rename -enumerate; write_rtlil, with `attribute \\src` lines removed.
    Returns (hash|None, ok_flag)."""
    eh = hashlib.sha256(strip_code(code).encode()).hexdigest()
    if eh in cache:
        return cache[eh], (cache[eh] is not None)
    with tempfile.TemporaryDirectory() as td:
        f = os.path.join(td, "g.v")
        open(f, "w").write(code)
        script = (f"read_verilog -sv {f}; hierarchy -top {top}; proc; opt_clean; "
                  f"rename -enumerate; write_rtlil")
        try:
            p = subprocess.run([yosys, "-q", "-p", script], capture_output=True,
                               text=True, timeout=180)
        except subprocess.TimeoutExpired:
            cache[eh] = None
            return None, False
        if p.returncode != 0:
            cache[eh] = None
            return None, False
        rtlil = "\n".join(l for l in p.stdout.splitlines()
                          if not l.strip().startswith("attribute \\src"))
        h = hashlib.sha256(rtlil.encode()).hexdigest()
        cache[eh] = h
        return h, True


class UF:
    def __init__(self):
        self.p = {}

    def find(self, x):
        self.p.setdefault(x, x)
        while self.p[x] != x:
            self.p[x] = self.p[self.p[x]]
            x = self.p[x]
        return x

    def union(self, a, b):
        ra, rb = self.find(a), self.find(b)
        if ra != rb:
            self.p[rb] = ra


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--gen", nargs="+", required=True,
                    help="generation jsonl files (run_scoring/gen row format)")
    ap.add_argument("--out", required=True, help="dedup map json (stats.py --dedup form)")
    ap.add_argument("--yosys", default=YOSYS_DEFAULT)
    args = ap.parse_args()

    rows = []
    for p in args.gen:
        rows += [json.loads(l) for l in open(p, encoding="utf-8")]

    cache = {}
    per = {}          # (arm, task) -> list of row dicts with hashes
    yosys_fail = noext = 0
    for r in rows:
        ex = extract_record(r["completion"], r["bench"], r["task_id"])
        code = ex["code"]
        key = f'{r["arm"]}|{r["bench"]}|{r["task_id"]}|{r["sample_idx"]}'
        if not code.strip():
            noext += 1
            per.setdefault((r["arm"], r["task_id"]), []).append(
                {"key": key, "exact": None, "norm": None,
                 "uniq": "noext:" + hashlib.sha256(key.encode()).hexdigest()[:12]})
            continue
        eh = exact_hash(code)
        top = "TopModule" if r["bench"] == "ve" else r["task_id"]
        nh, ok = norm_hash(code, top, args.yosys, cache)
        if not ok:
            yosys_fail += 1
        per.setdefault((r["arm"], r["task_id"]), []).append(
            {"key": key, "exact": eh, "norm": nh, "uniq": None})

    dmap, uniq_of_group = {}, {}
    for (arm, task), items in sorted(per.items()):
        uf = UF()
        ids = list(range(len(items)))
        by_exact, by_norm = {}, {}
        for i, it in enumerate(items):
            if it["uniq"] is not None:
                continue  # no-code rows never collapse
            if it["exact"] in by_exact:
                uf.union(i, by_exact[it["exact"]])
            else:
                by_exact[it["exact"]] = i
            if it["norm"] is not None:
                if it["norm"] in by_norm:
                    uf.union(i, by_norm[it["norm"]])
                else:
                    by_norm[it["norm"]] = i
        groups = {}
        for i, it in enumerate(items):
            groups.setdefault(uf.find(i), []).append(it)
        for root, members in groups.items():
            norms = [m["norm"] for m in members if m["norm"]]
            if norms:
                base = "n:" + sorted(norms)[0][:12]
            else:
                exs = sorted(m["exact"] for m in members if m["exact"])
                base = "x:" + exs[0][:12] if exs else members[0]["uniq"]
            # namespaced by task: PREREG scopes dedup WITHIN arm x task, so two
            # different tasks producing byte-identical code must never merge
            dk = f"{task}:{base}"
            for m in members:
                dmap[m["key"]] = dk
            uniq_of_group[(arm, task, dk)] = len(members)

    os.makedirs(os.path.dirname(args.out) or ".", exist_ok=True)
    json.dump(dmap, open(args.out, "w"), indent=0, sort_keys=True)

    n_in = len(rows)
    n_groups = len(uniq_of_group)
    summary = {"rows_in": n_in, "unique_designs": n_groups,
               "rows_collapsed": n_in - n_groups,
               "yosys_failures": yosys_fail, "extraction_empty": noext,
               "per_arm": {}}
    for k, v in dmap.items():
        a = k.split("|")[0]
        s = summary["per_arm"].setdefault(a, {"rows": 0, "unique": set()})
        s["rows"] += 1
        s["unique"].add(v)
    for a, s in summary["per_arm"].items():
        s["unique"] = len(s["unique"])
    json.dump(summary, open(args.out + ".summary.json", "w"), indent=1)
    print(json.dumps(summary, indent=1))
    print(f"wrote {args.out} ({len(dmap)} keys)")


if __name__ == "__main__":
    main()
