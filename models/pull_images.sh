#!/usr/bin/env bash
# Phase 1 step 4: pull the two pinned NGC images sequentially, record digests.
set -uo pipefail
VLLM=nvcr.io/nvidia/vllm:26.05.post1-py3
PT=nvcr.io/nvidia/pytorch:25.11-py3
LOG_DIR="$HOME/runs"
echo "=== $(date '+%H:%M:%S') pulling $VLLM ==="
if ! sg docker -c "docker pull $VLLM"; then echo "PULL FAILED: $VLLM"; exit 1; fi
echo "=== $(date '+%H:%M:%S') pulling $PT ==="
if ! sg docker -c "docker pull $PT"; then echo "PULL FAILED: $PT"; exit 1; fi
echo "=== $(date '+%H:%M:%S') digests ==="
sg docker -c "docker inspect --format '{{index .RepoDigests 0}}' $VLLM"
sg docker -c "docker inspect --format '{{index .RepoDigests 0}}' $PT"
echo "ALL PULLS DONE"
