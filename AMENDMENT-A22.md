# AMENDMENT-A22 — exploratory AI blind-40 adjudication: provenance/reporting readiness only

**Decision ID:** `blind40-ai-2026-11-12` (recorded 12 Nov 2026, 08:37 +08 in the originating decision record).

**This readiness work:** recorded 13 Nov 2026 (+08) on the DGX Spark. Local-only; no push, no unblinding, no key access, no process change.

## 1. What A22 is, and is not

The operator adopted one exact 40-row AI-generated label set for **exploratory** use and directed a provenance-preserving reporting path. A22 records that deviation and builds/tests the reporting renderer only. Explicitly:

- A22 is **post hoc and exploratory**. It does not rewrite or replace `PREREG.md`, `PREREG-A19.md`, `PREREG-A20.md`, or `PREREG-A21.md`, and it must not be described as timestamped before labelling. The AI labels and their aggregate counts existed before adoption, and the reviewer had prior aggregate study context.
- **No OpenTimestamp operation is authorized or performed** for A22 in this readiness step. A22 is not a pre-registration and must never be OTS-stamped as though it were one.
- Existing primary tables, contrasts, scorer/analysis behavior, the blind draw, packet IDs/order, and key handling remain **unchanged**.
- New A22 files only: `AMENDMENT-A22.md`, `a22/report.py`, `a22/test_report.py`, `results/main/blind40/protocol-deviation.md`, `results/main/blind40/labels.ai.provenance.json`, `results/main/blind40/labels.ai.csv`, `notes/a22_readiness_tests.txt`, `notes/a22_readiness_receipt.json`. Edits to existing tracked files are not part of this readiness commit.
- The **legacy A20 Part E path must never consume this AI set**. Later delivery must use only the quarantined `.ai` filenames and the A22 renderer. A20's `unblind_section_text` asserts `Single rater (the study author)`, which is false for this set; a sidecar beside the CSV would not fix that summary text.
- A later, **separate operator approval** is required before any push, real key access, unblinding, summary update, process stop/restart, or remote delivery. This readiness receipt is not that approval.

## 2. Adopted artifact identity (exact)

| Field | Value |
|---|---|
| File | `results/main/blind40/labels.ai.csv` (quarantined `.ai` name; never copied to `labels.csv`) |
| SHA-256 | `570eac0376dcacdab317d22c51ac31206ddbe802388cdc5cff33895d44055468` |
| Bytes / rows / schema | 843 bytes; 40 data rows; `id,label`; IDs exactly in `labels_template.csv` order |
| Packet revision | `00a5aef7e36ca2b8d27da9a8f4241e216df83d54` |
| Counts | 18 `real bug`; 5 `reference wrong`; 12 `allowed by spec`; 5 `unclear`; 0 `scorer artefact` |
| Rating provenance | One AI review session; harness-reported model `gpt-6-astra`; zero independent human raters; no hidden-key or arm-mapping access by the reviewer |
| Standalone decision record | `results/main/blind40/protocol-deviation.md` |
| Machine-readable sidecar | `results/main/blind40/labels.ai.provenance.json` |

Approval is bound to the exact CSV bytes. Any later label revision requires a retained prior version, a new hash and reasons, a before/after-unblinding timing record, and renewed adoption approval. The five `unclear` labels are retained.

## 3. Required downstream wording

Heading (exact), beside every blind-40 table or summary rendered under A22:

## Exploratory AI adjudication — protocol deviation

Disclosure (exact):

> The planned single-author human adjudication was replaced, with operator approval on 12 Nov 2026 after AI labelling was completed, by one AI-generated review. No independent human rater assessed these 40 packets. The reviewer did not access the hidden arm key but had prior aggregate study context. The five unclear labels were retained. These exploratory labels do not change the pre-registered primary results.

Prohibited wording in any A22-rendered output: `Single rater (the study author)`, `human-verified`, `expert human review`, `independent human validation`, `pre-registered human adjudication completed`, and any description of the selected-sample shares as population estimates or as changes to the primary results.

## 4. Originating evidence — reported, not reproduced

The sidecar names `ai-review.md` and `verify_ai_review.py` as the originating evidence artifacts in the originating decision repository (label checkpoint `c828ecc2cf228b8c676fed79af52a49816afc439`). They are not embedded here and are not needed for this reporting-renderer test. The originating review reported 40 targeted RTL witness checks (Icarus 13.0) as passing; **A22 does not rerun or claim to reproduce those checks**. A22 verifies artifact identity (hash/bytes/rows/order/counts and sidecar binding) and reporting behavior only. Targeted tests are not global correctness proofs or independent replication; the same agent produced judgments and tests, so there is no inter-rater agreement claim.

## 5. Sources

Pinned remote state (packet revision):

- A20 supervisor: https://github.com/jishnuvenugopal/rte-strict-eval/blob/00a5aef7e36ca2b8d27da9a8f4241e216df83d54/a20/supervisor.py
- Blind draw/unblind implementation: https://github.com/jishnuvenugopal/rte-strict-eval/blob/00a5aef7e36ca2b8d27da9a8f4241e216df83d54/scoring/blind40.py
- A20: https://github.com/jishnuvenugopal/rte-strict-eval/blob/00a5aef7e36ca2b8d27da9a8f4241e216df83d54/PREREG-A20.md
- A21: https://github.com/jishnuvenugopal/rte-strict-eval/blob/00a5aef7e36ca2b8d27da9a8f4241e216df83d54/PREREG-A21.md

Local counterparts read before editing: `HANDOFF.md`, `notes/HEARTBEAT.md`, `PREREG.md`, `PREREG-A19.md`, `PREREG-A20.md`, `PREREG-A21.md`, `a20/supervisor.py` (`validate_labels`, `unblind_section_text`, `epoll_once`, `epoll_loop`), `scoring/blind40.py` (`unblind`, `--labels`).

## 6. Readiness tests and stop gate

`a22/report.py` is standard-library-only with explicit check/render interfaces; its default invocation is a read-only bundle check. It never reads a key, never invokes unblinding, never fetches/pushes, and never writes the watched label path; rendered sections are written only to an explicitly named output file. Results are captured in `notes/a22_readiness_tests.txt` (synthetic fixtures and temporary directories only; the real key and any real `unblinded.json` are never used; `results/main/summary.md` is not modified).

Stop gate: after the local readiness commit and receipt (`notes/a22_readiness_receipt.json`), stop. Later delivery additionally requires, under separate explicit approval: (1) safely stop/disable legacy Part E first; (2) deliver only the `.ai` bundle; (3) invoke the pinned `scoring/blind40.py --unblind --labels results/main/blind40/labels.ai.csv` (never A20's watched-`labels.csv` path) with the real key; (4) render only through `a22/report.py`, never A20 `unblind_section_text`; (5) revalidate CSV hash/template order and recheck live polling/DNS state before delivery.
