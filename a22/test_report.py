#!/usr/bin/env python3
"""a22/test_report.py — A22 readiness tests (synthetic only).

All rendering consumes a synthetic unblinded.json-schema fixture built from
the adopted AI labels; all writes go to temporary directories. The real key
(~/runs/blind40_key.json) is never read — this file contains no key handling
at all. The watched label path results/main/blind40/labels.csv and the real
results/main/blind40/unblinded.json must remain absent, and
results/main/summary.md must remain byte-identical, before and after these
tests (asserted below).

Run: python3 a22/test_report.py -v
"""
import csv
import hashlib
import json
import math
import os
import shutil
import sys
import tempfile
import unittest

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import report  # noqa: E402

REPO = report.REPO
BUNDLE = report.BUNDLE_DIR
SUMMARY = os.path.join(REPO, "results", "main", "summary.md")
WATCHED_LABELS = os.path.join(BUNDLE, "labels.csv")
REAL_UNBLINDED = os.path.join(BUNDLE, "unblinded.json")

with open(SUMMARY, "rb") as _f:
    _SUMMARY_SHA_AT_START = hashlib.sha256(_f.read()).hexdigest()

BUNDLE_FILES = ("labels.ai.csv", "labels.ai.provenance.json",
                "protocol-deviation.md", "labels_template.csv")


def wilson95(k, n, z=1.96):
    """Test-local Wilson interval used ONLY to synthesize fixture numbers."""
    p = k / n
    d = 1 + z * z / n
    center = (p + z * z / (2 * n)) / d
    half = z * math.sqrt(p * (1 - p) / n + z * z / (4 * n * n)) / d
    return [max(0.0, center - half), min(1.0, center + half)]


def stat_cell(k, n):
    return {"count": k, "share": (k / n) if n else 0.0,
            "wilson95": wilson95(k, n)}


def read_adopted(path=None):
    path = path or os.path.join(BUNDLE, "labels.ai.csv")
    with open(path, encoding="utf-8") as f:
        rows = list(csv.reader(f))
    return rows[0], rows[1:]


def make_fixture(rows=None, n_override=None, drop_label=None,
                 overall_patch=None, family_patch=None, labels_override=None):
    """Synthetic unblinded.json fixture from the adopted labels."""
    _, data = read_adopted()
    if rows is not None:
        data = rows
    labs = [r[1] for r in data]
    fams = {}
    for i, r in enumerate(data):
        fams.setdefault("family-a" if i % 2 == 0 else "family-b",
                        []).append(r[1])
    overall = {lab: stat_cell(labs.count(lab), len(labs))
               for lab in report.LABELS}
    per_family = {}
    for fam, fl in fams.items():
        per_family[fam] = {lab: stat_cell(fl.count(lab), len(fl))
                           for lab in report.LABELS}
    unb = {"n": len(labs), "overall": overall, "per_family": per_family,
           "labels": list(report.LABELS)}
    if n_override is not None:
        unb["n"] = n_override
    if drop_label is not None:
        unb["overall"].pop(drop_label, None)
    if overall_patch:
        for k, v in overall_patch.items():
            unb["overall"][k] = v
    if family_patch:
        for fam, patch in family_patch.items():
            for k, v in patch.items():
                unb["per_family"][fam][k] = v
    if labels_override is not None:
        unb["labels"] = labels_override
    return unb


class TmpBundle:
    """Copy of the quarantined bundle (plus template) in a temp directory."""

    def __init__(self):
        self.dir = tempfile.mkdtemp(prefix="a22_bundle_")
        for f in BUNDLE_FILES:
            shutil.copy2(os.path.join(BUNDLE, f),
                         os.path.join(self.dir, f))
        self.csv = os.path.join(self.dir, "labels.ai.csv")
        self.sidecar = os.path.join(self.dir, "labels.ai.provenance.json")
        self.protocol = os.path.join(self.dir, "protocol-deviation.md")
        self.template = os.path.join(self.dir, "labels_template.csv")

    def write_csv(self, lines):
        with open(self.csv, "w", encoding="utf-8", newline="") as f:
            f.write("".join(lines))

    def rebind(self):
        """Re-bind sidecar hash/bytes/rows to the current CSV so only the
        intended structural check fails (used by mutation tests)."""
        with open(self.csv, "rb") as f:
            raw = f.read()
        with open(self.csv, encoding="utf-8") as f:
            nrows = len(list(csv.reader(f))) - 1
        with open(self.sidecar, encoding="utf-8") as f:
            side = json.load(f)
        side["labels"]["sha256"] = hashlib.sha256(raw).hexdigest()
        side["labels"]["bytes"] = len(raw)
        side["labels"]["rows"] = nrows
        with open(self.sidecar, "w", encoding="utf-8") as f:
            json.dump(side, f, indent=2, ensure_ascii=False)

    def patch_sidecar(self, fn):
        with open(self.sidecar, encoding="utf-8") as f:
            side = json.load(f)
        fn(side)
        with open(self.sidecar, "w", encoding="utf-8") as f:
            json.dump(side, f, indent=2, ensure_ascii=False)

    def check(self):
        return report.check_bundle(csv_path=self.csv, sidecar_path=self.sidecar,
                                   template_path=self.template,
                                   protocol_path=self.protocol)

    def cleanup(self):
        shutil.rmtree(self.dir, ignore_errors=True)


