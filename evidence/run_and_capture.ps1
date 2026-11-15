# Capture real PostgreSQL stdout and stderr; no fabricated results.
# Usage: ./evidence/run_and_capture.ps1 -Database library_portfolio -Portfolio portfolio-1 -Script portfolio-1-database-design/03_integrity_checks.sql
param(
  [Parameter(Mandatory)][string]$Database,
  [Parameter(Mandatory)][ValidateSet('portfolio-1','portfolio-2','portfolio-3','portfolio-4','portfolio-5')][string]$Portfolio,
  [Parameter(Mandatory)][string]$Script,
  [switch]$ExpectError
)
$ErrorActionPreference='Stop'
if (-not (Test-Path -LiteralPath $Script -PathType Leaf)) { throw "Missing script: $Script" }
if (-not (Get-Command psql -ErrorAction SilentlyContinue)) { throw 'psql not on PATH' }
$folder=Join-Path 'evidence' $Portfolio
New-Item -Type Directory -Force -Path $folder | Out-Null
$stamp=Get-Date -Format 'yyyyMMdd_HHmmss'
$file=Join-Path $folder ("{0}_{1}.txt" -f [IO.Path]::GetFileNameWithoutExtension($Script),$stamp)
"Captured UTC: $((Get-Date).ToUniversalTime().ToString('o'))`nDatabase: $Database`nScript: $Script" | Set-Content -Path $file
# The first command records server version. Tee-Object preserves original output in the evidence file.
& psql -X -v ON_ERROR_STOP=1 -d $Database -c 'SELECT version();' 2>&1 | Tee-Object -FilePath $file -Append
$versionExit=$LASTEXITCODE
if ($versionExit -ne 0) { throw "Version query failed (exit $versionExit); see $file" }
& psql -X -v ON_ERROR_STOP=1 -d $Database -f $Script 2>&1 | Tee-Object -FilePath $file -Append
$scriptExit=$LASTEXITCODE
Write-Host "Evidence saved: $file (exit=$scriptExit)"
if ($ExpectError) {
  if ($scriptExit -eq 0) { throw 'Expected error not observed; review evidence' }
  Write-Warning 'Nonzero exit observed: manually confirm exact expected SQLSTATE/error.'
} elseif ($scriptExit -ne 0) { throw "Script failed with exit $scriptExit" }
