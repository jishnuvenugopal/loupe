#!/usr/bin/env python3
"""Phase 4: verify every safetensors sha256 against the HF ?blobs=true API,
copy card text files, and emit models.yaml + results/h0/weights_sha256.tsv.

Verifies whatever is present; reports models still missing. Exit 0 only when
all 8 pinned models are fully present and every hash matches.
"""
import glob
import hashlib
import json
import os
import shutil
import urllib.request

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

MODELS = [  # (arm, repo_id, revision, dtype, size_gb, licence_note)
    ("7b-base", "Qwen/Qwen2.5-Coder-7B-Instruct",
     "c03e6d358207e414f1eca0bb1891e29f1db0e242", "bfloat16", 15.2,
     "license:apache-2.0 tag + LICENSE file"),
    ("7b-sft", "zhuyaoyu/CodeV-R1-Distill-Qwen-7B",
     "8fdb92e328cb2a98ef9a3f9dcd82995a2112bd9c", "bfloat16", 15.2,
     "license:apache-2.0 tag"),
    ("7b-rl", "zhuyaoyu/CodeV-R1-RL-Qwen-7B",
     "286cf433f596f1b8525529c1163eb81c19425c22", "bfloat16", 15.2,
     "no tag, no LICENSE file; card §5 says derived from Qwen-2.5 (Apache 2.0) — copied to models/cards/"),
    ("3b-base-instruct", "Qwen/Qwen2.5-Coder-3B-Instruct",
     "488639f1ff808d1d3d0ba301aef8c11461451ec5", "bfloat16", 6.2,
     "license:other (Qwen Research License), non-commercial"),
    ("3b-base-raw", "Qwen/Qwen2.5-Coder-3B",
     "09d9bc5d376b0cfa0100a0694ea7de7232525803", "bfloat16", 6.2,
     "license:other (Qwen Research License), non-commercial"),
    ("3b-sft", "Nellyw888/Qwen2.5-3b-sft-reasoning",
     "1f0b7fac9c057b32cba9107a854518be92e45c91", "float32", 12.4,
     "empty card; Qwen Research License applies via base"),
    ("3b-rl", "Nellyw888/VeriReason-Qwen2.5-3b-RTLCoder-Verilog-GRPO-reasoning-tb",
     "3b93ce1bd7e5d90dae8761363a9c6862d0ed583a", "bfloat16", 6.2,
     "no tag; card base_model: Qwen/Qwen2.5-Coder-3B"),
    ("grpo-base", "Qwen/Qwen2.5-Coder-1.5B-Instruct",
     "2e1fd397ee46e1388853d2af2c993145b0f1098a", "bfloat16", 3.1,
     "license:apache-2.0"),
]
DECLARED_BASE = {
    "7b-base": None,
    "7b-sft": "Qwen/Qwen2.5-Coder-7B-Instruct (CodeV-R1 distillation pipeline)",
    "7b-rl": "zhuyaoyu/CodeV-R1-Distill-Qwen-7B (CodeV-R1 paper §3)",
    "3b-base-instruct": "declared base of the VeriReason SFT (SFT/LLamaFactory/src/qwen2.5_3b.yaml)",
    "3b-base-raw": "declared base of the GRPO model card (base_model: Qwen/Qwen2.5-Coder-3B)",
    "3b-sft": "unconfirmed (H0-a); config _name_or_path=/workspace/LLaMA-Factory/outputs/Qwen2.5-Coder-3B/SFT",
    "3b-rl": "Nellyw888/Qwen2.5-3b-sft-reasoning (unconfirmed until H0-a)",
    "grpo-base": None,
}
CARD_FILES = ["README.md", "LICENSE", "LICENSE.md", "config.json",
              "generation_config.json", "tokenizer_config.json"]


def api(repo_id, rev):
    url = f"https://huggingface.co/api/models/{repo_id}/revision/{rev}?blobs=true"
    with urllib.request.urlopen(url) as r:
        return json.load(r)


def sha256_file(p):
    h = hashlib.sha256()
    with open(p, "rb") as f:
        for chunk in iter(lambda: f.read(1 << 22), b""):
            h.update(chunk)
    return h.hexdigest()


def snapshot_dir(repo_id, rev):
    return os.path.expanduser(f"~/hf/hub/models--{repo_id.replace('/', '--')}/snapshots/{rev}")


