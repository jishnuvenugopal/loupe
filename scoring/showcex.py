import re, sys
"""Print a compact per-step table from a Yosys 'sat -show-ports' style log (inputs, gold/gate outputs)."""
log = open(sys.argv[1]).read()
rows = re.findall(r"^\s+(\d+|init)\s+\\(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s*$", log, re.M)
steps = {}
for t, name, dec, hx, b in rows:
    if t == "init": continue
    steps.setdefault(int(t), {})[name] = b
for t in sorted(steps):
    s = steps[t]
    ins = " ".join(f"{k[3:]}={v}" for k, v in sorted(s.items()) if k.startswith("in_"))
    outs = " ".join(f"{k[5:]}:{s[k]}/{s.get('gate_'+k[5:], '?')}" for k in sorted(s) if k.startswith("gold_"))
    print(f"{t:>2} trig={s.get('trigger','?')} | {ins} || gold/gate {outs}")
