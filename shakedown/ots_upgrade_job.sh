#!/usr/bin/env bash
# A18 §8 step 4: ots upgrade ~6 h after the stamp; detached (survives tmux death).
set -uo pipefail
REPO=~/rtl-strict-eval
OTS=$(command -v ots || echo "$HOME/.venvs/host/bin/ots")
cd "$REPO"
TARGET=$(( $(cat ~/runs/ots_stamp_time.txt) + 6*3600 ))
while [ "$(date +%s)" -lt "$TARGET" ]; do sleep 60; done
"$OTS" upgrade PREREG.md.ots \
  && git add PREREG.md.ots \
  && git commit -qm "A18: ots upgrade PREREG.md.ots (T_stamp+6h)" \
  && git push origin spark \
  && echo "- $(date '+%Y-%m-%d %H:%M') — [chain] ots upgrade committed and pushed" >> notes/LOG.md
