#requires -Version 5.1
<#
.SYNOPSIS
    One-click installer for the AMC MotorTownClientMod Admin build.

.DESCRIPTION
    Drive-agnostic by design: Steam is discovered from the registry and from
    every library folder listed in steamapps\libraryfolders.vdf. No filesystem
    drive letter is hardcoded anywhere in this script.

    Copies ue4ss\, the proxy DLL and the rest of the extracted package into
    <GameRoot>\MotorTown\Binaries\Win64\, while preserving the operator's
    config.json and everything under racecam\ (token, bind, saved plans).

.PARAMETER GameRoot
    Optional Steam folder, "<...>\Motor Town" folder, or exact Binaries\Win64
    folder. Skips auto-detection and the folder picker.

.PARAMETER NoPause
    Skip the final Read-Host (useful in automation).
#>
[CmdletBinding()]
param(
    [string] $GameRoot,
    [switch] $NoPause
)

$ErrorActionPreference = 'Stop'

$modFolder = 'MotorTownClientMod'
$exeName = 'MotorTown-Win64-Shipping.exe'
$sourceDir = if ($PSScriptRoot) { $PSScriptRoot } else { Split-Path -Parent $MyInvocation.MyCommand.Path }

function Get-SteamRoots {
    $roots = New-Object 'System.Collections.Generic.List[string]'

    # Registry first. HKCU: / HKLM: are PowerShell providers, not drive letters.
    foreach ($key in @(
        'HKCU:\Software\Valve\Steam\SteamPath',
        'HKLM:\SOFTWARE\WOW6432Node\Valve\Steam\SteamPath',
        'HKLM:\SOFTWARE\Valve\Steam\SteamPath'
    )) {
        try {
            $prop = Get-ItemProperty -Path $key -Name 'SteamPath' -ErrorAction Stop
            if ($prop.SteamPath -and (Test-Path -LiteralPath $prop.SteamPath -PathType Container)) {
                if (-not $roots.Contains($prop.SteamPath)) { $roots.Add($prop.SteamPath) }
            }
        } catch {
            # No Steam registry entry: library folders may still be discoverable.
        }
    }

    # Then every library path in each libraryfolders.vdf (both the modern
    # "path" key and the legacy numeric key). VDF escapes '\' as '\\'.
    foreach ($root in @($roots.ToArray())) {
        $vdf = Join-Path $root 'steamapps\libraryfolders.vdf'
        if (-not (Test-Path -LiteralPath $vdf -PathType Leaf)) { continue }
        $content = Get-Content -LiteralPath $vdf -Raw
        foreach ($match in [regex]::Matches($content, '"(?:path|\d+)"\s+"([^"]+)"')) {
            $library = $match.Groups[1].Value.Replace('\\', '\')
            if ($library -and -not $roots.Contains($library)) { $roots.Add($library) }
        }
    }
    return $roots.ToArray()
}

function Resolve-GameBinDir {
    param(
        [Parameter(Mandatory = $true)] [string] $Root,
        [switch] $RequireExe
    )
    if (-not (Test-Path -LiteralPath $Root -PathType Container)) { return $null }

    # Deepest first, so an explicit "<...>\Motor Town" resolves to its Win64
    # folder instead of being mistaken for the target itself.
    $candidates = @(
        (Join-Path $Root 'steamapps\common\Motor Town\MotorTown\Binaries\Win64'),
        (Join-Path $Root 'MotorTown\Binaries\Win64'),
        $Root
    )
    foreach ($candidate in $candidates) {
        if ((Test-Path -LiteralPath $candidate -PathType Container) -and
            (Test-Path -LiteralPath (Join-Path $candidate $exeName) -PathType Leaf)) {
            return $candidate
        }
    }
    if (-not $RequireExe) {
        foreach ($candidate in $candidates) {
            if ((Test-Path -LiteralPath $candidate -PathType Container) -and
                $candidate.EndsWith('Binaries\Win64')) {
                return $candidate
            }
        }
        return $Root
    }
    return $null
}

function Show-FolderPicker {
    param([string] $InitialPath)
    Add-Type -AssemblyName System.Windows.Forms
    $dialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $dialog.Description = 'Select the Motor Town Binaries\Win64 folder (the one with ' + $exeName + ')'
    $dialog.ShowNewFolderButton = $false
    if ($InitialPath -and (Test-Path -LiteralPath $InitialPath -PathType Container)) {
        $dialog.SelectedPath = $InitialPath
    }
    if ($dialog.ShowDialog() -ne [System.Windows.Forms.DialogResult]::OK) { return $null }
    return $dialog.SelectedPath
}

function Test-ProtectedPath {
    param([Parameter(Mandatory = $true)] [string] $Relative)
    $rel = $Relative.Replace('/', '\')
    if ($rel -ieq "ue4ss\Mods\$modFolder\config.json") { return $true }
    if ($rel.StartsWith("ue4ss\Mods\$modFolder\racecam\", [System.StringComparison]::OrdinalIgnoreCase)) {
        return $true
    }
    return $false
}

function Copy-ModTree {
    param(
        [Parameter(Mandatory = $true)] [string] $Source,
        [Parameter(Mandatory = $true)] [string] $Destination,
        [string] $RelativePrefix = ''
    )
    New-Item -ItemType Directory -Path $Destination -Force | Out-Null
    foreach ($item in (Get-ChildItem -LiteralPath $Source -Force)) {
        $relative = if ($RelativePrefix) { Join-Path $RelativePrefix $item.Name } else { $item.Name }
        $target = Join-Path $Destination $item.Name
        if ($item.PSIsContainer) {
            Copy-ModTree -Source $item.FullName -Destination $target -RelativePrefix $relative
        } elseif ((Test-ProtectedPath -Relative $relative) -and
                  (Test-Path -LiteralPath $target -PathType Leaf)) {
            Write-Host "  preserved $relative" -ForegroundColor DarkGray
        } else {
            Copy-Item -LiteralPath $item.FullName -Destination $target -Force
        }
    }
}

# ── Main ────────────────────────────────────────────────────────────────────
Write-Host 'AMC Admin Mod installer'
Write-Host "  package  : $sourceDir"

if (-not (Test-Path -LiteralPath (Join-Path $sourceDir 'ue4ss') -PathType Container)) {
    throw 'No ue4ss folder next to this script. Extract the entire Admin zip first.'
}

if ($GameRoot) {
    $targetBin = Resolve-GameBinDir -Root $GameRoot
    if (-not $targetBin) { throw "GameRoot not found: $GameRoot" }
    Write-Host "  target   : $targetBin (from -GameRoot)"
} else {
    Write-Host 'Detecting Motor Town from Steam...'
    $steamRoots = @(Get-SteamRoots)
    $installs = @()
    foreach ($root in $steamRoots) {
        $bin = Resolve-GameBinDir -Root $root -RequireExe
        if ($bin -and -not ($installs -icontains $bin)) { $installs += $bin }
    }

    if ($installs.Count -eq 1) {
        $targetBin = $installs[0]
        Write-Host "  found    : $targetBin"
    } else {
        if ($installs.Count -eq 0) {
            Write-Host '  no installation found automatically' -ForegroundColor Yellow
            $initial = if ($steamRoots.Count -gt 0) { $steamRoots[0] } else { $null }
        } else {
            Write-Host '  more than one installation found:' -ForegroundColor Yellow
            foreach ($bin in $installs) { Write-Host "    $bin" }
            $initial = $installs[0]
        }
        try {
            $picked = Show-FolderPicker -InitialPath $initial
        } catch {
            throw 'Folder picker unavailable. Re-run with -GameRoot "<path to Motor Town>".'
        }
        if (-not $picked) { throw 'Installation cancelled: no folder selected.' }
        $targetBin = Resolve-GameBinDir -Root $picked
        if (-not $targetBin) { throw "Selected folder is not a Motor Town folder: $picked" }
    }
}

if (-not (Test-Path -LiteralPath (Join-Path $targetBin $exeName) -PathType Leaf)) {
    Write-Host "  warning  : $exeName not found in $targetBin" -ForegroundColor Yellow
}

Write-Host "Installing into $targetBin"
foreach ($item in (Get-ChildItem -LiteralPath $sourceDir -Force |
                   Where-Object { $_.Name -notmatch '\.(ps1|bat)$' })) {
    if ($item.PSIsContainer) {
        Copy-ModTree -Source $item.FullName -Destination (Join-Path $targetBin $item.Name) `
                     -RelativePrefix $item.Name
        Write-Host "  copied   $($item.Name)\"
    } else {
        Copy-Item -LiteralPath $item.FullName -Destination (Join-Path $targetBin $item.Name) -Force
        Write-Host "  copied   $($item.Name)"
    }
}

# Post-install sanity checks.
if (-not (Test-Path -LiteralPath (Join-Path $targetBin 'ue4ss\UE4SS.dll') -PathType Leaf)) {
    throw 'UE4SS.dll missing after install - was the whole Admin zip extracted?'
}
$proxy = @('dwmapi.dll', 'version.dll') |
    Where-Object { Test-Path -LiteralPath (Join-Path $targetBin $_) -PathType Leaf } |
    Select-Object -First 1
if (-not $proxy) {
    Write-Host '  warning  : no proxy DLL (dwmapi.dll / version.dll) in the package' -ForegroundColor Yellow
}

Write-Host ''
Write-Host 'INSTALL OK' -ForegroundColor Green
Write-Host "  game root : $targetBin"
Write-Host "  proxy     : $proxy"
Write-Host "  preserved : ue4ss\Mods\$modFolder\config.json"
Write-Host "              ue4ss\Mods\$modFolder\racecam\ (token, bind, saved plans)"
Write-Host '  next      : start Motor Town, press Ctrl+Shift+F10, open the RaceCam panel'
Write-Host ''

if (-not $NoPause) {
    try { Read-Host 'Press Enter to close' | Out-Null } catch { }
}
