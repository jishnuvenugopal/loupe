#!/usr/bin/env bash
# Phase 8 overnight generation runner (ONLY after G0 steps are complete).
# Usage (inside tmux): bash gen/run_overnight.sh
# Order per brief: CodeV RL, then Distill, then Qwen 7B base (cut first = last).
# Resumable: gen_vllm.py skips (task_id, sample_idx) already written.
set -uo pipefail
cd "$(dirname "$0")/.."
WORK=/work
RUNS=/runs
VE_PROMPTS=$WORK/prompts/built/codev_ve.jsonl
RT_PROMPTS=$WORK/prompts/built/codev_rtllm.jsonl
SYS=$WORK/prompts/system_prompts/codev.txt
declare -A REV=(
  [7b-rl]=286cf433f596f1b8525529c1163eb81c19425c22
  [7b-sft]=8fdb92e328cb2a98ef9a3f9dcd82995a2112bd9c
  [7b-base]=c03e6d358207e414f1eca0bb1891e29f1db0e242
)
declare -A ID=(
  [7b-rl]=zhuyaoyu/CodeV-R1-RL-Qwen-7B
  [7b-sft]=zhuyaoyu/CodeV-R1-Distill-Qwen-7B
  [7b-base]=Qwen/Qwen2.5-Coder-7B-Instruct
)
declare -A TEMP=( [7b-rl]=1.0 [7b-sft]=0.6 [7b-base]=1.0 )

gen_arm () {  # arm bench top_p
  local arm=$1 bench=$2 top_p=$3
  local prompts=$VE_PROMPTS; [ "$bench" = rtllm ] && prompts=$RT_PROMPTS
  local model=/models-hf/hub/models--${ID[$arm]//\//--}/snapshots/${REV[$arm]}
  echo "=== $(date '+%H:%M:%S') generating $arm / $bench (T=${TEMP[$arm]}, top_p=$top_p, n=3) ==="
  python3 gen/gen_vllm.py --arm "$arm" --model "$model" --revision "${REV[$arm]}" \
    --prompts "$prompts" --system "$SYS" --n 3 --max-tokens 16384 \
    --temperature "${TEMP[$arm]}" --top-p "$top_p" \
    --out "$RUNS/gen/${arm}_${bench}.jsonl" \
    --log-effective-params "$RUNS/gen/${arm}_effective_params.json"
}

for arm in 7b-rl 7b-sft 7b-base; do
  gen_arm "$arm" ve 1.0
  gen_arm "$arm" rtllm 0.95
done
echo "=== $(date '+%H:%M:%S') all generation done ==="