def main():
    tsv = ["arm\trepo_id\trevision\tfile\tsize_bytes\texpected_sha256\tactual_sha256\tmatch"]
    yaml_models = []
    all_ok = True
    for arm, repo_id, rev, dtype, size, lic in MODELS:
        row = {"arm": arm, "id": repo_id, "revision": rev, "dtype": dtype,
               "size_gb": size, "declared_base": DECLARED_BASE[arm],
               "licence_evidence": lic}
        try:
            info = api(repo_id, rev)
        except Exception as e:
            row["status"] = f"api_error: {e}"
            yaml_models.append(row)
            all_ok = False
            continue
        row["hf_tags"] = [t for t in info.get("tags", []) if t.startswith("license")]
        snap = snapshot_dir(repo_id, rev)
        blobs = {s["rfilename"]: s for s in info.get("siblings", [])}
        st_files = sorted(f for f in blobs if f.endswith(".safetensors"))
        local = sorted(os.path.basename(p) for p in glob.glob(os.path.join(snap, "*.safetensors"))) \
            if os.path.isdir(snap) else []
        missing = [f for f in st_files if f not in local]
        row["n_safetensors_remote"] = len(st_files)
        row["n_safetensors_local"] = len(local)
        bad = []
        for f in st_files:
            if f in missing:
                continue
            exp = blobs[f].get("lfs", {}).get("sha256")
            act = sha256_file(os.path.join(snap, f))
            ok = exp is not None and exp == act
            tsv.append("\t".join([arm, repo_id, rev, f, str(blobs[f].get("size", 0)),
                                  exp or "null", act, str(ok)]))
            if not ok:
                bad.append(f)
        row["hash_mismatches"] = bad
        row["missing_files"] = missing
        if missing or bad or not st_files:
            all_ok = False
            row["status"] = "incomplete"
        else:
            row["status"] = "verified"

        # card copies
        card_dir = os.path.join(REPO, "models/cards", repo_id)
        os.makedirs(card_dir, exist_ok=True)
        copied = []
        for cf in CARD_FILES:
            src = os.path.join(snap, cf)
            if os.path.isfile(src):
                shutil.copy(src, os.path.join(card_dir, cf))
                copied.append(cf)
        row["card_files_copied"] = copied
        tc = os.path.join(snap, "tokenizer_config.json")
        if os.path.isfile(tc):
            row["chat_template_sha256"] = hashlib.sha256(
                json.dumps(json.load(open(tc)).get("chat_template", ""), ensure_ascii=False).encode()
            ).hexdigest()
            cfgp = os.path.join(snap, "config.json")
            if os.path.isfile(cfgp):
                row["config_name_or_path"] = json.load(open(cfgp)).get("_name_or_path")
        gc = os.path.join(snap, "generation_config.json")
        if os.path.isfile(gc):
            row["generation_config"] = json.load(open(gc))  # recorded, NOT used (§6.2)
        yaml_models.append(row)
        print(f"{arm}: {row['status']} ({len(local)}/{len(st_files)} shards"
              + (f", BAD: {bad}" if bad else "") + (f", missing {len(missing)}" if missing else "") + ")")

    os.makedirs(os.path.join(REPO, "results/h0"), exist_ok=True)
    with open(os.path.join(REPO, "results/h0/weights_sha256.tsv"), "w") as f:
        f.write("\n".join(tsv) + "\n")

    # models.yaml
    lines = ["# Phase 4 (brief §3.2/§5): one entry per arm. Auto-generated by",
             "# models/verify_weights.py; verified rows say status: verified.", ""]
    for m in yaml_models:
        lines.append(f"arm: {m['arm']}")
        for k in ("id", "revision", "dtype", "size_gb", "status", "declared_base",
                  "licence_evidence", "hf_tags", "n_safetensors_remote", "n_safetensors_local",
                  "hash_mismatches", "card_files_copied", "chat_template_sha256",
                  "config_name_or_path"):
            if k in m:
                lines.append(f"{k}: {json.dumps(m[k], ensure_ascii=False)}")
        if "generation_config" in m:
            lines.append("generation_config: " + json.dumps(m["generation_config"], ensure_ascii=False))
        lines.append("")
    with open(os.path.join(REPO, "models.yaml"), "w") as f:
        f.write("\n".join(lines) + "\n")
    print("models.yaml + results/h0/weights_sha256.tsv written; all_ok =", all_ok)
    return 0 if all_ok else 1


if __name__ == "__main__":
    raise SystemExit(main())
