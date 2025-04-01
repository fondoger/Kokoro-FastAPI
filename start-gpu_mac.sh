#!/bin/bash

# ./start-gpu.sh
# ./start-gpu.sh 8881
PORT=${1:-8880}

# Get project root directory
PROJECT_ROOT=$(pwd)

# Set other environment variables
export USE_GPU=true
export USE_ONNX=false
export PYTHONPATH=$PROJECT_ROOT:$PROJECT_ROOT/api
export MODEL_DIR=src/models
export VOICES_DIR=src/voices/v1_0
export WEB_PLAYER_PATH=$PROJECT_ROOT/web

export DEVICE_TYPE=mps
# Enable MPS fallback for unsupported operations
export PYTORCH_ENABLE_MPS_FALLBACK=1

# Run FastAPI with GPU extras using uv run
uv pip install -e .
#uv run --no-sync python docker/scripts/download_model.py --output api/src/models/v1_0
#uv run --no-sync uvicorn api.src.main:app --host 0.0.0.0 --port 8880
command="uv run --no-sync uvicorn api.src.main:app --host 0.0.0.0 --port $PORT"

while true; do
    echo "Starting Python script on port $PORT..."
    $command
    exit_code=$?
    echo "Command exited with code $exit_code. Restarting..."
    sleep 2  # Prevents excessive rapid restarts
done