class A22BundleTests(unittest.TestCase):
    def test_valid_repo_bundle_passes(self):
        ok, problems = report.check_bundle()
        self.assertTrue(ok, problems)
        self.assertEqual(report.main([]), 0)

    def test_one_byte_csv_mutation_fails_hash(self):
        t = TmpBundle()
        try:
            with open(t.csv, "rb") as f:
                raw = bytearray(f.read())
            raw[10] = raw[10] ^ 0x20  # flip one byte inside the first id
            with open(t.csv, "wb") as f:
                f.write(bytes(raw))
            ok, problems = t.check()
            self.assertFalse(ok)
            self.assertTrue(any("sha256" in p for p in problems), problems)
        finally:
            t.cleanup()

    def _csv_lines(self, t):
        with open(t.csv, encoding="utf-8") as f:
            return [l + "\n" for l in f.read().splitlines()]

    def test_swapped_id_order_fails(self):
        t = TmpBundle()
        try:
            lines = self._csv_lines(t)
            lines[1], lines[2] = lines[2], lines[1]
            t.write_csv(lines)
            t.rebind()
            ok, problems = t.check()
            self.assertFalse(ok)
            self.assertTrue(any("labels_template.csv" in p for p in problems),
                            problems)
        finally:
            t.cleanup()

    def test_missing_id_fails(self):
        t = TmpBundle()
        try:
            lines = self._csv_lines(t)
            del lines[5]
            t.write_csv(lines)
            t.rebind()
            ok, problems = t.check()
            self.assertFalse(ok)
        finally:
            t.cleanup()

    def test_extra_id_fails(self):
        t = TmpBundle()
        try:
            lines = self._csv_lines(t)
            lines.append("b40_9999,unclear\n")
            t.write_csv(lines)
            t.rebind()
            ok, problems = t.check()
            self.assertFalse(ok)
            self.assertTrue(any("labels_template.csv" in p for p in problems),
                            problems)
        finally:
            t.cleanup()

    def test_blank_label_fails(self):
        t = TmpBundle()
        try:
            lines = self._csv_lines(t)
            lines[3] = lines[3].split(",")[0] + ",\n"
            t.write_csv(lines)
            t.rebind()
            ok, problems = t.check()
            self.assertFalse(ok)
            self.assertTrue(any("blank label" in p for p in problems),
                            problems)
        finally:
            t.cleanup()

    def test_unknown_label_fails(self):
        t = TmpBundle()
        try:
            lines = self._csv_lines(t)
            lines[3] = lines[3].split(",")[0] + ",super bug\n"
            t.write_csv(lines)
            t.rebind()
            ok, problems = t.check()
            self.assertFalse(ok)
            self.assertTrue(any("unknown label" in p for p in problems),
                            problems)
        finally:
            t.cleanup()

    def test_wrong_class_count_fails(self):
        t = TmpBundle()
        try:
            t.patch_sidecar(lambda s: s["labels"]["counts"].__setitem__(
                "real bug", 17))
            ok, problems = t.check()
            self.assertFalse(ok)
            self.assertTrue(any("sidecar count" in p for p in problems),
                            problems)
        finally:
            t.cleanup()

    def test_wrong_packet_revision_fails(self):
        t = TmpBundle()
        try:
            t.patch_sidecar(lambda s: s["sources"].__setitem__(
                "packet_revision", "deadbeef" * 5))
            ok, problems = t.check()
            self.assertFalse(ok)
            self.assertTrue(any("packet_revision" in p for p in problems),
                            problems)
        finally:
            t.cleanup()

    def test_sidecar_human_rater_fails(self):
        t = TmpBundle()
        try:
            t.patch_sidecar(lambda s: s["rating"].__setitem__("human_raters", 1))
            ok, problems = t.check()
            self.assertFalse(ok)
            self.assertTrue(any("human_raters" in p for p in problems),
                            problems)
        finally:
            t.cleanup()

    def test_sidecar_key_access_fails(self):
        t = TmpBundle()
        try:
            t.patch_sidecar(lambda s: s["rating"].__setitem__(
                "hidden_key_accessed_by_reviewer", True))
            ok, problems = t.check()
            self.assertFalse(ok)
            self.assertTrue(any("key access" in p for p in problems), problems)
        finally:
            t.cleanup()

    def test_sidecar_primary_results_changed_fails(self):
        t = TmpBundle()
        try:
            t.patch_sidecar(lambda s: s["reporting"].__setitem__(
                "primary_results_changed", True))
            ok, problems = t.check()
            self.assertFalse(ok)
            self.assertTrue(any("primary results" in p for p in problems),
                            problems)
        finally:
            t.cleanup()

    def test_sidecar_frozen_analysis_changed_fails(self):
        t = TmpBundle()
        try:
            t.patch_sidecar(lambda s: s["reporting"].__setitem__(
                "frozen_scoring_or_analysis_changed", True))
            ok, problems = t.check()
            self.assertFalse(ok)
            self.assertTrue(any("frozen scoring" in p for p in problems),
                            problems)
        finally:
            t.cleanup()

    def test_missing_sidecar_fails(self):
        t = TmpBundle()
        try:
            os.remove(t.sidecar)
            ok, problems = t.check()
            self.assertFalse(ok)
            self.assertTrue(any("missing provenance" in p for p in problems),
                            problems)
        finally:
            t.cleanup()

    def test_missing_required_disclosure_fails(self):
        t = TmpBundle()
        try:
            with open(t.protocol, encoding="utf-8") as f:
                lines = [l for l in f.read().splitlines()
                         if l != report.REQUIRED_DISCLOSURE]
            with open(t.protocol, "w", encoding="utf-8") as f:
                f.write("\n".join(lines))
            ok, problems = t.check()
            self.assertFalse(ok)
            self.assertTrue(any("disclosure" in p for p in problems), problems)
        finally:
            t.cleanup()

    def test_missing_required_heading_fails(self):
        t = TmpBundle()
        try:
            with open(t.protocol, encoding="utf-8") as f:
                lines = [l for l in f.read().splitlines()
                         if l != report.REQUIRED_HEADING]
            with open(t.protocol, "w", encoding="utf-8") as f:
                f.write("\n".join(lines))
            ok, problems = t.check()
            self.assertFalse(ok)
            self.assertTrue(any("heading" in p for p in problems), problems)
        finally:
            t.cleanup()


