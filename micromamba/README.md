# High-Performance Data Science & Machine Learning Environment

This guide provides step-by-step instructions for configuring an isolated, fully optimized data science and machine learning environment using Micromamba. It includes setup protocols for high-performance tabular manipulation, GPU-accelerated deep learning (PyTorch), and operations research solving (Gurobi). 

All terminal commands are configured for the **Fish shell**.

## 1. Micromamba Installation

Micromamba is an extremely fast, C++ based package manager. Install it based on your Linux distribution:

**For Arch Linux / CachyOS:**
```fish
yay -S micromamba-bin
micromamba shell init --shell fish --root-prefix ~/micromamba
source ~/.config/fish/config.fish

```

**For Ubuntu, Debian, or Fedora:**

```fish
curl -Ls [https://micro.mamba.pm/api/micromamba/linux-64/latest](https://micro.mamba.pm/api/micromamba/linux-64/latest) | tar -xvj bin/micromamba
sudo mv bin/micromamba /usr/local/bin/
micromamba shell init -s fish -p ~/micromamba
source ~/.config/fish/config.fish

```

## 2. Core Environment & Jupyter Registration

Create the isolated environment utilizing the `conda-forge` channel for stable, up-to-date packages.

**Create and activate the environment:**

```fish
micromamba create -n cachyds python=3.12 -c conda-forge -y
micromamba activate cachyds
```

**Install the core analytical stack and register the IDE kernel:**

```fish
micromamba install -c conda-forge numpy pandas polars scipy duckdb sqlalchemy matplotlib seaborn scikit-learn xgboost lightgbm ipykernel jupyterlab ruff fastapi streamlit dash -y

python -m ipykernel install --user --name cachyds --display-name "Python 3.12 (cachyds)"

```

## 3. PyTorch (GPU) & Gurobi Setup

To avoid C-library compilation conflicts between conda channels, install specialized mathematical and hardware-accelerated binaries directly via `pip`.

**PyTorch with CUDA 12.4 Acceleration:**

```fish
python -m pip install torch torchvision torchaudio --index-url [https://download.pytorch.org/whl/cu124](https://download.pytorch.org/whl/cu124)

```

**Gurobi Optimizer & License Configuration:**

```fish
python -m pip install gurobipy

# Move downloaded license to a clean, hidden configuration folder
mkdir -p ~/.config/gurobi
mv ~/Downloads/gurobi.lic ~/.config/gurobi/gurobi.lic

# Set universal Fish variable to point to the license
set -Ux GRB_LICENSE_FILE ~/.config/gurobi/gurobi.lic

```

**Verify System Integrity:**
Run this script to confirm GPU detection and Gurobi license authentication:

```fish
python -c '
import torch
import gurobipy as gp
from gurobipy import GRB

print("\n--- System Diagnostics ---")
print(f"PyTorch Version: {torch.__version__}")
print(f"GPU Detected: {torch.cuda.get_device_name(0) if torch.cuda.is_available() else "None"}")

print("\n--- Gurobi Diagnostics ---")
try:
    m = gp.Model("test")
    m.Params.LogToConsole = 0
    x, y = m.addVar(vtype=GRB.BINARY), m.addVar(vtype=GRB.BINARY)
    m.setObjective(x + y, GRB.MAXIMIZE)
    m.addConstr(x + 2 * y <= 2)
    m.optimize()
    print(f"Gurobi Status: SUCCESS (Objective Value: {m.objVal})")
except gp.GurobiError as e:
    print(f"Gurobi Error: {e}")
'

```

## 4. Environment Backup & Restoration

Keep a portable blueprint of this environment without system-specific build hashes to ensure cross-compatibility.

**Export the environment to a YAML file:**

```fish
mkdir -p ~/.config/micromamba_envs
micromamba env export -n cachyds --no-builds > ~/.config/micromamba_envs/cachyds.yml

```

**Restore or rebuild the environment on a new machine:**

```fish
micromamba env create -f ~/.config/micromamba_envs/cachyds.yml

```

