# .\start-gpu.ps1
# .\start-gpu.ps1 -Port 8881 -NoInstall $true
param(
    [int]$Port = 8880,
    [bool]$NoInstall = $false
)

$env:PHONEMIZER_ESPEAK_LIBRARY="C:\Program Files\eSpeak NG\libespeak-ng.dll"
$env:PYTHONUTF8=1
$Env:PROJECT_ROOT="$pwd"
$Env:USE_GPU="true"
$Env:USE_ONNX="false"
$Env:PYTHONPATH="$Env:PROJECT_ROOT;$Env:PROJECT_ROOT/api"
$Env:MODEL_DIR="src/models"
$Env:VOICES_DIR="src/voices/v1_0"
$Env:WEB_PLAYER_PATH="$Env:PROJECT_ROOT/web"

if (-not $NoInstall) {
    uv pip install -e ".[gpu]"
    uv run --no-sync python docker/scripts/download_model.py --output api/src/models/v1_0
}
# uv run --no-sync uvicorn api.src.main:app --host 0.0.0.0 --port 8880
$command = "uv run --no-sync uvicorn api.src.main:app --host 0.0.0.0 --port $Port"

while ($true) {
    Write-Host "Starting Python script on port $Port..."
    $process = Start-Process -FilePath "powershell" -ArgumentList "-Command $command" -NoNewWindow -PassThru -Wait
    Write-Host "Command exited with code $($process.ExitCode). Restarting..."
    Start-Sleep -Seconds 1  # Prevents excessive rapid restarts
}