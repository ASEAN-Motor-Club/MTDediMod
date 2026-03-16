---
name: mtdedimod-deploy
description: Building, packaging, and deploying MTDediMod releases to the Motor Town game servers
---

# MTDediMod Deployment

## Overview

MTDediMod is the UE4SS C++ mod for Motor Town dedicated servers. Releases are packaged as zips and served via HTTP — the game server downloads them at startup via `curl`.

## Release Workflow

### 1. Build the mod (from `MTDediMod/`)

```bash
cd MTDediMod
nix run .#configure   # First time only — downloads MSVC headers via xwin
nix run .#build       # Cross-compiles the C++ mod DLL
```

### 2. Package the zip

```bash
nix run .#package
# Output: MotorTownMods-package.zip
```

This automatically:
- Bundles `version.dll`, `UE4SS.dll`, mod DLL, Lua scripts, shared deps
- Downloads legacy Lua binaries (luasocket, cjson, mime) from the v0.30.0 release via a Nix `fetchzip` derivation
- Patches UE4SS settings for production (disables console/debug GUI)

### 3. Upload to the release server

```bash
scp MotorTownMods-package.zip root@asean-mt-server:/var/lib/mod-releases/MotorTownMods_vX.Y.Z.zip
```

Mod zips are served locally from `/var/lib/mod-releases/` on `asean-mt-server`. Containers access this via a read-only bind mount; the main server service accesses it directly.

### 4. Set the version in Nix config

In the root `flake.nix`, update the `modVersion` for the target container:

```nix
# Test server
modVersion = "vX.Y.Z";

# Main server (in nixosModules.motortown-server)
modVersion = "vX.Y.Z";
```

**No hash calculation needed** — the mod is downloaded at runtime via `curl` during service `preStart`.

### 5. Deploy

```bash
# From amc-server root (inside nix develop or with direnv)
deploy root@asean-mt-server
```

### 6. Purge the mod cache and restart

The container downloads and caches the mod zip at startup. When updating to a new version, or replacing the zip for the same version tag, you **must** purge the cache on the host so the container re-downloads / re-extracts:

```bash
# 1. Remove cached zip AND extracted directory (replace test/vX.Y.Z as needed)
ssh root@asean-mt-server "\
  rm -f  /var/lib/motortown-server-test/.mod-cache/MotorTownMods_vX.Y.Z.zip && \
  rm -rf /var/lib/motortown-server-test/.mod-cache/extracted-vX.Y.Z"

# 2. Fix version.dll ownership if it was previously written by root
#    (the container's steam user can't overwrite a root-owned file)
ssh root@asean-mt-server "\
  chown steam:nscd /var/lib/motortown-server-test/MotorTown/Binaries/Win64/version.dll 2>/dev/null || true"

# 3. Restart the container (this triggers preStart → download → extract → launch)
ssh root@asean-mt-server "systemctl restart container@motortown-server-test.service"

# 4. Wait ~20s for the game server to boot, then check UE4SS logs
ssh root@asean-mt-server "tail -n 50 /var/lib/motortown-server-test/MotorTown/Binaries/Win64/ue4ss/UE4SS.log | grep MotorTownMods"
```

> **Common pitfall:** If you manually `unzip` a mod package into the game directory as root (e.g. during debugging), the `version.dll` file ends up owned by `root:root`. The container's `steam` user cannot overwrite it during `preStart`, causing repeated `Permission denied` failures. Always fix ownership with step 2 above, or avoid manual extraction.

**Success indicators:**
- `INFO: Webserver listening to host 0.0.0.0 on port XXXXX`
- `INFO: Mod loaded`
- No `ERROR` lines about missing modules

## How Runtime Download Works

`mods.nix` generates an `install-mt-mods` script that runs in systemd `preStart`:

1. Resolves `modVersion` to a download URL:
   - `v0.2*` → GitHub releases (`github.com/ASEAN-Motor-Club/MTDediMod/releases/`)
   - Everything else → `aseanmotorclub.com/releases/`
   - `"dev"` → Skips download, uses bind mount from `/var/lib/mtdedimod-dev/ue4ss`
2. Downloads and caches the zip in `$STATE_DIRECTORY/.mod-cache/`
3. Extracts and installs into the game directory

## File Locations on Server

| Path | Description |
|------|-------------|
| `/var/lib/motortown-server-test/` | Test server state directory |
| `/var/lib/motortown-server/` | Main server state directory |
| `…/MotorTown/Binaries/Win64/ue4ss/` | Installed UE4SS + mod files |
| `…/MotorTown/Binaries/Win64/ue4ss/UE4SS.log` | UE4SS log file |
| `…/.mod-cache/` | Cached mod downloads |

## Version History

| Version | UE4SS | Notes |
|---------|-------|-------|
| `v12` | v4 | Legacy event server mod, includes `bcrypt.dll`, `ssl.dll` |
| `v0.20.x` | v5 | Stable releases on GitHub |
| `v0.30.0` | v5 | Last GitHub release |
| `v0.31.0-rcX` | v5 | Current RC series, hosted on aseanmotorclub.com |
