#!/usr/bin/env python3
"""a22/report.py — A22 exploratory AI blind-40 adjudication: provenance-aware
reporting renderer (readiness only).

Scope and hard limits (see AMENDMENT-A22.md):
  * Standard library only. Two explicit interfaces: `check_bundle` (read-only
    identity/provenance validation of the quarantined `.ai` bundle) and
    `render_result_section` (render a blind-40 result section from an
    `unblinded.json`-schema fixture WITHOUT recomputing any statistics).
  * The default CLI invocation is the read-only bundle check. This module
    never reads the real blind key (~/runs/blind40_key.json or any key file),
    never invokes unblinding, never runs git fetch/push, and never writes the
    watched label path `results/main/blind40/labels.csv`.
  * Rendered output is written only when an output file is explicitly named,
    and guards refuse watched/real-result filenames.
  * It never emits the legacy A20 wording or any prohibited phrase.

The unblinded fixture schema is the one written by the pinned
`scoring/blind40.py --unblind`:
  {"n": int, "overall": {label: {"count": int, "share": float,
   "wilson95": [lo, hi]}}, "per_family": {family: {label: {...}}},
   "labels": ["real bug", "reference wrong", "allowed by spec", "unclear",
              "scorer artefact"]}
"""
import argparse
import csv
import hashlib
import io
import json
import math
import os
import sys

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
BUNDLE_DIR = os.path.join(REPO, "results", "main", "blind40")

DECISION_ID = "blind40-ai-2026-11-12"
PACKET_REVISION = "00a5aef7e36ca2b8d27da9a8f4241e216df83d54"
ADOPTED_CSV_SHA256 = "570eac0376dcacdab317d22c51ac31206ddbe802388cdc5cff33895d44055468"
ADOPTED_CSV_BYTES = 843
ADOPTED_ROWS = 40
MODEL_ID = "gpt-6-astra"

LABELS = ("real bug", "reference wrong", "allowed by spec", "unclear",
          "scorer artefact")
CSV_COLUMNS = ["id", "label"]

REQUIRED_HEADING = "## Exploratory AI adjudication — protocol deviation"
REQUIRED_DISCLOSURE = (
    "> The planned single-author human adjudication was replaced, with operator "
    "approval on 12 Nov 2026 after AI labelling was completed, by one "
    "AI-generated review. No independent human rater assessed these 40 packets. "
    "The reviewer did not access the hidden arm key but had prior aggregate "
    "study context. The five unclear labels were retained. These exploratory "
    "labels do not change the pre-registered primary results.")

PROHIBITED_PHRASES = (
    "Single rater (the study author)",
    "human-verified",
    "expert human review",
    "independent human validation",
    "pre-registered human adjudication completed",
)

# Filenames this module must never write (watched label path / real results).
FORBIDDEN_OUT_BASENAMES = {"labels.csv", "unblinded.json", "summary.md"}
# Paths this module must never read as inputs (watched/real-result files).
WATCHED_TAILS = ("results/main/blind40/labels.csv",
                 "results/main/blind40/unblinded.json")

SIDECAR_RELPATH = "results/main/blind40/labels.ai.provenance.json"
CSV_RELPATH = "results/main/blind40/labels.ai.csv"


class A22ReportError(ValueError):
    """Validation failure — A22 always fails closed."""


# ---------------------------------------------------------------- helpers
def _reject_watched_input(path):
    p = os.path.abspath(path).replace(os.sep, "/")
    for tail in WATCHED_TAILS:
        if p.endswith(tail):
            raise A22ReportError(
                f"refusing to read watched/real-result path: {tail} "
                "(A22 readiness must not touch it)")


def _reject_forbidden_output(path):
    base = os.path.basename(path)
    if base in FORBIDDEN_OUT_BASENAMES:
        raise A22ReportError(
            f"refusing to write output file named {base!r}: watched/real-result "
            "filenames must never be written by the A22 renderer")
    ap = os.path.abspath(path).replace(os.sep, "/")
    for tail in WATCHED_TAILS:
        if ap.endswith(tail):
            raise A22ReportError(
                f"refusing to write watched/real-result path: {tail}")


def _is_plain_int(v):
    return isinstance(v, int) and not isinstance(v, bool)


