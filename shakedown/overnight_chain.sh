#!/usr/bin/env bash
# shakedown/overnight_chain.sh — A18 §8: the whole conditional-G0 chain from C2
# onwards, in ONE script under tmux (extends shakedown/watch_7b.sh and
# gen/run_overnight.sh; supersedes the A16 watcher).
#
# Conditions in order: C2 weights (09:00 cut-off) -> C3 7B shakedown (3 arms,
# hard checks per arm) -> C4 steady-state projection + cut ladder -> C5 PREREG
# final -> G0 steps (tag, push, ls-remote, ots stamp) -> Phase 8 generation ->
# Phase 10 scoring/analysis -> STOP waiting for G3 review + blind labels.
# ots upgrade is scheduled ~6 h after the stamp.
#
# Every condition is a hard check logged to notes/LOG.md; every stop path
# writes SPARK_REPORT.md (shakedown/report_status.py) and pushes.
# C1 (items 1-5+7 committed, pushed, PREREG sha256 final) is verified here as
# the entry check.
#
# Dry run: CHAIN_FORCE_FAIL=C2 bash shakedown/overnight_chain.sh  (stops,
# logs, pushes — no generation happens).
set -uo pipefail
REPO=~/rtl-strict-eval
PY=$HOME/.venvs/host/bin/python
PY3=python3
OTS=$(command -v ots || echo "$HOME/.venvs/host/bin/ots")
cd "$REPO"
LOGF=notes/LOG.md
FORCE_FAIL=${CHAIN_FORCE_FAIL:-none}
DEADLINE=$(date -d "today 09:00" +%s)   # C2 cut-off, this clock

say()  { printf '%s\n' "$*"; }
log()  { local line="- $(date '+%Y-%m-%d %H:%M') — [chain] $*"; say "$line";
         printf '%s\n' "$line" >> "$LOGF"; }
stop() { # stop <condition> <why>
  local cond="$1"; shift
  local why="$*"
  log "STOP — $cond failed: $why"
  $PY3 shakedown/report_status.py --phase "$cond" \
      --status "FAILED: $why" \
      --stop "STOP — $cond failed: $why" || true
  git add -A >/dev/null 2>&1 || true
  git commit -qm "A18 chain STOP — $cond failed: $why" >/dev/null 2>&1 || true
  git push origin spark >/dev/null 2>&1 || true
  say "STOP — $cond failed: $why"
  exit 3
}
push_all() { # push_all <msg>
  git add -A >/dev/null 2>&1
  if ! git diff --cached --quiet; then
    git commit -qm "$1"
  fi
  # transient network failures must not kill the night: 5 tries, 2 min apart
  local tries=0
  until git push origin spark >/dev/null 2>&1; do
    tries=$((tries+1))
    [ "$tries" -ge 5 ] && stop PUSH "git push failed 5 times: $1"
    log "PUSH retry $tries for: $1 (sleep 120)"
    sleep 120
  done
  log "pushed: $1"
}
forced() { [ "$FORCE_FAIL" = "$1" ]; }

# ---------------------------------------------------------------- entry check
log "A18 §8 chain start (pid $$, force_fail=$FORCE_FAIL, C2 deadline $(date -d @$DEADLINE '+%H:%M'))"

# ---- C1 (verified, was done interactively before the chain was left alone)
if forced C1; then stop C1 "forced failure (dry run)"; fi
bad=0
for f in scoring/extract.py scoring/stats.py scoring/run_scoring.py \
         scoring/showcex.py scoring/dedup.py scoring/blind40.py; do
  want=$(grep -A2 "$f" PREREG.md | grep -oE '[0-9a-f]{64}' | head -1)
  got=$(sha256sum "$f" | cut -d' ' -f1)
  if [ -z "$want" ] || [ "$want" != "$got" ]; then
    log "C1 mismatch: $f prereg=$want disk=$got"; bad=1
  fi
done
[ -n "$(git status --porcelain -- . ':!notes/LOG.md')" ] && { log "C1: working tree not clean (excluding notes/LOG.md, which this chain writes)"; bad=1; }
git fetch origin spark >/dev/null 2>&1
[ "$(git rev-parse HEAD)" = "$(git rev-parse origin/spark)" ] || { log "C1: HEAD != origin/spark"; bad=1; }
[ "$bad" = 0 ] || stop C1 "code/PREREG/push consistency check failed (see log above)"
log "C1 PASS: items 1-5+7 committed, pushed, PREREG sha256 final"

