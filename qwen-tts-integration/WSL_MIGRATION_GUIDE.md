# 🚀 WSL2 Migration & Optimization Guide for Qwen3-TTS

## 1. Project Context (Previous Session Summary)

- **Goal**: Optimize Qwen3-TTS streaming performance on RTX 3060 (12GB).
- **Previous Status (Windows)**:
  - RTF (Real-Time Factor): **~3.7** (Too slow for streaming).
  - GPU Usage: Low (~35%) due to Windows OS scheduling overhead and kernel launch latency.
  - Tried: `sdpa` (Best on Win, RTF 3.25), `flash_attention_2` (Slow on Win), `torch.compile` (Failed/Overhead).
- **Current Strategy**: Migrate to **WSL2 (Ubuntu)** to unlock Linux-native optimizations.
- **Target Metrics**: RTF < **1.0** (Real-time).

## 2. Code Status

- **`api/tts_service.py`**: Already patched with specific logic for Linux/WSL.
  - `attn_implementation="flash_attention_2"` (Enabled by default on Linux).
  - `torch.compile(mode="reduce-overhead")` (Enabled by default on Linux).
  - Pipeline Streaming (Prefetching next chunk) is implemented.

## 3. 🛠️ Action Plan (Execute in Order)

Run these commands in your WSL terminal to set up the optimized environment.

### Step 1: Install Miniconda (If not installed)

```bash
mkdir -p ~/miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
~/miniconda3/bin/conda init bash
source ~/.bashrc
```

### Step 2: Create Environment & Install PyTorch (Linux-Optimized)

```bash
conda create -n qwen3 python=3.10 -y
conda activate qwen3

# Install PyTorch with CUDA 12.1 (Must be Linux version for compilation support)
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121
```

### Step 3: Install Critical Dependencies (Flash Attention 2)

This is the magic sauce that was missing on Windows.

```bash
# Install dependencies from file
pip install -r requirements.txt

# Install Flash Attention 2 (This might take a few minutes to build)
pip install flash-attn --no-build-isolation
```

### Step 4: Run Server & Verify Performance

```bash
python -m uvicorn api.main:app --host 0.0.0.0 --port 8000
```

- **Expectation**: First generation will take 1-2 mins (Compilation). Subsequent generations should have **RTF < 1.0**.

## 4. Troubleshooting

- If `flash-attn` fails to install, ensure `nvcc` is available (`sudo apt install nvidia-cuda-toolkit` might be needed, but usually Conda handles it).
- If RTF is still high, check `nvidia-smi` to ensure the process is actually using the GPU.
