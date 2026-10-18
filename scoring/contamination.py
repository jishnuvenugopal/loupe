#!/usr/bin/env python3
"""scoring/contamination.py — pinned main contamination check (A16 §6 step 5;
rules and revisions fixed in PREREG "Analysis plan — Contamination").

Datasets at pinned revisions (sha256 of the named LFS files checked where
PREREG pins them):
  zhuyaoyu/CodeV-R1-dataset @ 9ab06ff  (codev_r1_sft.jsonl,
      codev_r1_rl_train.parquet, codev_r1_rl_val.parquet)
  Nellyw888/RTL-Coder_small @ 801eea7  (randomized_filtered_data_7b.jsonl,
      randomized_filtered_data_fixed.jsonl)
  Nellyw888/RTL-Coder_7b_reasoning @ 528eb9b  (train.jsonl)
  Nellyw888/VeriReason-RTL-Coder_7b_reasoning_tb @ 42823db  (1,149 rows)
  Nellyw888/VeriReason-RTL-Coder_7b_reasoning_tb_simple @ 61cc6a2 (743 rows)

PRIMARY: every training problem statement vs the 206 benchmark specs
(156 VerilogEval user texts + 50 RTLLM design_description texts) — MinHash
5-gram word shingles, 128 perms, MinHashLSH at 0.8 for candidates, exact
Jaccard >= 0.8 kept, plus whitespace-collapsed exact match.
SECONDARY: training code vs the benchmark reference designs, same rules.

Writes results/main/contamination/overlaps.csv + summary.json. Tasks that
overlap are listed so stats.py --drop-tasks can rerun the contrasts without
them. H0-d's GRPO exclusion list is untouched.

Usage:
  python3 scoring/contamination.py [--out results/main/contamination]
"""
import argparse
import csv
import glob
import hashlib
import json
import os
import re

from datasketch import MinHash, MinHashLSH

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
HF = os.path.expanduser("~/hf/hub")
NUM_PERM = 128
NGRAM = 5
J_THR = 0.8

# dataset -> (snapshot path, files, statement field, code field, pinned sha256)
DATASETS = {
    "codev_sft": (f"{HF}/datasets--zhuyaoyu--CodeV-R1-dataset/snapshots/9ab06ff546c597b66e124839a6f60c5330083424",
                  ["codev_r1_sft.jsonl"], "problem", "code",
                  {"codev_r1_sft.jsonl": "6adce4c38e22633298ba7a80650711415d44fbf3cc9a8dcdd7680a480d3e2682"}),
    "codev_rl_train": (f"{HF}/datasets--zhuyaoyu--CodeV-R1-dataset/snapshots/9ab06ff546c597b66e124839a6f60c5330083424",
                       ["codev_r1_rl_train.parquet"], "question", "ground_truth",
                       {"codev_r1_rl_train.parquet": "9a531077fb28d20f99023bd5f00476610d3be7c715ea85c2e4a639abbc9db4fd"}),
    "codev_rl_val": (f"{HF}/datasets--zhuyaoyu--CodeV-R1-dataset/snapshots/9ab06ff546c597b66e124839a6f60c5330083424",
                     ["codev_r1_rl_val.parquet"], "question", "ground_truth",
                     {"codev_r1_rl_val.parquet": "7dbf5534968516f7515adcd0234697d6f8caa767b24d46adc3b1e881626bae1b"}),
    "rtlcoder_small_7b": (f"{HF}/datasets--Nellyw888--RTL-Coder_small/snapshots/801eea76297a75ad4e1facdfccdc68aff6c89121",
                          ["randomized_filtered_data_7b.jsonl"], "instruction", "output", {}),
    "rtlcoder_small_fixed": (f"{HF}/datasets--Nellyw888--RTL-Coder_small/snapshots/801eea76297a75ad4e1facdfccdc68aff6c89121",
                             ["randomized_filtered_data_fixed.jsonl"], "instruction", "output", {}),
    "rtlcoder_reasoning": (f"{HF}/datasets--Nellyw888--RTL-Coder_7b_reasoning/snapshots/528eb9b7258581cc0123e3ac2d6b747cf388d8cd",
                           ["train.jsonl"], "instruction", "output", {}),
    "verireason_tb": (f"{HF}/datasets--Nellyw888--VeriReason-RTL-Coder_7b_reasoning_tb/snapshots/42823db968114c25da260dece0e4bea8ab20d573",
                      ["train_tb_filtered.jsonl"], "instruction", "output", {}),
    "verireason_tb_simple": (f"{HF}/datasets--Nellyw888--VeriReason-RTL-Coder_7b_reasoning_tb_simple/snapshots/61cc6a2a326dc96cb93bceb0e2040b953f0cb0a5",
                             ["processed_entries.jsonl"], "instruction", "output", {}),
}


