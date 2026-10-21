#!/usr/bin/env python3
"""a20/supervisor.py — the unattended A20 orchestrator (Parts C, D, E).

Runs under tmux (`a20/run_supervisor.sh`) from the moment Part B is pushed
until 31 Oct 2026 23:59 +08. Design (PREREG-A20):

Part C (main thread, ONE heavy job at a time; GRPO never overlaps generation
or scoring):
  1. brief setting: W 100 steps -> S 100 steps (lr 1e-6), push after each.
  2. E1 on base, W-100, S-100 -> push.
  3. extension setting: W 300 steps -> S 300 steps (lr 1e-5), push.
  4. E1 on W-ext, S-ext -> push.
  5. final: ots upgrade retries, SPARK_REPORT "Phase 9 + E1 (A20)" section,
     STOP line, push. Then idle (only D and E keep running).
Rules implemented: checkpoints every 10 steps under ~/runs/grpo_<setting>_<arm>/
(never git); the B2 CSV + plot committed and pushed after every 10-step log;
on a crash (or a 60-min stall) resume from the last checkpoint at most 2 times
per run, never changing hyperparameters/data/seeds/reward; a run that still
fails is marked incomplete and E1 runs on what finished; heavy work stops by
30 Oct 2026 20:00 +08 (checked before starting each job; running jobs are
allowed to reach their next safe point, which for GRPO is the next 10-step
checkpoint or natural end).

Part D (thread): every 6 h append one line to notes/HEARTBEAT.md and push it
(time +08; current Part C step, run and training step; GPU utilisation; free
disk; free memory; Part E status; last error or "none"). In the same beat,
retry any pending `ots upgrade`.

Part E (thread): every 30 min `git fetch origin operator` (never a checkout);
if origin/operator:results/main/blind40/labels.csv exists, validate it
(exactly the 40 template ids, labels among the five classes), and when valid:
copy byte-for-byte to spark, log the operator commit sha + its commit time,
re-check the key sha256, run `scoring/blind40.py --unblind --key
~/runs/blind40_key.json`, rewrite the blind-sample section of
results/main/summary.md from unblinded.json (overall + per-family shares with
Wilson 95%), commit, push, record "Part E done" in the next heartbeat.

Push failures are retried with backoff for up to 24 h; work continues
locally. A systemd sleep:idle inhibitor is held for the whole run.
"""
import datetime
import glob
import json
import os
import re
import shlex
import subprocess
import sys
import threading
import time

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RUNS = os.path.expanduser("~/runs")
HF = os.path.expanduser("~/hf")
PYV = os.path.expanduser("~/.venvs/host/bin/python")
OTS = PYV if os.path.isfile(PYV) else "python3"   # ots is on PATH via the venv
IMAGE = "nvcr.io/nvidia/vllm:26.05.post1-py3"
DEADLINE = datetime.datetime(2026, 10, 30, 20, 0)   # heavy work stops (checked between jobs)
END_OF_MISSION = datetime.datetime(2026, 10, 31, 23, 59)
GRPO_DIR = os.path.join(REPO, "results/grpo")
LOGMD = os.path.join(REPO, "notes/LOG.md")

state = {"part_c": "starting", "run": "-", "train_step": "-", "last_error": "none",
         "part_e": "waiting for labels on origin/operator", "heartbeats": 0}
state_lock = threading.Lock()
git_lock = threading.Lock()


def now():
    return datetime.datetime.now()


def log(msg):
    line = f"- {now().strftime('%Y-%m-%d %H:%M')} — [a20] {msg}"
    print(line, flush=True)
    with open(LOGMD, "a") as f:
        f.write(line + "\n")


def set_state(**kw):
    with state_lock:
        state.update(kw)


# ---------------------------------------------------------------- git ops
def git(*args, timeout=300):
    return subprocess.run(["git", "-C", REPO, *args], capture_output=True, text=True,
                          timeout=timeout)