def _is_fin(v):
    return isinstance(v, (int, float)) and not isinstance(v, bool) \
        and math.isfinite(v)


# ------------------------------------------------------------ bundle check
def check_bundle(csv_path=None, sidecar_path=None, template_path=None,
                 protocol_path=None):
    """Read-only validation of the quarantined `.ai` provenance bundle.

    Returns (ok, problems). Independently recomputes the CSV hash, byte
    count, schema, template order, vocabulary and class counts, then
    cross-checks every corresponding sidecar field, the decision ID, the
    packet revision, rating honesty fields, frozen-study fields, and the
    required heading/disclosure in the standalone protocol record.
    """
    csv_path = csv_path or os.path.join(BUNDLE_DIR, "labels.ai.csv")
    sidecar_path = sidecar_path or os.path.join(BUNDLE_DIR,
                                                "labels.ai.provenance.json")
    template_path = template_path or os.path.join(BUNDLE_DIR,
                                                  "labels_template.csv")
    protocol_path = protocol_path or os.path.join(BUNDLE_DIR,
                                                  "protocol-deviation.md")
    problems = []

    for p in (csv_path, sidecar_path, template_path, protocol_path):
        if not os.path.isfile(p):
            problems.append(f"missing provenance file: {p}")
    if problems:
        return False, problems

    _reject_watched_input(csv_path)
    with open(csv_path, "rb") as f:
        raw = f.read()
    sha = hashlib.sha256(raw).hexdigest()
    if sha != ADOPTED_CSV_SHA256:
        problems.append(f"CSV sha256 {sha} != adopted {ADOPTED_CSV_SHA256}")
    if len(raw) != ADOPTED_CSV_BYTES:
        problems.append(f"CSV byte count {len(raw)} != adopted "
                        f"{ADOPTED_CSV_BYTES}")

    rows = list(csv.reader(io.StringIO(raw.decode("utf-8"))))
    if not rows or rows[0] != CSV_COLUMNS:
        problems.append(f"CSV header {rows[0] if rows else []!r} != "
                        f"{CSV_COLUMNS!r}")
    data = rows[1:]
    if len(data) != ADOPTED_ROWS:
        problems.append(f"CSV data rows {len(data)} != {ADOPTED_ROWS}")
    ids, labels = [], []
    for i, r in enumerate(data, start=2):
        if len(r) != 2:
            problems.append(f"CSV line {i}: not exactly one comma")
            continue
        pid, lab = r[0].strip(), r[1].strip()
        if not pid:
            problems.append(f"CSV line {i}: blank id")
        if not lab:
            problems.append(f"CSV line {i}: blank label")
        if lab and lab not in LABELS:
            problems.append(f"CSV line {i}: unknown label {lab!r}")
        ids.append(pid)
        labels.append(lab)
    if len(set(ids)) != len(ids):
        problems.append("duplicate ids in CSV")

    tmpl = []
    with open(template_path, encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith("id,label"):
                continue
            tmpl.append(line.split(",")[0].strip())
    if ids != tmpl:
        problems.append("CSV ids do not match labels_template.csv exactly "
                        "(same set and exact order)")

    counts = {lab: 0 for lab in LABELS}
    for lab in labels:
        if lab in counts:
            counts[lab] += 1

    try:
        with open(sidecar_path, encoding="utf-8") as f:
            side = json.load(f)
    except (ValueError, OSError) as e:
        return False, problems + [f"sidecar not parseable JSON: {e}"]
    if not isinstance(side, dict):
        return False, problems + ["sidecar is not a JSON object"]

    def need(cond, msg):
        if not cond:
            problems.append(msg)

    need(side.get("deviation_id") == DECISION_ID,
         f"sidecar deviation_id != {DECISION_ID}")
    need(side.get("sources", {}).get("packet_revision") == PACKET_REVISION,
         f"sidecar packet_revision != {PACKET_REVISION}")

    lab = side.get("labels", {})
    need(lab.get("file") == "labels.ai.csv",
         "sidecar labels.file != labels.ai.csv")
    need(lab.get("sha256") == ADOPTED_CSV_SHA256,
         "sidecar labels.sha256 does not bind the adopted CSV hash")
    need(lab.get("bytes") == ADOPTED_CSV_BYTES,
         "sidecar labels.bytes does not match recomputed byte count")
    need(lab.get("rows") == ADOPTED_ROWS,
         "sidecar labels.rows does not match recomputed row count")
    need(lab.get("columns") == CSV_COLUMNS,
         "sidecar labels.columns != ['id', 'label']")
    side_counts = lab.get("counts", {})
    need(isinstance(side_counts, dict) and
         set(side_counts) == set(LABELS),
         "sidecar counts must cover exactly the five-label vocabulary")
    for k in (side_counts if isinstance(side_counts, dict) else {}):
        need(side_counts.get(k) == counts.get(k, 0),
             f"sidecar count for {k!r} != recomputed {counts.get(k, 0)}")
    need(counts.get("unclear") == 5,
         f"unclear count {counts.get('unclear')} != 5 (all five retained)")

    rating = side.get("rating", {})
    need(rating.get("human_raters") == 0, "sidecar rating.human_raters != 0")
    need(rating.get("ai_review_sessions") == 1,
         "sidecar rating.ai_review_sessions != 1")
    need(rating.get("hidden_key_accessed_by_reviewer") is False,
         "sidecar claims reviewer key access")
    need(rating.get("arm_mapping_accessed_by_reviewer") is False,
         "sidecar claims reviewer arm-mapping access")
    need(rating.get("model_id_reported_by_labelling_harness") == MODEL_ID,
         f"sidecar harness model != {MODEL_ID}")

    rep = side.get("reporting", {})
    need(rep.get("primary_results_changed") is False,
         "sidecar claims primary results changed")
    need(rep.get("frozen_prereg_changed") is False,
         "sidecar claims frozen prereg changed")
    need(rep.get("frozen_scoring_or_analysis_changed") is False,
         "sidecar claims frozen scoring/analysis changed")

    with open(protocol_path, encoding="utf-8") as f:
        proto_lines = f.read().splitlines()
    need(REQUIRED_HEADING in proto_lines,
         "protocol record is missing the exact required heading")
    need(REQUIRED_DISCLOSURE in proto_lines,
         "protocol record is missing the exact required disclosure")

    return (not problems), problems


# --------------------------------------------------------- fixture checks
def _check_stat_cell(cell, where, problems):
    if not isinstance(cell, dict):
        problems.append(f"{where}: not an object")
        return
    c = cell.get("count")
    if not _is_plain_int(c):
        problems.append(f"{where}.count is not an integer: {c!r}")
    elif c < 0:
        problems.append(f"{where}.count is negative: {c}")
    s = cell.get("share")
    if not _is_fin(s) or not (0.0 <= s <= 1.0):
        problems.append(f"{where}.share is not a finite share in [0,1]: {s!r}")
    w = cell.get("wilson95")
    if not isinstance(w, (list, tuple)) or len(w) != 2 \
            or not all(_is_fin(x) for x in w):
        problems.append(f"{where}.wilson95 must be two finite numbers: {w!r}")
    elif not (0.0 <= w[0] <= w[1] <= 1.0):
        problems.append(f"{where}.wilson95 is not an ordered [0,1] interval: "
                        f"{w!r}")


def _validate_unblinded(unb, sidecar_counts):
    """Fail-closed validation of an unblinded.json-schema fixture.

    Requires n == 40, the exact five-label vocabulary, overall counts
    matching the adopted sidecar, per-family counts that sum to the overall
    count for every label, and integral non-negative counts everywhere.
    Never invents or recomputes counts, shares, or intervals.
    """
    problems = []
    if not isinstance(unb, dict):
        return ["unblinded fixture is not a JSON object"]
    for k in ("n", "overall", "per_family", "labels"):
        if k not in unb:
            problems.append(f"unblinded fixture missing key {k!r}")
    if problems:
        return problems
    if not _is_plain_int(unb["n"]):
        problems.append(f"n is not an integer: {unb['n']!r}")
    elif unb["n"] != ADOPTED_ROWS:
        problems.append(f"n == {unb['n']!r}, expected {ADOPTED_ROWS}")
    if list(unb["labels"]) != list(LABELS):
        problems.append(f"labels {unb['labels']!r} != the exact five-label "
                        "vocabulary")
    overall = unb["overall"]
    if not isinstance(overall, dict):
        return problems + ["overall is not an object"]
    for lab in LABELS:
        if lab not in overall:
            problems.append(f"overall is missing label {lab!r}")
        else:
            _check_stat_cell(overall[lab], f"overall[{lab!r}]", problems)
    total = 0
    for lab in LABELS:
        if lab in overall and isinstance(overall[lab], dict) \
                and _is_plain_int(overall[lab].get("count")):
            total += overall[lab]["count"]
            if overall[lab]["count"] != sidecar_counts.get(lab):
                problems.append(
                    f"overall[{lab!r}].count {overall[lab]['count']} != adopted "
                    f"sidecar count {sidecar_counts.get(lab)}")
    if total != ADOPTED_ROWS:
        problems.append(f"overall counts sum to {total}, expected "
                        f"{ADOPTED_ROWS}")
    pf = unb["per_family"]
    if not isinstance(pf, dict) or not pf:
        return problems + ["per_family is not a non-empty object"]
    fam_totals = {lab: 0 for lab in LABELS}
    for fam in sorted(pf):
        cells = pf[fam]
        if not isinstance(cells, dict):
            problems.append(f"per_family[{fam!r}] is not an object")
            continue
        for lab in LABELS:
            if lab not in cells:
                problems.append(f"per_family[{fam!r}] is missing label {lab!r}")
                continue
            _check_stat_cell(cells[lab], f"per_family[{fam!r}][{lab!r}]",
                             problems)
            c = cells[lab].get("count") if isinstance(cells[lab], dict) else None
            if _is_plain_int(c):
                fam_totals[lab] += c
    for lab in LABELS:
        oc = None
        if lab in overall and isinstance(overall[lab], dict) \
                and _is_plain_int(overall[lab].get("count")):
            oc = overall[lab]["count"]
        if fam_totals[lab] != oc:
            problems.append(
                f"per-family sum for {lab!r} ({fam_totals[lab]}) disagrees with "
                f"overall count ({oc!r})")
    if sum(fam_totals.values()) != ADOPTED_ROWS:
        problems.append(f"per-family grand total {sum(fam_totals.values())} != "
                        f"{ADOPTED_ROWS}")
    return problems


# ----------------------------------------------------------------- render
def render_result_section(unblinded, csv_path=None, sidecar_path=None,
                          template_path=None, protocol_path=None,
                          out_path=None):
    """Render the A22 blind-40 result section from an unblinded.json-schema
    fixture (dict or path). Returns the markdown text; writes it only if
    `out_path` is explicitly named (guarded). Uses the supplied Wilson
    intervals verbatim — the pinned statistical method is never recomputed.
    """
    ok, problems = check_bundle(csv_path, sidecar_path, template_path,
                                protocol_path)
    if not ok:
        raise A22ReportError("bundle check failed: " + "; ".join(problems))

    sidecar_path = sidecar_path or os.path.join(BUNDLE_DIR,
                                                "labels.ai.provenance.json")
    with open(sidecar_path, encoding="utf-8") as f:
        side = json.load(f)
    side_counts = side["labels"]["counts"]
    method = side["rating"]["method"]

    if isinstance(unblinded, (str, os.PathLike)):
        _reject_watched_input(unblinded)
        with open(unblinded, encoding="utf-8") as f:
            try:
                unb = json.load(f)
            except ValueError as e:
                raise A22ReportError(f"unblinded fixture is not valid JSON: "
                                     f"{e}")
    else:
        unb = unblinded
    problems = _validate_unblinded(unb, side_counts)
    if problems:
        raise A22ReportError("unblinded fixture rejected: " + "; ".join(problems))

    def pct(x):
        return f"{100 * x:.1f}"

    def cell(c):
        w = c["wilson95"]
        return f"{c['count']} | {pct(c['share'])} [{pct(w[0])}, {pct(w[1])}]"

    L = [REQUIRED_HEADING, "", REQUIRED_DISCLOSURE, "",
         f"**Provenance (decision `{DECISION_ID}`):** labels from {method} "
         f"(harness-reported model `{MODEL_ID}`); zero independent human "
         "raters assessed these 40 packets. Adopted artifact "
         f"`{CSV_RELPATH}` (SHA-256 `{ADOPTED_CSV_SHA256}`, "
         f"{ADOPTED_CSV_BYTES} bytes, {ADOPTED_ROWS} rows) at packet revision "
         f"`{PACKET_REVISION}`. Machine-readable provenance: "
         f"`{SIDECAR_RELPATH}`. The five unclear labels were retained.", "",
         "Overall (n = 40):", "",
         "| class | n | share % [Wilson 95% CI] |", "|---|---|---|"]
    for lab in unb["labels"]:
        L.append(f"| {lab} | {cell(unb['overall'][lab])} |")
    L += ["", "Per family (every class row shown, including zero counts):", "",
          "| family | class | n | share % [Wilson 95% CI] |", "|---|---|---|---|"]
    for fam in sorted(unb["per_family"]):
        cells = unb["per_family"][fam]
        fam_n = sum(cells[lab]["count"] for lab in unb["labels"])
        for lab in unb["labels"]:
            L.append(f"| {fam} (n={fam_n}) | {lab} | {cell(cells[lab])} |")
    L += ["",
          "**Limitations:** the Wilson 95% intervals above describe this "
          "selected 40-packet sample only. They do not account for AI-rating "
          "error, correlated judgments, aggregate-context exposure, or "
          "blinding limitations. These are selected-sample exploratory "
          "shares, not estimates for any wider population and not changes to "
          "the pre-registered primary results. Targeted simulation "
          "observations behind individual labels are not global correctness "
          "proofs, independent replication, or inter-rater agreement.", ""]

    text = "\n".join(L)
    lines = text.splitlines()
    if REQUIRED_HEADING not in lines:
        raise A22ReportError("rendered section lost the required heading")
    if REQUIRED_DISCLOSURE not in lines:
        raise A22ReportError("rendered section lost the required disclosure")
    for phrase in PROHIBITED_PHRASES:
        if phrase in text:
            raise A22ReportError(f"rendered section contains prohibited "
                                 f"phrase: {phrase!r}")
    if out_path is not None:
        _reject_forbidden_output(out_path)
        with open(out_path, "w", encoding="utf-8") as f:
            f.write(text)
    return text


# -------------------------------------------------------------------- CLI
def main(argv=None):
    ap = argparse.ArgumentParser(
        description="A22 exploratory AI blind-40 reporting renderer "
                    "(readiness only; default action is a read-only bundle "
                    "check)")
    ap.add_argument("--check", action="store_true",
                    help="read-only bundle check (default action)")
    ap.add_argument("--bundle-dir", default=BUNDLE_DIR,
                    help="directory holding labels.ai.csv, "
                         "labels.ai.provenance.json, protocol-deviation.md "
                         "(tests use a temporary copy)")
    ap.add_argument("--template", default="",
                    help="labels_template.csv path (default: bundle dir)")
    ap.add_argument("--render", default="",
                    help="render a section from an unblinded.json-schema "
                         "fixture (synthetic in readiness tests)")
    ap.add_argument("--out", default="",
                    help="explicit output file for the rendered section "
                         "(never the watched label path)")
    args = ap.parse_args(argv)

    kw = {"csv_path": os.path.join(args.bundle_dir, "labels.ai.csv"),
          "sidecar_path": os.path.join(args.bundle_dir,
                                       "labels.ai.provenance.json"),
          "protocol_path": os.path.join(args.bundle_dir,
                                        "protocol-deviation.md")}
    if args.template:
        kw["template_path"] = args.template
    else:
        kw["template_path"] = os.path.join(args.bundle_dir,
                                           "labels_template.csv")

    if args.render:
        try:
            text = render_result_section(args.render, out_path=args.out or None,
                                         **kw)
        except A22ReportError as e:
            print(f"A22 render REFUSED: {e}", file=sys.stderr)
            return 2
        if not args.out:
            print(text)
        return 0

    ok, problems = check_bundle(**kw)
    if ok:
        print("A22 bundle check: PASS (labels.ai.csv identity, template "
              "order, vocabulary, counts, sidecar binding, rating honesty, "
              "frozen-study flags, required heading/disclosure)")
        return 0
    print("A22 bundle check: FAIL", file=sys.stderr)
    for p in problems:
        print(f"  - {p}", file=sys.stderr)
    return 1


if __name__ == "__main__":
    sys.exit(main())
