#!/usr/bin/env python3
"""Read-only audit of blind packet code against the original sample identities.

The blind key is hash-checked and used ONLY in memory. Output contains aggregate
counts, not packet identities, attribution, labels, key bytes or source code.
This does not redraw, repair, score, label or unblind the review sample.
"""
import argparse
import csv
import datetime
import hashlib
import json
from pathlib import Path
import re
import subprocess
import sys

REPO = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(REPO / "scoring"))
from extract import extract_record

ARMS = {"7b-rl", "7b-sft", "7b-base", "3b-rl", "3b-base"}
SECTION = re.compile(
    r"## 3\. Generated design under review \(extracted verbatim\)\n\n```verilog\n"
    r"(.*?)\n```\n\n## 4\.", re.S)


def digest(data):
    return hashlib.sha256(data).hexdigest()


def audit():
    root = REPO / "results/main/blind40"
    template = list(csv.DictReader((root / "labels_template.csv").open()))
    ids = [r["id"] for r in template]
    packets = list((root / "packet").glob("*.md"))
    assert len(ids) == len(set(ids)) == 40, "unexpected template IDs"
    assert {p.stem for p in packets} == set(ids), "packet/template IDs differ"
    raw_key = (Path.home() / "runs/blind40_key.json").read_bytes()
    assert digest(raw_key) == (root / "KEY_SHA256").read_text().strip(), "key hash mismatch"
    key = json.loads(raw_key)
    assert set(key) == set(ids), "key/template IDs differ"

    sources, verified_files = {}, 0
    for arm in sorted(ARMS):
        manifest = json.loads((REPO / f"gen/manifests/{arm}.json").read_text())
        assert manifest["arm"] == arm, "manifest arm mismatch"
        for info in manifest["files"]:
            data = (Path.home() / "runs/gen" / info["file"]).read_bytes()
            assert digest(data) == info["sha256"], "generation manifest hash mismatch"
            records = [json.loads(line) for line in data.splitlines()]
            assert len(records) == info["rows"], "generation row-count mismatch"
            for row in records:
                assert row["arm"] == arm, "generation arm mismatch"
                identity = (arm, row["bench"], row["task_id"], row["sample_idx"])
                assert identity not in sources, "duplicate generation identity"
                sources[identity] = row
            verified_files += 1
    assert verified_files == 10, "unexpected generation file set"

    matched = mismatched = malformed = 0
    for pid, info in key.items():
        text = (root / "packet" / f"{pid}.md").read_text()
        section = SECTION.search(text)
        if not section:
            malformed += 1
            continue
        row = sources[(info["arm"], info["bench"], info["task"], info["sample_idx"])]
        code = extract_record(row["completion"], row["bench"], row["task_id"])["code"].strip()
        expected = code or "// (no code extracted)"
        if section.group(1) == expected:
            matched += 1
        else:
            mismatched += 1

    p = subprocess.run(["git", "-C", str(REPO), "diff", "--quiet", "phase10-results", "--",
                        "results/main/blind40", "gen/manifests"], check=False)
    return {
        "checked_at": datetime.datetime.now().astimezone().isoformat(timespec="seconds"),
        "ok": mismatched == malformed == 0,
        "key_hash_ok": True,
        "packet_template_ids_match": True,
        "labels_template_blank": all(not r["label"] for r in template),
        "labels_file_present": (root / "labels.csv").exists(),
        "review_artifacts_unchanged_since_phase10": p.returncode == 0,
        "generation_manifest_files_verified": verified_files,
        "packets": len(key),
        "code_matches_intended_sample": matched,
        "code_mismatches_intended_sample": mismatched,
        "unreadable_code_sections": malformed,
        "mapping_disclosed": False,
        "review_artifacts_modified": [],
        "source_sha256": {name: digest((REPO / name).read_bytes()) for name in (
            "scoring/blind40.py", "scoring/extract.py", "a20/audit_blind40_inputs.py")},
    }


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--out", type=Path, help="optional aggregate evidence JSON (never the key)")
    args = ap.parse_args()
    result = audit()
    text = json.dumps(result, indent=2) + "\n"
    if args.out:
        protected = REPO / "results/main/blind40"
        dst = args.out.resolve()
        if dst.is_relative_to(protected) or dst == Path.home() / "runs/blind40_key.json":
            ap.error("audit output must not overwrite review artifacts or the key")
        dst.parent.mkdir(parents=True, exist_ok=True)
        dst.write_text(text)
    print(text, end="")
    return 0 if result["ok"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
