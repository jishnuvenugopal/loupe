# The lab notebook

<!-- ste:begin -->

The `spark` branch is the raw record of the run. The agents wrote it as they worked, so it is long, technical and full of stop lines. I keep it as it is, because the failures are part of the evidence. This page tells you where to look.

## Where to start

| File | What it holds |
|---|---|
| [`PREREG.md`](../PREREG.md) and `PREREG-A19.md` to `PREREG-A21.md` | The frozen analysis plan and its amendments, each with an `.ots` timestamp proof |
| [`AMENDMENT-A22.md`](../AMENDMENT-A22.md) | The AI-label deviation and the exact text that reports must carry |
| [`results/main/summary.md`](../results/main/summary.md) | The primary results, as the pinned code wrote them |
| [`SPARK_REPORT.md`](../SPARK_REPORT.md) | The status report of the Spark agent, newest entry first |
| [`DEEP_REPORT.md`](../DEEP_REPORT.md) | The checks on the scorer: proofs, mutants, simulators, reference audit |
| [`notes/LOG.md`](../notes/LOG.md) | The full run log, with every stop, restart and decision |
| [`HANDOFF.md`](../HANDOFF.md) | The last handoff note between agent sessions |

## Other folders

| Folder | What it holds |
|---|---|
| `results/h0/` | Checks before the main run: weight hashes, the parent check for the 3B models, contamination, the oracle check |
| `shakedown/` | Timing and set-up runs before the plan froze, and the overnight chain script |
| `a20/` | The unattended chain supervisor and the outage recovery |
| `a22/` | The renderer and the tests for the AI-label report |
| `notes/` | Raw logs, heartbeats and receipts for each amendment |
| `results/main/releases/`, `gen/manifests/` | Deterministic archives of the generated outputs, and their manifests |

## Names and paths in the record

- The files call the project `rte-strict-eval` or `rtl-strict-eval`. Those are earlier names of this project.
- Paths that start with `~/runs/` or `/home/` point to the local disk of the Spark. Those files are not in this repository, unless a commit copied them.
- "The operator" in the record means me, the author.

## One change to the history

On 15 and 16 Nov 2026, I rebuilt the last three commits of `spark`. These are the records of amendment A22 from 13 Nov. The rebuild made two changes:

- One JSON key in `results/main/blind40/labels.ai.provenance.json` named a private local repository. The key is now `source_local_labelling_commit`, and its value did not change.
- One receipt, `notes/a22_delivery_receipt.json`, gave the full path of a folder on my laptop. It now says only "fresh clone".

Three files and one commit message cite the IDs of those commits, so they now cite the new IDs. Apart from these two changes and the IDs, nothing changed. Every earlier commit and all three tags keep their original IDs, and the plan files and their timestamp proofs did not change.

<!-- ste:end -->
