#!/usr/bin/env python3
"""shakedown/report_status.py — every stop path of the A18 overnight chain
writes its status into SPARK_REPORT.md (replacing the trailing STOP line) and
spark_report.json, then the chain commits and pushes.

Usage: python3 shakedown/report_status.py --status "C3 failed: 7b-rl cap 5/16" \
          --stop 'STOP — C3 failed: 7b-rl cap hits 5/16' [--phase "7B shakedown"]
"""
import argparse
import json
import os
import re
import time

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
MD = os.path.join(REPO, "SPARK_REPORT.md")
JS = os.path.join(REPO, "spark_report.json")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--status", required=True)
    ap.add_argument("--stop", default="")
    ap.add_argument("--phase", default="A18 overnight chain")
    args = ap.parse_args()
    t = open(MD).read()
    t = re.sub(r"^Updated .*$", f"Updated {time.strftime('%d %b %Y, %H:%M')} UTC+08 "
               "(A18 overnight chain).", t, count=1, flags=re.M)
    entry = (f"- [{time.strftime('%H:%M')}] {args.phase}: {args.status}")
    m = re.search(r"(## 1\. Status\n\n)", t)
    if m:
        t = t[:m.end()] + entry + "\n" + t[m.end():]
    else:
        t += "\n" + entry + "\n"
    # replace the trailing STOP line (whatever it waits for now)
    t = re.sub(r"STOP — .+(\n)?$", "", t.rstrip() + "\n")
    if args.stop:
        t = t.rstrip() + "\n\n" + args.stop + "\n"
    open(MD, "w").write(t)
    try:
        j = json.load(open(JS))
    except Exception:
        j = {}
    ch = j.setdefault("chain", {})
    ch["last_update"] = time.strftime("%Y-%m-%d %H:%M:%S")
    ch["phase"] = args.phase
    ch["status"] = args.status
    ch["stop"] = args.stop or None
    json.dump(j, open(JS, "w"), indent=1)
    print(f"report updated: {args.status}")


if __name__ == "__main__":
    main()
