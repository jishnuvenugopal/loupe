#!/usr/bin/env python3
"""shakedown/prereg_finalize.py — A18 §8 C5: fill every remaining PREREG
placeholder with measured numbers, add the G0 sentence, and verify nothing is
left. Fails (exit 1) if a placeholder remains.

Placeholders filled (measured, nothing invented):
  - header date at G0
  - "Generation throughput, 7B lane: PENDING ..." -> per-arm steady + wall
    tok/s from results/shakedown/<arm>.json
  - Overlap probe PENDING -> skipped per A18 §8 C4 (score nothing until
    generation ends)
  - the cut applied (from results/shakedown/projection.json) + RTLLM n=5: no
  - Phase 4 exit-check deviation `<time>` -> actual 7B verification time
    (results/h0/weights_verified_at.txt, written by the chain at C2)
  - 7B chat-template provenance (from models.yaml: chat_template_sha256 +
    standalone chat_template.jinja presence)
  - G0 approval sentence (verbatim from A18 §8 C5)
Usage: python3 shakedown/prereg_finalize.py [--dry-run]
"""
import argparse
import glob
import json
import os
import re
import subprocess
import time

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
P = os.path.join(REPO, "PREREG.md")
G0_SENTENCE = ("G0: approved by the operator in advance on 18 Oct 2026, conditional "
               "on amendment A18 §8 C1–C5; each check is logged with its time in "
               "`notes/LOG.md`.")


