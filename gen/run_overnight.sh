#!/usr/bin/env bash
# Phase 8 overnight generation (thin wrapper, A18: docker-driven).
# The real runner is gen/run_overnight.py (A16 §3 step 4 order, A16 §5 steps
# 2-5, cuts only as PREREG states via gen/cut.txt, throughput checks 30 min in
# and at the first 3B arm, manifests at the end are built by the chain).
# Usage (inside the chain's tmux): bash gen/run_overnight.sh
set -uo pipefail
cd "$(dirname "$0")/.."
exec python3 gen/run_overnight.py
