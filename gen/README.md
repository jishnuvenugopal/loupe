# gen/ — generation lane

- `gen_vllm.py` — in-container generation driver (Phase 8 row format, resumable
  by `(task_id, sample_idx)`, per-task seed, all sampling fields explicit,
  `generation_config="vllm"`). Smoke-tested in-container; resume verified.
- `run_overnight.sh` — Phase 8 order (A16 §3 step 4): CodeV RL → Distill → 3B RL
  → 3B base → Qwen 7B base (run only after the G0 steps, inside tmux, with the
  recommended container flags `--ipc=host --ulimit memlock=-1 --ulimit stack=67108864`).
- `make_manifest.py` — morning manifests (row counts, sha256, truncation,
  extraction rate). Commit manifests only; raw generations stay in `~/runs/gen`.

## A16: no rsync step

Amendment A16 removed the second machine. There is no Halo transfer: when
 generation ends, write `gen/manifests/<arm>.json` for every arm, commit and
push the manifests only, and go straight to Phase 10 (strict scoring on this
machine) unless the operator has written `hold`.