def words(text):
    return re.findall(r"\S+", text or "")


def shingles(text):
    w = words(text)
    return {" ".join(w[i:i + NGRAM]) for i in range(len(w) - NGRAM + 1)} or {" ".join(w)}


def minhash(sh):
    m = MinHash(num_perm=NUM_PERM)
    for s in sorted(sh):
        m.update(s.encode("utf-8"))
    return m


def norm_exact(text):
    return " ".join(words(text))


def sha256_file(p):
    h = hashlib.sha256()
    with open(p, "rb") as f:
        for chunk in iter(lambda: f.read(1 << 22), b""):
            h.update(chunk)
    return h.hexdigest()


def benchmark_specs():
    """(bench, task_id, text) for the 206 specs; user texts from the built
    prompt rows (what the models actually saw)."""
    out = []
    for bench, fam in (("ve", "codev"), ("rtllm", "codev")):
        for l in open(os.path.join(REPO, f"prompts/built/{fam}_{bench}.jsonl")):
            r = json.loads(l)
            out.append((bench, r["task_id"], r["user"]))
    return out


def benchmark_refs():
    """(bench, task_id, code) for the 206 reference designs."""
    out = []
    ve = os.path.expanduser("~/bench/verilog-eval/dataset_spec-to-rtl")
    for p in sorted(glob.glob(ve + "/*_ref.sv")):
        tid = os.path.basename(p)[: -len("_ref.sv")]
        out.append(("ve", tid, open(p, errors="ignore").read()))
    for d, _, _ in os.walk(os.path.expanduser("~/bench/RTLLM")):
        if os.path.basename(d) and glob.glob(os.path.join(d, "verified_*.v")):
            g = glob.glob(os.path.join(d, "verified_*.v"))[0]
            out.append(("rtllm", os.path.basename(d), open(g, errors="ignore").read()))
    return out


def iter_rows(path, stmt_field, code_field):
    if path.endswith(".parquet"):
        import pyarrow.parquet as pq
        t = pq.read_table(path)
        cols = t.column_names
        s = stmt_field if stmt_field in cols else cols[0]
        c = code_field if code_field in cols else cols[-1]
        for i, (sv, cv) in enumerate(zip(t[s].to_pylist(), t[c].to_pylist())):
            yield i, (sv if isinstance(sv, str) else json.dumps(sv)), \
                (cv if isinstance(cv, str) else json.dumps(cv)), {"statement_col": s, "code_col": c}
    else:
        for i, l in enumerate(open(path, encoding="utf-8", errors="ignore")):
            try:
                r = json.loads(l)
            except json.JSONDecodeError:
                continue
            s = r.get(stmt_field) or r.get("prompt") or r.get("problem") or r.get("instruction") or ""
            c = r.get(code_field) or r.get("completion") or r.get("code") or r.get("response") or ""
            yield i, str(s), str(c), {}


