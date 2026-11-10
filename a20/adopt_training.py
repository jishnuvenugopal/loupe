"""Adopt an already-running GRPO container without restarting training.

Operational recovery only. Nonzero training exits use the pinned resume command
and last checkpoint, at most twice as pre-registered. Ambiguous completion or a
monitoring failure blocks downstream work instead of claiming success.
"""
import datetime
import json
from pathlib import Path
import shlex
import shutil
import subprocess
import time

from recovery_checks import training_check


def docker(*args):
    return subprocess.run(["sg", "docker", "-c", shlex.join(["docker", *args])],
                          capture_output=True, text=True, timeout=30, check=True).stdout.strip()


def adopt(sup, container_id):
    name = "grpo_ext_S"
    identity = docker("inspect", "--format", "{{.Name}} {{.Id}}", container_id).split()
    if identity != ["/a20_grpo_ext_S", container_id]:
        raise RuntimeError("refusing to adopt a different container")
    state = json.loads(docker("inspect", "--format", "{{json .State}}", container_id))
    if not state.get("Running"):
        raise RuntimeError("attachment requires a live training container")
    started = datetime.datetime.fromisoformat(state["StartedAt"].replace("Z", "+00:00"))
    path = Path(sup.GRPO_DIR) / f"{name}_status.json"
    old = json.loads(path.read_text()) if path.exists() else {}
    record = {"run": name, "arm": "S", "setting": "ext", "steps": 300, "lr": 1e-5,
              "status": "running", "resumes": 0, "reason": "adopted live container; training not restarted",
              "container_id": container_id, "started_at": state["StartedAt"],
              "adopted_at": datetime.datetime.now().isoformat(timespec="seconds"),
              "previous_attempt": old}

    def save():
        record["csv_rows"] = sup.csv_rows(str(csv_path))
        record["wall_h"] = round((datetime.datetime.now(datetime.timezone.utc) - started).total_seconds() / 3600, 2)
        tmp = path.with_suffix(".json.tmp")
        tmp.write_text(json.dumps(record, indent=1) + "\n")
        tmp.replace(path)

    csv_path = Path(sup.GRPO_DIR) / f"{name}.csv"
    log_path = Path(sup.RUNS) / f"{name}.train.log"
    sup.set_state(part_c="Part C GRPO ext setting (adopted)", run=name,
                  train_step=sup.csv_rows(str(csv_path)) * 10)
    sup.log(f"adopting live container {container_id}: training PID/optimizer untouched")
    # Subscribe to the exit code while the --rm container still exists.
    waiter = subprocess.Popen(["sg", "docker", "-c", shlex.join(["docker", "wait", container_id])],
                              stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    save()
    sup.commit_push([str(path.relative_to(sup.REPO)), "notes/LOG.md"],
                    "A20 recovery: adopted live extended-S training (no restart)")
    def watch(proc):
        last_rows = sup.csv_rows(str(csv_path))
        last_progress = time.monotonic()
        previous = None
        while proc.poll() is None:
            rows = sup.csv_rows(str(csv_path))
            progress = (rows, log_path.stat().st_size if log_path.exists() else 0)
            if progress != previous:
                previous, last_progress = progress, time.monotonic()
            elif time.monotonic() - last_progress >= 3600:
                sup.log("GRPO stalled 60 minutes; stopping container for the pre-registered checkpoint resume")
                docker("kill", "a20_grpo_ext_S")
                return
            if rows > last_rows:
                last_rows = rows
                sup.set_state(train_step=rows * 10)
                save()
                sup.plot(str(csv_path))
                sup.commit_push(["results/grpo", "notes/LOG.md"],
                                f"A20 grpo_ext_S: 10-step log #{rows} (adopted, CSV+plot)")
            time.sleep(20)

    try:
        watch(waiter)
        out, err = waiter.communicate(timeout=30)
        if waiter.returncode != 0:
            raise RuntimeError(f"docker wait failed; refusing to infer training success: {err.strip()}")
        rc = int(out.strip())
        # Identical settings, data, reward and seed; only the checkpoint argument
        # changes. No from-scratch restart and no third resume are permitted.
        while rc != 0 and record["resumes"] < 2 and not sup.past_deadline():
            checkpoint = sup.latest_checkpoint(name)
            if not checkpoint:
                break
            record["resumes"] += 1
            sup.log(f"{name}: exit={rc}; resume {record['resumes']}/2 from {checkpoint}")
            save()
            if log_path.exists():
                backup = log_path.with_name(f"{name}.before_resume_{record['resumes']}.{time.time_ns()}.log")
                shutil.copy2(log_path, backup)
            cmd = sup.docker_train_cmd("ext", "S", 300, 1e-5,
                                      checkpoint.replace(sup.RUNS, "/runs", 1))
            resumed = subprocess.Popen(["bash", "-c", cmd])
            watch(resumed)
            rc = resumed.wait(timeout=30)
        record["exit_code"] = rc
        check = training_check(sup.REPO, sup.RUNS)
        record["artifact_check"] = check
        record["status"] = "done" if rc == 0 and check["ok"] else "incomplete"
        record["reason"] = "ok" if record["status"] == "done" else f"exit={rc}; artifacts={check}"
        record["finished_at"] = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
        save()
        sup.plot(str(csv_path))
        sup.log(f"{name}: adopted run {record['status']}; {record['reason']}")
        sup.commit_push(["results/grpo", "notes/LOG.md"],
                        f"A20 grpo_ext_S: adopted run {record['status']}")
        return record["status"] == "done"
    finally:
        # Only detach the waiter on an exception. Never signal the training process.
        if waiter.poll() is None:
            waiter.terminate()
            try:
                waiter.communicate(timeout=10)
            except subprocess.TimeoutExpired:
                waiter.kill()
                waiter.communicate()
