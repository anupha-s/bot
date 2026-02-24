# OpenClaw LINE Bot Stop Script
# Run this script to stop everything

Write-Host "Stopping OpenClaw LINE Bot..." -ForegroundColor Cyan
Write-Host ""

# Stop OpenClaw Gateway
Write-Host "Stopping OpenClaw Gateway..." -ForegroundColor Yellow
Get-Process | Where-Object {$_.ProcessName -eq "node" -and $_.CommandLine -like "*openclaw*gateway*"} | Stop-Process -Force
Write-Host "Gateway stopped" -ForegroundColor Green

# Stop ngrok
Write-Host "Stopping ngrok..." -ForegroundColor Yellow
Get-Process | Where-Object {$_.ProcessName -eq "ngrok"} | Stop-Process -Force
Write-Host "ngrok stopped" -ForegroundColor Green

Write-Host ""
Write-Host "All services stopped!" -ForegroundColor Green
Write-Host ""
