#!/usr/bin/env python3
"""A21: replace only the code section of the EXISTING blind-40 packets.

Default is preview. --apply requires the amended builder and original generation
hashes; never calls draw(), never writes the key/template/metadata or scores.
Only aggregate results are printed: no attribution or key contents.
"""
import argparse
import datetime
import hashlib
import importlib.util
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile

REPO = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(REPO / "a20"))
from audit_blind40_inputs import ARMS, SECTION, audit, digest

BUILDER_SHA = "acfe8185446c0636b835766574bd125992eb457935d8d7d0c43e29d700c85ad3"


def replace_code(text, code):
    sections = list(SECTION.finditer(text))
    if len(sections) != 1:
        raise ValueError("expected exactly one generated-code section")
    match = sections[0]
    return text[:match.start(1)] + code + text[match.end(1):]


def protected_fingerprint():
    """All tracked primary/sensitivity results, scores, manifests and old preregs."""
    names = subprocess.check_output([
        "git", "-C", str(REPO), "ls-files", "-z", "--", "scores", "results/main",
        "results/sens", "gen/manifests", "PREREG.md", "PREREG-A19.md", "PREREG-A20.md",
        "scorer", "deep", "grpo", "e1", "prompts", "models.yaml"])
    h, count = hashlib.sha256(), 0
    for name in sorted(names.decode().split("\0")):
        if not name or name.startswith("results/main/blind40/packet/"):
            continue
        path = REPO / name
        h.update(name.encode() + b"\0" + hashlib.sha256(path.read_bytes()).digest())
        count += 1
    return {"sha256": h.hexdigest(), "files": count}


def atomic_text(path, text):
    with tempfile.NamedTemporaryFile(mode="w", encoding="utf-8", dir=path.parent,
                                     prefix=".a21-", delete=False) as f:
        tmp = Path(f.name)
        f.write(text)
    try:
        os.chmod(tmp, path.stat().st_mode & 0o777)
        os.replace(tmp, path)
    finally:
        tmp.unlink(missing_ok=True)


def repair(apply=False):
    if digest((REPO / "scoring/blind40.py").read_bytes()) != BUILDER_SHA:
        raise RuntimeError("amended packet builder hash mismatch")
    before = audit()  # independent audit also verifies generation/key/template hashes
    if before["labels_file_present"] or not before["labels_template_blank"]:
        raise RuntimeError("labels already exist; stop for operator review before repair")
    root = REPO / "results/main/blind40"
    key_path = Path.home() / "runs/blind40_key.json"
    raw_key = key_path.read_bytes()
    if digest(raw_key) != (root / "KEY_SHA256").read_text().strip():
        raise RuntimeError("key hash mismatch")
    key = json.loads(raw_key)  # attribution remains in memory only
    spec = importlib.util.spec_from_file_location("blind40_a21_repair", REPO / "scoring/blind40.py")
    builder = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(builder)
    paths = []
    for arm in sorted(ARMS):
        manifest = json.loads((REPO / f"gen/manifests/{arm}.json").read_text())
        paths.extend(str(Path.home() / "runs/gen" / f["file"]) for f in manifest["files"])
    generations = builder.gen_rows(paths)
    from extract import extract_record
    protected_before = protected_fingerprint()
    planned, originals = {}, {}
    for pid, meta in key.items():
        path = root / "packet" / f"{pid}.md"
        text = path.read_text()
        baseline = subprocess.check_output([
            "git", "-C", str(REPO), "show", f"phase10-results:{path.relative_to(REPO)}"], text=True)
        if replace_code(text, "<CODE>") != replace_code(baseline, "<CODE>"):
            raise RuntimeError("non-code packet content differs from the original draw")
        row = generations[(meta["arm"], meta["bench"], meta["task"], meta["sample_idx"])]
        code = extract_record(row["completion"], row["bench"], row["task_id"])["code"].strip()
        candidate = replace_code(text, code or "// (no code extracted)")
        try:
            builder.scrub(candidate, "(identity withheld)")
        except SystemExit:
            raise RuntimeError("a proposed packet fails the frozen blindness scrub") from None
        if replace_code(candidate, "<CODE>") != replace_code(text, "<CODE>"):
            raise RuntimeError("repair would alter content outside the code section")
        if candidate != text:
            planned[path], originals[path] = candidate, text
    if apply:
        if (root / "labels.csv").exists() or key_path.read_bytes() != raw_key:
            raise RuntimeError("review state changed during preview; refusing repair")
        if protected_fingerprint() != protected_before:
            raise RuntimeError("protected artifacts changed during preview")
        try:
            for path, text in planned.items():
                atomic_text(path, text)
            after = audit()
            if not after["ok"]:
                raise RuntimeError("post-repair provenance audit failed")
            if protected_fingerprint() != protected_before or key_path.read_bytes() != raw_key:
                raise RuntimeError("protected artifacts changed during repair")
        except BaseException:
            for path, text in originals.items():
                atomic_text(path, text)
            raise
    else:
        after = None
    return {
        "checked_at": datetime.datetime.now().astimezone().isoformat(timespec="seconds"),
        "mode": "applied" if apply else "preview", "ok": True,
        "packets": len(key), "changed_or_planned": len(planned),
        "before_mismatches": before["code_mismatches_intended_sample"],
        "after_matches": after["code_matches_intended_sample"] if after else None,
        "after_mismatches": after["code_mismatches_intended_sample"] if after else None,
        "non_code_sections_match_original": True, "blindness_scrub_passed": len(key),
        "protected_before": protected_before, "protected_after": protected_fingerprint(),
        "key_bytes_unchanged": key_path.read_bytes() == raw_key,
        "draw_reexecuted": False, "mapping_disclosed": False,
        "builder_sha256": BUILDER_SHA,
    }


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--apply", action="store_true")
    args = ap.parse_args()
    print(json.dumps(repair(args.apply), indent=2))


if __name__ == "__main__":
    main()
