"""Read-only integrity/completeness checks for the unfrozen A20 recovery driver.

No scorer, training, generation, or analysis behavior is changed here.
"""
from collections import Counter
import hashlib
import json
from pathlib import Path
import re
import subprocess

ARMS = ("base", "w100", "s100", "wext", "sext")
BENCH_TASKS = {"ve": 144, "rtllm": 33}
# Explicitly documented supersessions; the stamped preregistrations stay intact.
SUPERSESSIONS = {
    "scoring/extract.py": "9f626ebc6808a0a140cbffbc3645bf9faaa003bfe605825c31edfb910b251b2a",
    "a20/supervisor.py": "0b7c6b348ccb924dfaf2dccd878975cd4fc37fdf665c3fc0ea3f98e8f4972c74",
}


def sha256(path):
    h = hashlib.sha256()
    with Path(path).open("rb") as f:
        for chunk in iter(lambda: f.read(1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest()


def freeze_check(repo):
    """Check all explicit file pins, the scorer tree and stamped document bytes."""
    repo = Path(repo)
    pins = {}
    for doc in ("PREREG.md", "PREREG-A19.md", "PREREG-A20.md"):
        text = (repo / doc).read_text()
        for name, digest in re.findall(
                r"`([^`\n]+)`\s*(?:—\s*|sha256\s*)?`([a-f0-9]{64})`", text):
            # Only file pins, not inline prose/gate abbreviations.
            if "/" in name:
                pins[name] = digest
    for line in (repo / "results/pilot_repro/SCORER_SHA256").read_text().splitlines():
        digest, name = line.split(maxsplit=1)
        pins[name] = digest
    pins.update(SUPERSESSIONS)
    records = []
    for name, expected in sorted(pins.items()):
        path = repo / name
        actual = sha256(path) if path.is_file() else None
        records.append({"path": name, "expected": expected, "actual": actual,
                        "ok": actual == expected})
    errors = [f"pin mismatch: {r['path']}" for r in records if not r["ok"]]
    for ref, paths in (("scorer-v1", ["scorer"]),
                       ("phase10-results", ["scoring", "deep", "tests"])):
        p = subprocess.run(["git", "-C", str(repo), "diff", "--quiet", ref, "--", *paths,
                            ":(exclude)scorer/__pycache__"])
        if p.returncode:
            errors.append(f"frozen tree differs from {ref}: {paths}")
    for doc, ref in (("PREREG.md", "g0-prereg"),
                     ("PREREG-A19.md", "phase10-results"),
                     ("PREREG-A20.md", "829db22")):
        p = subprocess.run(["git", "-C", str(repo), "show", f"{ref}:{doc}"],
                           capture_output=True, check=True)
        if p.stdout != (repo / doc).read_bytes():
            errors.append(f"stamped document differs: {doc}")
    return {"ok": not errors, "errors": errors, "pins": records}


def jsonl(path):
    with Path(path).open(encoding="utf-8") as f:
        return [json.loads(line) for line in f]


def expected_samples(repo):
    expected = {}
    for bench, count in BENCH_TASKS.items():
        rows = jsonl(Path(repo) / f"prompts/built_e1/verireason_gated_{bench}.jsonl")
        ids = [r["task_id"] for r in rows]
        if len(ids) != count or len(set(ids)) != count:
            raise ValueError(f"invalid frozen prompt task set: {bench}")
        for r in rows:
            seed = int(hashlib.sha256(r["task_id"].encode()).hexdigest()[:8], 16)
            for sample_idx in range(3):
                expected[(bench, r["task_id"], sample_idx)] = (r["prompt_sha256"], seed)
    return expected


def validate_rows(rows, expected, arm, *, scores=False, scorer_sha=None, scorer_commit=None):
    """Exact identities, not just counts: reject duplicates, extras and stale provenance."""
    errors, keys = [], []
    for row in rows:
        try:
            key = (row["bench"], row["task_id"], row["sample_idx"])
            if type(key[2]) is not int:
                raise ValueError("sample_idx must be an integer")
            hash(key)  # reject non-scalar identities before adding them to Counter
            keys.append(key)
            if key not in expected:
                errors.append(f"unexpected sample: {key}")
                continue
            prompt_sha, seed = expected[key]
            if row.get("arm") != f"e1-{arm}" or row.get("seed") != seed:
                errors.append(f"arm/seed mismatch: {key}")
            if scores:
                if row.get("scorer_sha256") != scorer_sha or row.get("scorer_commit") != scorer_commit:
                    errors.append(f"scorer provenance mismatch: {key}")
                if not all(k in row for k in ("tb", "vclass", "class", "verdict")):
                    errors.append(f"incomplete score record: {key}")
            elif row.get("prompt_sha256") != prompt_sha or not isinstance(row.get("completion"), str):
                errors.append(f"prompt/completion mismatch: {key}")
        except (KeyError, TypeError, ValueError) as e:
            errors.append(f"malformed record: {e}")
    counts = Counter(keys)
    missing = set(expected) - counts.keys()
    duplicates = sum(n - 1 for n in counts.values() if n > 1)
    if missing:
        errors.append(f"missing {len(missing)} sample identities")
    if duplicates:
        errors.append(f"{duplicates} duplicate sample identities")
    return {"ok": not errors, "rows": len(rows), "expected": len(expected),
            "missing": len(missing), "duplicates": duplicates, "errors": errors[:20]}


def e1_check(repo, runs, arms=ARMS):
    repo, runs = Path(repo), Path(runs)
    expected = expected_samples(repo)
    commit = subprocess.check_output(
        ["git", "-C", str(repo), "rev-parse", "scorer-v1^{commit}"], text=True).strip()
    scorer_sha = sha256(repo / "scorer/score.py")
    result = {"ok": True, "arms": {}}
    for arm in arms:
        files = {}
        for bench in BENCH_TASKS:
            files[bench] = (runs / f"gen_e1/e1-{arm}_{bench}.jsonl",
                            {k: v for k, v in expected.items() if k[0] == bench})
        files["scores"] = (repo / f"scores_e1/e1-{arm}.jsonl", expected)
        checks = {}
        for kind, (path, want) in files.items():
            try:
                checks[kind] = validate_rows(jsonl(path), want, arm, scores=kind == "scores",
                                             scorer_sha=scorer_sha, scorer_commit=commit)
            except (OSError, ValueError, TypeError) as e:
                checks[kind] = {"ok": False, "errors": [str(e)]}
            checks[kind]["path"] = str(path)
        checks["ok"] = all(c["ok"] for c in checks.values())
        result["arms"][arm] = checks
        result["ok"] &= checks["ok"]
    return result


def training_check(repo, runs, name="grpo_ext_S"):
    """Only accept a finished 300-step run with every B2 row and a verified adapter."""
    import csv
    repo, runs = Path(repo), Path(runs)
    errors = []
    try:
        with (repo / f"results/grpo/{name}.csv").open() as f:
            rows = list(csv.DictReader(f))
        steps = [int(r["step"]) for r in rows]
        if steps != list(range(10, 301, 10)):
            errors.append("B2 CSV must have steps 10..300 exactly once")
        metrics = json.loads((repo / f"results/grpo/{name}_metrics.json").read_text())
        if any(metrics.get(k) != v for k, v in {
                "run_name": name, "arm": "S", "mode": "strict", "steps": 300, "lr": 1e-5}.items()):
            errors.append("training metrics configuration mismatch")
        record = json.loads((repo / f"results/grpo/{name}_adapter.sha256.json").read_text())
        hashes = record["adapter_sha256"]
        if "adapter_model.safetensors" not in hashes:
            errors.append("no final adapter hash")
        for path, want in hashes.items():
            if sha256(runs / name / "final_adapter" / path) != want:
                errors.append(f"final adapter hash mismatch: {path}")
    except (OSError, ValueError, KeyError, TypeError) as e:
        errors.append(str(e))
    return {"ok": not errors, "errors": errors}
