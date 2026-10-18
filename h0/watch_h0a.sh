#!/usr/bin/env bash
# Watcher: run H0-a as soon as (a) the pinned PyTorch image is present and
# (b) all four 3B checkpoints are fully downloaded. Then commit+push the result
# if the tree is otherwise clean. Logs to ~/runs/h0a_watcher.log.
set -uo pipefail
cd "$(dirname "$0")/.."
PT_IMAGE=nvcr.io/nvidia/pytorch:25.11-py3
LOG=~/runs/h0a_watcher.log
NEED3B=(
  "Qwen/Qwen2.5-Coder-3B-Instruct|488639f1ff808d1d3d0ba301aef8c11461451ec5|2"
  "Qwen/Qwen2.5-Coder-3B|09d9bc5d376b0cfa0100a0694ea7de7232525803|2"
  "Nellyw888/Qwen2.5-3b-sft-reasoning|1f0b7fac9c057b32cba9107a854518be92e45c91|3"
  "Nellyw888/VeriReason-Qwen2.5-3b-RTLCoder-Verilog-GRPO-reasoning-tb|3b93ce1bd7e5d90dae8761363a9c6862d0ed583a|2"
)

log(){ echo "$(date '+%F %T') $*" >> "$LOG"; }

while : ; do
  ok=1
  sg docker -c "docker image inspect $PT_IMAGE" >/dev/null 2>&1 || ok=0
  for e in "${NEED3B[@]}"; do
    IFS='|' read -r id rev nsh <<< "$e"
    d=~/hf/hub/models--${id//\//--}
    snap=$d/snapshots/$rev
    have=$(ls "$snap"/*.safetensors 2>/dev/null | wc -l)
    inc=$(ls "$d"/blobs/*.incomplete 2>/dev/null | wc -l)
    [ "$have" -ge "$nsh" ] && [ "$inc" -eq 0 ] || ok=0
  done
  [ "$ok" -eq 1 ] && break
  log "waiting (image/weights incomplete)"
  sleep 300
done
log "prerequisites met; running H0-a in $PT_IMAGE"

sg docker -c "docker run --rm -v $HOME/hf:/root/hf -v $PWD:/work --entrypoint python3 $PT_IMAGE /work/h0/h0a_weight_distance.py" >> "$LOG" 2>&1
rc=$?
log "h0a exit=$rc"
if [ $rc -eq 0 ] && [ -f results/h0/h0a_weight_distance.json ]; then
  if [ -z "$(git status --porcelain | grep -vE '^\?\? (results/h0/h0a_weight_distance.json)$' )" ]; then
    cat >> notes/LOG.md <<WEOF

## $(date '+%F %H:%M') — H0-a executed by watcher (pytorch container)
- h0/h0a_weight_distance.py in nvcr.io/nvidia/pytorch:25.11-py3, CPU fp32, 4 checkpoints.
- Result: results/h0/h0a_weight_distance.json (auto-committed by watcher).
WEOF
    git add results/h0/h0a_weight_distance.json notes/LOG.md
    git commit -q -m "h0-a: weight-distance result (watcher run in pytorch container)" && git push origin spark >> "$LOG" 2>&1
    log "committed+pushed"
  else
    log "tree not clean; left result uncommitted"
  fi
fi
log "watcher done"