def commit_push(paths, msg, tag=None):
    """Serialize commit+push; retry the push with backoff up to 24 h."""
    with git_lock:
        for p in paths:
            if os.path.exists(os.path.join(REPO, p)):
                git("add", "--", p)
        git("commit", "-m", msg)
        deadline = time.time() + 24 * 3600
        delay = 60
        attempt = 0
        while True:
            attempt += 1
            args = ["push", "origin", "spark"] + ([tag] if tag else [])
            p = git(*args)
            if p.returncode == 0:
                if attempt > 1:
                    log(f"push succeeded on attempt {attempt}: {msg}")
                return True
            err = (p.stderr or p.stdout or "").strip().splitlines()
            err = err[-1] if err else "?"
            if time.time() >= deadline:
                set_state(last_error=f"push failed for 24h: {err[:120]}")
                log(f"PUSH FAILED for 24h, giving up this push ({msg}): {err}")
                return False
            log(f"push failed (attempt {attempt}): {err} — retrying in {delay}s "
                f"(backoff, up to 24h)")
            time.sleep(delay)
            delay = min(delay * 2, 600)


# ---------------------------------------------------------------- helpers
def gpu_util():
    try:
        out = subprocess.run(["nvidia-smi", "--query-gpu=utilization.gpu,memory.used",
                              "--format=csv,noheader"], capture_output=True, text=True,
                             timeout=30).stdout.strip()
        return out.replace("\n", "; ")
    except Exception as e:
        return f"nvidia-smi unavailable ({e})"


def free_disk_mem():
    try:
        d = subprocess.run(["df", "-h", "/"], capture_output=True, text=True,
                           timeout=30).stdout.splitlines()[1].split()[-2]
    except Exception:
        d = "?"
    try:
        m = subprocess.run(["free", "-g"], capture_output=True, text=True,
                           timeout=30).stdout.splitlines()[1].split()[2]
    except Exception:
        m = "?"
    return d, m


def run_inhibit():
    """Hold a systemd sleep:idle inhibitor for the whole mission."""
    return subprocess.Popen(["systemd-inhibit", "--what=sleep:idle",
                             "--who=a20-supervisor",
                             "--why=unattended A20 run until 31 Oct 2026",
                             "--mode=block", "sleep", "infinity"])


def past_deadline():
    return now() >= DEADLINE


def csv_rows(path):
    if not os.path.isfile(path):
        return 0
    n = 0
    with open(path) as f:
        for l in f:
            if l.strip() and not l.startswith("step,"):
                n += 1
    return n


def plot(csv_path):
    try:
        subprocess.run([PYV, os.path.join(REPO, "a20/plot.py"), csv_path],
                       capture_output=True, timeout=120)
    except Exception as e:
        log(f"plot failed for {csv_path}: {e}")


# ---------------------------------------------------------------- Part C
def docker_train_cmd(setting, arm, steps, lr, resume=""):
    name = f"grpo_{setting}_{arm}"
    mounts = (f"-v {HF}:/models-hf -v {REPO}:/work -v {os.path.expanduser('~/eda')}:/eda "
              f"-v {os.path.expanduser('~/eda')}:/root/eda "
              f"-v {os.path.expanduser('~/bench')}:/bench -v {RUNS}:/runs")
    inner = (f"pip install -q trl==1.15.0 peft==0.21.2 && "
             f"python3 /work/grpo/train_grpo.py --arm {arm} --steps {steps} --lr {lr} "
             f"--run-name {name} --out /runs --save-steps 10 --callback-every 10 "
             f"--csv-out /work/results/grpo/{name}.csv "
             f"--adapter-sha-out /work/results/grpo/{name}_adapter.sha256.json "
             f"--metrics-out /work/results/grpo/{name}_metrics.json "
             + (f"--resume-from-checkpoint {resume}" if resume else ""))
    return (f"sg docker -c 'docker run --rm --name a20_{name} --gpus all --ipc=host "
            f"--ulimit memlock=-1 --ulimit stack=67108864 {mounts} "
            f"-e EDA_BIN=/eda/oss-cad-suite/bin -e GRPO_WORK_DIR=/runs/grpo "
            f"-e TZ=Asia/Singapore {IMAGE} "
            f"bash -lc {shlex.quote(inner)}'"
            f" > {RUNS}/{name}.train.log 2>&1")


