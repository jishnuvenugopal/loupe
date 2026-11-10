# A21 — post-generation amendment: blind-review packet provenance repair

Authorized by the operator's `yes` on 10 Nov 2026, following the reported
33/40 packet mismatch and the explicitly proposed narrow repair. Recorded in
the session beginning 21:19 +08. This is a **post-generation correction**, not
a claim of pre-registration before the original evaluation. No human labels
have been submitted (`operator` branch and `labels.csv` absent at the check).

## Finding and scope

`scoring/blind40.py:gen_rows` and its caller keyed generations by
`(bench, task_id, sample_idx)`, omitting arm. Different arms therefore overwrote
one another. The verified original blind key selects the intended samples, but
33 of the 40 packet code sections show a different sample's code.

Evidence: `notes/blind40_integrity_check.json` and the read-only
`a20/audit_blind40_inputs.py`. Ten source generation files match their committed
manifests. The key matches `KEY_SHA256`; packet IDs, metadata and blank template
match the original draw. No attribution/key contents are disclosed by the audit.

The approved change is limited to:

1. Include **arm** in the generation lookup identity in `gen_rows` and `draw`.
   The only other source change is that function's explanatory docstring.
2. Add synthetic cross-arm regression tests and code-section preservation tests.
3. Repair only the generated-code sections of the existing packets from the
   original, hash-verified generations, then audit all 40 packets again.

## Invariants

- **No redraw**: retain exactly the same selected samples, all 40 IDs, key bytes,
  `KEY_SHA256`, `draw_meta.json` and `labels_template.csv`.
- Keep packet specifications, references, official verdicts, counterexample
  sections and label choices byte-identical to the original packets.
- No new model generations, training, scoring or primary/sensitivity statistics.
- `scorer/`, other `scoring/` files, training/reward code, prompt/task sets,
  sampling, model revisions and existing primary scores/results remain unchanged.
- `PREREG.md`, `PREREG-A19.md`, `PREREG-A20.md` and their existing stamps remain
  byte-identical. A21 does not retrospectively alter those documents.
- Human review starts only after all 40 code sections match their intended
  generation and pass the existing blindness scrub. Review the current packet
  files, not attribution files or repair diffs/history, to maintain blinding.

## Explicit pin supersession

Only the packet-writer source pin from the original PREREG is superseded:

- Original digest: `c6688f39d4e12ea61bb9e65ffe5bcc96c8f88d311806e468d809e0637b7c06df`.
- `scoring/blind40.py` — `acfe8185446c0636b835766574bd125992eb457935d8d7d0c43e29d700c85ad3`.

The unblinding and statistical functions in that file are unchanged. The
operational recovery freeze checker is updated to accept **this exact digest**,
not arbitrary changes under scoring/. All other tree/hash checks remain active.

Repair and regression implementation snapshots:

- `a20/repair_blind40_packets.py` — `add22f2ed1bbb8958c731c50488b6516f131f551590f9f7b212122f3c82c6d6b`.
- `a20/test_blind40_packet_repair.py` — `ffd021c14950c110463402e568258294e859e29a2f8d4361a0e7871a951e008e`.

## Execution and evidence

- Before the fix, all three cross-arm regression tests fail on synthetic data:
  `notes/a21_regression_before.txt`.
- After the fix, the six A21 tests plus fourteen existing recovery tests pass:
  `notes/a21_regression_after.txt` (20 tests). Existing frozen file-handle
  ResourceWarnings are recorded, not repaired by this amendment.
- Preview: `notes/a21_packet_preview.json` plans exactly 33 code-section edits;
  all 40 candidate packets pass the existing scrub. The preview hashes 3,301
  protected tracked artifacts (including primary/sensitivity results, scores,
  draw metadata, templates, manifests, frozen training/scorer source and old
  preregistrations); aggregate before/after hashes match.
- Apply the approved repair with `a20/repair_blind40_packets.py --apply`.
  Aggregate receipt: `notes/a21_packet_repair.json`. The tool never calls draw,
  writes the key, or outputs packet-to-arm attribution. It checks protected
  fingerprints before/after and rolls packet edits back on a failed post-check.
- Independently re-run `a20/audit_blind40_inputs.py`; output:
  `notes/blind40_integrity_after_a21.json`. Required result: 40 matches, zero
  mismatches/unreadable sections, no key disclosure.
- Commit/push this amendment, source fix and tests before changing packet data;
  timestamp A21 separately. Commit the repaired packet data and receipts as the
  following step, retaining the original packets and failure evidence in history.

## Running-job handling

The active recovery supervisor loaded the old freeze checker in memory. After
the approved pin update, replace **only that supervisory process** and adopt the
same live training container, preserving its PID/start time and resume budget.
The original paused supervisor/terminal holding the training Docker client stays
intact until training exits. Do not restart training, change its configuration,
or launch a second heavy workload. This operational handover is logged separately.
