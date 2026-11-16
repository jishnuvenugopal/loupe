#!/usr/bin/env python3
"""Draw the README figures as SVG, in a light and a dark version.

The results chart reads its numbers from results/main/stats.json, so the
figure cannot drift from the data. The other figures restate facts from
README.md, docs/how-it-works.md and docs/ai-workflow.md.

    python3 docs/img/make_figures.py           # write docs/img/*.svg
    python3 docs/img/make_figures.py --check   # exit 1 if a file is stale
"""
import json
import os
import sys
from xml.sax.saxutils import escape

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(os.path.dirname(HERE))

SANS = "-apple-system, BlinkMacSystemFont, 'Segoe UI', Helvetica, Arial, sans-serif"
MONO = "ui-monospace, SFMono-Regular, Menlo, Consolas, monospace"

THEMES = {
    "light": dict(bg="#fcfcfb", panel="#f3f2ee", line="#dcdad3", ink="#0b0b0b", ink2="#52514e",
                  muted="#8a8880", accent="#2a78d6", soft="#e3eefc", good="#0ca30c",
                  warn="#eda100", bad="#d03b3b", unk="#8a8880", outer="#86b6ef",
                  inner="#184f95", whisker="#0d366b"),
    "dark": dict(bg="#1a1a19", panel="#242422", line="#3a3a37", ink="#f0efec", ink2="#c3c2b7",
                 muted="#8f8e86", accent="#3987e5", soft="#1d2b3d", good="#0ca30c",
                 warn="#fab219", bad="#e66767", unk="#8f8e86", outer="#184f95",
                 inner="#86b6ef", whisker="#cde2fb"),
}


# ---------- small SVG helpers ----------

def svg(w, h, t, body, title, desc):
    return (f'<svg xmlns="http://www.w3.org/2000/svg" width="{w}" height="{h}" '
            f'viewBox="0 0 {w} {h}" role="img" aria-labelledby="t d">\n'
            f'<title id="t">{escape(title)}</title>\n<desc id="d">{escape(desc)}</desc>\n'
            f'<defs><marker id="arr" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="7" '
            f'markerHeight="7" orient="auto-start-reverse"><path d="M0,0 L10,5 L0,10 z" '
            f'fill="{t["ink2"]}"/></marker></defs>\n'
            f'<rect x="0.5" y="0.5" width="{w - 1}" height="{h - 1}" rx="14" fill="{t["bg"]}" '
            f'stroke="{t["line"]}"/>\n' + "\n".join(body) + "\n</svg>\n")


def text(x, y, s, t, size=13, weight=400, color="ink", anchor="start", mono=False):
    fam = MONO if mono else SANS
    return (f'<text x="{x}" y="{y}" font-family="{fam}" font-size="{size}" '
            f'font-weight="{weight}" fill="{t[color]}" text-anchor="{anchor}">{escape(s)}</text>')


def lines(x, y, rows, t, size=12.5, gap=17, color="ink2", anchor="start"):
    return [text(x, y + i * gap, r, t, size, 400, color, anchor) for i, r in enumerate(rows)]


def box(x, y, w, h, t, fill="panel", stroke="line", rx=10, sw=1):
    return (f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="{rx}" fill="{t[fill]}" '
            f'stroke="{t[stroke]}" stroke-width="{sw}"/>')


def arrow(d, t, dash=False):
    extra = ' stroke-dasharray="5 4"' if dash else ""
    return (f'<path d="{d}" fill="none" stroke="{t["ink2"]}" stroke-width="1.6"{extra} '
            f'marker-end="url(#arr)"/>')


def card(x, y, w, h, title, sub, t, mono_title=False):
    out = [box(x, y, w, h, t), text(x + 16, y + 28, title, t, 15, 650, mono=mono_title)]
    out += lines(x + 16, y + 50, sub, t)
    return out


# ---------- figure 1: pipeline ----------