def latest_checkpoint(name):
    d = os.path.join(RUNS, name)
    if not os.path.isdir(d):
        return None
    cands = []
    for e in os.listdir(d):
        m = re.fullmatch(r"checkpoint-(\d+)", e)
        if m and os.path.isdir(os.path.join(d, e)):
            cands.append((int(m.group(1)), e))
    return os.path.join(d, max(cands)[1]) if cands else None


def run_grpo(setting, arm, steps, lr):
    name = f"grpo_{setting}_{arm}"
    os.makedirs(GRPO_DIR, exist_ok=True)
    status_p = os.path.join(GRPO_DIR, f"{name}_status.json")
    if os.path.isfile(status_p) and json.load(open(status_p)).get("status") == "done":
        log(f"{name}: already done — resume skip")
        return True
    set_state(part_c=f"Part C GRPO {setting} setting", run=name, train_step=0)
    t0 = now()
    resumes = 0
    resume = ""
    incomplete_reason = None
    rc, status = -1, "incomplete"
    while True:
        if past_deadline():
            incomplete_reason = "deadline (30 Oct 20:00) reached before this attempt"
            break
        csv_path = os.path.join(GRPO_DIR, f"{name}.csv")
        rows_before = csv_rows(csv_path)
        logp = os.path.join(RUNS, f"{name}.train.log")
        log_size_before = os.path.getsize(logp) if os.path.isfile(logp) else 0
        stall_t0 = time.time()
        cmd = docker_train_cmd(setting, arm, steps, lr, resume)
        log(f"{name}: starting (steps={steps} lr={lr} resume={resume or 'none'})")
        proc = subprocess.Popen(["bash", "-c", cmd])
        # supervise: CSV watcher + stall detector
        while proc.poll() is None:
            time.sleep(20)
            r = csv_rows(csv_path)
            if r > rows_before:
                rows_before = r
                set_state(run=name, train_step=r * 10)
                plot(csv_path)
                commit_push(["results/grpo", "notes/LOG.md"],
                            f"A20 {name}: 10-step log #{r} (CSV+plot)")
            cur = os.path.getsize(logp) if os.path.isfile(logp) else 0
            if cur > log_size_before or csv_rows(csv_path) > rows_before - 1:
                log_size_before = max(cur, log_size_before)
                stall_t0 = time.time()
            elif time.time() - stall_t0 > 3600:
                set_state(last_error=f"{name} stalled 60 min (no log/CSV progress)")
                log(f"{name}: stalled for 60 min — killing container, "
                    f"resume attempt {resumes + 1}/2")
                subprocess.run(["sg", "docker", "-c", f"docker kill a20_{name}"],
                               capture_output=True)
                break
        rc = proc.wait()
        if rc == 0:
            log(f"{name}: finished rc=0 in {(now()-t0).total_seconds()/3600:.2f} h")
            status = "done"
            break
        ckpt = latest_checkpoint(name)
        if resumes >= 2:
            incomplete_reason = f"rc={rc} after {resumes} resumes (limit 2)"
            log(f"{name}: INCOMPLETE — {incomplete_reason}")
            break
        if not ckpt:
            incomplete_reason = f"rc={rc} with no checkpoint to resume from"
            log(f"{name}: INCOMPLETE — {incomplete_reason}")
            break
        resumes += 1
        resume = ckpt.replace(RUNS, "/runs")
        log(f"{name}: rc={rc}; resuming from {ckpt} (resume {resumes}/2)")
        set_state(last_error=f"{name} rc={rc}, resume {resumes}/2)")
    rec = {"run": name, "arm": arm, "setting": setting, "steps": steps, "lr": lr,
           "status": status, "resumes": resumes,
           "reason": incomplete_reason or "ok",
           "csv_rows": csv_rows(os.path.join(GRPO_DIR, f"{name}.csv")),
           "wall_h": round((now() - t0).total_seconds() / 3600, 2),
           "finished_at": now().strftime("%Y-%m-%d %H:%M")}
    json.dump(rec, open(status_p, "w"), indent=1)
    if status == "done":
        plot(os.path.join(GRPO_DIR, f"{name}.csv"))
    commit_push(["results/grpo", "notes/LOG.md"],
                f"A20 {name}: run {status} ({rec['csv_rows']} 10-step logs, "
                f"{rec['resumes']} resumes)")
    return status == "done"


