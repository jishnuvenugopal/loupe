---
base_model:
- Qwen/Qwen2.5-Coder-7B-Instruct
library_name: transformers
tags:
- verilog
license: apache-2.0
pipeline_tag: text-generation
---

## CodeV-R1-Distill-Qwen-7B

Project page: https://iprc-dip.github.io/CodeV-R1

### 1. Introduction

Large language models (LLMs) trained via reinforcement learning with verifiable reward (RLVR) have achieved breakthroughs on tasks with explicit, automatable verification, such as software programming and mathematical problems. Extending RLVR to electronic design automation (EDA), especially automatically generating hardware description languages (HDLs) like Verilog from natural-language (NL) specifications, however, poses three key challenges: the lack of automated and accurate verification environments, the scarcity of high‐quality NL–code pairs, and the prohibitive computation cost of RLVR. 

To this end, we introduce **CodeV-R1**, an RLVR framework for training Verilog generation LLMs, As a continuation of the work initiated with [CodeV](https://huggingface.co/collections/yang-z/codev-6698a560cd94e61a9675fa2a). First, we develop a rule-based testbench generator that performs robust equivalence checking against golden references. Second, we propose a round-trip data synthesis method that pairs open-source Verilog snippets with LLM‐generated NL descriptions, verifies code–NL–code consistency via the generated testbench, and filters out inequivalent examples to yield a high-quality dataset. Third, we employ a two-stage distill-then-RL training pipeline: distillation for the cold start of reasoning abilities, followed by adaptive DAPO, our novel RLVR algorithm that can reduce training cost by adaptively adjusting sampling rate.

This model,  **CodeV-R1-Distill-Qwen-7B**, is the model after distillation. The  RL model,  **CodeV-R1-Qwen-7B**,  is provided [here](https://huggingface.co/zhuyaoyu/CodeV-R1-Qwen-7B). For more training details, please refer to our  [paper](https://arxiv.org/abs/2505.24183).

### 2. Evaluation Results

During the evaluation phase, the maximum generation length is configured to 16,384 tokens. A temperature setting of 0.6 is applied, and 20 responses are generated per query to estimate the pass@1 score.

Our evaluation encompasses Verilog benchmarks, including VerilogEval and RTLLM. For VerilogEval v2, we examine zero-shot scenarios in both specification-to-RTL translation and code completion tasks. Concerning RTLLM, results are reported for version 1.1, which offers a broader spectrum of comparative analyses. Furthermore, we find that the acquisition of the reasoning process in Verilog problems, as facilitated by DeepSeek-R1, enhances the model's out-of-domain mathematical capabilities.

#### VerilogEval (v2)

| Model                       | Model size  | Type        | Spec-to-rtl | Completion |
| --------------------------- | ----------- | ----------- | ----------- | ---------- |
| GPT-4o                      | Undisclosed | General     | 62.5%       | 59.0%      |
| GPT-4 Turbo                 | Undisclosed | General     | 61.1%       | 53.9%      |
| GPT-4                       | Undisclosed | General     | 32.0%       | 42.3%      |
| Mistral Large               | Undisclosed | General     | 37.5%       | 34.0%      |
| Llama3.1                    | 405B        | General     | 57.2%       | 56.4%      |
| Llama3.1                    | 70B         | General     | 42.8%       | 35.3%      |
| Llama3                      | 70B         | General     | 43.9%       | 37.8%      |
| Llama2                      | 70B         | General     | 5.3%        | 1.3%       |
| Llama3.1                    | 8B          | General     | 19.1%       | 2.6%       |
| CodeLlama                   | 70B         | Coding      | 34.9%       | 37.2%      |
| DeepSeek Coder              | 33B         | Coding      | 21.7%       | 25.0%      |
| CodeGemma                   | 7B          | Coding      | 9.5%        | 8.3%       |
| DeepSeek Coder              | 6.7B        | Coding      | 29.6%       | 24.4%      |
| RTL-Coder                   | 6.7B        | Verilog RTL | 36.8%       | 35.9%      |
| **CodeV-R1-distill (ours)** | 7B          | Verilog RTL | 65.2%       | 65.5%      |
| **CodeV-R1 (ours)**         | 7B          | Verilog RTL | **68.8%**   | **69.9%**  |

### RTLLM (v1.1)

| Model                       | Model size  | Type        | Pass@1    |
| --------------------------- | ----------- | ----------- | --------- |
| GPT-4o                      | Undisclosed | General     | 33.8%     |
| GPT-3.5 Turbo               | Undisclosed | General     | 28.3%     |
| Llama3.1                    | 405B        | General     | 38.9%     |
| Nemotron-4                  | 340B        | General     | 18.9%     |
| Llama3.1                    | 8B          | General     | 19.1%     |
| CodeLlama                   | 7B          | Coding      | 17.9%     |
| CodeQwen                    | 7B          | Coding      | 24.1%     |
| Starcoder2                  | 15B         | Coding      | 15.5%     |
| DeepSeek Coder              | 6.7B        | Coding      | 23.1%     |
| DeepSeek-Coder-V2           | 16B         | Coding      | 33.1%     |
| DeepSeek-Coder-V2           | 236B        | Coding      | 34.5%     |
| RTL-Coder                   | 6.7B        | Verilog RTL | 36.8%     |
| CraftRTL                    | 6.7B        | Verilog RTL | 53.1%     |
| **CodeV-R1-distill (ours)** | 7B          | Verilog RTL | 56.2%     |
| **CodeV-R1 (ours)**         | 7B          | Verilog RTL | **72.9%** |

For RTLLM v1.1, we also plot results showing pass rate against model size.
<div style="display: flex; gap: 10px;">
 <img src="./assets/rtllm_acc_vs_model_size.png" alt="RTLLM TTS Results" width="1200">
</div>

### 4. Usage

CodeV-R1-Distill-Qwen-7B can be utilized in the same manner as Qwen or Llama models. 

For instance, you can easily start a service using [vLLM](https://github.com/vllm-project/vllm):

```bash
vllm serve zhuyaoyu/CodeV-R1-Distill-Qwen-7B --tensor-parallel-size 2 --max-model-len 16384 --enforce-eager
```

**Usage Recommendations**

During training and evaluation, we use a system prompt

```
You are a helpful assistant. The assistant first thinks about the reasoning process in the mind and then provides the user with the answer. The reasoning process and answer are enclosed within <think> </think> and<answer> </answer> tags, respectively, i.e., <think> reasoning process here </think><answer> answer here </answer>.  Now the user asks you to write verilog code. After thinking, when you finally reach a conclusion, enclose the final verilog code in ```verilog ``` within <answer> </answer> tags. i.e., <answer> ```verilog
 module top_module(in, out, ...) ... ``` </answer>.

```

It is recommended to use this prompt during inference.

### 5. License

CodeV-R1-Distill-Qwen-7B is derived from [Qwen-2.5 series](https://github.com/QwenLM/Qwen2.5), which are originally licensed under [Apache 2.0 License](https://huggingface.co/Qwen/Qwen2.5-1.5B/blob/main/LICENSE), and now finetuned with 87k samples curated with DeepSeek-R1.

### 6. Citation

If you find our model helpful, please cite our [paper](https://arxiv.org/abs/2505.24183):

```tex
@misc{zhu2025codevr1reasoningenhancedveriloggeneration,
      title={CodeV-R1: Reasoning-Enhanced Verilog Generation}, 
      author={Yaoyu Zhu and Di Huang and Hanqi Lyu and Xiaoyun Zhang and Chongxiao Li and Wenxuan Shi and Yutong Wu and Jianan Mu and Jinghua Wang and Yang Zhao and Pengwei Jin and Shuyao Cheng and Shengwen Liang and Xishan Zhang and Rui Zhang and Zidong Du and Qi Guo and Xing Hu and Yunji Chen},
      year={2025},
      eprint={2505.24183},
      archivePrefix={arXiv},
      primaryClass={cs.LG},
      url={https://arxiv.org/abs/2505.24183}, 
}
```