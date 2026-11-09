# Run from extracted project: powershell -NoProfile -ExecutionPolicy Bypass -File .\SETUP-GEMINI-WINDOWS.ps1
# Stores your OWN Google AI Studio API key locally, server-side only.
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$envPath = Join-Path $root 'backend\.env'
$samplePath = Join-Path $root 'backend\.env.example'
if (-not (Test-Path -LiteralPath $envPath)) { Copy-Item -LiteralPath $samplePath -Destination $envPath }
Write-Host "First create an API key at https://aistudio.google.com/api-keys" -ForegroundColor Cyan
Write-Host 'The key will NOT display on the screen and is saved only in backend\.env.'
$secure = Read-Host 'Paste your Gemini API key' -AsSecureString
$bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
try { $key = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr) }
finally { [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr) }
if ($key -notmatch '^[A-Za-z0-9_-]{20,250}$') {
  Write-Error 'Invalid key format. No key saved.'
  exit 1
}
$content = Get-Content -LiteralPath $envPath -Raw
if ($content -match '(?m)^#?\s*GEMINI_API_KEY=') {
  $content = [regex]::Replace($content,'(?m)^#?\s*GEMINI_API_KEY=.*$',('GEMINI_API_KEY=' + $key))
} else { $content += "`r`nGEMINI_API_KEY=$key`r`n" }
[System.IO.File]::WriteAllText($envPath, $content, (New-Object System.Text.UTF8Encoding $false))
$key = $null
Write-Host 'Saved in backend\.env. Restart npm start to activate AI responses.' -ForegroundColor Green
Write-Host 'DO NOT upload or share backend\.env (contains a private key).'