def run_e1(arms, merges):
    set_state(part_c="Part C E1", run=f"e1:{','.join(arms)}", train_step="-")
    args = [PYV, os.path.join(REPO, "e1/run_e1.py"), "--arms", *arms]
    for m in merges:
        args += ["--merge", m]
    p = subprocess.run(args)
    log(f"e1 run rc={p.returncode} arms={arms}")
    q = subprocess.run([PYV, os.path.join(REPO, "e1/report.py")])
    log(f"e1 report rc={q.returncode}")
    ok = p.returncode == 0 and q.returncode == 0
    commit_push(["results/e1", "scores_e1", "prompts/built_e1", "notes/LOG.md"],
                f"A20 E1: arms {','.join(arms)} generated+scored+reported "
                f"({'ok' if ok else 'WITH ERRORS — see notes/LOG.md'})")
    return ok


def final_steps():
    set_state(part_c="Part C step 5 (final)", run="-", train_step="-")
    # ots upgrade anything still pending
    for f in ("PREREG.md.ots", "PREREG-A19.md.ots", "PREREG-A20.md.ots"):
        p = os.path.join(REPO, f)
        if os.path.isfile(p):
            r = subprocess.run(["bash", "-c", f"cd {REPO} && PATH=$PATH:{os.path.dirname(PYV)} "
                                            f"ots upgrade {f}"], capture_output=True, text=True)
            log(f"final ots upgrade {f}: rc={r.returncode} "
                f"{(r.stdout or '').strip().splitlines()[-1] if (r.stdout or '').strip() else ''}")
    # SPARK_REPORT final section
    rep = os.path.join(REPO, "SPARK_REPORT.md")
    section = ["", "## 13. Phase 9 + E1 (A20)", "",
               f"Completed {now().strftime('%Y-%m-%d %H:%M')} +08 by a20/supervisor.py "
               "(PREREG-A20; exploratory — never feeds the primary results).", "",
               "Run status files: `results/grpo/*_status.json`; B2 CSVs + plots: "
               "`results/grpo/*.csv/.png`; adapter sha256 records: "
               "`results/grpo/*_adapter.sha256.json` (weights stay under `~/runs/`). "
               "E1: `results/e1/summary.md` + `stats.json` + `g2.json`, scores in "
               "`scores_e1/`, merged-model sha256 records in `results/e1/models/`.", ""]
    for f in sorted(glob.glob(os.path.join(GRPO_DIR, "*_status.json"))):
        rec = json.load(open(f))
        section.append(f"- **{rec['run']}** ({rec['setting']} setting, arm {rec['arm'].upper()}, "
                       f"steps {rec['steps']}, lr {rec['lr']:g}): **{rec['status']}** "
                       f"({rec['csv_rows']} 10-step logs, {rec['resumes']} resumes, "
                       f"{rec['wall_h']} h; {rec['reason']})")
    ep = os.path.join(REPO, "results/e1/summary.md")
    if os.path.isfile(ep):
        section.append("- E1 report: `results/e1/summary.md` (per-arm table + contrasts + "
                       "G2 flags, all exploratory).")
    else:
        section.append("- E1 report: NOT PRODUCED (see notes/LOG.md).")
    with state_lock:
        section.append(f"- Part E (blind-40 unblinding): {state['part_e']}.")
    section += ["", "Heartbeats: `notes/HEARTBEAT.md` (every 6 h until 31 Oct). "
               "Heavy work stopped at/by the 30 Oct 20:00 deadline as required.", "",
               "STOP — Phase 9 + E1 done; waiting for the operator (31 Oct)", ""]
    with open(rep, "a") as f:
        f.write("\n".join(section))
    log("STOP — Phase 9 + E1 done; waiting for the operator (31 Oct)")
    print("STOP — Phase 9 + E1 done; waiting for the operator (31 Oct)", flush=True)
    commit_push(["SPARK_REPORT.md", "PREREG.md.ots", "PREREG-A19.md.ots", "PREREG-A20.md.ots",
                 "notes/LOG.md"], "A20 final: Phase 9 + E1 section, ots upgrades, STOP line")


