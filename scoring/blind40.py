#!/usr/bin/env python3
"""scoring/blind40.py — pinned blind-40 draw + packet writer (A16 §6 step 7;
written pre-G0 per A18 item 5, with the A18 population-ordering fix).

Procedure (all as PREREG states):
  1. Population: UNIQUE official passes of class `different` or `vacuous`
     (class = the run_scoring row's a16_class), all arms, EXCLUDING the four
     reported-apart designs (accu, LIFObuffer, RAM, square_wave).
     Unique = one row per (arm, bench, dedup design_key) — duplicates drawn
     from the same design collapse; bounded-only and unverified passes are not
     in the population (no counterexample to judge).
  2. The population is LISTED SORTED BY (arm, bench, task, sample index)
     BEFORE sampling — A18 fix: the draw must not depend on file order.
  3. Strata = arm x benchmark; proportional largest-remainder allocation of
     40 (or the population size, if smaller).
  4. Sampling and ids from ONE random.Random(0): strata visited in sorted
     key order, random.sample(stratum, k) per stratum, then one
     random.sample(range(10000), n) gives the packet ids (b40_<dddd>),
     assigned in draw order.
  5. Packet contents per item: the spec text, the reference design, the
     extracted code, the official testbench result and the counterexample
     table. Nothing that names the arm, model, family or sample index; a
     scrub check fails loudly if any banned token appears.
  6. Key (id -> arm, bench, task, sample_idx) written OUTSIDE the repo
     (~/runs/blind40_key.json); only its sha256 is committed. Also writes
     labels_template.csv (id,label).

Unblind (after the operator commits labels.csv and writes `blind labels in`):
  python3 scoring/blind40.py --unblind --key ~/runs/blind40_key.json \
      --labels results/main/blind40/labels.csv --out results/main/blind40/unblinded.json
  reports class shares with Wilson 95% intervals, overall and per family.

Tested (pre-G0): tests/test_a18_blind40.py — allocation determinism, sorted
population, blindness scrub, and an end-to-end draw on the pilot + shakedown
rows.
"""
import argparse
import hashlib
import json
import os
import random
import re
import sys

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(REPO, "scoring"))
from stats import wilson  # pinned Wilson interval

APART = {"accu", "LIFObuffer", "RAM", "square_wave"}   # reported apart, never in the draw
LABELS = ("real bug", "reference wrong", "allowed by spec", "unclear", "scorer artefact")
BANNED = ("7b-rl", "7b-sft", "7b-base", "3b-rl", "3b-base", "3b-sft", "codev",
          "verireason", "qwen", "distill", "sample_idx", "chatgpt", "gpt-4",
          "gpt-3.5", "grpo", "family")
FAMILY = {"7b-rl": "codev-rl", "7b-sft": "codev-distill", "7b-base": "codev-base",
          "3b-rl": "verireason-rl", "3b-base": "verireason-instruct"}

VE_DIR = os.path.expanduser("~/bench/verilog-eval/dataset_spec-to-rtl")
RTLLM = os.path.expanduser("~/bench/RTLLM")


def sort_key(r):
    return (r["arm"], r["bench"], r["task_id"], int(r["sample_idx"]))


def load_scores(paths):
    rows = []
    for p in paths:
        rows += [json.loads(l) for l in open(p, encoding="utf-8")]
    return rows


def population(scores, dedup):
    """Unique official passes of class different/vacuous, apart designs out."""
    pops = [r for r in scores
            if r.get("tb") == "pass" and r.get("class") in ("different", "vacuous")
            and r["task_id"] not in APART]
    # one row per (arm, bench, design_key); dedup map optional (fallback: task)
    best = {}
    for r in pops:
        k = (r["arm"], r["bench"], dedup.get(
            f'{r["arm"]}|{r["bench"]}|{r["task_id"]}|{r["sample_idx"]}',
            f'{r["task_id"]}:nofallback-{r["sample_idx"]}'))
        if k not in best or sort_key(r) < sort_key(best[k]):
            best[k] = r
    return sorted(best.values(), key=sort_key)


