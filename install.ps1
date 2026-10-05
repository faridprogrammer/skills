param(
  [switch]$DryRun
)

$ErrorActionPreference = 'Stop'
$Source = Join-Path $PSScriptRoot 'skills'
$Dest = Join-Path $HOME '.agents/skills'

if (-not (Test-Path -LiteralPath $Source)) {
  Write-Error "Source folder not found: $Source"
  exit 1
}

$skills = Get-ChildItem -LiteralPath $Source -Directory
if ($skills.Count -eq 0) { Write-Error "No skills found in $Source"; exit 1 }

if ($DryRun) {
  Write-Output "Dry run: would clean $Dest and copy $($skills.Count) skills:"
  $skills | ForEach-Object { Write-Output "  $($_.Name)" }
  exit 0
}

New-Item -ItemType Directory -Force -Path $Dest | Out-Null
Get-ChildItem -LiteralPath $Dest -Force | Remove-Item -Recurse -Force
Copy-Item -Path (Join-Path $Source '*') -Destination $Dest -Recurse -Force

Write-Output "Installed $($skills.Count) skills to $Dest"