def part_c():
    log("Part C starts: brief W -> brief S -> E1(base,w100,s100) -> ext W -> ext S -> "
        "E1(wext,sext) -> final")
    # 1. brief setting
    if not past_deadline():
        run_grpo("brief", "W", 100, 1e-6)
    if not past_deadline():
        run_grpo("brief", "S", 100, 1e-6)
    # 2. E1 on base, W-100, S-100 (only arms whose runs finished; an incomplete
    #    run still leaves its last checkpoint/final adapter if it got that far —
    #    merge only from final_adapter, else from the last checkpoint)
    if not past_deadline():
        arms, merges = ["base"], []
        for arm, name in (("w100", "grpo_brief_W"), ("s100", "grpo_brief_S")):
            src = adapter_source(name)
            if src:
                arms.append(arm)
                merges.append(f"{arm}:{src}")
        run_e1(arms, merges)
    # 3. extension setting
    if not past_deadline():
        run_grpo("ext", "W", 300, 1e-5)
    if not past_deadline():
        run_grpo("ext", "S", 300, 1e-5)
    # 4. E1 on W-ext, S-ext
    if not past_deadline():
        arms, merges = [], []
        for arm, name in (("wext", "grpo_ext_W"), ("sext", "grpo_ext_S")):
            src = adapter_source(name)
            if src:
                arms.append(arm)
                merges.append(f"{arm}:{src}")
        if arms:
            run_e1(arms, merges)
        else:
            log("E1 ext: no adapters available (both runs incomplete before any checkpoint)")
    # 5. final steps
    final_steps()


def adapter_source(name):
    """final_adapter if the run finished with one; else the last checkpoint
    (an incomplete run's E1 uses what did finish, per PREREG-A20 run rules)."""
    final = os.path.join(RUNS, name, "final_adapter")
    if os.path.isdir(final) and os.path.isfile(os.path.join(final, "adapter_model.safetensors")):
        return final
    ck = latest_checkpoint(name)
    if ck and os.path.isfile(os.path.join(ck, "adapter_model.safetensors")):
        log(f"{name}: no final_adapter — E1 will merge the last checkpoint {ck}")
        return ck
    return None


# ---------------------------------------------------------------- Part D
def heartbeat_once():
    d, m = free_disk_mem()
    with state_lock:
        line = (f"{now().strftime('%Y-%m-%d %H:%M')} +08 | step: {state['part_c']} | "
                f"run: {state['run']} | train step: {state['train_step']} | "
                f"GPU: {gpu_util()} | disk free: {d} | mem free: {m} G | "
                f"Part E: {state['part_e']} | last error: {state['last_error']}")
        state["heartbeats"] += 1
    hb = os.path.join(REPO, "notes/HEARTBEAT.md")
    os.makedirs(os.path.dirname(hb), exist_ok=True)
    if not os.path.isfile(hb):
        open(hb, "w").write("# A20 heartbeats (every 6 h; operator reads these on GitHub — "
                            "a missing line means the machine needs attention on 31 Oct)\n")
    with open(hb, "a") as f:
        f.write(line + "\n")
    print(f"[heartbeat] {line}", flush=True)
    commit_push(["notes/HEARTBEAT.md", "notes/LOG.md"], f"A20 heartbeat #{state['heartbeats']}")
    # retry pending ots upgrades in the same beat
    for f in ("PREREG.md.ots", "PREREG-A19.md.ots", "PREREG-A20.md.ots"):
        p = os.path.join(REPO, f)
        if os.path.isfile(p):
            r = subprocess.run(["bash", "-c", f"cd {REPO} && PATH=$PATH:{os.path.dirname(PYV)} "
                                            f"ots upgrade {f} 2>&1 | tail -1"],
                               capture_output=True, text=True)
            out = (r.stdout or "").strip()
            if "Success" in out or "complete" in out.lower():
                log(f"heartbeat ots upgrade {f}: {out}")
                commit_push([f], f"A20 heartbeat: ots upgrade completed for {f}")