def largest_remainder(strata_counts, total):
    """Proportional largest-remainder allocation; every stratum keeps at most
    its population; remainder seats go to largest fractional parts (ties: the
    stratum earlier in sorted order)."""
    n = len(strata_counts)
    pop_total = sum(strata_counts.values())
    if pop_total <= total:
        return dict(strata_counts)
    quota = {s: c * total / pop_total for s, c in strata_counts.items()}
    alloc = {s: int(q) for s, q in quota.items()}
    left = total - sum(alloc.values())
    order = sorted(strata_counts, key=lambda s: (-(quota[s] - int(quota[s])), s))
    i = 0
    while left > 0:
        s = order[i % n]
        if alloc[s] < strata_counts[s]:
            alloc[s] += 1
            left -= 1
        i += 1
        if i > 10 * n + total:  # safety: all strata saturated
            break
    return alloc


def reference_design(bench, task):
    if bench == "ve":
        p = os.path.join(VE_DIR, f"{task}_ref.sv")
        return open(p, encoding="utf-8", errors="ignore").read() if os.path.isfile(p) \
            else f"(reference file missing: {task}_ref.sv)"
    for d, _, _ in os.walk(RTLLM):
        if os.path.basename(d) == task:
            import glob
            g = glob.glob(os.path.join(d, "verified_*.v"))
            if g:
                return open(g[0], encoding="utf-8", errors="ignore").read()
    return f"(reference file missing for {task})"


def spec_text(bench, task):
    fam = "codev"
    p = os.path.join(REPO, f"prompts/built/{fam}_{bench}.jsonl")
    for l in open(p, encoding="utf-8"):
        r = json.loads(l)
        if r["task_id"] == task:
            return r["user"]
    return f"(spec text missing for {task})"


def gen_rows(paths):
    """task lookup: (bench, task_id, sample_idx) -> gen row (for the code)."""
    g = {}
    for p in paths:
        for l in open(p, encoding="utf-8"):
            r = json.loads(l)
            g[(r["bench"], r["task_id"], r["sample_idx"])] = r
    return g


def packet_markdown(pid, bench, task, spec, ref, code, tb, cex_table):
    return f"""# Blind review packet {pid}

## 1. Specification (what the design was asked to do)

```
{spec.strip()}
```

## 2. Reference design (the benchmark's own reference)

```verilog
{ref.strip()}
```

## 3. Generated design under review (extracted verbatim)

```verilog
{code.strip() if code.strip() else "// (no code extracted)"}
```

## 4. Official testbench result

The official testbench for this task reports: **{tb}**.

## 5. Formal counterexample table

```
{cex_table.strip() if cex_table.strip() else "(no sat-log table was produced for this sample; the engine counterexample trace is on file)"}
```

## 6. Your label (one of)

real bug / reference wrong / allowed by spec / unclear / scorer artefact
"""


def scrub(txt, pid):
    low = txt.lower()
    for b in BANNED:
        if b in low:
            raise SystemExit(f"error: packet {pid} is not blind: found '{b}'")
    return txt


