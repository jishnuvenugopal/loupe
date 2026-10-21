#!/usr/bin/env bash
# a20/keepawake.sh — operator-requested housekeeping (21 Oct 2026): hold a
# FULL sleep block inhibitor for the whole unattended window, independent of
# the A20 supervisor, so the machine cannot suspend even if the supervisor
# dies between heartbeats. Auto-restarts the inhibitor if it ever exits.
# Runs under tmux:  tmux new-session -d -s keepawake 'bash a20/keepawake.sh'
while true; do
  systemd-inhibit --what=sleep:shutdown:idle \
    --who=a20-keepawake \
    --why="unattended A20 run until 31 Oct 2026 (operator instruction: system must stay active)" \
    --mode=block sleep infinity
  echo "$(date '+%Y-%m-%d %H:%M:%S') inhibitor exited rc=$? — restarting in 5s" >> ~/runs/keepawake.log
  sleep 5
done
