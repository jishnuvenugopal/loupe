# Third-party material

This repository contains material from other projects. Each item keeps its own licence. My own code and text are under [Apache-2.0](LICENSE).

No model weights are in this repository. It holds model cards, configuration files, prompts, generated Verilog and scores.

## Benchmarks

| Project | What is here | Licence |
|---|---|---|
| [RTLLM](https://github.com/hkust-zhiyao/RTLLM) v2.1 at `51ed553` | Task texts in `prompts/`; some reference designs inside the blind packets in `results/main/blind40/packet/` | MIT (text below) |
| [VerilogEval](https://github.com/NVlabs/verilog-eval) v2 at `c498220` | Task texts in `prompts/`; some reference designs inside the blind packets in `results/main/blind40/packet/` | MIT (text below) |

## Models

| Model | What is here | Licence |
|---|---|---|
| `Qwen/Qwen2.5-Coder-7B-Instruct`, `Qwen/Qwen2.5-Coder-1.5B-Instruct` | Cards in `models/cards/`, generated outputs | Apache-2.0 (copy in each card folder) |
| `Qwen/Qwen2.5-Coder-3B`, `Qwen/Qwen2.5-Coder-3B-Instruct` | Cards in `models/cards/`, generated outputs of the 3B-Instruct model | Qwen Research License (non-commercial: research or evaluation only). Copy in each card folder |
| `zhuyaoyu/CodeV-R1-Distill-Qwen-7B` | Card files, generated outputs | `apache-2.0` tag on the model card |
| `zhuyaoyu/CodeV-R1-RL-Qwen-7B` | Card files, generated outputs | No licence file on the model repository (checked 17 Oct 2026). The card says that the model derives from Qwen-2.5 (Apache-2.0) |
| `Nellyw888/VeriReason-Qwen2.5-3b-RTLCoder-Verilog-GRPO-reasoning-tb`, `Nellyw888/Qwen2.5-3b-sft-reasoning` | Card files, generated outputs of the GRPO model | No licence tag on the card. The base is the research-licensed Qwen 3B, so treat these outputs as research-only |

Notice required by the Qwen Research License:

"Qwen is licensed under the Qwen RESEARCH LICENSE AGREEMENT, Copyright (c) Alibaba Cloud. All Rights Reserved."

The outputs of the 3B models in this repository are for research and evaluation only.

## Training data (GRPO test)

The GRPO test read `Nellyw888/VeriReason-RTL-Coder_7b_reasoning_tb` at revision `42823db` (`train_tb_filtered.jsonl`). This repository holds only row indices (`grpo/heldout_indices.txt`), not the dataset.

## Tools (not redistributed)

Yosys, SymbiYosys, Icarus Verilog and Verilator came from `oss-cad-suite-linux-arm64-20261016`. Generation used the NVIDIA vLLM container and TRL. These tools are not in this repository.

## RTLLM licence

```
MIT License

Copyright (c) 2024 Nora Lu

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```

## VerilogEval licence

```
MIT License

Copyright (c) 2023-2024 NVIDIA Research Projects

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.


This project contains code from human-eval (https://github.com/openai/human-eval/).

The MIT License

Copyright (c) OpenAI (https://openai.com)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```