def pipeline(t):
    W, H, cw, bh = 1000, 520, 290, 92
    xs = [30, 355, 680]
    ys = [86, 208, 330]
    b = [text(30, 38, "How Loupe scores one sample", t, 19, 700),
         text(30, 60, "Each official pass gets exactly one proof class from the frozen scorer "
              "(tag scorer-v1).", t, 13, 400, "ink2")]
    for x, head in zip(xs, ["1  GENERATE", "2  CHECK", "3  CLASSIFY AND COUNT"]):
        b.append(text(x, 80, head, t, 11.5, 700, "accent"))
    gen = [("Task text", ["RTLLM v2.1: 50 designs", "VerilogEval v2: 156 tasks"]),
           ("5 open-weight checkpoints", ["vLLM 0.21.0, one DGX Spark", "3 samples per task, fixed seeds"]),
           ("Extract the Verilog module", ["Gate G2: 95% or more of outputs", "must hold a usable module"])]
    chk = [("Official testbench", ["Icarus Verilog", "fail: not counted as a pass"]),
           ("Non-vacuity check", ["A flag, not a class:", "a vacuous pass keeps its class"]),
           ("Formal equivalence", ["Design vs reference, from reset", "Yosys + SymbiYosys: BMC, PDR, k-ind."])]
    for col, items in ((0, gen), (1, chk)):
        for i, (ti, sub) in enumerate(items):
            b += card(xs[col] + 0, ys[i] + 6, cw, bh, ti, sub, t)
        for i in range(2):
            x = xs[col] + cw / 2
            b.append(arrow(f"M{x},{ys[i] + 6 + bh} L{x},{ys[i + 1] + 4}", t))
    # column 1 -> column 2
    b.append(arrow(f"M{xs[0] + cw},{ys[2] + 52} C{xs[0] + cw + 20},{ys[2] + 52} "
                   f"{xs[1] - 20},{ys[0] + 52} {xs[1] - 2},{ys[0] + 52}", t))
    b.append(text(xs[1] + cw / 2 + 8, ys[1] - 6, "pass", t, 12, 600, "ink2"))
    # proof classes
    classes = [("UNBOUNDED-EQ", "Proved correct, for all time", "good", "✓"),
               ("BMC-N-EQ-ONLY", "Matches to depth d (10) only", "warn", "≈"),
               ("DIFFERENT", "Proved wrong, with a witness", "bad", "✗"),
               ("UNKNOWN", "Timeout (60 s) or engine error", "unk", "?")]
    cy, chh = 92, 56
    for i, (name, sub, col, icon) in enumerate(classes):
        y = cy + i * (chh + 10)
        b.append(box(xs[2], y, cw, chh, t))
        b.append(f'<rect x="{xs[2]}" y="{y}" width="8" height="{chh}" rx="4" fill="{t[col]}"/>')
        b.append(f'<circle cx="{xs[2] + 32}" cy="{y + chh / 2}" r="12" fill="none" '
                 f'stroke="{t[col]}" stroke-width="2"/>')
        b.append(text(xs[2] + 32, y + chh / 2 + 5, icon, t, 14, 700, "ink", "middle"))
        b.append(text(xs[2] + 56, y + 24, name, t, 13.5, 700, mono=True))
        b.append(text(xs[2] + 56, y + 43, sub, t, 12.5, 400, "ink2"))
    # column 2 -> classes
    b.append(arrow(f"M{xs[1] + cw},{ys[2] + 52} C{xs[1] + cw + 20},{ys[2] + 52} "
                   f"{xs[2] - 20},{cy + 129} {xs[2] - 2},{cy + 129}", t))
    sy = cy + 4 * (chh + 10) + 26
    b.append(arrow(f"M{xs[2] + cw / 2},{sy - 24} L{xs[2] + cw / 2},{sy - 2}", t))
    b += card(xs[2], sy, cw, 104, "Gated statistics",
              ["VerilogEval 144 tasks, RTLLM 37", "(headline 33): reference proved first", "Task-clustered bootstrap, 10,000 draws"], t)
    b.append(text(30, H - 22, "Not proved correct = official passes without UNBOUNDED-EQ (primary).  "
                  "Proved wrong = class DIFFERENT (the floor).", t, 12.5, 400, "ink2"))
    return svg(W, H, t, b, "How Loupe scores one sample",
               "Pipeline: task text, five checkpoints, module extraction, official testbench, "
               "non-vacuity check, formal equivalence with the reference from reset, then one of "
               "four proof classes and gated statistics.")


