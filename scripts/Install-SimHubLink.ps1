#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Points SimHub's copy of this dashboard at the repo with a directory junction.

.DESCRIPTION
    SimHub loads and saves dashboards in <SimHub>\DashTemplates\<name>\. Replacing that folder with a
    junction to src\<name> makes the Dash Studio editor save straight into this repo.

    Safe to re-run: an existing junction to this repo is left alone. A real folder is moved to
    $HOME\SimHub-DashBackups\<name>-<timestamp> (never deleted) before the junction is created.
    Admin rights are needed only because DashTemplates sits under Program Files.

.EXAMPLE
    .\scripts\Install-SimHubLink.ps1
#>
[CmdletBinding()]
param(
    [string]$SimHubPath = 'C:\Program Files (x86)\SimHub',
    [string]$DashboardName = 'Trucker Information'
)

$ErrorActionPreference = 'Stop'

$source = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..\src\$DashboardName")).Path
$templates = Join-Path $SimHubPath 'DashTemplates'
$target = Join-Path $templates $DashboardName

if (-not (Test-Path -LiteralPath $templates -PathType Container)) {
    throw "SimHub DashTemplates folder not found at '$templates'. Pass -SimHubPath."
}

# SimHub keeps the dashboard open and rewrites it; moving the folder underneath it can lose edits.
if (Get-Process -Name 'SimHubWPF' -ErrorAction SilentlyContinue) {
    throw 'SimHub is running. Close it first, then re-run this script.'
}

$existing = Get-Item -LiteralPath $target -Force -ErrorAction SilentlyContinue
if ($existing -and $existing.LinkType -eq 'Junction') {
    $current = @($existing.Target)[0]
    if ($current.TrimEnd('\') -ieq $source.TrimEnd('\')) {
        Write-Host "Already linked: $target -> $source" -ForegroundColor Green
        return
    }
    throw "'$target' is already a junction to '$current'. Remove it by hand if you want to relink."
}

if ($existing) {
    $backupRoot = Join-Path $HOME 'SimHub-DashBackups'
    New-Item -ItemType Directory -Force -Path $backupRoot | Out-Null
    $backup = Join-Path $backupRoot "$DashboardName-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
    Move-Item -LiteralPath $target -Destination $backup
    Write-Host "Moved SimHub's copy to: $backup" -ForegroundColor Yellow
}

New-Item -ItemType Junction -Path $target -Target $source | Out-Null
Write-Host "Linked: $target -> $source" -ForegroundColor Green