def heartbeat_loop():
    while now() < END_OF_MISSION:
        try:
            heartbeat_once()
        except Exception as e:
            set_state(last_error=f"heartbeat exception: {e}")
            log(f"heartbeat exception: {e}")
        time.sleep(6 * 3600)
    log("heartbeat loop ends (31 Oct)")


# ---------------------------------------------------------------- Part E
LABELS = {"real bug", "reference wrong", "allowed by spec", "unclear", "scorer artefact"}


def validate_labels(text):
    ids, labels, problems = [], [], []
    for i, l in enumerate(text.splitlines()):
        l = l.strip()
        if not l or l.startswith("id,label"):
            continue
        parts = l.split(",")
        if len(parts) != 2:
            problems.append(f"line {i+1}: not exactly one comma")
            continue
        ids.append(parts[0].strip())
        labels.append(parts[1].strip())
    tmpl = [l.split(",")[0].strip() for l in
            open(os.path.join(REPO, "results/main/blind40/labels_template.csv"))
            if l.strip() and not l.startswith("id,label")]
    if len(ids) != 40:
        problems.append(f"{len(ids)} ids, expected 40")
    if len(set(ids)) != len(ids):
        problems.append("duplicate ids")
    if set(ids) != set(tmpl):
        problems.append("ids do not match labels_template.csv exactly")
    bad = sorted({lab for lab in labels if lab not in LABELS})
    if bad:
        problems.append(f"unknown labels: {bad[:5]}")
    return problems


def unblind_section_text(unb, op_sha, op_time):
    def row(label):
        o = unb["overall"][label]
        w = o["wilson95"]
        return (f"| {label} | {o['count']} | {100*o['share']:.1f} "
                f"[{100*w[0]:.1f}, {100*w[1]:.1f}] |")
    L = ["## Blind sample of 40 — unblinded (A20 Part E)", "",
         f"Labels from branch `operator` commit `{op_sha}` (committer time {op_time}; "
         "git does not expose push time), copied byte-for-byte to "
         "`results/main/blind40/labels.csv`; the key sha256 was re-verified against "
         "`KEY_SHA256` before unblinding. Source: `results/main/blind40/unblinded.json` "
         "(written by the pinned `scoring/blind40.py --unblind`). Single rater "
         "(the study author) — the pre-registered limitation stands.", "",
         "| class | overall n | share % [Wilson 95] |", "|---|---|---|"]
    for lab in unb["labels"]:
        L.append(row(lab))
    L += ["", "Per family:", "", "| family | class | n | share % [Wilson 95] |",
          "|---|---|---|---|"]
    for fam, cells in sorted(unb["per_family"].items()):
        n_fam = sum(c["count"] for c in cells.values())
        for lab in unb["labels"]:
            c = cells[lab]
            w = c["wilson95"]
            if c["count"] or lab == "real bug":
                L.append(f"| {fam} (n={n_fam}) | {lab} | {c['count']} | "
                         f"{100*c['share']:.1f} [{100*w[0]:.1f}, {100*w[1]:.1f}] |")
    L.append("")
    return "\n".join(L)


