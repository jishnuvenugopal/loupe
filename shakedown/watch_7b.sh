#!/usr/bin/env bash
# A16 overnight watcher: when the three 7B weight sets are complete, verify
# hashes, then run the 7B shakedown lanes sequentially (Phase 6 steps 1-2).
# The overlap probe (A16 §3 step 7) is NOT automated — it needs an interactive
# 10-minute WORKERS=8 scoring window against a live 64-concurrent 7B batch;
# run it in the morning session (or the next interactive session).
set -uo pipefail
REPO=~/rtl-strict-eval
PY=~/.venvs/host/bin/python
LOG=~/runs/7b_watcher.log
cd "$REPO"

need() {  # arm -> repo_id revision
  case $1 in
    7b-rl)   echo "zhuyaoyu/CodeV-R1-RL-Qwen-7B 286cf433f596f1b8525529c1163eb81c19425c22";;
    7b-sft)  echo "zhuyaoyu/CodeV-R1-Distill-Qwen-7B 8fdb92e328cb2a98ef9a3f9dcd82995a2112bd9c";;
    7b-base) echo "Qwen/Qwen2.5-Coder-7B-Instruct c03e6d358207e414f1eca0bb1891e29f1db0e242";;
  esac
}

complete_arm() {
  read -r id rev <<< "$(need "$1")"
  local snap=~/hf/hub/models--${id//\//--}/snapshots/$rev
  local blobs=~/hf/hub/models--${id//\//--}/blobs
  [ -d "$snap" ] && ls "$snap"/*.safetensors >/dev/null 2>&1 \
    && ! ls "$blobs"/*.incomplete >/dev/null 2>&1
}

echo "=== $(date) watcher started (pid $$) ===" >> "$LOG"
while true; do
  all=1
  for a in 7b-rl 7b-sft 7b-base; do complete_arm "$a" || all=0; done
  [ "$all" = 1 ] && break
  sleep 300
done
echo "=== $(date) all three 7B weight sets complete ===" >> "$LOG"

"$PY" models/verify_weights.py >> "$LOG" 2>&1
echo "=== $(date) verify_weights rc=$? ===" >> "$LOG"

for arm in 7b-rl 7b-sft 7b-base; do
  echo "=== $(date) shakedown $arm ===" >> "$LOG"
  "$PY" shakedown/shakedown_run.py --arm "$arm" >> ~/runs/shakedown_${arm}.log 2>&1
  echo "=== $(date) $arm rc=$? ===" >> "$LOG"
done
"$PY" shakedown/projection.py --rtllm-n 5 >> "$LOG" 2>&1
echo "=== $(date) watcher done; morning session: overlap probe, PREREG refresh, G0 prep ===" >> "$LOG"
