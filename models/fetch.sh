#!/usr/bin/env bash
# Phase 4: download the 8 pinned model revisions (brief §3.2) into HF_HOME.
# Smallest first so each completed model can be hash-verified early.
# Retry loop: hf download resumes partial blobs, so we just re-invoke on failure.
set -uo pipefail
export HF_HOME="$HOME/hf"
HF="$HOME/.venvs/host/bin/hf"

MODELS=(
  "Qwen/Qwen2.5-Coder-1.5B-Instruct|2e1fd397ee46e1388853d2af2c993145b0f1098a"
  "Qwen/Qwen2.5-Coder-3B|09d9bc5d376b0cfa0100a0694ea7de7232525803"
  "Qwen/Qwen2.5-Coder-3B-Instruct|488639f1ff808d1d3d0ba301aef8c11461451ec5"
  "Nellyw888/VeriReason-Qwen2.5-3b-RTLCoder-Verilog-GRPO-reasoning-tb|3b93ce1bd7e5d90dae8761363a9c6862d0ed583a"
  "Nellyw888/Qwen2.5-3b-sft-reasoning|1f0b7fac9c057b32cba9107a854518be92e45c91"
  "Qwen/Qwen2.5-Coder-7B-Instruct|c03e6d358207e414f1eca0bb1891e29f1db0e242"
  "zhuyaoyu/CodeV-R1-Distill-Qwen-7B|8fdb92e328cb2a98ef9a3f9dcd82995a2112bd9c"
  "zhuyaoyu/CodeV-R1-RL-Qwen-7B|286cf433f596f1b8525529c1163eb81c19425c22"
)

for entry in "${MODELS[@]}"; do
  id="${entry%%|*}"; rev="${entry##*|}"
  echo "=== $(date '+%H:%M:%S') $id @ $rev ==="
  tries=0
  until "$HF" download "$id" --revision "$rev"; do
    tries=$((tries+1))
    echo "retry $tries for $id (sleep 60)"
    [ "$tries" -ge 200 ] && { echo "GIVING UP: $id"; exit 1; }
    sleep 60
  done
  echo "=== $(date '+%H:%M:%S') DONE $id ==="
done
echo "ALL MODELS DONE $(date '+%H:%M:%S')"
