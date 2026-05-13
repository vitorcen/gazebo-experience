#!/bin/bash
set -e

# init.sh - 初始化 Gazebo Experience 的 Python 运行环境

# 1. 检查 Conda
if ! command -v conda &> /dev/null; then
    echo "❌ 未检测到 Conda。请先安装 Anaconda 或 Miniconda。"
    exit 1
fi

echo "🚀 开始初始化 'gazebo' Conda 环境..."

# 2. 创建环境 (Python 3.10)
# 注意：我们特意不在此环境中安装 gazebo/gz-sim 的 conda 包，
# 因为 standalone 示例的编译强依赖于系统级的 Gazebo 和库 (libfmt/spdlog)，
# 混用会导致严重的版本冲突。此环境主要用于运行 Jupyter Notebook。
if conda info --envs | grep -q "gazebo"; then
    echo "⚠️  环境 'gazebo' 已存在，跳过创建。"
else
    conda create -n gazebo python=3.10 -y
fi

# 3. 激活环境并安装 Jupyter 依赖
# 使用 source 激活（兼容性更好）
source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate gazebo

echo "📦 安装 Jupyter Lab 及相关依赖..."
pip install jupyterlab ipykernel ipywidgets

# 4. 注册 Jupyter Kernel
echo "🔗 注册 Jupyter Kernel..."
python -m ipykernel install --user --name=gazebo --display-name "Python 3 (gazebo)"

echo "
✅ 环境初始化完成！

请按以下步骤操作：
1. 激活环境：
   conda activate gazebo

2. 启动 Jupyter Lab：
   jupyter lab

3. 在打开的 Notebook 中，确保 Kernel 选择为 'Python 3 (gazebo)'。

⚠️  注意：
编译 Standalone C++ 示例时，请直接运行 ./build-standalone.sh。
该脚本会自动屏蔽 Conda 环境以避免库冲突，无需手动退出 Conda。
"