# ---------- figure 2: results chart (from data) ----------

ARMS = ["7b-rl", "7b-sft", "7b-base", "3b-rl", "3b-base"]


def results(t, stats):
    W, H = 1000, 500
    x0s, pw, lab = [30, 520], 450, 70
    vmax = 0.75
    rows_y, rh, bh = 132, 56, 18
    b = [text(30, 38, "Passes without a proof, by checkpoint", t, 19, 700),
         text(30, 60, "Share of official testbench passes. Same scale in both panels.", t, 13, 400, "ink2")]
    # legend
    lx, ly = 30, 84
    b.append(f'<rect x="{lx}" y="{ly - 11}" width="22" height="12" rx="3" fill="{t["outer"]}"/>')
    b.append(text(lx + 30, ly, "Not proved correct (primary)", t, 12.5, 400, "ink"))
    lx += 230
    b.append(f'<rect x="{lx}" y="{ly - 11}" width="22" height="12" rx="3" fill="{t["inner"]}"/>')
    b.append(text(lx + 30, ly, "Proved wrong, with a witness (the floor)", t, 12.5, 400, "ink"))
    lx += 300
    b.append(f'<path d="M{lx},{ly - 5} L{lx + 22},{ly - 5} M{lx},{ly - 10} L{lx},{ly} '
             f'M{lx + 22},{ly - 10} L{lx + 22},{ly}" stroke="{t["whisker"]}" stroke-width="1.6"/>')
    b.append(text(lx + 30, ly, "95% interval of the primary share", t, 12.5, 400, "ink"))
    for x0, bench, name, unit in ((x0s[0], "rtllm", "RTLLM v2.1", "headline designs"),
                                  (x0s[1], "ve", "VerilogEval v2", "gated tasks")):
        n = stats["arms"][ARMS[0]][bench]["point"]["tasks"]
        b.append(text(x0, 116, f"{name}  ({n} {unit})", t, 14, 700))
        sx0, sw = x0 + lab, pw - lab - 10
        sc = lambda v: sx0 + sw * v / vmax  # noqa: E731
        for g in (0, 0.25, 0.5, 0.75):
            gx = sc(g)
            b.append(f'<line x1="{gx}" y1="{rows_y - 8}" x2="{gx}" y2="{rows_y + rh * 5}" '
                     f'stroke="{t["line"]}" stroke-width="1"/>')
            b.append(text(gx, rows_y + rh * 5 + 18, f"{int(g * 100)}%", t, 11.5, 400, "muted", "middle"))
        for i, arm in enumerate(ARMS):
            a = stats["arms"][arm][bench]
            npc = a["point"]["not_proved_correct_share"]
            pwr = a["point"]["proved_wrong_share"]
            lo, hi = a["ci95"]["not_proved_correct_share"]
            y = rows_y + i * rh
            b.append(text(x0, y + 14, arm, t, 13, 600, mono=True))
            if npc > 0:
                b.append(f'<rect x="{sx0}" y="{y}" width="{max(sc(npc) - sx0, 2):.1f}" height="{bh}" '
                         f'rx="4" fill="{t["outer"]}"/>')
            if pwr > 0:
                b.append(f'<rect x="{sx0}" y="{y + 5}" width="{max(sc(pwr) - sx0, 2):.1f}" '
                         f'height="{bh - 10}" rx="3" fill="{t["inner"]}"/>')
            wy = y + bh + 5
            wd = (f"M{sc(lo):.1f},{wy} L{sc(hi):.1f},{wy} M{sc(lo):.1f},{wy - 4} "
                  f"L{sc(lo):.1f},{wy + 4} M{sc(hi):.1f},{wy - 4} L{sc(hi):.1f},{wy + 4}")
            b.append(f'<path d="{wd}" stroke="{t["whisker"]}" stroke-width="1.6" fill="none"/>')
            b.append(text(sx0, y + bh + 24, f"{100 * npc:.1f}%", t, 12, 700, "ink"))
            b.append(text(sx0 + 44, y + bh + 24, f"floor {100 * pwr:.1f}%", t, 12, 400, "ink2"))
    b.append(text(30, H - 22, "Source: results/main/stats.json (task-clustered bootstrap, 10,000 "
                  "resamples). Five checkpoints, three samples per task.", t, 12, 400, "muted"))
    return svg(W, H, t, b, "Passes without a proof, by checkpoint",
               "Bar chart. RTLLM: 27.5 to 36.0 percent of official passes are not proved correct; "
               "the proved-wrong floor is 20.0 to 33.3 percent. VerilogEval: at most 4.7 percent. "
               "The README tables hold every number with its interval.")