def compare(target_name, targets, rows_iter, csv_rows):
    """targets: list of (bench, task_id, text); LSH over target minhashes."""
    lsh = MinHashLSH(threshold=J_THR, num_perm=NUM_PERM)
    mh = {}
    exact = {}
    for bench, tid, text in targets:
        key = f"{bench}|{tid}"
        m = minhash(shingles(text))
        mh[key] = m
        exact[key] = norm_exact(text)
        lsh.insert(key, m)
    n_rows = n_stmt = 0
    overlaps = []
    for i, stmt, code, cols in rows_iter:
        n_rows += 1
        for side_name, text in (("statement", stmt),):
            m = minhash(shingles(text))
            ne = norm_exact(text)
            for cand in lsh.query(m):
                bench, tid = cand.split("|", 1)
                if ne == exact[cand]:
                    rule, j = "exact_ws", 1.0
                else:
                    j = m.jaccard(mh[cand])
                    if j < J_THR:
                        continue
                    rule = "jaccard"
                overlaps.append((target_name, side_name, bench, tid, i, rule, round(j, 4)))
                csv_rows.append([target_name, side_name, bench, tid, i, rule, f"{j:.4f}"])
            n_stmt += 1
    return n_rows, overlaps


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", default=os.path.join(REPO, "results/main/contamination"))
    ap.add_argument("--skip-secondary", action="store_true")
    args = ap.parse_args()
    os.makedirs(args.out, exist_ok=True)
    csv_rows = [["dataset", "side", "benchmark", "task", "row", "rule", "jaccard"]]
    summary = {"params": {"ngram_words": NGRAM, "num_perm": NUM_PERM,
                          "jaccard_threshold": J_THR, "lsh_threshold": J_THR,
                          "exact_rule": "whitespace-normalised equality"},
               "datasets": {}}
    specs = benchmark_specs()
    refs = benchmark_refs() if not args.skip_secondary else []
    summary["n_benchmark_specs"] = len(specs)
    summary["n_benchmark_refs"] = len(refs)
    for name, (snap, files, sf, cf, pins) in DATASETS.items():
        entry = {"path": snap, "files": {}}
        if not os.path.isdir(snap):
            summary["datasets"][name] = {**entry, "status": "MISSING (download first)"}
            continue
        all_overlaps = []
        for f in files:
            p = os.path.join(snap, f)
            if not os.path.isfile(p):
                entry["files"][f] = "missing"
                continue
            pin = pins.get(f)
            h = sha256_file(p) if pin else None
            ok = (pin is None) or (h == pin)
            fe = {"sha256": h or "(not pinned)", "pin_ok": ok,
                  "size_bytes": os.path.getsize(p)}
            n, ov = compare(f"{name}:{f}", specs, iter_rows(p, sf, cf), csv_rows)
            fe.update({"rows": n, "spec_overlaps": len(ov)})
            all_overlaps += ov
            if not args.skip_secondary:
                _, ovc = compare(f"{name}:{f}:code", refs,
                                 ((i, c, "", {}) for i, s, c, _ in iter_rows(p, sf, cf)),
                                 csv_rows)
                fe["ref_overlaps_secondary"] = len(ovc)
                all_overlaps += ovc
            entry["files"][f] = fe
        entry["total_overlaps"] = len(all_overlaps)
        summary["datasets"][name] = entry
        print(name, json.dumps({k: v for k, v in entry.items() if k != "path"}))
    with open(os.path.join(args.out, "overlaps.csv"), "w", newline="") as f:
        csv.writer(f).writerows(csv_rows)
    tasks = sorted({(r[2], r[3]) for r in csv_rows[1:] if r[1] == "statement"})
    with open(os.path.join(args.out, "overlapping_tasks.txt"), "w") as f:
        f.write("".join(f"{b}\t{t}\n" for b, t in tasks))
    json.dump(summary, open(os.path.join(args.out, "summary.json"), "w"), indent=1)
    print(f"overlap rows: {len(csv_rows) - 1}; overlapping statement tasks: {len(tasks)}")
    print(f"wrote {args.out}/overlaps.csv")


if __name__ == "__main__":
    main()
