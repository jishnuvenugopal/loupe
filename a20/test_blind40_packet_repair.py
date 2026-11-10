"""A21 packet-provenance regressions, using only synthetic data in temp dirs."""
import contextlib
import importlib.util
import io
import json
from pathlib import Path
import sys
import tempfile
import unittest
from unittest.mock import patch

REPO = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(REPO / "scoring"))
spec = importlib.util.spec_from_file_location("blind40_a21_test", REPO / "scoring/blind40.py")
B = importlib.util.module_from_spec(spec)
spec.loader.exec_module(B)


class CrossArmPackets(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.root = Path(self.tmp.name)
        self.rows = [{"arm": arm, "bench": "ve", "task_id": "synthetic_task",
                      "sample_idx": 0, "completion": f"module TopModule; // value {i}\nendmodule"}
                     for i, arm in enumerate(("synthetic-a", "synthetic-b"))]
        self.gen = self.root / "gen.jsonl"
        self.gen.write_text("".join(json.dumps(r) + "\n" for r in self.rows))

    def test_lookup_retains_two_arms_with_same_task_and_index(self):
        rows = B.gen_rows([str(self.gen)])
        self.assertEqual(len(rows), 2)
        for row in self.rows:
            key = (row["arm"], row["bench"], row["task_id"], row["sample_idx"])
            self.assertEqual(rows[key], row)

    def test_lookup_is_independent_of_arm_file_order(self):
        reversed_gen = self.root / "reversed.jsonl"
        reversed_gen.write_text("".join(json.dumps(r) + "\n" for r in reversed(self.rows)))
        self.assertEqual(B.gen_rows([str(self.gen)]), B.gen_rows([str(reversed_gen)]))

    def test_draw_displays_code_from_the_selected_arm(self):
        scores = self.root / "scores.jsonl"
        scores.write_text("".join(json.dumps({**r, "tb": "pass", "class": "different"}) + "\n"
                                  for r in self.rows))
        key_path, out = self.root / "synthetic_key.json", self.root / "out"
        with patch.object(B, "spec_text", return_value="synthetic specification"), \
                patch.object(B, "reference_design", return_value="module TopModule; endmodule"), \
                patch("extract.extract_record", side_effect=lambda c, *_: {"code": c}), \
                contextlib.redirect_stdout(io.StringIO()):
            B.draw([str(scores)], [str(self.gen)], None, str(out), str(key_path),
                   str(self.root / "cex"), n_draw=2)
        key = json.loads(key_path.read_text())
        self.assertEqual(len(key), 2)
        expected = {r["arm"]: r["completion"] for r in self.rows}
        for pid, meta in key.items():
            text = (out / "packet" / f"{pid}.md").read_text()
            code = text.split("## 3. Generated design under review (extracted verbatim)\n\n```verilog\n", 1)[1]
            code = code.split("\n```\n\n## 4.", 1)[0]
            self.assertEqual(code, expected[meta["arm"]])
            B.scrub(text, pid)


class PacketSectionRepair(unittest.TestCase):
    def setUp(self):
        sys.path.insert(0, str(REPO / "a20"))
        from repair_blind40_packets import replace_code
        self.replace = replace_code
        self.old = "module Old; endmodule"
        self.text = B.packet_markdown("synthetic-id", "ve", "test", "spec", "reference",
                                      self.old, "pass", "counterexample")

    def test_only_generated_code_changes(self):
        new = "module New;\nwire \\escaped ;\nendmodule"
        self.assertEqual(self.replace(self.text, new), self.text.replace(self.old, new))

    def test_replacement_is_idempotent(self):
        repaired = self.replace(self.text, "module New; endmodule")
        self.assertEqual(self.replace(repaired, "module New; endmodule"), repaired)

    def test_missing_or_duplicate_sections_are_rejected(self):
        for text in ("no packet section", self.text + self.text):
            with self.assertRaises(ValueError):
                self.replace(text, "anything")


if __name__ == "__main__":
    unittest.main()