def draw(scores_paths, gen_paths, dedup_path, out_dir, key_path, cex_dir, n_draw=40):
    scores = load_scores(scores_paths)
    dedup = json.load(open(dedup_path)) if dedup_path else {}
    pop = population(scores, dedup)
    gens = gen_rows(gen_paths) if gen_paths else {}
    rng = random.Random(0)

    strata = {}
    for r in pop:
        strata.setdefault((r["arm"], r["bench"]), []).append(r)
    alloc = largest_remainder({s: len(v) for s, v in strata.items()}, n_draw)

    # single generator, strata in sorted order (A18: deterministic, file-order free)
    picked = []
    rng = random.Random(0)
    for s in sorted(strata):
        k = alloc.get(s, 0)
        if k > 0:
            picked += rng.sample(sorted(strata[s], key=sort_key), k)
    ids = rng.sample(range(10000), len(picked))

    os.makedirs(os.path.join(out_dir, "packet"), exist_ok=True)
    key = {}
    meta = {"population": len(pop), "drawn": len(picked), "seed": 0,
            "strata": {f"{a}|{b}": {"population": len(v), "drawn": alloc.get((a, b), 0)}
                       for (a, b), v in sorted(strata.items())},
            "ids": {}}
    for pid_num, r in zip(ids, picked):
        pid = f"b40_{pid_num:04d}"
        g = gens.get((r["bench"], r["task_id"], r["sample_idx"]), {})
        from extract import extract_record
        ex = extract_record(g.get("completion", ""), r["bench"], r["task_id"])
        cex_p = os.path.join(cex_dir, r["arm"], f'{r["task_id"]}__{r["sample_idx"]}.txt')
        cex_table = open(cex_p, encoding="utf-8", errors="ignore").read() \
            if os.path.isfile(cex_p) else ""
        md = packet_markdown(pid, r["bench"], r["task_id"],
                             spec_text(r["bench"], r["task_id"]),
                             reference_design(r["bench"], r["task_id"]),
                             ex["code"], r.get("tb", "?"), cex_table)
        # scrub: drop the cex table's own path lines if any leak the arm
        md = re.sub(r"results/main/cex/\S+", "(counterexample table)", md)
        scrub(md, pid)
        open(os.path.join(out_dir, "packet", f"{pid}.md"), "w").write(md)
        key[pid] = {"arm": r["arm"], "bench": r["bench"], "task": r["task_id"],
                    "sample_idx": r["sample_idx"], "family": FAMILY.get(r["arm"], "other")}
        meta["ids"][pid] = f'{r["bench"]}|{r["task_id"]}|{r["sample_idx"]}'
    json.dump(key, open(key_path, "w"), indent=1)
    with open(os.path.join(out_dir, "labels_template.csv"), "w") as f:
        f.write("id,label\n" + "".join(f"{pid},\n" for pid in sorted(key)))
    json.dump(meta, open(os.path.join(out_dir, "draw_meta.json"), "w"), indent=1)
    print(json.dumps({k: v for k, v in meta.items() if k != "ids"}, indent=1))
    print(f"key: {key_path} (outside the repo; commit only its sha256)")


def unblind(key_path, labels_csv, out_json):
    key = json.load(open(key_path))
    import csv
    rows = list(csv.DictReader(open(labels_csv)))
    bad = [r["id"] for r in rows if r["label"] not in LABELS]
    if bad:
        sys.exit(f"error: unknown labels for ids {bad[:5]} (allowed: {LABELS})")
    res = {"n": len(rows), "overall": {}, "per_family": {}, "labels": LABELS}
    for lab in LABELS:
        k = sum(1 for r in rows if r["label"] == lab)
        res["overall"][lab] = {"count": k, "share": k / len(rows),
                               "wilson95": wilson(k, len(rows))}
    fams = {}
    for r in rows:
        fams.setdefault(key[r["id"]]["family"], []).append(r["label"])
    for fam, labs in sorted(fams.items()):
        res["per_family"][fam] = {lab: {"count": labs.count(lab),
                                        "share": labs.count(lab) / len(labs),
                                        "wilson95": wilson(labs.count(lab), len(labs))}
                                  for lab in LABELS}
    json.dump(res, open(out_json, "w"), indent=1)
    print(json.dumps(res["overall"], indent=1))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--scores", nargs="*", default=[], help="scores/<arm>.jsonl files")
    ap.add_argument("--gen", nargs="*", default=[], help="generation jsonl files")
    ap.add_argument("--dedup", default="", help="dedup map json (scoring/dedup.py)")
    ap.add_argument("--out-dir", default="results/main/blind40")
    ap.add_argument("--key", default=os.path.expanduser("~/runs/blind40_key.json"))
    ap.add_argument("--cex-dir", default="results/main/cex")
    ap.add_argument("--n", type=int, default=40)
    ap.add_argument("--unblind", action="store_true")
    ap.add_argument("--labels", default="")
    args = ap.parse_args()
    if args.unblind:
        unblind(args.key, args.labels or os.path.join(args.out_dir, "labels.csv"),
                os.path.join(args.out_dir, "unblinded.json"))
        return
    draw(args.scores, args.gen, args.dedup, args.out_dir, args.key, args.cex_dir, args.n)


if __name__ == "__main__":
    main()
