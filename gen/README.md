# gen/ — generation lane

- `gen_vllm.py` — in-container generation driver (Phase 8 row format, resumable
  by `(task_id, sample_idx)`, per-task seed, all sampling fields explicit,
  `generation_config="vllm"`). Smoke-tested in-container; resume verified.
- `run_overnight.sh` — Phase 8 order: CodeV RL → Distill → Qwen 7B base
  (run only after the G0 steps, inside tmux, with the recommended container
  flags `--ipc=host --ulimit memlock=-1 --ulimit stack=67108864`).
- `make_manifest.py` — morning manifests (row counts, sha256, truncation,
  extraction rate). Commit manifests only; raw generations stay in `~/runs/gen`.

## Prepared rsync to the Halo (Phase 8 step 5 — prepare, do NOT run)

Replace `<halo-host>` with the operator-provided address; the receiving
operator runs the matching `rsync --receive` or has the path pre-created:

```bash
rsync -av --partial --info=progress2 \
  ~/runs/gen/ <halo-host>:~/runs/spark_gen/
```

Sent: `~/runs/gen/*.jsonl` (rows only, no weights, no prompts beyond hashes).
Not sent: `~/hf` (weights stay on each machine), the repo (Halo pulls `spark`).