def swap(text, old, new, count=1):
    if old not in text:
        return None
    return text.replace(old, new, count)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dry-run", action="store_true")
    args = ap.parse_args()
    t = open(P).read()
    errs = []

    def do(old, new):
        nonlocal t
        if new in t and old not in t:
            return  # idempotent resume: already finalized in an earlier run
        t2 = swap(t, old, new)
        if t2 is None:
            errs.append(f"placeholder not found: {old[:70]!r}")
        else:
            t = t2

    # header date (idempotent across minutes: skip if a real date is present)
    if re.search(r"Date: \d{4}-\d{2}-\d{2} \d{2}:\d{2}", t):
        pass
    else:
        do("Date: <date at G0>.", f"Date: {time.strftime('%Y-%m-%d %H:%M')} (G0 tag time).")

    # 7B generation numbers
    lines = []
    for arm in ("7b-rl", "7b-sft", "7b-base"):
        rp = os.path.join(REPO, f"results/shakedown/{arm}.json")
        if not os.path.isfile(rp):
            errs.append(f"missing shakedown report {rp}")
            continue
        d = json.load(open(rp))
        tp = d.get("throughput", {})
        cells = []
        for b in ("ve", "rtllm"):
            c = tp.get(b, {})
            steady = c.get("steady_tok_per_s")
            cells.append(f"{b} {steady if steady is not None else c.get('tok_per_s')}"
                         f"{'' if steady is not None else ' (wall)'} tok/s")
        lines.append(f"{arm} mean {d['completion_tokens']['mean']} tok / p95 "
                     f"{d['completion_tokens']['p95']} / cap {d['completion_tokens']['cap_hits']}"
                     f"/16; extraction+name {d['module_name_ok']}/16; "
                     + " ; ".join(cells)
                     + f"; official passes from finish_reason=length: "
                     f"{d.get('official_passes_from_length')}")
    do("- Generation throughput, 7B lane: **PENDING — weights still downloading at\n"
       "  18 Oct 20:00** (7B-Instruct ~2.7/15.2 GB; Distill ~0; RL 1/4 shards). The\n"
       "  overnight projection completes when the 7B shakedown runs; the projection\n"
       "  script is `shakedown/projection.py` (cut ladder coded).",
       "- Generation throughput, 7B lane (A18 §8 C3, steady-state split where\n"
       "  marked): " + " | ".join(lines) + ".")

    # 3B line: refresh with the steady-state split C4 used (was wall-inclusive)
    t3 = []
    for arm in ("3b-rl", "3b-base"):
        rp = os.path.join(REPO, f"results/shakedown/{arm}.json")
        d = json.load(open(rp)) if os.path.isfile(rp) else {}
        tp = d.get("throughput", {})
        t3.append(f"{arm} " + "/".join(
            str(tp.get(b, {}).get("steady_tok_per_s") or tp.get(b, {}).get("tok_per_s"))
            for b in ("ve", "rtllm")) + " tok/s")
    do("- Generation throughput, 3B lane (A16 settings, 64 concurrent, wall includes\n"
       "  model load): 3B-RL VE 167 / RTLLM 378 tok/s; 3B base VE 194 / RTLLM 316 tok/s\n"
       "  (`results/shakedown/{3b-rl,3b-base}.json`). 3B generation projection ≈ 1.3 h.",
       "- Generation throughput, 3B lane (A16 settings, 64 concurrent; A18 §8 C4\n"
       "  steady-state split, wall was load-inclusive at draft time): "
       + " ; ".join(t3) + " (VE/RTLLM; `results/shakedown/{3b-rl,3b-base}.json`).")

    # overlap probe
    do("- Overlap probe (A16 §3 step 7): PENDING — needs a 7B arm generating at 64\n"
       "  concurrent; decides only whether finished arms may be scored with WORKERS=8\n"
       "  during generation.",
       "- Overlap probe (A16 §3 step 7): **skipped** per A18 §8 C4 — nothing is\n"
       "  scored until generation ends (the A16 §5 step 4 default).")

    # cut record
    proj_p = os.path.join(REPO, "results/shakedown/projection.json")
    if os.path.isfile(proj_p):
        proj = json.load(open(proj_p))
        step = proj.get("cut_applied")
        total = proj["steps"][0]["total_h"] if proj.get("steps") else None
        after = next((s["total_h"] for s in proj.get("steps", [])
                      if s["step"] == step), None)
        cutline = (f"- **Cut applied (A18 §8 C4)**: `{step}` — steady-state projection "
                   f"{total:.2f} h → {after:.2f} h of the 9 h window; ladder order "
                   f"(VE seeded 60 → n 3→2 → drop 7B base → drop 3B base); RTLLM "
                   f"n = 5: **no**; overlap probe skipped (score nothing until "
                   f"generation ends). VE subset rule: `random.Random(0).sample("
                   f"sorted(ve_ids), 60)` pinned pre-G0 as `gen/ve_subset60.txt`.")
        anchor = "VE/RTLLM; `results/shakedown/{3b-rl,3b-base}.json`)."
        if cutline in t:
            t2 = t  # idempotent resume: cut record already present
        else:
            t2 = swap(t, anchor, anchor + "\n" + cutline)
        if t2 is None:
            errs.append("cut-record anchor not found")
        else:
            t = t2
    else:
        errs.append("missing results/shakedown/projection.json")

    # Phase 4 deviation time
    vt = os.path.join(REPO, "results/h0/weights_verified_at.txt")
    when = open(vt).read().strip() if os.path.isfile(vt) else "(missing)"
    t = re.sub(r"three 7B arms are verified by the watcher \(timestamp recorded at G0 from\n?\s*`~/runs/7b_watcher\.log`\)\.",
               f"three 7B arms are verified at **{when}** (`models/verify_weights.py`, "
               f"exit check 8 of 8; `results/h0/weights_verified_at.txt`).", t, count=1)
    if "7b_watcher.log" in t:
        errs.append("phase-4 verification-time placeholder not replaced")

    # 7B template provenance
    prov = []
    for arm, rid in (("7b-base", "Qwen--Qwen2.5-Coder-7B-Instruct"),
                     ("7b-sft", "zhuyaoyu--CodeV-R1-Distill-Qwen-7B"),
                     ("7b-rl", "zhuyaoyu--CodeV-R1-RL-Qwen-7B")):
        snaps = glob.glob(os.path.expanduser(f"~/hf/hub/models--{rid}/snapshots/*"))
        standalone = any(os.path.isfile(os.path.join(s, "chat_template.jinja")) for s in snaps)
        prov.append(f"{arm}: {'chat_template.jinja (standalone)' if standalone else 'embedded in tokenizer_config.json'}")
    do("the\n  three 7B arms' provenance is recorded at weight verification (downloads were\n  in flight at draft time).",
       "the\n  three 7B arms: " + "; ".join(prov) + " (recorded at weight verification).")

    # G0 sentence
    t2 = swap(t, "Date: ", G0_SENTENCE + "\nDate: ")
    if G0_SENTENCE not in t:
        t = t2 if t2 else t + "\n" + G0_SENTENCE + "\n"

    # remaining placeholders? (bare markdown autolinks like <https://...> are not
    # placeholders)
    left = [x for x in re.findall(r"<[a-z][^>\n]{3,40}>|\*\*PENDING[^*]*\*\*|`<time>`", t)
            if not x.startswith("<http") and x not in ("<think>",)]
    if left:
        errs.append("placeholders remain: " + ", ".join(sorted(set(left))[:10]))

    if errs:
        print("PREREG FINALIZE FAILED:")
        for e in errs:
            print("  -", e)
        return 1
    if args.dry_run:
        print("dry run OK — all placeholders resolvable; no write")
        return 0
    open(P, "w").write(t)
    print(f"PREREG finalized ({time.strftime('%Y-%m-%d %H:%M')})")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