# ---------- figure 3: timeline ----------

def timeline(t):
    W, H = 1000, 380
    b = [text(30, 38, "The order of events", t, 19, 700),
         text(30, 60, "The plan and the scorer were frozen before the main data existed. "
              "All times UTC+08, 2026.", t, 13, 400, "ink2")]
    ev = [("18 Oct 14:41", "Scorer frozen", ["tag scorer-v1"], "accent"),
          ("19 Oct 10:41", "Plan frozen", ["tag g0-prereg; proof in", "Bitcoin block 972099"], "accent"),
          ("19 Oct 10:52", "Main generation", ["7.28 h on one DGX Spark;", "scorer after 18:09"], "ink2"),
          ("19–20 Oct", "Gate G2 stop", ["3B arms wait 29 h;", "amendment A19"], "warn"),
          ("21 Oct 02:50", "Primary results", ["tag phase10-results", "on the 12:28 commit"], "good"),
          ("21 Oct–11 Nov", "GRPO test", ["small, exploratory"], "muted"),
          ("13 Nov", "Blind 40 unblinded", ["AI labels: amendment", "A22, a deviation"], "muted")]
    ly, x1, x2 = 190, 100, 880
    b.append(f'<line x1="{x1 - 30}" y1="{ly}" x2="{x2 + 30}" y2="{ly}" stroke="{t["line"]}" stroke-width="3"/>')
    step = (x2 - x1) / (len(ev) - 1)
    for i, (when, what, sub, col) in enumerate(ev):
        x = x1 + i * step
        up = i % 2 == 0
        b.append(f'<line x1="{x}" y1="{ly}" x2="{x}" y2="{ly + (-26 if up else 26)}" '
                 f'stroke="{t["line"]}" stroke-width="1.5"/>')
        b.append(f'<circle cx="{x}" cy="{ly}" r="8" fill="{t["bg"]}" stroke="{t[col]}" stroke-width="3"/>')
        if up:
            base = ly - 34 - 17 * len(sub)
            b.append(text(x, base - 36, when, t, 12, 700, "accent", "middle"))
            b.append(text(x, base - 18, what, t, 14, 700, "ink", "middle"))
            b += lines(x, base, sub, t, 12, 16, "ink2", "middle")
        else:
            b.append(text(x, ly + 46, when, t, 12, 700, "accent", "middle"))
            b.append(text(x, ly + 64, what, t, 14, 700, "ink", "middle"))
            b += lines(x, ly + 82, sub, t, 12, 16, "ink2", "middle")
    b.append(text(30, H - 22, "Block header times can be off by about two hours: the proof is certain "
                  "for “before the scorer ran” and probable for “before generation”.",
                  t, 12, 400, "muted"))
    return svg(W, H, t, b, "The order of events",
               "Timeline: scorer frozen 18 Oct; plan frozen and timestamped in Bitcoin block 972099 "
               "on 19 Oct; main generation 19 Oct; gate G2 stop and amendment A19; primary results "
               "21 Oct; GRPO test to 11 Nov; blind 40 unblinded with AI labels on 13 Nov.")


# ---------- figure 4: the agent loop ----------

