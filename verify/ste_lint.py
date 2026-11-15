#!/usr/bin/env python3
"""Mechanical ASD-STE100 checks for the prose of a Markdown file.

Checks the text between each <!-- ste:begin --> and <!-- ste:end --> pair:
- sentence length: numbered steps (procedural) <= 20 words, other text <= 25
- sentences per paragraph <= 6
- words that end in -ing, other than a short allowlist and the words in the
  "Glossary of technical names" line
- common passive-voice patterns
- a short list of words that STE does not use

It does NOT check the ASD-STE100 dictionary (approved words and their single
meanings). That check needs the dictionary itself and a human reader.
Headings, tables, code blocks, HTML lines and link targets are not checked.

    python3 verify/ste_lint.py README.md
"""
import re
import sys

ING_OK = {"training", "during", "thing", "nothing", "something", "string", "bring", "anything"}
BANNED = {"thus", "hence", "via", "ensure", "utilize", "utilise", "leverage", "etc", "e.g.",
          "i.e.", "approximately", "whilst", "therefore"}
PASSIVE = re.compile(r"\b(is|are|was|were|be|been|being)\s+(\w+ed|made|done|shown|known|given|"
                     r"written|seen|found|taken|built|put|set|run|drawn|kept|told|left)\b", re.I)
PASSIVE_OK = {"is full", "are different"}


def sentences(text):
    text = re.sub(r"`[^`]*`", "CODE", text)
    parts = re.split(r"(?:(?<=[.!?])|(?<=[.!?][\")]))\s+(?=[A-Z0-9\"(*])", text.strip())
    return [p for p in parts if p.strip()]


def words(s):
    return [w for w in re.split(r"\s+", s.strip()) if re.search(r"\w", w)]


def clean(line):
    line = re.sub(r"!\[[^\]]*\]\([^)]*\)", "", line)           # images
    line = re.sub(r"\[([^\]]+)\]\([^)]*\)", r"\1", line)       # links -> text
    line = re.sub(r"<[^>]+>", "", line)                         # inline HTML
    return line.replace("**", "").replace("*", "")


def blocks_of(body):
    blocks, cur, kind, fence = [], [], None, False
    for raw in body.splitlines():
        st = raw.strip()
        if st.startswith("```"):
            fence = not fence
            if cur:
                blocks.append((kind, " ".join(cur)))
                cur = []
            continue
        if fence or not st or st.startswith(("#", "|", "<", "---")):
            if cur:
                blocks.append((kind, " ".join(cur)))
                cur = []
            continue
        st = clean(st.lstrip("> ").strip())
        if not st:
            continue
        if re.match(r"^\d+\.\s", st):
            if cur:
                blocks.append((kind, " ".join(cur)))
            cur, kind = [re.sub(r"^\d+\.\s", "", st)], "procedural"
            continue
        if st.startswith("- "):
            if cur:
                blocks.append((kind, " ".join(cur)))
            cur, kind = [st[2:]], "descriptive-list"
            continue
        if not cur:
            kind = "paragraph"
        cur.append(st)
    if cur:
        blocks.append((kind, " ".join(cur)))
    return blocks


def lint(path):
    src = open(path, encoding="utf-8").read()
    bodies = re.findall(r"<!-- ste:begin -->(.*?)<!-- ste:end -->", src, re.S)
    g = re.search(r"Glossary of technical names\s*\n+(.+?)\n\s*\n", src, re.S)
    glossary = {w.lower() for t in (g.group(1).split(",") if g else [])
                for w in re.findall(r"[A-Za-z]+", t)}
    issues, nsent = [], 0
    for body in bodies:
        for kind, text in blocks_of(body):
            ss = sentences(text)
            nsent += len(ss)
            if kind == "paragraph" and len(ss) > 6:
                issues.append(f"paragraph has {len(ss)} sentences (> 6): {text[:60]}...")
            limit = 20 if kind == "procedural" else 25
            for s in ss:
                n = len(words(s))
                if n > limit:
                    issues.append(f"{n} words > {limit} ({kind}): {s}")
                for w in re.findall(r"\b[A-Za-z]+ing\b", s):
                    if w.lower() not in ING_OK and w.lower() not in glossary:
                        issues.append(f"-ing form '{w}': {s}")
                low = s.lower()
                for b in BANNED:
                    if re.search(rf"(?<!\w){re.escape(b)}(?!\w)", low):
                        issues.append(f"non-STE word '{b}': {s}")
                for pm in PASSIVE.finditer(s):
                    if pm.group(0).lower() not in PASSIVE_OK:
                        issues.append(f"possible passive '{pm.group(0)}': {s}")
    return len(bodies), nsent, issues


if __name__ == "__main__":
    rc = 0
    for path in sys.argv[1:]:
        nb, n, issues = lint(path)
        print(f"{path}: {nb} STE sections, {n} sentences checked")
        for i in issues:
            print("  ISSUE:", i)
        print("  RESULT:", "PASS" if not issues else f"FAIL ({len(issues)} issues)")
        rc |= bool(issues) or nb == 0
    sys.exit(rc)