# ---- C2 weights (all three 7B verified; cut-off 09:00)
if forced C2; then stop C2 "forced failure (dry run)"; fi
log "C2: waiting for 8/8 weight verification (cut-off $(date -d @$DEADLINE '+%H:%M'))"
while true; do
  if "$PY" models/verify_weights.py >> ~/runs/chain_verify.log 2>&1; then
    date '+%Y-%m-%d %H:%M' > results/h0/weights_verified_at.txt
    log "C2 PASS: all 8 weight sets hash-verified (8 of 8) at $(cat results/h0/weights_verified_at.txt)"
    push_all "A18 C2: 8/8 weights verified at $(cat results/h0/weights_verified_at.txt)"
    break
  fi
  if [ "$(date +%s)" -ge "$DEADLINE" ]; then
    stop C2 "7B weights not verified by 09:00"
  fi
  log "C2: verify_weights rc!=0; disk/process check + retry in 300 s"
  df -h / | tail -1 >> ~/runs/chain_verify.log
  sleep 300
done

# ---- C3 7B shakedown (Phase 6 step 1 for all three 7B arms)
if forced C3; then stop C3 "forced failure (dry run)"; fi
for arm in 7b-rl 7b-sft 7b-base; do
  if [ -f "results/shakedown/$arm.json" ] \
     && "$PY" shakedown/c3_check.py --arm "$arm" >/dev/null 2>&1; then
    log "C3: $arm already green (report present, checks pass) — resume skip"
    continue
  fi
  log "C3: shakedown $arm (Phase 6 step 1)"
  if ! "$PY" shakedown/shakedown_run.py --arm "$arm" >> ~/runs/shakedown_${arm}.log 2>&1; then
    stop C3 "shakedown_run $arm rc!=0 (log ~/runs/shakedown_${arm}.log)"
  fi
  if ! "$PY" shakedown/c3_check.py --arm "$arm" >> "$LOGF" 2>&1; then
    tail -5 "$LOGF" >&2
    stop C3 "$arm checks failed (see notes/LOG.md)"
  fi
  log "C3: $arm PASS (params/§6.2, extraction, cap, no scorer crash; "
      "official passes from length recorded)"
done
# 3B steady-state refresh (C4 needs every arm; weights already verified)
for arm in 3b-rl 3b-base; do
  if "$PY" - "$arm" <<'PYEOF' >/dev/null 2>&1
import json, os, sys
arm = sys.argv[1]
d = json.load(open(f"results/shakedown/{arm}.json"))
tp = d.get("throughput", {})
sys.exit(0 if all("steady_tok_per_s" in tp.get(b, {}) for b in ("ve", "rtllm")) else 1)
PYEOF
  then
    log "C3 (C4 prep): $arm steady split already present — resume skip"
  else
    log "C3 (C4 prep): throughput-only refresh $arm"
    "$PY" shakedown/shakedown_run.py --arm "$arm" --skip-gen --skip-score \
        >> ~/runs/shakedown_${arm}.log 2>&1 || log "WARN: $arm refresh rc!=0 (keeps wall rate)"
  fi