def epoll_once():
    if os.path.isfile(os.path.join(REPO, "results/main/blind40/labels.csv")):
        set_state(part_e="done")
        return
    f = git("fetch", "origin", "operator", timeout=300)
    if f.returncode != 0:
        err = (f.stderr or "").strip()
        if "couldn't find remote ref" in err or "not found" in err.lower():
            return  # branch does not exist yet — that is "waiting", not an error
        set_state(last_error=f"git fetch origin operator failed: {err[:120]}")
        return
    exists = subprocess.run(["git", "-C", REPO, "cat-file", "-e",
                             "origin/operator:results/main/blind40/labels.csv"],
                            capture_output=True).returncode == 0
    if not exists:
        return
    text = subprocess.run(["git", "-C", REPO, "show",
                           "origin/operator:results/main/blind40/labels.csv"],
                          capture_output=True, text=True).stdout
    problems = validate_labels(text)
    if problems:
        set_state(part_e=f"invalid labels on origin/operator ({'; '.join(problems[:3])}) "
                         "— waiting for a newer commit")
        log(f"Part E: labels INVALID: {problems}")
        return
    op_sha = git("rev-parse", "origin/operator").stdout.strip()
    op_time = git("log", "-1", "--format=%cI", "origin/operator").stdout.strip()
    dst = os.path.join(REPO, "results/main/blind40/labels.csv")
    open(dst, "w").write(text)
    key = os.path.expanduser("~/runs/blind40_key.json")
    import hashlib
    h = hashlib.sha256(open(key, "rb").read()).hexdigest()
    want = open(os.path.join(REPO, "results/main/blind40/KEY_SHA256")).read().strip()
    if h != want:
        set_state(last_error="blind40 key sha256 MISMATCH — unblinding refused")
        log("Part E ABORTED: key sha256 mismatch")
        os.remove(dst)
        return
    r = subprocess.run([PYV, os.path.join(REPO, "scoring/blind40.py"), "--unblind",
                        "--key", key], cwd=REPO, capture_output=True, text=True)
    if r.returncode != 0:
        set_state(last_error=f"blind40 --unblind failed: {(r.stderr or '')[:200]}")
        log(f"Part E: unblind FAILED: {r.stderr[-500:]}")
        return
    unb_p = os.path.join(REPO, "results/main/blind40/unblinded.json")
    unb = json.load(open(unb_p))
    sump = os.path.join(REPO, "results/main/summary.md")
    txt = open(sump).read()
    m = re.search(r"^## Blind sample of 40.*", txt, re.S | re.M)
    new_section = unblind_section_text(unb, op_sha, op_time)
    if m:
        txt = txt[:m.start()] + new_section + "\n"
    else:
        txt = txt + "\n" + new_section
    open(sump, "w").write(txt)
    set_state(part_e="done")
    log(f"Part E DONE: labels from operator commit {op_sha} (committer time {op_time}); "
        "unblinded.json written; summary.md blind section updated")
    commit_push(["results/main/blind40/labels.csv", "results/main/blind40/unblinded.json",
                 "results/main/summary.md", "notes/LOG.md"],
                "A20 Part E: blind-40 unblinded (labels from operator branch); "
                "summary.md updated with Wilson intervals")


def epoll_loop():
    time.sleep(300)  # first check 5 min in
    while now() < END_OF_MISSION:
        try:
            epoll_once()
        except Exception as e:
            set_state(last_error=f"epoll exception: {e}")
            log(f"epoll exception: {e}")
        if now() < END_OF_MISSION:
            time.sleep(1800)


# ---------------------------------------------------------------- main
def main():
    os.makedirs(RUNS, exist_ok=True)
    inhib = run_inhibit()
    log(f"supervisor up (pid {os.getpid()}, inhibitor pid {inhib.pid}); "
        f"deadline {DEADLINE}, end of mission {END_OF_MISSION}")
    threading.Thread(target=heartbeat_loop, daemon=False, name="heartbeat").start()
    threading.Thread(target=epoll_loop, daemon=False, name="epoll").start()
    try:
        part_c()
    except Exception as e:
        set_state(last_error=f"part_c exception: {e}")
        log(f"Part C EXCEPTION: {e} — writing STOP state and pushing")
        import traceback
        traceback.print_exc()
        with open(os.path.join(REPO, "SPARK_REPORT.md"), "a") as f:
            f.write(f"\nPart C stopped on an exception at {now()}: {e}\n")
        commit_push(["SPARK_REPORT.md", "notes/LOG.md"],
                    "A20: Part C stopped on an exception (see notes/LOG.md)")
    set_state(part_c="idle (Parts D/E only)", run="-", train_step="-")
    # stay alive until the end of mission for D and E
    while now() < END_OF_MISSION:
        time.sleep(60)
    heartbeat_once()
    log("supervisor exiting (end of mission)")
    inhib.terminate()


if __name__ == "__main__":
    main()