def loop(t):
    W, H, bw, bh = 1000, 470, 144, 92
    b = [text(30, 38, "How the work moved between me and the AI agents", t, 19, 700),
         text(30, 60, "An agent never moves past a gate on its own judgment.", t, 13, 400, "ink2")]
    lanes = [("ME (THE AUTHOR)", 82), ("AI AGENTS", 222)]
    for name, y in lanes:
        b.append(f'<rect x="20" y="{y}" width="960" height="122" rx="12" fill="{t["soft"]}"/>')
        b.append(text(34, y + 20, name, t, 11.5, 700, "accent"))
    xs = [36 + i * 156 for i in range(6)]
    steps = [(0, "1  Brief", ["Goal, pins, gates", "and stop rules"]),
             (1, "2  Work", ["Until the next gate", "(code, runs, reports)"]),
             (1, "3  Stop line", ["Write the evidence", "and wait"]),
             (0, "4  Decide", ["Read the evidence;", "approve or change"]),
             (1, "5  Amendment", ["Record it with a", "number (A13–A22)"]),
             (1, "6  Continue", ["From that point", "only"])]
    pos = []
    for i, (lane, ti, sub) in enumerate(steps):
        y = lanes[lane][1] + 26
        b += card(xs[i], y, bw, bh, ti, sub, t)
        pos.append((xs[i], y))
    for i in range(5):
        (ax, ay), (bx, by) = pos[i], pos[i + 1]
        if ay == by:
            b.append(arrow(f"M{ax + bw},{ay + bh / 2} L{bx - 2},{by + bh / 2}", t))
        elif ay < by:
            b.append(arrow(f"M{ax + bw},{ay + bh / 2} C{ax + bw + 20},{ay + bh / 2} "
                           f"{bx - 20},{by + bh / 2} {bx - 2},{by + bh / 2}", t))
        else:
            b.append(arrow(f"M{ax + bw},{ay + bh / 2} C{ax + bw + 20},{ay + bh / 2} "
                           f"{bx - 20},{by + bh / 2} {bx - 2},{by + bh / 2}", t))
    (sx, sy), (ex, ey) = pos[5], pos[1]
    yb = sy + bh + 16
    b.append(arrow(f"M{sx + bw / 2},{sy + bh} L{sx + bw / 2},{yb} L{ex + bw / 2},{yb} "
                   f"L{ex + bw / 2},{ey + bh + 2}", t, dash=True))
    b.append(text((sx + ex + bw) / 2, yb - 5, "next gate", t, 11.5, 600, "ink2", "middle"))
    gy = 372
    b += card(30, gy, 465, 72, "Review before the data",
              ["A second agent reviewed the plan: 12 problems, fixed as A17 and A18"], t)
    b += card(505, gy, 465, 72, "Recompute after the data",
              ["New code on a second machine: all 10 point estimates match"], t)
    return svg(W, H, t, b, "How the work moved between me and the AI agents",
               "Swimlane: I write a brief; an agent works until a gate, writes a stop line and "
               "waits; I decide; the agent records a numbered amendment and continues. Guards: "
               "plan review before the data and an independent recompute after it.")


def build():
    stats = json.load(open(os.path.join(ROOT, "results", "main", "stats.json")))
    out = {}
    for mode, t in THEMES.items():
        out[f"pipeline-{mode}.svg"] = pipeline(t)
        out[f"results-{mode}.svg"] = results(t, stats)
        out[f"timeline-{mode}.svg"] = timeline(t)
        out[f"agent-loop-{mode}.svg"] = loop(t)
    return out


def main():
    check = "--check" in sys.argv
    stale = []
    for name, body in build().items():
        path = os.path.join(HERE, name)
        if check:
            old = open(path, encoding="utf-8").read() if os.path.exists(path) else None
            if old != body:
                stale.append(name)
        else:
            with open(path, "w", encoding="utf-8") as f:
                f.write(body)
    if stale:
        print("stale figures (run docs/img/make_figures.py):", ", ".join(stale))
        sys.exit(1)
    print("figures OK" if check else "figures written")


if __name__ == "__main__":
    main()
