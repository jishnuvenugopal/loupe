#!/usr/bin/env python3
"""Draw the README figures as SVG, in a light and a dark version.

The results chart, the summary card and the evidence chain read their numbers
from results/main/stats.json and results/main/blind40/unblinded.ai.json, so
those figures cannot drift from the data. The other figures restate facts from
README.md and the pages in docs/.

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


# ---------- helpers for figures 5 to 9 ----------

def lane(y, h, name, t):
    return [f'<rect x="20" y="{y}" width="960" height="{h}" rx="12" fill="{t["soft"]}"/>',
            text(34, y + 20, name, t, 11.5, 700, "accent")]


def mini(x, y, w, title, sub, t, mono_sub=False):
    return [box(x, y, w, 50, t), text(x + 12, y + 21, title, t, 13, 650),
            text(x + 12, y + 38, sub, t, 11 if mono_sub else 11.5, 400, "ink2", mono=mono_sub)]


def row_of(cards, y, t, mono_sub=False):
    n = len(cards)
    cw = (930 - 10 * (n - 1)) // n
    x0 = 20 + (960 - n * cw - 10 * (n - 1)) / 2
    out = []
    for i, (ti, sub) in enumerate(cards):
        out += mini(x0 + i * (cw + 10), y, cw, ti, sub, t, mono_sub)
    return out



def lens(cx, cy, r, t, sw=2.4):
    k = r * 0.72
    return [f'<circle cx="{cx}" cy="{cy}" r="{r}" fill="none" stroke="{t["accent"]}" stroke-width="{sw}"/>',
            f'<path d="M{cx + k:.1f},{cy + k:.1f} L{cx + k + r * 0.8:.1f},{cy + k + r * 0.8:.1f}" '
            f'stroke="{t["accent"]}" stroke-width="{sw + 0.6:.1f}" stroke-linecap="round"/>']


# ---------- figure 5: the summary card (from data) ----------

def overview(t, stats, blind, tasks):
    # The type is large on purpose: this card must stay readable at phone width.
    W, H = 1000, 640
    pct = lambda v: f"{100 * v:.1f}%"  # noqa: E731
    rt = [stats["arms"][a]["rtllm"]["point"] for a in ARMS]
    ve = [stats["arms"][a]["ve"]["point"] for a in ARMS]
    npc = [p["not_proved_correct_share"] for p in rt]
    floor = [p["proved_wrong_share"] for p in rt]
    ve_npc = max(p["not_proved_correct_share"] for p in ve)
    ve_floor = max(p["proved_wrong_share"] for p in ve)
    bugs, n = blind["overall"]["real bug"]["count"], blind["n"]
    b = lens(57, 50, 11, t, 3)
    b += [text(86, 59, "LOUPE", t, 22, 700, "accent"),
          text(44, 118, "A test says “pass”.", t, 44, 700),
          text(44, 170, "Is the design proved correct?", t, 44, 700)]
    steps = [f"Five AI models write chip designs for {tasks} tasks.",
             "The benchmark test gives each design a pass or a fail.",
             "For each pass, formal tools look for a proof."]
    sy = 222
    b.append(f'<line x1="62" y1="{sy}" x2="62" y2="{sy + 96}" stroke="{t["line"]}" stroke-width="3"/>')
    for i, s in enumerate(steps):
        y = sy + i * 48
        b.append(f'<circle cx="62" cy="{y}" r="17" fill="{t["bg"]}" stroke="{t["accent"]}" '
                 f'stroke-width="2.5"/>')
        b.append(text(62, y + 7, str(i + 1), t, 20, 700, "ink", "middle"))
        b.append(text(98, y + 10, s, t, 28, 400))

    def row(y, col, big, l1, l2):
        return [box(44, y, 912, 92, t),
                f'<rect x="44" y="{y}" width="10" height="92" rx="5" fill="{t[col]}"/>',
                text(76, y + 62, big, t, 46, 700),
                text(452, y + 40, l1, t, 27, 650),
                text(452, y + 74, l2, t, 26, 400, "ink2")]

    b += row(352, "bad", f"{pct(min(npc))} to {pct(max(npc))}", "of RTLLM passes have no proof",
             f"Floor: {pct(min(floor))} to {pct(max(floor))} have a witness")
    b += row(456, "good", f"at most {pct(ve_npc)}", "of VerilogEval passes have no proof",
             f"Floor: at most {pct(ve_floor)} have a witness")
    b.append(text(44, 586, "A difference from the reference is not always a bug:", t, 26, 400, "ink2"))
    b.append(text(44, 618, f"an exploratory AI review of {n} cases found {bugs} real bugs.",
                  t, 26, 400, "ink2"))
    return svg(W, H, t, b, "Loupe in one picture",
               f"Summary card. Five AI models write chip designs for {tasks} tasks. The benchmark "
               "test gives each design a pass or a fail. For each pass, formal tools look for a "
               "proof. "
               f"On RTLLM, {pct(min(npc))} to {pct(max(npc))} of the passes have no proof, and "
               f"{pct(min(floor))} to {pct(max(floor))} have a witness. On VerilogEval, at most "
               f"{pct(ve_npc)} of the passes have no proof, and at most {pct(ve_floor)} have a "
               f"witness. An exploratory AI review of {n} cases found {bugs} real bugs.")


# ---------- figure 6: the system in layers ----------

def architecture(t):
    W, bh, gap, y0 = 1000, 86, 32, 78
    b = [text(30, 38, "The system in one picture", t, 19, 700),
         text(30, 60, "People decide, agents work, tools give evidence, git keeps the record, "
              "checks read the record.", t, 13, 400, "ink2")]
    layers = [
        ("THE AUTHOR", False,
         [("Question and rules", "what to measure, what counts"),
          ("Brief for each session", "goal, pins, gates, stop rules"),
          ("Decision at each gate", "approve, change or stop"),
          ("Numbered amendments", "A13 to A22, each with a reason")]),
        ("AI AGENT SESSIONS", False,
         [("On the DGX Spark", "scorer, generation, statistics, reports"),
          ("On the Mac", "briefs, plan review, recompute, write-up"),
          ("One review session", "labels for the blind sample of 40")]),
        ("TOOLS", False,
         [("vLLM", "runs the five checkpoints"),
          ("Icarus, Verilator", "simulate the testbench"),
          ("Yosys, SymbiYosys", "prove, or find a witness"),
          ("TRL (GRPO)", "the small training test"),
          ("OpenTimestamps", "dates the frozen plan")]),
        ("THE RECORD IN GIT", True,
         [("Plan and proofs", "PREREG*.md + .ots"),
          ("Pinned inputs", "prompts/, models.yaml"),
          ("Per-sample scores", "scores/*.jsonl"),
          ("Tables and witnesses", "results/"),
          ("Log and receipts", "notes/, HANDOFF.md")]),
        ("CHECKS", False,
         [("Scorer hash", "before each scorer run"),
          ("Gates", "a stop line at each one"),
          ("Plan review", "before the data existed"),
          ("Recompute", "second machine, new code"),
          ("CI on each push", "numbers, figures, tests")]),
    ]
    ys = [y0 + i * (bh + gap) for i in range(len(layers))]
    for y, (name, mono, cards) in zip(ys, layers):
        b += lane(y, bh, name, t)
        b += row_of(cards, y + 28, t, mono)

    def link(x, ya, yb, label):
        return [arrow(f"M{x},{ya} L{x},{yb}", t),
                text(x + 10, (ya + yb) / 2 + 4, label, t, 11.5, 600, "ink2")]

    b += link(330, ys[0] + bh + 4, ys[1] - 3, "brief, decisions")
    b += link(620, ys[1] - 4, ys[0] + bh + 3, "stop line, evidence")
    b += link(480, ys[1] + bh + 4, ys[2] - 3, "run the tools")
    b += link(480, ys[2] + bh + 4, ys[3] - 3, "write files, commit")
    b += link(480, ys[4] - 4, ys[3] + bh + 3, "read and compare")
    return svg(W, ys[-1] + bh + 24, t, b, "The system in one picture",
               "Five layers. The author gives a question, a brief for each session, a decision at "
               "each gate and numbered amendments. AI agent sessions on a DGX Spark and on a Mac do "
               "the work. They run vLLM, Icarus, Verilator, Yosys, SymbiYosys, TRL and "
               "OpenTimestamps. The record in git holds the plan and proofs, pinned inputs, "
               "per-sample scores, tables, witnesses, the log and receipts. The checks read the "
               "record: scorer hash, gates, plan review, recompute and CI.")


# ---------- figure 7: the evidence chain ----------

def evidence(t, stats):
    W, y0, rh, gap = 1000, 98, 60, 20
    a = stats["arms"]["7b-rl"]["rtllm"]
    lo, hi = a["ci95"]["not_proved_correct_share"]
    ex = f"{100 * a['point']['not_proved_correct_share']:.1f} [{100 * lo:.1f}, {100 * hi:.1f}]"
    b = [text(30, 38, "From a number on this page back to the raw data", t, 19, 700),
         text(30, 60, "Each step is a file in this repository, and each step has a check.",
              t, 13, 400, "ink2"),
         text(30, 88, "THE CHAIN", t, 11.5, 700, "accent"),
         text(470, 88, "THE CHECK ON THAT STEP", t, 11.5, 700, "accent")]
    rows = [("A number on this page", f"README.md, for example {ex}",
             "CI compares every table number with the data files", "verify/check.py, on each push"),
            ("The statistics", "results/main/stats.json",
             "New code recomputes every point estimate from the scores", "verify/recompute.py"),
            ("One row per sample", "scores/<arm>.jsonl",
             "Each row names the scorer commit and the scorer hash", "scorer/, frozen at tag scorer-v1"),
            ("The generated designs", "results/main/releases/*.tar.gz",
             "A manifest holds the hash of each output file", "gen/manifests/"),
            ("The pinned inputs", "prompts/, models.yaml, benchmark commits",
             "The frozen plan names the pins and has a timestamp", "PREREG.md + PREREG.md.ots")]
    for i, (ti, path, chk, where) in enumerate(rows):
        y = y0 + i * (rh + gap)
        b.append(box(30, y, 400, rh, t))
        b.append(f'<circle cx="58" cy="{y + rh / 2}" r="13" fill="none" stroke="{t["accent"]}" '
                 f'stroke-width="2"/>')
        b.append(text(58, y + rh / 2 + 5, str(i + 1), t, 13, 700, "ink", "middle"))
        b.append(text(84, y + 26, ti, t, 14.5, 650))
        b.append(text(84, y + 46, path, t, 11.5, 400, "ink2", mono=True))
        b.append(f'<line x1="431" y1="{y + rh / 2}" x2="469" y2="{y + rh / 2}" stroke="{t["muted"]}" '
                 f'stroke-width="1.6" stroke-dasharray="4 4"/>')
        b.append(box(470, y, 500, rh, t))
        b.append(f'<rect x="470" y="{y}" width="8" height="{rh}" rx="4" fill="{t["good"]}"/>')
        b.append(text(494, y + 26, chk, t, 13.5, 600))
        b.append(text(494, y + 46, where, t, 11.5, 400, "ink2", mono=True))
        if i < len(rows) - 1:
            b.append(arrow(f"M230,{y + rh + 2} L230,{y + rh + gap - 2}", t))
    b.append(text(242, y0 + rh + gap / 2 + 4, "comes from", t, 11.5, 600, "ink2"))
    wy = y0 + len(rows) * (rh + gap) + 2
    b.append(box(30, wy, 940, 66, t))
    b.append(f'<rect x="30" y="{wy}" width="8" height="66" rx="4" fill="{t["bad"]}"/>')
    b.append(text(54, wy + 27, "A proved-wrong pass has one more link: the witness", t, 14.5, 650))
    b.append(text(54, wy + 48, "results/main/cex/ holds the input trace. Replay it, and the design "
                  "and the reference give different outputs.", t, 12.5, 400, "ink2"))
    return svg(W, wy + 66 + 26, t, b, "From a number on this page back to the raw data",
               "Chain of five steps, each with a check. A number in the README comes from the "
               "statistics file; CI compares every table number with the data. The statistics come "
               "from one row per sample; new code recomputes every point estimate. Each row names "
               "the scorer commit and hash. The generated designs have a manifest with hashes. The "
               "pinned inputs are in the frozen plan, which has a timestamp. Each proved-wrong pass "
               "also has a witness trace.")


# ---------- figure 8: one agent session ----------

def session(t):
    W, y0, ch, g = 1000, 98, 70, 12
    b = [text(30, 38, "One agent session: what goes in, what comes out, what stops it", t, 19, 700),
         text(30, 60, "Each session starts from written files, and it must leave written files.",
              t, 13, 400, "ink2")]
    for x, name in ((30, "IN: THE CONTEXT"), (360, "THE SESSION"), (690, "OUT: THE RECORD")):
        b.append(text(x, 88, name, t, 11.5, 700, "accent"))
    ins = [("The brief", ["goal, pins, gates, stop rules"]),
           ("The frozen plan", ["PREREG.md and its amendments"]),
           ("The record so far", ["HANDOFF.md, notes/LOG.md"])]
    outs = [("Commits on the run branch", ["code, results, reports"]),
            ("Structured results", ["JSONL scores, JSON results, receipts"]),
            ("Stop line and handoff note", ["what happened, what needs a decision"])]
    for i in range(3):
        y = y0 + i * (ch + g)
        b += card(30, y, 280, ch, ins[i][0], ins[i][1], t)
        b += card(690, y, 280, ch, outs[i][0], outs[i][1], t)
        b.append(arrow(f"M312,{y + ch / 2} L357,{y + ch / 2}", t))
        b.append(arrow(f"M642,{y + ch / 2} L687,{y + ch / 2}", t))
    sh = 3 * ch + 2 * g
    b.append(box(360, y0, 280, sh, t, "soft", "accent", 12, 1.5))
    b.append(text(380, y0 + 32, "AI agent session", t, 16, 700))
    work = ["1   Reads the context", "2   Writes code and runs the tools",
            "3   Checks each exit condition", "4   Writes the results and a report"]
    b += lines(380, y0 + 62, work, t, 13.5, 24, "ink")
    b.append(f'<line x1="380" y1="{y0 + 154}" x2="620" y2="{y0 + 154}" stroke="{t["line"]}" '
             f'stroke-width="1"/>')
    b.append(text(380, y0 + 176, "TOOLS", t, 11, 700, "muted"))
    b += lines(380, y0 + 196, ["shell, git, vLLM, TRL", "Icarus, Verilator, Yosys, SymbiYosys"],
               t, 12.5, 18, "ink2")
    ly = y0 + sh + 24
    b += lane(ly, 88, "WHAT STOPS OR WATCHES A SESSION", t)
    b += row_of([("A gate", "stop line, then wait"),
                 ("A hash check", "frozen scorer, same hash"),
                 ("A sample count", "every sample must exist"),
                 ("A retry limit", "unattended run: 2 restarts"),
                 ("A heartbeat", "unattended run: every 6 h")], ly + 28, t)
    return svg(W, ly + 88 + 24, t, b, "One agent session",
               "An AI agent session receives the brief, the frozen plan and the record so far. It "
               "reads the context, writes code, runs the tools, checks each exit condition and "
               "writes results and a report. It leaves commits, structured results, a stop line "
               "and a handoff note. A gate, a hash check, a sample count, a retry limit and a "
               "heartbeat stop or watch the session.")


# ---------- figure 9: the picture for the five-year-old ----------

SEEN = {(1, 2), (3, 7), (5, 4), (6, 8), (8, 1)}     # the five sums that the teacher checks
WRONG = {(2, 5), (4, 1), (7, 6)}                    # wrong sums; the teacher checks none of them
STAR = [(0, -20), (4.9, -6.8), (19, -6.2), (8, 2.6), (11.8, 16.2), (0, 8.4), (-11.8, 16.2),
        (-8, 2.6), (-19, -6.2), (-4.9, -6.8)]


def page(x0, y0, all_sums, t):
    out, ticks, crosses = [], [], []
    for r in range(10):
        for c in range(10):
            x, y = x0 + c * 24, y0 + r * 24
            if (r, c) in WRONG and all_sums:
                out.append(f'<rect x="{x}" y="{y}" width="20" height="20" rx="4" fill="{t["bad"]}"/>')
                crosses.append(f"M{x + 6},{y + 6} L{x + 14},{y + 14} M{x + 14},{y + 6} L{x + 6},{y + 14}")
            elif (r, c) in WRONG:
                out.append(f'<rect x="{x}" y="{y}" width="20" height="20" rx="4" fill="{t["bad"]}" '
                           f'fill-opacity="0.25" stroke="{t["line"]}"/>')
            elif all_sums or (r, c) in SEEN:
                out.append(f'<rect x="{x}" y="{y}" width="20" height="20" rx="4" fill="{t["bg"]}" '
                           f'stroke="{t["good"]}" stroke-width="1.6"/>')
                ticks.append(f"M{x + 5},{y + 10} L{x + 9},{y + 14} L{x + 15},{y + 6}")
            else:
                out.append(f'<rect x="{x}" y="{y}" width="20" height="20" rx="4" fill="{t["bg"]}" '
                           f'stroke="{t["line"]}"/>')
    out.append(f'<path d="{" ".join(ticks)}" fill="none" stroke="{t["good"]}" stroke-width="2" '
               f'stroke-linecap="round" stroke-linejoin="round"/>')
    if crosses:
        out.append(f'<path d="{" ".join(crosses)}" fill="none" stroke="{t["bg"]}" stroke-width="2.2" '
                   f'stroke-linecap="round"/>')
    return out


def key(x, y, kind, s, t):
    fill = {"ok": t["bg"], "miss": t["bad"], "bad": t["bad"], "none": t["bg"]}[kind]
    stroke = {"ok": t["good"], "miss": t["line"], "bad": t["bad"], "none": t["line"]}[kind]
    op = ' fill-opacity="0.25"' if kind == "miss" else ""
    return [f'<rect x="{x}" y="{y - 12}" width="14" height="14" rx="3" fill="{fill}"{op} '
            f'stroke="{stroke}" stroke-width="1.4"/>', text(x + 24, y, s, t, 12.5, 400, "ink2")]


def eli5(t):
    W, H = 1000, 424
    b = [text(30, 38, "A gold star is not a proof", t, 19, 700),
         text(30, 60, "The same page of 100 sums, with two ways to check it.", t, 13, 400, "ink2")]
    for x, name in ((30, "THE BENCHMARK TEST: CHECKS A FEW SUMS"), (508, "LOUPE: CHECKS EVERY SUM")):
        b.append(box(x, 78, 462, 300, t))
        b.append(text(x + 22, 104, name, t, 11.5, 700, "accent"))
    b += page(52, 120, False, t)
    b += page(530, 120, True, t)
    pts = " ".join(f"{334 + dx:.1f},{146 + dy:.1f}" for dx, dy in STAR)
    b.append(f'<polygon points="{pts}" fill="{t["warn"]}"/>')
    b.append(text(364, 143, "Gold star", t, 16, 700))
    b.append(text(364, 161, "the test says pass", t, 12.5, 400, "ink2"))
    b += key(316, 204, "ok", "5 sums checked", t)
    b += key(316, 230, "none", "92 sums not checked", t)
    b += key(316, 256, "miss", "3 wrong sums, not seen", t)
    b += lens(806, 140, 13, t, 3)
    b.append(text(842, 143, "No gold star", t, 16, 700))
    b.append(text(842, 161, "proof, or a witness", t, 12.5, 400, "ink2"))
    b += key(794, 204, "ok", "97 sums proved right", t)
    b += key(794, 230, "bad", "3 sums proved wrong", t)
    b += lines(790, 262, ["Each red sum is a witness:", "replay it to see the bug."], t, 12.5, 17)
    b.append(text(30, H - 22, "In the study, a sum is one input to a chip design. A formal tool "
                  "checks all inputs, at every clock step.", t, 12.5, 400, "ink2"))
    return svg(W, H, t, b, "A gold star is not a proof",
               "Two copies of a page of 100 sums. The benchmark test checks five sums, misses three "
               "wrong sums and gives a gold star. Loupe checks every sum and finds the three wrong "
               "sums. Each wrong sum is a witness that you can replay.")


def build():
    stats = json.load(open(os.path.join(ROOT, "results", "main", "stats.json")))
    blind = json.load(open(os.path.join(ROOT, "results", "main", "blind40", "unblinded.ai.json")))
    man = json.load(open(os.path.join(ROOT, "gen", "manifests", "7b-rl.json")))
    tasks = sum(f["rows"] for f in man["files"]) // 3  # three samples per task
    out = {}
    for mode, t in THEMES.items():
        out[f"pipeline-{mode}.svg"] = pipeline(t)
        out[f"results-{mode}.svg"] = results(t, stats)
        out[f"timeline-{mode}.svg"] = timeline(t)
        out[f"agent-loop-{mode}.svg"] = loop(t)
        out[f"overview-{mode}.svg"] = overview(t, stats, blind, tasks)
        out[f"architecture-{mode}.svg"] = architecture(t)
        out[f"evidence-chain-{mode}.svg"] = evidence(t, stats)
        out[f"agent-session-{mode}.svg"] = session(t)
        out[f"eli5-{mode}.svg"] = eli5(t)
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
