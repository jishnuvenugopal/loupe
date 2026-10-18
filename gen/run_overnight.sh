#!/usr/bin/env bash
# Phase 8 overnight generation runner (ONLY after G0 steps are complete).
# Usage (inside tmux): bash gen/run_overnight.sh
# Order per A16 §3 step 4: CodeV RL → Distill → 3B RL → 3B base → Qwen 7B base
# (base arms last because they are cut first; 3B SFT dropped by H0-a).
# Resumable: gen_vllm.py skips (task_id, sample_idx) already written.
set -uo pipefail
cd "$(dirname "$0")/.."
WORK=/work
RUNS=/runs
VE_PROMPTS=$WORK/prompts/built/codev_ve.jsonl
RT_PROMPTS=$WORK/prompts/built/codev_rtllm.jsonl
SYS=$WORK/prompts/system_prompts/codev.txt
VE_PROMPTS_VR=$WORK/prompts/built/verireason_ve.jsonl
RT_PROMPTS_VR=$WORK/prompts/built/verireason_rtllm.jsonl
SYS_VR=$WORK/prompts/system_prompts/verireason.txt
declare -A REV=(
  [7b-rl]=286cf433f596f1b8525529c1163eb81c19425c22
  [7b-sft]=8fdb92e328cb2a98ef9a3f9dcd82995a2112bd9c
  [7b-base]=c03e6d358207e414f1eca0bb1891e29f1db0e242
  [3b-rl]=3b93ce1bd7e5d90dae8761363a9c6862d0ed583a
  [3b-base]=488639f1ff808d1d3d0ba301aef8c11461451ec5
)
declare -A ID=(
  [7b-rl]=zhuyaoyu/CodeV-R1-RL-Qwen-7B
  [7b-sft]=zhuyaoyu/CodeV-R1-Distill-Qwen-7B
  [7b-base]=Qwen/Qwen2.5-Coder-7B-Instruct
  [3b-rl]=Nellyw888/VeriReason-Qwen2.5-3b-RTLCoder-Verilog-GRPO-reasoning-tb
  [3b-base]=Qwen/Qwen2.5-Coder-3B-Instruct
)
declare -A TEMP=( [7b-rl]=1.0 [7b-sft]=0.6 [7b-base]=1.0 [3b-rl]=0.2 [3b-base]=0.2 )
declare -A MAXTOK=( [7b-rl]=16384 [7b-sft]=16384 [7b-base]=16384 [3b-rl]=2048 [3b-base]=2048 )
declare -A MML=( [7b-rl]=20480 [7b-sft]=20480 [7b-base]=20480 [3b-rl]=4096 [3b-base]=4096 )

gen_arm () {  # arm bench top_p prompts system
  local arm=$1 bench=$2 top_p=$3 prompts=$4 system=$5
  local model=/models-hf/hub/models--${ID[$arm]//\//--}/snapshots/${REV[$arm]}
  echo "=== $(date '+%H:%M:%S') generating $arm / $bench (T=${TEMP[$arm]}, top_p=$top_p, n=3) ==="
  python3 gen/gen_vllm.py --arm "$arm" --model "$model" --revision "${REV[$arm]}" \
    --prompts "$prompts" --system "$system" --n 3 --max-tokens "${MAXTOK[$arm]}" \
    --temperature "${TEMP[$arm]}" --top-p "$top_p" --max-model-len "${MML[$arm]}" \
    --out "$RUNS/gen/${arm}_${bench}.jsonl" \
    --log-effective-params "$RUNS/gen/${arm}_effective_params.json"
}

for arm in 7b-rl 7b-sft 3b-rl 3b-base 7b-base; do
  if [[ $arm == 3b-* ]]; then
    gen_arm "$arm" ve 0.95 "$VE_PROMPTS_VR" "$SYS_VR"
    gen_arm "$arm" rtllm 0.95 "$RT_PROMPTS_VR" "$SYS_VR"
  else
    gen_arm "$arm" ve 1.0 "$VE_PROMPTS" "$SYS"
    gen_arm "$arm" rtllm 0.95 "$RT_PROMPTS" "$SYS"
  fi
done
echo "=== $(date '+%H:%M:%S') all generation done ==="
