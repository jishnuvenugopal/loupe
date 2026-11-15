# How AI agents ran this study

<!-- ste:begin -->

I am an AI engineer, not an RTL engineer. AI agents wrote most of the code and ran every job. My work was the question, the rules and each decision at a gate. This page shows how that split worked, and where it broke.

## The roles

| Who | Where | What |
|---|---|---|
| Me | Laptop and chat | Question, rules, every gate decision, every amendment |
| AI agent sessions | DGX Spark (one machine, arm64, GB10 GPU) | Set-up, scorer, generation, scoring, statistics, GRPO runs, reports |
| AI agent sessions | Mac | Run briefs, plan reviews, independent recompute, this write-up |
| One AI review session | Offline blind packets | The exploratory labels for the blind sample of 40 |

## The loop

1. I write a brief with the goal, the pins and the gates.
2. The agent works until it reaches a gate.
3. At a gate, the agent writes a stop line and waits.
4. I read the evidence and decide.
5. The agent records my decision as a numbered amendment.
6. The agent continues from that point only.

The agent never moves past a gate on its own judgment. One example: on 19 Oct, gate G2 stopped two 3B arms. The run waited 29 hours for my decision.

## The amendments

Every change to the plan has a number, a date and a reason. The amendments that change the analysis have their own OpenTimestamps proof.

| Amendment | Date (2026) | What changed |
|---|---|---|
| A13 to A15 | 17 Oct | From a direct read of the CodeV-R1 paper and code: sampling per checkpoint, anchors for all three CodeV arms, the new name of the GRPO dataset |
| A16 | 18 Oct | One machine only; the second machine drops out |
| A17 | 18 Oct | Two definitions of correct; references with bounded proofs only leave the gate (144 and 37 tasks, headline 33) |
| A18 | 18 to 19 Oct | Six fixes to the analysis code, plus a conditional plan freeze for an unattended night run |
| A19 | 20 Oct | After the G2 stop: a module-name alias, two pinned waivers, a 3B sensitivity run. The prompts did not change |
| A20 | 21 Oct | Primary results accepted; plan for the GRPO test and its evaluation; unattended chain with heartbeats |
| A21 | 10 Nov | Repair of 33 code sections in the blind packets; all 40 packets pass the blinding check |
| A22 | 12 to 13 Nov | AI labels in place of human labels, recorded as a protocol deviation; unblinding |

## Review before the data

On 18 Oct, before the plan froze, a second agent reviewed the plan and its pinned code. It found twelve problems. Three of them would have changed what the plan measured, and one would have stopped the run:

- The code put bounded-only proofs in the wrong group.
- The code used the wrong denominator.
- The code had no gate filter.
- The freeze check would always fail.

The fixes became amendments A17 and A18. Without this review, the frozen plan would have measured the wrong thing.

## Recompute after the data

After the primary results, an agent on a second machine recomputed them with new code. That code reads only the per-sample scores and the gate lists. It does not import or copy the original statistics code, and it uses a different bootstrap seed.

- All 10 point estimates match. The largest difference is 1e-16.
- No "resolved" or "not resolved" call changes.
- The ends of the intervals differ by at most 2.4 points, from the different seed.

That code is now [`verify/recompute.py`](../verify/recompute.py), and CI runs it on each push.

## What went wrong, and stayed in the record

- **Three chain restarts (20 to 21 Oct).** Bugs in the code between steps stopped the overnight chain three times. Each fix touched only the orchestration code (the chain script and `scoring/phase10.py`). The scorer and the statistics code did not change.
- **A file race (21 Oct, 00:55).** Two parallel helpers wrote one file while the statistics step read it. Gate G1b failed. A rerun on complete files passed.
- **A network outage (late Oct).** The Spark lost name resolution. One GRPO run died at start, and one evaluation step reported success with no output. A post-mortem found this, and new checks now count every sample before a step can report success.
- **A missed push (11 Nov).** The last commit did not push the five-arm evaluation report. The `main` branch regenerates it with the pinned script.
- **The blind labels (12 Nov).** I planned to label the 40 cases myself. One AI session labelled them. Amendment A22 records this as a deviation, with the exact text that every report must carry.

## What I would do differently

- Get a human RTL engineer to label the blind sample, as a second rater.
- Keep a second machine for generation, so that one engine does not carry the whole result.
- Add labels for task text that allows more than one behaviour, because that group was large.
- Build the completeness checks into every step from the first day, not after an outage.

<!-- ste:end -->
