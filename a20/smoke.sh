#!/usr/bin/env bash
# a20/smoke.sh — PREREG-A20 B6 smoke test, run BEFORE the stamp.
# Each arm at both settings for 2 steps, callback forced to step 1:
#   smoke_W_lr6 / smoke_S_lr6 (brief setting, lr 1e-6)
#   smoke_W_lr5 / smoke_S_lr5 (extension lr, 1e-5)
# Checks (results recorded in results/grpo/smoke/):
#   1. the CSV has every B2 column (and rows at steps 1 and 2)
#   2. one checkpoint is written (save-steps forced to 1)
#   3. one resume from that checkpoint works
#   4. E1 generates 2 tasks from a 2-step adapter (merge -> gen_vllm --limit 2)
set -uo pipefail
cd "$(dirname "$0")/.."
PYV=~/.venvs/host/bin/python
IMAGE=nvcr.io/nvidia/vllm:26.05.post1-py3
MOUNTS="-v $HOME/hf:/models-hf -v $PWD:/work -v $HOME/eda:/eda -v $HOME/eda:/root/eda -v $HOME/bench:/bench -v $HOME/runs:/runs"
mkdir -p results/grpo/smoke

run() {  # name arm lr extra
  local name=$1 arm=$2 lr=$3 extra=${4:-}
  echo "== smoke run $name (arm $arm, lr $lr) =="
  sg docker -c "docker run --rm --name a20_$name --gpus all --ipc=host \
    --ulimit memlock=-1 --ulimit stack=67108864 $MOUNTS \
    -e EDA_BIN=/eda/oss-cad-suite/bin -e GRPO_WORK_DIR=/runs/grpo $IMAGE \
    bash -lc 'pip install -q trl==1.15.0 peft==0.21.2 && python3 /work/grpo/train_grpo.py \
      --arm $arm --steps 2 --lr $lr --run-name $name --out /runs \
      --save-steps 1 --callback-every 1 \
      --csv-out /work/results/grpo/smoke/$name.csv \
      --adapter-sha-out /work/results/grpo/smoke/${name}_adapter.sha256.json \
      --metrics-out /work/results/grpo/smoke/${name}_metrics.json $extra'" \
    > ~/runs/$name.train.log 2>&1
  echo "rc=$? (log: ~/runs/$name.train.log)"
}

run smoke_W_lr6 W 1e-6
run smoke_S_lr6 S 1e-6
run smoke_W_lr5 W 1e-5
run smoke_S_lr5 S 1e-5
# resume check: continue smoke_W_lr6 from checkpoint-1 to max_steps 2
run smoke_W_lr6 W 1e-6 "--resume-from-checkpoint /runs/smoke_W_lr6/checkpoint-1"

# E1 path check: merge the 2-step adapter and generate 2 tasks with gen_vllm
$PYV e1/run_e1.py --arms smoke_s6 --merge smoke_s6:$HOME/runs/smoke_S_lr6/final_adapter \
  --smoke --limit 2 --n 1

echo "== smoke runs complete =="