done
push_all "A18 C3: 7B shakedowns done + checked (params, extraction, cap, scorer); 3B steady refresh"
# delete every shakedown generation from ~/runs (A16 §3 end-of-phase rule)
rm -rf ~/runs/shakedown/*_shakedown*.jsonl ~/runs/shakedown/*_tp_* \
       ~/runs/shakedown/score_* ~/runs/shakedown/samples_* \
       ~/runs/shakedown/prompts ~/runs/shakedown/machinery*
log "C3: shakedown generations deleted from ~/runs/shakedown (reports kept in repo)"

# ---- C4 projection (steady-state tok/s + per-arm load; ladder to <= 9 h)
if forced C4; then stop C4 "forced failure (dry run)"; fi
if ! "$PY" shakedown/projection.py >> "$LOGF" 2>&1; then
  stop C4 "projection.py rc!=0"
fi
cut_step=$($PY3 -c "import json;print(json.load(open('results/shakedown/projection.json'))['cut_applied'])")
echo "$cut_step" > gen/cut.txt
log "C4 PASS: cut applied = $cut_step (RTLLM n=5: no; overlap probe skipped)"
push_all "A18 C4: steady-state projection done; cut applied = $cut_step"

# ---- C5 PREREG final
if forced C5; then stop C5 "forced failure (dry run)"; fi
if ! "$PY" shakedown/prereg_finalize.py >> "$LOGF" 2>&1; then
  stop C5 "placeholders unresolved (see notes/LOG.md)"
fi
grep -q "G0: approved by the operator in advance" PREREG.md \
  || stop C5 "G0 sentence missing after finalize"
push_all "A18 C5: PREREG finalized (7B numbers, cut $cut_step, verification time, G0 sentence)"

# ---------------------------------------------------------------- G0 steps
if forced G0TAG; then stop G0TAG "forced failure (dry run)"; fi
git tag g0-prereg 2>/dev/null || log "tag g0-prereg already exists (reusing)"
git push origin g0-prereg >/dev/null 2>&1 || stop G0TAG "pushing tag g0-prereg failed"
tagsha=$(git rev-parse g0-prereg)
lsr=$(git ls-remote origin refs/tags/g0-prereg)
echo "$lsr" | grep -q "$tagsha" || stop G0TAG "ls-remote does not show $tagsha for g0-prereg"
log "G0 step 1 PASS: tag g0-prereg = $tagsha pushed and visible via ls-remote"
[ -f ~/runs/ots_stamp_time.txt ] || date +%s > ~/runs/ots_stamp_time.txt
if [ -f PREREG.md.ots ] && "$OTS" verify PREREG.md.ots >/dev/null 2>&1; then
  log "G0 step 2: PREREG.md.ots already exists and verifies — skipping re-stamp (resume)"
elif ! "$OTS" stamp PREREG.md; then
  stop OTS "ots stamp PREREG.md failed"
fi
[ -f PREREG.md.ots ] || stop OTS "ots stamp produced no PREREG.md.ots"
log "G0 step 2 PASS: PREREG.md.ots stamped ($(date '+%H:%M'))"
push_all "A18 G0 steps: tag g0-prereg pushed (ls-remote verified) + PREREG.md.ots stamped"

# ots upgrade ~6 h after the stamp, independent of the rest of the chain
# (one scheduler only: marker file guards against duplicate jobs on resume)
if [ ! -f ~/runs/ots_upgrade_scheduled ]; then
  date +%s > ~/runs/ots_upgrade_scheduled
  setsid nohup bash "$REPO/shakedown/ots_upgrade_job.sh" >> ~/runs/ots_upgrade.log 2>&1 < /dev/null &
  log "ots upgrade scheduled for $(date -d "@$(( $(cat ~/runs/ots_stamp_time.txt) + 6*3600 ))" '+%H:%M') (detached job)"
else
  log "ots upgrade already scheduled (marker present) — not duplicating"
fi

# ---------------------------------------------------------------- Phase 8
if forced PHASE8; then stop PHASE8 "forced failure (dry run)"; fi
log "phase 8: overnight generation starts (cut=$cut_step, order 7b-rl 7b-sft 3b-rl 3b-base 7b-base)"
if ! $PY3 gen/run_overnight.py; then
  stop PHASE8 "generation runner rc!=0 (see notes/LOG.md and ~/runs/gen/log_*)"
fi
$PY3 gen/make_manifest.py >> "$LOGF" 2>&1 || stop PHASE8 "make_manifest failed"
# release archives (A17 item 10: generations are the record; released under
# the manifest sha256)
mkdir -p results/main/releases ~/runs/gen/release
for arm in 7b-rl 7b-sft 3b-rl 3b-base 7b-base; do
  f=~/runs/gen/release/${arm}.tar.gz
  tar czf "$f" -C ~/runs/gen --transform "s|^|$arm/|" "${arm}_ve.jsonl" "${arm}_rtllm.jsonl" 2>/dev/null \
    || tar czf "$f" -C ~/runs/gen --transform "s|^|$arm/|" "${arm}"_*.jsonl
  sha=$(sha256sum "$f" | cut -d' ' -f1)
  cp "$f" results/main/releases/
  $PY3 - "gen/manifests/$arm.json" "$sha" <<'PYEOF' >> "$LOGF" 2>&1
import json, sys
p, sha = sys.argv[1], sys.argv[2]
d = json.load(open(p)); d["release_tar_sha256"] = sha
json.dump(d, open(p, "w"), indent=1)
PYEOF
done
cp ~/runs/gen/throughput_checks.jsonl results/gen_throughput_checks.jsonl 2>/dev/null || true
push_all "A18 phase 8: generation done; manifests + release archives + throughput checks committed"

# ---------------------------------------------------------------- Phase 10
if forced PHASE10; then stop PHASE10 "forced failure (dry run)"; fi
log "phase 10: scoring + analysis (freeze checks, G2, G1b, strict, dedup, contamination, stats, blind40)"
if ! "$PY" scoring/phase10.py; then
  rc=$?
  stop PHASE10 "phase10.py rc=$rc (its STOP line names the failing gate)"
fi
push_all "A18 phase 10: scoring + analysis complete (results/main/summary.md)"
$PY3 shakedown/report_status.py --phase "Phase 10" \
  --status "complete: G2/G1b/strict/dedup/contamination/stats/blind40 done; summary.md + figure written; blind labels pending" \
  --stop 'STOP — waiting for G3 review ("G3 pass, start GRPO") and blind labels ("blind labels in")'
push_all "A18: phase 10 report status (STOP waiting for G3 review + blind labels)"

say 'STOP — waiting for G3 review ("G3 pass, start GRPO") and blind labels ("blind labels in")'
exit 0
