---
library_name: transformers
tags:
- verilog
- reasoning
- reinforcement-learning
- rtl
datasets:
- Nellyw888/RTL-Coder_7b_reasoning_tb
- Nellyw888/RTL-Coder_7b_reasoning_tb_simple
base_model:
- Qwen/Qwen2.5-Coder-3B
---

# VeriReason-Qwen2.5-3b-RTLCoder-Verilog-GRPO-reasoning-tb

For implementation details, visit our GitHub repository: [VeriReason](https://github.com/NellyW8/VeriReason) and our [page](https://nellyw8.github.io/VeriReason/)

Check out our paper: [VeriReason: Reinforcement Learning with Testbench Feedback for Reasoning-Enhanced Verilog Generation](https://arxiv.org/abs/2505.11849)

## Update Log
2025.05.17: Initial release of VeriReason-Qwen2.5-3B-Verilog-RTL-GRPO-reasoning-tb

## Project Description

This is the Model for the paper: VeriReason: Reinforcement Learning with Testbench Feedback for Reasoning-Enhanced Verilog Generation
This study introduces VeriReason, a novel approach utilizing reinforcement learning with testbench feedback to enhance the performance of pre-trained models for Verilog RTL code generation. VeriReason-Qwen2.5-3B is a 3B parameter model based on Qwen2.5-Coder-3B that combines supervised fine-tuning with Guided Reward Proximal Optimization (GRPO) reinforcement learning, specifically tailored for RTL code generation.

The model integrates explicit reasoning capabilities with reinforcement learning for Verilog generation, establishing a new state-of-the-art for automated RTL synthesis in a smaller model size. By using our curated high-quality training examples alongside a feedback-driven reward model, this 3B parameter model delivers exceptional performance on Verilog generation tasks while maintaining efficiency.

## Installation
To install this project, follow these steps:

1. Clone the repository: `git clone https://github.com/NellyW8/VeriReason.git`
2. Navigate to the project directory: `cd VeriReason`
3. Install the dependencies as specified in the repository

## Usage
You can use the model with the transformers library:

```python
import torch
from transformers import AutoTokenizer, AutoModelForCausalLM

model_name = "Nellyw888/VeriReason-Qwen2.5-3b-RTLCoder-Verilog-GRPO-reasoning-tb"
tokenizer = AutoTokenizer.from_pretrained(model_name)
model = AutoModelForCausalLM.from_pretrained(model_name, torch_dtype=torch.float16)
model.eval()

prompt = """
Please act as a professional verilog designer. Develop a module that implements a 8-bit comparator. The module should have two 8-bit inputs and one output. If the first input is greater than the second input, the output should be high. Otherwise, the output should be low. First, think through the design approach, considering the functionality, inputs, outputs, and implementation details. Then provide the complete Verilog code implementation. Respond in the following format: <think>
...
</think>
<answer>
```verilog
...```
</answer>
"""

input_ids = tokenizer(prompt, return_tensors="pt").input_ids
outputs = model.generate(input_ids, max_length=1024, temperature=0.2, top_p=0.95)
result = tokenizer.decode(outputs[0], skip_special_tokens=True)
print(result)
```

## Training
The GRPO (Generative Reinforcement Learning from Preference Optimization) training is based on the OpenR1 framework. For training with GRPO:

1. Move the necessary files to the OpenR1 directory:
   ```bash
   mv verilog_rewards_tb.py verilog_train_tb.py src/open-r1/
   ```
   
2. Create a directory for the Verilog recipe:
   ```bash
   mkdir verilog_recipe
   mv verilog_grpo_tb.yaml verilog_recipe/
   ```
3. Run training:
   ```bash
   NCCL_DEBUG=INFO TORCH_DISTRIBUTED_DEBUG=DETAIL CUDA_VISIBLE_DEVICES=0,1,2 ACCELERATE_USE_NCCL=1 accelerate launch --config_file recipes/accelerate_configs/zero3.yaml --num_processes=3 src/open_r1/verilog_train_rtlcoder.py --config verilog_recipe/verilog_grpo_tb.yaml --use_vllm=false
   ```

## Citation
Please cite our paper if you use our model or dataset:

```bibtex
@misc{wang2025verireasonreinforcementlearningtestbench,
      title={VeriReason: Reinforcement Learning with Testbench Feedback for Reasoning-Enhanced Verilog Generation}, 
      author={Yiting Wang and Guoheng Sun and Wanghao Ye and Gang Qu and Ang Li},
      year={2025},
      eprint={2505.11849},
      archivePrefix={arXiv},
      primaryClass={cs.AI},
      url={https://arxiv.org/abs/2505.11849}, 
}
```

## Acknowledgement
This repo benefits from OpenR1 and LLamaFactory.