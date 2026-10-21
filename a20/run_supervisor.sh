#!/usr/bin/env bash
# a20/run_supervisor.sh — launch the A20 supervisor under tmux (Part C/D/E).
# Usage:  tmux new-session -d -s a20 'bash a20/run_supervisor.sh'
set -u
cd "$(dirname "$0")/.."
mkdir -p ~/runs
exec ~/.venvs/host/bin/python -u a20/supervisor.py >> ~/runs/a20_supervisor.log 2>&1
