# OpenClaw LINE Bot Startup Script
# Run this script to start everything

Write-Host "Starting OpenClaw LINE Bot..." -ForegroundColor Cyan
Write-Host ""

# Check OpenClaw installation
Write-Host "Checking OpenClaw installation..." -ForegroundColor Yellow
if (-not (Get-Command openclaw -ErrorAction SilentlyContinue)) {
    Write-Host "OpenClaw not found! Please install first:" -ForegroundColor Red
    Write-Host "   iwr -useb https://openclaw.ai/install.ps1 | iex" -ForegroundColor White
    exit 1
}

$version = openclaw --version
Write-Host "OpenClaw $version installed" -ForegroundColor Green
Write-Host ""

# Check config file
if (-not (Test-Path "openclaw.json")) {
    Write-Host "openclaw.json not found!" -ForegroundColor Red
    Write-Host "   Please create openclaw.json with your LINE tokens" -ForegroundColor White
    exit 1
}

Write-Host "Config file found" -ForegroundColor Green
Write-Host ""

# Start OpenClaw Gateway
Write-Host "Starting OpenClaw Gateway..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "openclaw gateway --port 18789"
Start-Sleep -Seconds 3

# Start ngrok
Write-Host "Starting ngrok tunnel..." -ForegroundColor Yellow
if (Test-Path "ngrok.exe") {
    Start-Process powershell -ArgumentList "-NoExit", "-Command", ".\ngrok.exe http 18789"
    Start-Sleep -Seconds 3
} else {
    Write-Host "ngrok.exe not found in current directory" -ForegroundColor Yellow
    Write-Host "   Please start ngrok manually: ngrok http 18789" -ForegroundColor White
}

Write-Host ""
Write-Host "All services started!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "   1. Check ngrok terminal for the HTTPS URL" -ForegroundColor White
Write-Host "   2. Update LINE webhook URL: https://YOUR_NGROK_URL/line/webhook" -ForegroundColor White
Write-Host "   3. Test by sending a message in LINE" -ForegroundColor White
Write-Host ""
