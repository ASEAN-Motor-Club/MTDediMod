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

### Quick Lua-Only Hot Reload

For Lua-only changes (no C++ DLL rebuild), skip the full deploy cycle. SCP scripts directly to the installed directory and hit the reload endpoint:

```bash
# 1. SCP changed scripts (replace test with main server path as needed)
scp MTDediMod/Scripts/*.lua \
  root@asean-mt-server:/var/lib/motortown-server-test/MotorTown/Binaries/Win64/ue4ss/Mods/MotorTownMods/Scripts/

# 2. Hot-reload (connection resets — that's expected, mod restarts in ~5s)
curl -s -X POST http://asean-mt-server:5001/mods/reload || true
```

Players stay connected. The mod webserver restarts and re-registers all handlers. No container restart, no cache purge, no NixOS deploy needed.

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

## Test Server Networking

The test server runs inside a NixOS container (`motortown-server-test`) on a **private network** (`10.250.0.x`). The container's IP can be found via:

```bash
ssh root@asean-mt-server "machinectl list"
# → motortown-server-test  container systemd-nspawn nixos 25.05  10.250.0.2…
```

### Port Access

| Port | Service | Access Pattern |
|------|---------|---------------|
| 5000 | C++ management server (events) | Container-internal only: `curl http://10.250.0.2:5000/events` from host |
| 5001 | Lua webserver (HTTP endpoints) | Container-internal only: `curl http://10.250.0.2:5001/...` from host |

> [!CAUTION]
> The C++ management port (`MOD_MANAGEMENT_PORT`) is set to `5010` in `flake.nix` for the test server container, but the server actually binds to **port 5000** inside the private container network. The `5010` value is the environment variable — check the actual binding in `UE4SS.log`. Always query from the host via the container's private IP (`10.250.0.2:5000`), **not** via `asean-mt-server:5010` (which is unreachable from Tailscale).

### Checking events from the test server

```bash
# From your local machine (SSH to host, curl from there):
ssh root@asean-mt-server "curl -s http://10.250.0.2:5000/events" | jq '.events[]'

# For the Lua webserver:
ssh root@asean-mt-server "curl -s http://10.250.0.2:5001/players"
```

### Checking UE4SS logs

```bash
ssh root@asean-mt-server "grep 'MotorTownMods' /var/lib/motortown-server-test/MotorTown/Binaries/Win64/ue4ss/UE4SS.log | tail -20"
```

## External Mod Paks

External game content mods (`.pak` files from mod.io or elsewhere) are served from the same releases directory as MTDediMod zips. The game server downloads them at startup via `curl`.

### Upload a mod pak

```bash
scp <mod_name>.pak root@amc-peripheral:/var/lib/mod-releases/mods/
```

Files are served at `https://www.aseanmotorclub.com/releases/mods/<mod_name>.pak`.

### Enable in Nix config

In `flake.nix`, under the relevant server's `enableExternalMods`:

```nix
enableExternalMods = {
  MajasDetailWorks7_17_P = true;
  # ...
};
```

### Cache purge (when replacing a mod with an updated version)

The server caches downloaded paks in `$STATE_DIRECTORY/.mod-cache/paks/`. When replacing a pak file on the hosting server, purge the cache and restart:

```bash
ssh root@asean-mt-server "\
  rm -rf /var/lib/motortown-server/.mod-cache/paks/ && \
  rm -rf /var/lib/motortown-server-test/.mod-cache/paks/"
# Then restart the relevant server/container
```

## Version History

| Version | UE4SS | Notes |
|---------|-------|-------|
| `v12` | v4 | Legacy event server mod, includes `bcrypt.dll`, `ssl.dll` |
| `v0.20.x` | v5 | Stable releases on GitHub |
| `v0.30.0` | v5 | Last GitHub release |
| `v0.31.0-rcX` | v5 | Current RC series, hosted on aseanmotorclub.com |