class A22RenderTests(unittest.TestCase):
    def render(self, unb, out=None, **kw):
        return report.render_result_section(unb, out_path=out, **kw)

    def test_valid_fixture_renders_required_content(self):
        text = self.render(make_fixture())
        lines = text.splitlines()
        self.assertIn(report.REQUIRED_HEADING, lines)
        self.assertIn(report.REQUIRED_DISCLOSURE, lines)
        for lab in report.LABELS:  # all five classes present as rows
            self.assertIn(f"| {lab} |", text)
        self.assertIn("| unclear | 5 |", text)          # overall unclear = 5
        self.assertIn("| scorer artefact | 0 |", text)  # zero class shown
        self.assertIn(report.ADOPTED_CSV_SHA256, text)
        self.assertIn(report.DECISION_ID, text)
        self.assertIn(report.MODEL_ID, text)
        self.assertIn("zero independent human raters", text)
        self.assertIn(report.PACKET_REVISION, text)
        self.assertIn(report.SIDECAR_RELPATH, text)
        self.assertIn("The five unclear labels were retained.", text)
        self.assertIn("selected 40-packet sample only", text)
        for phrase in ("AI-rating error", "correlated judgments",
                       "aggregate-context exposure", "blinding limitations",
                       "not global correctness proofs",
                       "independent replication", "inter-rater agreement"):
            self.assertIn(phrase, text)
        self.assertRegex(text, r"\[3[0-9]\.[0-9], [4-6][0-9]\.[0-9]\]")  # CI

    def test_render_from_path_and_explicit_out_in_tmp(self):
        with tempfile.TemporaryDirectory(prefix="a22_out_") as d:
            fx = os.path.join(d, "unblinded_fixture.json")
            with open(fx, "w", encoding="utf-8") as f:
                json.dump(make_fixture(), f)
            out = os.path.join(d, "section.md")
            text = self.render(fx, out=out)
            with open(out, encoding="utf-8") as f:
                self.assertEqual(text, f.read())
            self.assertEqual(report.main(
                ["--render", fx, "--out", out, "--bundle-dir", BUNDLE,
                 "--template", os.path.join(BUNDLE, "labels_template.csv")]),
                0)

    def test_prohibited_phrases_absent(self):
        text = self.render(make_fixture())
        for phrase in report.PROHIBITED_PHRASES:
            self.assertNotIn(phrase, text)
        self.assertNotIn("population estimate", text)

    def test_refuses_to_read_watched_or_real_paths(self):
        for p in (WATCHED_LABELS, REAL_UNBLINDED):
            with self.assertRaises(report.A22ReportError):
                self.render(p)

    def test_refuses_to_write_watched_names(self):
        with tempfile.TemporaryDirectory(prefix="a22_out_") as d:
            for name in ("labels.csv", "unblinded.json", "summary.md"):
                with self.assertRaises(report.A22ReportError):
                    self.render(make_fixture(), out=os.path.join(d, name))

    def test_rejects_malformed_fixtures(self):
        _, data = read_adopted()
        cases = {
            "not a dict": [1, 2, 3],
            "missing key": {"n": 40},
            "wrong n": make_fixture(n_override=39),
            "wrong vocabulary": make_fixture(labels_override=list(
                report.LABELS[:4])),
            "missing overall label": make_fixture(drop_label="unclear"),
            "sidecar count mismatch": make_fixture(overall_patch={
                "real bug": stat_cell(17, 40)}),
            "overall sum mismatch": make_fixture(overall_patch={
                "real bug": stat_cell(19, 40)}),
            "negative count": make_fixture(overall_patch={
                "real bug": {"count": -1, "share": 0.0,
                             "wilson95": [0.0, 0.1]}}),
            "non-integral count": make_fixture(overall_patch={
                "real bug": {"count": 18.5, "share": 0.45,
                             "wilson95": [0.3, 0.6]}}),
            "bool count": make_fixture(overall_patch={
                "real bug": {"count": True, "share": 0.45,
                             "wilson95": [0.3, 0.6]}}),
            "short wilson": make_fixture(overall_patch={
                "real bug": {"count": 18, "share": 0.45, "wilson95": [0.3]}}),
            "inverted wilson": make_fixture(overall_patch={
                "real bug": {"count": 18, "share": 0.45,
                             "wilson95": [0.6, 0.3]}}),
            "wilson below zero": make_fixture(overall_patch={
                "real bug": {"count": 18, "share": 0.45,
                             "wilson95": [-0.1, 0.3]}}),
            "share above one": make_fixture(overall_patch={
                "real bug": {"count": 18, "share": 1.2,
                             "wilson95": [0.3, 0.6]}}),
            "family sum mismatch": make_fixture(family_patch={
                "family-a": {"unclear": stat_cell(
                    make_fixture()["per_family"]["family-a"]["unclear"]
                    ["count"] + 1, 20)}}),
            "family missing label": (lambda u: (
                {**u, "per_family": {f: {k: v for k, v in cells.items()
                                         if k != "unclear"}
                                     for f, cells in u["per_family"].items()}}
            ))(make_fixture()),
        }
        for name, fixture in cases.items():
            with self.subTest(case=name):
                with self.assertRaises(report.A22ReportError):
                    self.render(fixture)
        # malformed JSON file also rejected
        with tempfile.TemporaryDirectory(prefix="a22_out_") as d:
            bad = os.path.join(d, "bad.json")
            with open(bad, "w") as f:
                f.write("{not json")
            with self.assertRaises(report.A22ReportError):
                self.render(bad)

    def test_render_fails_closed_on_invalid_bundle(self):
        t = TmpBundle()
        try:
            t.patch_sidecar(lambda s: s["rating"].__setitem__("human_raters", 1))
            with self.assertRaises(report.A22ReportError):
                self.render(make_fixture(), csv_path=t.csv,
                            sidecar_path=t.sidecar,
                            template_path=t.template,
                            protocol_path=t.protocol)
        finally:
            t.cleanup()

    def test_watched_paths_absent_and_summary_unchanged(self):
        self.assertFalse(os.path.exists(WATCHED_LABELS))
        self.assertFalse(os.path.exists(REAL_UNBLINDED))
        with open(SUMMARY, "rb") as f:
            sha_now = hashlib.sha256(f.read()).hexdigest()
        self.assertEqual(sha_now, _SUMMARY_SHA_AT_START)


if __name__ == "__main__":
    unittest.main(verbosity=2)
