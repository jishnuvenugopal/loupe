# Approved deviation: AI adjudication replaces the planned human blind-40 labels

**Decision ID:** `blind40-ai-2026-11-12`

**Recorded:** 12 Nov 2026, 08:37 +08 (local decision-record time, not an external timestamp).

**Status:** operator-approved for exploratory use. A22 records the downstream reporting path; real unblinding and remote delivery remain separately gated.

## Decision and timing

The frozen pre-registration required the operator, as one human study-author rater, to label the blind sample. The operator later approved AI-generated exploratory adjudication instead for these 40 packets. This approval occurred on 12 Nov 2026 after the AI labels and their counts had been completed. Aggregate study findings were available in the rating context.

This is a post hoc deviation, not a new pre-registration. The originally planned single-author human rating was not performed. Operator adoption, or later import into a labelling interface, does not convert the AI judgments into human labels.

The reviewer did not access the hidden arm key or arm mapping. It was not a fresh isolated reviewer and had prior aggregate study context. No fully independent blinding or second-rater claim is made.

## Exact adopted artifact

| Field | Value |
|---|---|
| File | `labels.ai.csv` |
| SHA-256 | `570eac0376dcacdab317d22c51ac31206ddbe802388cdc5cff33895d44055468` |
| Bytes / rows | 843 bytes; 40 data rows; `id,label` schema |
| Source label checkpoint | `c828ecc2cf228b8c676fed79af52a49816afc439` in the originating local decision repository |
| Packet revision | `00a5aef7e36ca2b8d27da9a8f4241e216df83d54` |
| Counts | 18 real bug; 5 reference wrong; 12 allowed by spec; 5 unclear; 0 scorer artefact |
| Rater | One AI review session; harness-reported model `gpt-6-astra`; zero independent human raters |
| Evidence records | `ai-review.md` and `verify_ai_review.py` in the originating evidence bundle; 40 targeted RTL witness checks were reported there |
| Machine-readable provenance | `labels.ai.provenance.json` |

Approval is bound to the exact CSV bytes. Any later label revision requires a retained prior version, a new hash and reasons, a before/after-unblinding timing record, and renewed adoption approval. The five unclear cases are retained, not dropped or silently relabelled.

The originating review reported that all 40 targeted RTL witness checks passed with Icarus 13.0. Those checks support individual observations; they do not prove every label or design correct. The same agent wrote the judgments and tests, so this is not independent replication or inter-rater agreement. A22 does not rerun or claim to reproduce those checks.

## Frozen study invariants

The frozen pre-registration remains unchanged. Its SHA-256 is `eec18735d7787e6ddcb04d84b66446f02f22189b6e7909a882ed02889fb98179`; its bytes at the packet revision match `g0-prereg`. No existing pre-registration, timestamp proof, or tag is replaced.

The scorer, generation, gates, primary metrics, primary contrasts, and interpretation remain unchanged. These labels are a separate exploratory adjudication result, not formal score classes and not a correction to headline rates.

The registered overall and per-family class-share calculations and Wilson intervals remain the intended descriptive calculation after separately authorized unblinding. This decision does not authorize a new statistical method or population extrapolation. Intervals must state that they do not account for AI-rating error, correlated judgments, or context/blinding limitations.

## Required downstream wording and limitations

Use this heading beside every blind-40 table or summary:

## Exploratory AI adjudication — protocol deviation

Use this disclosure beside every blind-40 table or summary:

> The planned single-author human adjudication was replaced, with operator approval on 12 Nov 2026 after AI labelling was completed, by one AI-generated review. No independent human rater assessed these 40 packets. The reviewer did not access the hidden arm key but had prior aggregate study context. The five unclear labels were retained. These exploratory labels do not change the pre-registered primary results.

Keep the provenance record and adopted CSV hash with the result. Do not say `human-verified`, `expert human review`, `independent human validation`, or `pre-registered human adjudication completed`. Targeted simulation supports individual observations but does not prove all labels correct. AI reviewer/model error and correlated biases remain limitations.

## Authorization and delivery boundary

The original adoption authorizes the exact AI label set for exploratory use and recording this deviation. It does not by itself authorize submission to the watched label path, any push, unblinding, publication, key access/disclosure, credential changes, or changes to frozen scoring/analysis.

A20 automation can fetch `results/main/blind40/labels.csv`, automatically unblind, and rewrite the summary with an incorrect human-rater statement. It does not propagate this provenance record. Therefore:

1. A22 must first establish and locally test a provenance-aware reporting path without using the real key or producing real unblinded results.
2. Legacy A20 Part E must not consume this AI set. Any later delivery must first disable that path safely under separate approval, use only the quarantined `.ai` files, and render through A22.
3. Before later delivery, revalidate the exact CSV against the pinned template and hash, preserve all 40 labels, and recheck live polling/DNS and expiry status. The last prior handoff recorded a 15 Nov 2026 23:59 +08 polling deadline; that is not evidence that polling remains alive.
4. Separate explicit push/unblind approval is required. After any authorized delivery, record the delivery commit/time and matching label hash in durable handoffs and keep this provenance beside every resulting blind-40 report. Frozen primary tables remain unchanged.

**A22 delivery receipt:** pending. **Push/unblind approval:** not granted by this record. **Watched label file:** must remain absent during readiness.
