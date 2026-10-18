#!/usr/bin/env python3
"""Timed wrapper around scorer/score.py for Phase 6 step 5.

Runs score.py's logic in-process with deep.common.run monkeypatched to
classify elapsed time per EDA invocation:
  testbench : iverilog / vvp
  formal    : yosys (miter/sat/pdr/smtbmc scripts)
  synth+lint: yosys stat / verilator --lint-only
Writes <out>/timing.json next to score.py's own output record.
"""
import os
import sys
import time

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "deep"))
import common as C

_orig_run = C.run
ACCUM = {"testbench": 0.0, "formal": 0.0, "synth_lint": 0.0, "other": 0.0, "calls": 0}


def timed_run(cmd, cwd, timeout):
    t0 = time.monotonic()
    rc, out = _orig_run(cmd, cwd, timeout)
    dt = time.monotonic() - t0
    ACCUM["calls"] += 1
    b = os.path.basename(cmd[0]) if cmd else "?"
    if b in ("iverilog", "vvp") or b.startswith("vSim"):
        ACCUM["testbench"] += dt
    elif b == "verilator" or b == "verilator_bin":
        ACCUM["synth_lint"] += dt
    elif b == "sby":
        ACCUM["formal"] += dt
    elif b == "yosys":
        script = " ".join(cmd)
        if "stat" in script and "miter" not in script and "sat " not in script:
            ACCUM["synth_lint"] += dt
        else:
            ACCUM["formal"] += dt
    else:
        ACCUM["other"] += dt
    return rc, out


C.run = timed_run


def main():
    sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "scorer"))
    import score
    score.main()
    import json
    with open(os.path.join(sys.argv[-1], "timing.json"), "w") as f:
        json.dump(ACCUM, f)


if __name__ == "__main__":
    main()
