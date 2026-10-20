#!/usr/bin/env python3
"""A19 §2: the module-name alias applies to exactly one misspelled RTLLM task,
to the G2 gate only, and cannot leak anywhere else."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from scoring.extract import module_name_ok, _NAME_ALIAS

CODE_MISSPELLED = "module fixed_point_substractor (a, b);\nendmodule"
CODE_CORRECT = "module fixed_point_subtractor (a, b);\nendmodule"
CODE_OTHER = "module serial2parallel (a, b);\nendmodule"
CODE_TOPMODULE = "module TopModule (a, b);\nendmodule"


def test_alias_task_accepts_correct_spelling():
    assert module_name_ok(CODE_MISSPELLED, "rtllm", "fixed_point_substractor")
    assert module_name_ok(CODE_CORRECT, "rtllm", "fixed_point_substractor")


def test_alias_task_still_rejects_other_modules():
    assert not module_name_ok(CODE_OTHER, "rtllm", "fixed_point_substractor")
    assert not module_name_ok("", "rtllm", "fixed_point_substractor")


def test_no_alias_for_any_other_task():
    # a task whose name happens to be another task's alias must not match it
    assert not module_name_ok(CODE_CORRECT, "rtllm", "serial2parallel")
    assert module_name_ok(CODE_OTHER, "rtllm", "serial2parallel")
    assert _NAME_ALIAS.keys() <= {"fixed_point_substractor"}


def test_ve_untouched():
    assert module_name_ok(CODE_TOPMODULE, "ve", "Prob001_zero")
    assert module_name_ok(CODE_TOPMODULE, "verilogeval", "Prob001_zero")
    assert not module_name_ok(CODE_CORRECT, "ve", "Prob001_zero")
    # the alias must never apply on the ve side, even for a hypothetical name
    assert not module_name_ok(CODE_CORRECT, "ve", "fixed_point_substractor")


if __name__ == "__main__":
    test_alias_task_accepts_correct_spelling()
    test_alias_task_still_rejects_other_modules()
    test_no_alias_for_any_other_task()
    test_ve_untouched()
    print("test_a19_extract_alias: all green")
