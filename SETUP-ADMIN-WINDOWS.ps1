# Creates or updates the private admin user locally. Does not save your password to a text file.
$ErrorActionPreference = 'Stop'
Set-Location -LiteralPath $PSScriptRoot
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
  Write-Host 'Node.js 22.13+ is required. Install from https://nodejs.org/' -ForegroundColor Red
  exit 1
}
$envPath = Join-Path $PSScriptRoot 'backend\.env'
if (-not (Test-Path -LiteralPath $envPath)) {
  $envExample = Get-Content -LiteralPath (Join-Path $PSScriptRoot 'backend\.env.example') -Raw
  $bytes = New-Object byte[] 32
  $rng = [Security.Cryptography.RandomNumberGenerator]::Create()
  try { $rng.GetBytes($bytes) } finally { $rng.Dispose() }
  $secret = ([BitConverter]::ToString($bytes)).Replace("-", "")
  $envExample = $envExample -replace 'JWT_SECRET=GENERATE_A_RANDOM_SECRET_OF_AT_LEAST_32_CHARACTERS', ('JWT_SECRET='+$secret)
  [System.IO.File]::WriteAllText($envPath, $envExample, (New-Object System.Text.UTF8Encoding $false))
}
$email = (Read-Host 'Admin email address').Trim().ToLowerInvariant()
$securePassword = Read-Host 'Admin password (minimum 12 characters, not shown)' -AsSecureString
$bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword)
try {
  $env:ADMIN_EMAIL = $email
  $env:ADMIN_PASSWORD = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
  & node backend/createAdmin.js
  if ($LASTEXITCODE -ne 0) { Write-Host 'Admin creation failed. Check the error above.' -ForegroundColor Red; exit 1 }
  Write-Host 'SUCCESS! Open http://localhost:5000/admin.html after starting the website.' -ForegroundColor Green
} finally {
  [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)
  Remove-Item Env:ADMIN_PASSWORD -ErrorAction SilentlyContinue
  Remove-Item Env:ADMIN_EMAIL -ErrorAction SilentlyContinue
}
