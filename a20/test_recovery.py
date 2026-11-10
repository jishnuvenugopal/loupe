"""Recovery-only regressions; no model, simulator, Docker or remote access."""
import json
from pathlib import Path
import sys
import tempfile
import types
import unittest
from unittest.mock import Mock, patch

sys.path.insert(0, str(Path(__file__).resolve().parent))
import adopt_training
import continue_after_outage as driver
import recovery_checks as checks


class SampleChecks(unittest.TestCase):
    def setUp(self):
        self.expected = {
            (bench, f"task-{t}", idx): ("prompt", 7)
            for bench, n in (("ve", 144), ("rtllm", 33))
            for t in range(n) for idx in range(3)
        }
        self.rows = [{"arm": "e1-base", "bench": b, "task_id": t,
                      "sample_idx": i, "seed": 7, "prompt_sha256": "prompt", "completion": ""}
                     for b, t, i in self.expected]

    def test_exact_432_plus_99_and_combined_531(self):
        for bench, count in (("ve", 432), ("rtllm", 99)):
            want = {k: v for k, v in self.expected.items() if k[0] == bench}
            rows = [r for r in self.rows if r["bench"] == bench]
            result = checks.validate_rows(rows, want, "base")
            self.assertTrue(result["ok"])
            self.assertEqual(result["rows"], count)
        self.assertTrue(checks.validate_rows(self.rows, self.expected, "base")["ok"])

    def test_duplicate_replacing_missing_row_same_total_is_rejected(self):
        rows = self.rows[:-1] + [self.rows[0]]
        result = checks.validate_rows(rows, self.expected, "base")
        self.assertFalse(result["ok"])
        self.assertEqual((result["missing"], result["duplicates"]), (1, 1))

    def test_missing_extra_and_bad_provenance(self):
        self.assertFalse(checks.validate_rows([], self.expected, "base")["ok"])
        for update in ({"task_id": "unexpected"}, {"bench": "other"}, {"arm": "e1-w100"},
                       {"seed": 8}, {"prompt_sha256": "wrong"}, {"sample_idx": True},
                       {"sample_idx": "0"}, {"bench": []}, {"completion": None}):
            with self.subTest(update=update):
                rows = [dict(r) for r in self.rows]
                rows[0].update(update)
                self.assertFalse(checks.validate_rows(rows, self.expected, "base")["ok"])

    def test_score_file_must_have_exact_coverage_and_provenance(self):
        for r in self.rows:
            r.update(scorer_sha256="sha", scorer_commit="commit", tb="fail",
                     vclass=None, **{"class": "tb-fail", "verdict": {}})
        kwargs = dict(scores=True, scorer_sha="sha", scorer_commit="commit")
        self.assertTrue(checks.validate_rows(self.rows, self.expected, "base", **kwargs)["ok"])
        self.assertFalse(checks.validate_rows(self.rows[:432], self.expected, "base", **kwargs)["ok"])
        self.rows[0]["scorer_sha256"] = "stale"
        self.assertFalse(checks.validate_rows(self.rows, self.expected, "base", **kwargs)["ok"])

    def test_malformed_record(self):
        self.assertFalse(checks.validate_rows([{}], self.expected, "base")["ok"])

    def test_missing_training_artifacts_are_not_success(self):
        with tempfile.TemporaryDirectory() as d:
            self.assertFalse(checks.training_check(d, d)["ok"])


class ChainChecks(unittest.TestCase):
    @patch.object(driver, "write_json")
    @patch.object(driver, "freeze_check", return_value={"ok": True})
    @patch.object(driver.sup, "past_deadline", return_value=False)
    @patch.object(driver.sup, "set_state")
    @patch.object(driver.subprocess, "run")
    @patch.object(driver, "e1_check")
    def test_zero_exit_with_missing_outputs_blocks_report(self, e1, run, *_):
        e1.side_effect = [
            {"arms": {"base": {"ok": False, "ve": {"ok": False}, "rtllm": {"ok": False}}}},
            {"ok": False},
        ]
        run.return_value.returncode = 0
        with self.assertRaisesRegex(RuntimeError, "completeness failed"):
            driver.run_e1_checked({})
        self.assertEqual(run.call_count, 1)
        self.assertIn("e1/run_e1.py", run.call_args.args[0][1])

    @patch.object(driver, "write_json")
    @patch.object(driver, "freeze_check", return_value={"ok": False})
    @patch.object(driver.sup, "past_deadline", return_value=False)
    @patch.object(driver.subprocess, "run")
    def test_pin_drift_blocks_e1(self, run, *_):
        with self.assertRaisesRegex(RuntimeError, "freeze"):
            driver.run_e1_checked({})
        run.assert_not_called()

    @patch.object(driver.sup, "past_deadline", return_value=True)
    @patch.object(driver.subprocess, "run")
    def test_deadline_blocks_new_work(self, run, *_):
        with self.assertRaisesRegex(RuntimeError, "deadline"):
            driver.run_e1_checked({})
        run.assert_not_called()

    def test_report_blocked_does_not_claim_done(self):
        with tempfile.TemporaryDirectory() as d, patch.object(driver, "REPO", d):
            p = Path(d)
            (p / "SPARK_REPORT.md").write_text("# Report\n\n## 13. Phase 9 + E1 (A20)\nold done\n")
            (p / "spark_report.json").write_text("{}")
            driver.report_state("blocked", "E1 missing")
            text = (p / "SPARK_REPORT.md").read_text()
            self.assertIn("BLOCKED", text)
            self.assertNotIn("Phase 9 + E1 complete", text)
            self.assertNotIn("old done", text)
            self.assertEqual(json.loads((p / "spark_report.json").read_text())["a20_recovery"]["status"], "blocked")


