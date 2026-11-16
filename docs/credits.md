# Credits and related work

<!-- ste:begin -->

Loupe stands on the work of other people. This page names that work. The licence terms for the material in this repository are in [`THIRD_PARTY.md`](../THIRD_PARTY.md). This page does not repeat them.

There are three groups:

1. Benchmarks, models and data that this study used.
2. Tools and methods that this study used.
3. Related work that I checked before the analysis plan froze.

<!-- ste:end -->

## 1. Benchmarks, models and data

| Work | How Loupe uses it | Source |
|---|---|---|
| RTLLM v2.1 (Lu et al., ASP-DAC 2024; Liu et al., ICCAD 2024) | Task texts, reference designs and testbenches; the 290 GPT outputs that it ships are the scorer anchor | [repo](https://github.com/hkust-zhiyao/RTLLM), [arXiv:2308.05345](https://arxiv.org/abs/2308.05345) |
| VerilogEval v2 (Liu et al., ICCAD 2023; Pinckney et al. 2024) | Spec-to-RTL task texts, reference designs and testbenches | [repo](https://github.com/NVlabs/verilog-eval), [arXiv:2309.07544](https://arxiv.org/abs/2309.07544), [arXiv:2408.11053](https://arxiv.org/abs/2408.11053) |
| human-eval (OpenAI) | Code that VerilogEval includes | [repo](https://github.com/openai/human-eval) |
| Qwen2.5-Coder (Qwen team, Alibaba Cloud) | The 7B and 3B base checkpoints, and the 1.5B model for the GRPO test | [repo](https://github.com/QwenLM/Qwen2.5-Coder) |
| CodeV-R1 (Zhu et al.) | The 7b-sft and 7b-rl checkpoints, their sampling protocol and the published scores for gate G1b | [arXiv:2505.24183](https://arxiv.org/abs/2505.24183), [project page](https://iprc-dip.github.io/CodeV-R1) |
| VeriReason (Wang et al.) | The 3b-rl checkpoint, its system prompt, and the RTL dataset for the GRPO test | [arXiv:2505.11849](https://arxiv.org/abs/2505.11849), [repo](https://github.com/NellyW8/VeriReason) |

### Upstream reports

<!-- ste:begin -->

Other people reported RTLLM problems before me. Two designs that the headline leaves out, `RAM` and `square_wave`, match their open reports.

<!-- ste:end -->

| Issue | Author | What it reports |
|---|---|---|
| [RTLLM #16](https://github.com/hkust-zhiyao/RTLLM/issues/16) | [zxc114514aaa](https://github.com/zxc114514aaa); comment by [ZhongYic00](https://github.com/ZhongYic00) | Mismatches between task texts and testbenches; the comment (Mar 2026) flags the `RAM` array size in the task text |
| [RTLLM #20](https://github.com/hkust-zhiyao/RTLLM/issues/20) | [observerw](https://github.com/observerw) | `radix2_div`: the reference fails its own testbench in Icarus |
| [RTLLM #23](https://github.com/hkust-zhiyao/RTLLM/issues/23) | [derekszen](https://github.com/derekszen) | Proposed fixes for v2.1, among them aligned `RAM` sizes and exact `square_wave` waveform checks |

## 2. Tools and methods

| Tool or method | What it did here | Source |
|---|---|---|
| Yosys, SymbiYosys (YosysHQ) | Read the designs and build the comparison circuit; the bounded check uses the Yosys `sat` command; SymbiYosys runs the unbounded engines | [yosys](https://github.com/YosysHQ/yosys), [sby](https://github.com/YosysHQ/sby) |
| ABC (Berkeley) | The `abc pdr` engine for unbounded proofs | [repo](https://github.com/berkeley-abc/abc) |
| Z3 (Microsoft Research) | The SMT solver behind the second unbounded engine (`smtbmc z3`, k-induction) | [repo](https://github.com/Z3Prover/z3) |
| Yices 2 (SRI International) | The default `smtbmc` solver in the property checks of the reference bugs (`deep/spec_oracle.py`) | [repo](https://github.com/SRI-CSL/yices2) |
| Icarus Verilog | The official testbench runs | [repo](https://github.com/steveicarus/iverilog) |
| Verilator | The second simulator for the agreement check | [repo](https://github.com/verilator/verilator) |
| OSS CAD Suite (YosysHQ) | One pinned build of all EDA tools above (2026-10-16, arm64) | [repo](https://github.com/YosysHQ/oss-cad-suite-build) |
| vLLM | Generation for every arm | [repo](https://github.com/vllm-project/vllm) |
| TRL, PEFT, Transformers (Hugging Face) | GRPO training with a LoRA adapter | [trl](https://github.com/huggingface/trl), [peft](https://github.com/huggingface/peft), [transformers](https://github.com/huggingface/transformers) |
| NumPy | Bootstrap statistics and the checks in `verify/` | [numpy.org](https://numpy.org) |
| OpenTimestamps | The Bitcoin timestamp proofs of the analysis plan | [opentimestamps.org](https://opentimestamps.org) |
| gitleaks | Secret scan of the full history before the repository went public | [repo](https://github.com/gitleaks/gitleaks) |
| ASD-STE100 Simplified Technical English | The writing rules for the README prose; `verify/ste_lint.py` checks part of them | [asd-ste100.org](https://www.asd-ste100.org) |
| koder pattern (Jikku Jose) | The operator files and the session open and close routine that kept the agent hand-offs in order | [koder](https://github.com/jikkuatwork/jikkujose.in-mirror/tree/master/koder) |
| AI coding agents | Wrote most of the code and ran the compute work; see [`ai-workflow.md`](ai-workflow.md) | — |

## 3. Related work checked before the plan froze

<!-- ste:begin -->

This list dates from 17 Oct 2026, before the analysis plan froze. I checked each arXiv page again on 16 Nov 2026. No paper in this group is a source of a number in Loupe. CodeV-R1 and VeriReason are in group 1, because Loupe uses their checkpoints.

<!-- ste:end -->

| Paper | Topic | Link |
|---|---|---|
| Insights from Verification: Training a Verilog Generation LLM with Reinforcement Learning with Testbench Feedback (Wang et al., 2025) | Preference training from testbench results | [arXiv:2504.15804](https://arxiv.org/abs/2504.15804) |
| ChipSeek: Optimizing Verilog Generation via EDA-Integrated Reinforcement Learning (Chen et al., ACL 2026) | RL with rewards from EDA tools | [arXiv:2507.04736](https://arxiv.org/abs/2507.04736) |
| VeriContaminated: Assessing LLM-Driven Verilog Coding for Data Contamination (Wang et al., 2025) | Contamination of Verilog benchmarks | [arXiv:2503.13572](https://arxiv.org/abs/2503.13572) |
| NotSoTiny: A Large, Living Benchmark for RTL Code Generation (Ghorab et al., 2025) | A large RTL benchmark from Tiny Tapeout designs | [arXiv:2512.20823](https://arxiv.org/abs/2512.20823) |
| GateTruth: Auditing the Rigor of RTL Design Benchmarks via Mutation Testing (Bhadra, 2026) | Mutation audit of RTL benchmark testbenches, RTLLM v2.0 included | [arXiv:2608.12635](https://arxiv.org/abs/2608.12635) |
| Before the Model Learns the Bug: Fuzzing RLVR Verifiers (Ray, 2026) | Bugs in reward verifiers for RL | [arXiv:2606.01066](https://arxiv.org/abs/2606.01066) |
| LLMs Gaming Verifiers: RLVR can Lead to Reward Hacking (Helff et al., 2026) | Models that learn to exploit weak verifiers | [arXiv:2604.15149](https://arxiv.org/abs/2604.15149) |

<!-- ste:begin -->

If your work belongs on this page and it is not here, please open an issue.

<!-- ste:end -->
