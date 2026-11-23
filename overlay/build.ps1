# Build mt_overlay.dll and optionally install it into the game.
#   .\build.ps1
#   .\build.ps1 -GameWin64 "D:\SteamLibrary\steamapps\common\Motor Town\MotorTown\Binaries\Win64"
param([string]$GameWin64)

$ErrorActionPreference = "Stop"
Push-Location $PSScriptRoot
try {
    cargo build --release
    $dll = Join-Path $PSScriptRoot "target\release\mt_overlay.dll"
    if ($GameWin64) {
        $dest = Join-Path $GameWin64 "ue4ss\Mods\MotorTownClientMod\overlay"
        New-Item -ItemType Directory -Force $dest | Out-Null
        Copy-Item $dll $dest -Force
        Write-Host "Installed to $dest"
    } else {
        Write-Host "Built $dll"
    }
} finally {
    Pop-Location
}