class AdoptionChecks(unittest.TestCase):
    @patch.object(adopt_training, "docker")
    @patch.object(adopt_training, "training_check", return_value={"ok": False, "errors": ["missing CSV"]})
    @patch.object(adopt_training.subprocess, "Popen")
    def test_zero_exit_without_final_artifacts_is_incomplete(self, popen, _, docker):
        with tempfile.TemporaryDirectory() as d:
            p = Path(d)
            (p / "results/grpo").mkdir(parents=True)
            docker.side_effect = ["/a20_grpo_ext_S abc", json.dumps({
                "Running": True, "StartedAt": "2026-11-10T06:33:39.836176506Z"})]
            waiter = popen.return_value
            waiter.poll.return_value = 0
            waiter.returncode = 0
            waiter.communicate.return_value = ("0\n", "")
            sup = types.SimpleNamespace(REPO=d, RUNS=d, GRPO_DIR=str(p / "results/grpo"),
                                        csv_rows=Mock(return_value=0), set_state=Mock(), log=Mock(),
                                        commit_push=Mock(), plot=Mock())
            self.assertFalse(adopt_training.adopt(sup, "abc"))
            rec = json.loads((p / "results/grpo/grpo_ext_S_status.json").read_text())
            self.assertEqual(rec["status"], "incomplete")
            self.assertIn("docker wait", popen.call_args.args[0][-1])
            waiter.terminate.assert_not_called()

    @patch.object(adopt_training, "docker")
    @patch.object(adopt_training, "training_check", return_value={"ok": False, "errors": []})
    @patch.object(adopt_training.subprocess, "Popen")
    def test_nonzero_exit_resumes_same_settings_at_most_twice(self, popen, _, docker):
        with tempfile.TemporaryDirectory() as d:
            p = Path(d)
            (p / "results/grpo").mkdir(parents=True)
            docker.side_effect = ["/a20_grpo_ext_S abc", json.dumps({
                "Running": True, "StartedAt": "2026-11-10T06:33:39Z"})]
            proc = popen.return_value
            proc.poll.return_value = 0
            proc.returncode = 0
            proc.communicate.return_value = ("1\n", "")
            proc.wait.return_value = 1
            sup = types.SimpleNamespace(REPO=d, RUNS=d, GRPO_DIR=str(p / "results/grpo"),
                                        csv_rows=Mock(return_value=1), set_state=Mock(), log=Mock(),
                                        commit_push=Mock(), plot=Mock(), past_deadline=Mock(return_value=False),
                                        latest_checkpoint=Mock(return_value=f"{d}/grpo_ext_S/checkpoint-10"),
                                        docker_train_cmd=Mock(return_value="mock-training-command"))
            self.assertFalse(adopt_training.adopt(sup, "abc"))
            self.assertEqual(sup.docker_train_cmd.call_count, 2)
            for call in sup.docker_train_cmd.call_args_list:
                self.assertEqual(call.args, ("ext", "S", 300, 1e-5, "/runs/grpo_ext_S/checkpoint-10"))
            rec = json.loads((p / "results/grpo/grpo_ext_S_status.json").read_text())
            self.assertEqual(rec["resumes"], 2)
            self.assertEqual(rec["status"], "incomplete")

    @patch.object(adopt_training, "docker")
    @patch.object(adopt_training, "training_check", return_value={"ok": False, "errors": []})
    @patch.object(adopt_training.subprocess, "Popen")
    def test_readoption_preserves_exhausted_resume_budget(self, popen, _, docker):
        with tempfile.TemporaryDirectory() as d:
            p = Path(d)
            (p / "results/grpo").mkdir(parents=True)
            status = p / "results/grpo/grpo_ext_S_status.json"
            status.write_text(json.dumps({"resumes": 2, "status": "running"}))
            docker.side_effect = ["/a20_grpo_ext_S abc", json.dumps({
                "Running": True, "StartedAt": "2026-11-10T06:33:39Z"})]
            proc = popen.return_value
            proc.poll.return_value = 0
            proc.returncode = 0
            proc.communicate.return_value = ("1\n", "")
            sup = types.SimpleNamespace(REPO=d, RUNS=d, GRPO_DIR=str(p / "results/grpo"),
                                        csv_rows=Mock(return_value=1), set_state=Mock(), log=Mock(),
                                        commit_push=Mock(), plot=Mock(), docker_train_cmd=Mock())
            self.assertFalse(adopt_training.adopt(sup, "abc"))
            sup.docker_train_cmd.assert_not_called()
            self.assertEqual(json.loads(status.read_text())["resumes"], 2)

    @patch.object(adopt_training, "docker", return_value="/unrelated abc")
    @patch.object(adopt_training.subprocess, "Popen")
    def test_wrong_container_is_not_adopted(self, popen, _):
        with self.assertRaisesRegex(RuntimeError, "different container"):
            adopt_training.adopt(None, "abc")
        popen.assert_not_called()


if __name__ == "__main__":
    unittest.main()
