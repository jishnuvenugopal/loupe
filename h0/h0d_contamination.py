#!/usr/bin/env python3
"""H0-d (part 2): contamination between the GRPO training data and the benchmarks.

MinHash (5-gram word shingles, 128 permutations, Jaccard >= 0.8) plus exact
match after whitespace normalisation, comparing every dataset `instruction`
against every benchmark spec:
  - VerilogEval v2 spec-to-rtl: the 156 *_prompt.txt texts (c498220)
  - RTLLM v2.1: the 50 design_description.txt texts (51ed553)

Datasets checked (both pinned revisions, §3.3):
  - VeriReason-RTL-Coder_7b_reasoning_tb         (1,149 rows)  [primary]
  - VeriReason-RTL-Coder_7b_reasoning_tb_simple  (743 rows)    [secondary]

Writes results/h0/h0d_contamination.json.
"""
import glob
import json
import os
import re

from datasketch import MinHash

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DATASETS = {
    "tb": os.path.expanduser(
        "~/hf/hub/datasets--Nellyw888--VeriReason-RTL-Coder_7b_reasoning_tb/"
        "snapshots/42823db968114c25da260dece0e4bea8ab20d573/train_tb_filtered.jsonl"),
    "tb_simple": os.path.expanduser(
        "~/hf/hub/datasets--Nellyw888--VeriReason-RTL-Coder_7b_reasoning_tb_simple/"
        "snapshots/61cc6a2a326dc96cb93bceb0e2040b953f0cb0a5/processed_entries.jsonl"),
}
VE = os.path.expanduser("~/bench/verilog-eval/dataset_spec-to-rtl")
RTLLM = os.path.expanduser("~/bench/RTLLM")

NUM_PERM = 128
NGRAM = 5
J_THR = 0.8


def words(text):
    return re.findall(r"\S+", text)


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


def main():
    specs = {}
    for p in sorted(glob.glob(os.path.join(VE, "*_prompt.txt"))):
        specs["ve:" + os.path.basename(p)[len("Prob"):-len("_prompt.txt")]] = open(p, encoding="utf-8").read()
    for d in sorted(g for g in glob.glob(os.path.join(RTLLM, "*", "*", "*"))
                    if glob.glob(os.path.join(g, "verified_*.v"))):
        specs["rtllm:" + os.path.basename(d)] = open(os.path.join(d, "design_description.txt"), encoding="utf-8").read()
    spec_mh = {k: minhash(shingles(v)) for k, v in specs.items()}
    spec_norm = {k: norm_exact(v) for k, v in specs.items()}

    # positive control: a benchmark spec passed as an instruction MUST be flagged
    ctl_key = sorted(specs)[0]
    ctl = minhash(shingles(specs[ctl_key]))
    assert ctl.jaccard(spec_mh[ctl_key]) > 0.99, "positive control failed"
    print("positive control OK:", ctl_key, "self-jaccard", round(ctl.jaccard(spec_mh[ctl_key]), 4))

    report = {"params": {"ngram_words": NGRAM, "num_perm": NUM_PERM, "jaccard_threshold": J_THR,
                         "exact_rule": "whitespace-normalised equality"},
              "n_benchmark_specs": len(specs), "datasets": {}}
    for name, path in DATASETS.items():
        rows = [json.loads(l) for l in open(path, encoding="utf-8")]
        hits = []
        for i, r in enumerate(rows):
            instr = r["instruction"]
            im = minhash(shingles(instr))
            inorm = norm_exact(instr)
            for k in specs:
                if inorm == spec_norm[k]:
                    hits.append({"row": i, "id": r.get("id"), "spec": k, "match": "exact_normalized"})
                    break
            else:
                for k, km in spec_mh.items():
                    if im.jaccard(km) >= J_THR:
                        hits.append({"row": i, "id": r.get("id"), "spec": k,
                                     "match": "minhash", "jaccard": round(im.jaccard(km), 4)})
                        break
        report["datasets"][name] = {"path": path, "n_rows": len(rows),
                                    "n_overlapping_rows": len(hits), "overlaps": hits}
        print(f"{name}: {len(rows)} rows, {len(hits)} overlapping: "
              + ", ".join(f"{h['spec']}({h['match']})" for h in hits[:10]))
    with open(os.path.join(REPO, "results/h0/h0d_contamination.json"), "w") as f:
        json.dump(report, f, indent=1)


if __name__ == "__main__":
    main()
