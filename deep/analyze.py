"""Assemble the deep-oracle report tables from runs 1-2 (+3 when present)."""
import os, re, json, collections, sys

BRIEF = os.path.expanduser("~/Downloads/pi/halo/spark-agent-brief.md")
REFS = os.path.expanduser("~/runs/deep/refs_summary.json")
GPT = os.path.expanduser("~/~/runs/deep/gpt_summary.json".replace("~//", "/"))
GPT = os.path.expanduser("~/runs/deep/gpt_summary.json")

def appendix_b():
    txt = open(BRIEF).read()
    m = re.search(r"## Appendix B:.*?```csv\n(.*?)```", txt, re.S)
    rows = []
    for line in m.group(1).strip().splitlines():
        f = line.split(",")
        if len(f) == 5 and f[0] in ("chatgpt4", "chatgpt35"):
            rows.append({"model": f[0], "trial": f[1], "design": f[2],
                         "tb": f[3], "equiv": f[4]})
    return rows

def main():
    refs = json.load(open(REFS))
    gpts = json.load(open(GPT))
    apb = appendix_b()
    print("=" * 72)
    print("RUN1 — self-equivalence of the 50 references, by proof class")
    print("=" * 72)
    cnt = collections.Counter(r.get("class") for r in refs)
    for k, v in sorted(cnt.items(), key=lambda x: -x[1]):
        print(f"  {str(k):20s} {v}")
    pdr_eq = [r["design"] for r in refs if r.get("pdr") == "equivalent"]
    ind_eq = [r["design"] for r in refs if r.get("tind") == "equivalent"]
    both = sorted(set(pdr_eq) & set(ind_eq))
    print(f"  unbounded proof from BOTH engines: {len(both)} designs")
    # pilot's 38 usable list
    m = re.search(r"## Appendix C:.*?\*\*RTLLM v2\.1: 38 usable designs\*\*\n\n(.*?)\n\n", open(BRIEF).read(), re.S)
    usable38 = set(re.findall(r"`(\w+)`", m.group(1)))
    print(f"  pilot usable set: {len(usable38)}")
    newly = sorted(set(pdr_eq) | set(ind_eq) - usable38)
    deep_eq = {r["design"] for r in refs if r.get("class") == "UNBOUNDED-EQ"}
    gained = sorted(deep_eq - usable38)
    lost = sorted(d for d in usable38 if next((r for r in refs if r["design"] == d), {}).get("class") not in ("UNBOUNDED-EQ",))
    print(f"  designs with unbounded proofs NOT in pilot's usable set (gained): {gained}")
    print(f"  pilot-usable designs without an unbounded proof here: {lost}")
    r12 = [r for r in refs if next((a for a in usable38 if a == r['design']), None)]
    print(f"  pilot-usable with unbounded proof now: {sum(1 for r in refs if r['design'] in usable38 and r.get('class')=='UNBOUNDED-EQ')}/38")

    print()
    print("=" * 72)
    print("RUN2 — anchor check vs Appendix B (290 GPT rows) + unbounded flips")
    print("=" * 72)
    apx = {(r["model"], r["trial"], r["design"]): r for r in apb}
    diff_tb, diff_eq, missing = [], [], []
    agg = collections.Counter()
    for g in gpts:
        key = (g["model"], g["trial"], g["design"])
        a = apx.get(key)
        if not a:
            missing.append(key); continue
        agg[(a["tb"], a["equiv"])] += 1
        if g.get("tb_icarus") != a["tb"]:
            diff_tb.append((key, a["tb"], g.get("tb_icarus")))
        mine = g.get("bmc")
        if a["tb"] == "pass":
            if (mine or "") != a["equiv"]:
                diff_eq.append((key, a["equiv"], mine, g.get("pdr"), g.get("tind")))
    print(f"  rows compared: {len(gpts) - len(missing)}, missing from appendix: {len(missing)}")
    print(f"  TB verdict diffs vs Appendix B: {len(diff_tb)}")
    for d in diff_tb[:10]: print("   ", d)
    print(f"  equiv verdict diffs vs Appendix B (bmc column): {len(diff_eq)}")
    for d in diff_eq[:10]: print("   ", d)
    tot = collections.Counter((g["model"]) for g in gpts)
    for model in ("chatgpt4", "chatgpt35"):
        rows = [g for g in gpts if g["model"] == model]
        tb_pass = sum(1 for g in rows if g.get("tb_icarus") == "pass")
        eq = sum(1 for g in rows if g.get("bmc") == "equivalent")
        di = sum(1 for g in rows if g.get("bmc") == "different")
        er = sum(1 for g in rows if g.get("tb_icarus") == "pass" and g.get("bmc") in ("error", "timeout", None))
        print(f"  {model}: tb pass {tb_pass}, bmc-equiv {eq}, bmc-diff {di}, bmc-err/tmo {er}")
    flips = [g for g in gpts if g.get("flip")]
    print(f"  FLIPS (bmc-equivalent at depth 10 -> unbounded engines say DIFFERENT): {len(flips)}")
    for g in flips:
        print(f"    {g['model']} {g['trial']} {g['design']}: pdr={g['pdr']} smt-ind={g['tind']}  cex: {g.get('pdr_dir')}")
    stuck = [g for g in gpts if g.get("bmc") == "equivalent" and g.get("class") != "UNBOUNDED-EQ"]
    print(f"  bmc-equivalent rows still lacking an unbounded witness: {len(stuck)}")
    for g in stuck[:20]:
        print(f"    {g['model']} {g['trial']} {g['design']}: pdr={g['pdr']} smt-ind={g['tind']}")
    # cross-simulator
    print()
    print("=" * 72)
    print("RUN2b — cross-simulator (Icarus vs Verilator) on the same 290 rows + 50 refs")
    print("=" * 72)
    cc = collections.Counter((r.get("tb_icarus"), r.get("tb_verilator")) for r in gpts)
    for k, v in sorted(cc.items(), key=lambda x: -x[1]):
        print(f"  icarus={str(k[0]):14s} verilator={str(k[1]):16s} {v}")
    dis = [r for r in gpts if r.get("tb_icarus") == "pass" and r.get("tb_verilator") == "fail"]
    print(f"  PASS(icarus) but FAIL(verilator): {len(dis)}  ->", [(r['model'], r['trial'], r['design']) for r in dis][:15])
    vp = sum(1 for r in gpts if r.get("tb_verilator") == "pass")
    print(f"  verilator-agreeing passes: {vp} / {sum(1 for r in gpts if r.get('tb_icarus')=='pass')} icarus passes")

if __name__ == "__main__":
    main()
