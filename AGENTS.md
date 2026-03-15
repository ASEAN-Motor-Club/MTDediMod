# MTDediMod — Agent Guide

## Overview

**MTDediMod** is a C++ and Lua mod for the Motor Town Dedicated Server. It is built on top of [RE-UE4SS](https://github.com/ASEAN-Motor-Club/RE-UE4SS), an Unreal Engine 4 script system and mod loader. 

This repository contains:
1. **C++ Mods** (`src/`) — Hooks into UE4 engine logic, runs a local management webserver (port `55000` / `55001`), and emits events to the AMC backend.
2. **Lua Scripts** (`Scripts/` & `shared/`) — Game logic extensions and API handlers.
3. **Nix Toolchain** (`flake.nix` & `setup_cross_compile.sh`) — A fully reproducible, zero-setup cross-compilation toolchain for building the Windows DLL from Linux or macOS.

---

## Mod Architecture

### Dependencies
- **RE-UE4SS**: The underlying mod loader. MTDediMod points to the `main` branch of the AMC fork (`ASEAN-Motor-Club/RE-UE4SS`).
- **UEPseudo**: A private submodule of RE-UE4SS. Requires valid GitHub authentication to fetch during the Nix build phase.

### Code Organization
- `src/` — The main C++ source code. Compiles into `MotorTownMods.dll`.
  - `dllmain.cpp`: Entry point, registers Lua functions, hooks Unreal Engine functions (e.g., Event Owner creation, Webhooks).
- `Scripts/` — Lua scripts loaded directly by UE4SS at runtime.
- `shared/` — Shared Lua files exposing utility functions utilized by `Scripts/`.

---

## Development & Build Pipeline

The entire build pipeline is managed by **Nix**. It provisions the Clang compiler, downloads Windows MSVC headers (via `xwin`), and compiles the C++ codebase for the `x86_64-windows` target.

### Building Locally (macOS or Linux)

You must have Nix installed with flake support.

```bash
# 1. Download MSVC headers and run CMake configuration
nix run --no-update-lock-file .#configure

# 2. Compile the C++ DLL
nix run --no-update-lock-file .#build

# 3. Package the final release zip (MotorTownMods-package.zip)
nix run --no-update-lock-file .#package
```

> **Note**: The `--no-update-lock-file` flag is crucial to prevent Nix from attempting to hit the GitHub API to update locked upstream inputs (like `nixpkgs` or `flake-parts`), which can cause unnecessary authentication errors if a restricted PAT is configured system-wide.

### GitHub Actions CI

The `.github/workflows/nix-release.yml` workflow runs on every push. It performs the exact same three Nix commands listed above on an Ubuntu runner.

**Authentication Note:** 
Because `UEPseudo` is a private submodule of the `Re-UE4SS` organization, the Nix daemon requires authentication to fetch it. The CI uses a **Classic GitHub PAT** (with `repo` scope) passed to the Nix installer via `access-tokens = github.com=PAT`. 
*Do not use a fine-grained PAT.* Fine-grained PATs are scoped to specific organizations and will cause Nix to throw HTTP 401 Unauthorized errors when it attempts to fetch public inputs (like `flake-parts`) via the GitHub API using that token.

---

## Deployment Pipeline (Self-Hosted)

We utilize a self-hosted artifact deployment model to bypass GitHub Actions release limitations and deploy quickly from local builds.

### 1. Upload Artifact
Once the zip is built locally via `nix run .#package`, `rsync` it into the Nginx hosting directory on the peripheral server:

```bash
VERSION="v0.31.0"
rsync -avz MotorTownMods-package.zip \
  root@amc-peripheral:/var/lib/mod-releases/MotorTownMods_${VERSION}.zip
```

### 2. Update `mods.nix` in amc-server
In the root `amc-server` repository, update `motortown-server-flake/mods.nix` to include the newly hosted URL. 
First, get the SRI hash of the file:
```bash
nix hash to-sri --type sha256 $(nix-prefetch-url --unpack https://www.aseanmotorclub.com/releases/MotorTownMods_${VERSION}.zip)
```
Add the block to the `motorTownModsVersions` attribute set in `mods.nix`:
```nix
    "v0.31.0" = let
      release = pkgs.fetchzip {
        url = "https://www.aseanmotorclub.com/releases/MotorTownMods_v0.31.0.zip";
        hash = "sha256-<THE_SRI_HASH>=";
        stripRoot = false;
      };
    in {
      ue4ss = release;
      mod = "${release}/ue4ss/Mods/MotorTownMods";
      shared = "${release}/ue4ss/Mods/shared";
    };
```

### 3. Deploy NixOS Server
Bump the `modVersion` in `amc-server/flake.nix` (e.g., for `motortown-server-containers-test`), and trigger a deploy:

```bash
deploy root@asean-mt-server
```

### 4. Apply the Mod
Once deployed, the `motortown-server` service container needs to be restarted to inject the new DLL and scripts:

```bash
ssh root@asean-mt-server "systemctl restart container@motortown-server-test.service"
```

Verify by listening to the UE4SS output:
```bash
ssh root@asean-mt-server
machinectl shell motortown-server-test /bin/bash -c "tail -f /var/lib/motortown-server/MotorTown/Binaries/Win64/ue4ss/UE4SS.log"
```
