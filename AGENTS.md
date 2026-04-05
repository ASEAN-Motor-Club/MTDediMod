# MTDediMod — Agent Guide

## Overview

**MTDediMod** is a C++ and Lua mod for Motor Town. It is built on top of [RE-UE4SS](https://github.com/ASEAN-Motor-Club/RE-UE4SS), an Unreal Engine 4 script system and mod loader.

This repository produces **two independent artifacts**:

| Artifact | Output | Proxy DLL | Source | Distribution |
|----------|--------|-----------|--------|-------------|
| **Server mod** | `MotorTownMods-package.zip` | `version.dll` | `src/`, `Scripts/`, `shared/` | Downloaded by game server at startup |
| **Client mod** | `MotorTownClientMod-package.zip` | `dwmapi.dll` | `ClientScripts/`, `shared/` | Distributed to players |

---

## Code Organization

- `src/` — C++ source code. Compiles into `MotorTownMods.dll`.
  - `dllmain.cpp`: Entry point, registers Lua functions, hooks Unreal Engine functions (e.g., Event Owner creation, Webhooks).
- `Scripts/` — **Server-side** Lua scripts loaded by UE4SS at runtime.
- `ClientScripts/` — **Client-side** Lua scripts bundled into the client mod.
- `shared/` — Shared Lua utilities used by both server and client scripts.
- `client-signatures/` — UE4SS_Signatures for Motor Town client binary.
- `types/` — Lua type annotations for server-side game APIs (for IntelliSense).
- `client-types/` — Lua type annotations for client-side game APIs.

### Dependencies
- **RE-UE4SS**: The underlying mod loader. Points to the `main` branch of the AMC fork (`ASEAN-Motor-Club/RE-UE4SS`).
- **UEPseudo**: A private submodule of RE-UE4SS. Requires valid GitHub authentication to fetch during the Nix build phase.

---

## Versioning

Server and client mods are versioned **independently** using prefixed git tags:

```
server/v0.34.0-rc5    # server mod releases
client/v0.1.0         # client mod releases
```

### When to bump what

| Change | Server tag | Client tag |
|--------|-----------|------------|
| Server Lua fix (`Scripts/`) | bump RC | no change |
| Client Lua fix (`ClientScripts/`) | no change | bump RC or patch |
| New C++ hook (`src/`) | bump minor | bump minor (if proxy DLL rebuilt) |
| Shared Lua change (`shared/`) | bump both | bump both |
| Config-only tweak | bump RC on affected side | — |

### Listing existing tags

```bash
git tag -l 'server/*' --sort=-v:refname | head -5   # Server versions
git tag -l 'client/*' --sort=-v:refname | head -5   # Client versions
```

> **Note**: Legacy tags (`v0.20.x` through `v0.34.0-rc4`) predate the split and cover server-only releases.

---

## Changelog

Every release **must** update [`CHANGELOG.md`](CHANGELOG.md) before tagging.

The changelog uses [Keep a Changelog](https://keepachangelog.com/) format with separate **Server** and **Client** sections. Each version gets a `### [tag] — YYYY-MM-DD` heading with categorized entries (Added, Changed, Fixed, Removed).

### Rules

1. Add the entry **before tagging** — the changelog update should be part of the tagged commit
2. New entries go **at the top** of their section (Server or Client)
3. One entry per tag — each tag gets exactly one version block
4. Keep descriptions concise — one line per change

---

## Development & Build Pipeline

The entire build pipeline is managed by **Nix**. It provisions the Clang compiler, downloads Windows MSVC headers (via `xwin`), and compiles the C++ codebase for the `x86_64-windows` target.

### Server Mod Build

```bash
# 1. Download MSVC headers and run CMake configuration
nix run --no-update-lock-file .#configure

# 2. Compile the C++ DLL
nix run --no-update-lock-file .#build

# 3. Package the final release zip (MotorTownMods-package.zip)
nix run --no-update-lock-file .#package
```

### Client Mod Build

```bash
# 1. Download MSVC headers and configure with dwmapi.dll proxy
nix run --no-update-lock-file .#configure-client

# 2. Cross-compile UE4SS with dwmapi.dll proxy
nix run --no-update-lock-file .#build-client

# 3. Package the client zip (MotorTownClientMod-package.zip)
nix run --no-update-lock-file .#package-client
```

The client package bundles `dwmapi.dll`, `UE4SS.dll`, client Lua scripts from `ClientScripts/`, shared Lua libraries, and `UE4SS_Signatures`. UE4SS settings are patched for client use (console + hot reload enabled).

> **Note**: The `--no-update-lock-file` flag is crucial to prevent Nix from attempting to hit the GitHub API to update locked upstream inputs (like `nixpkgs` or `flake-parts`), which can cause unnecessary authentication errors if a restricted PAT is configured system-wide.

### GitHub Actions CI

The `.github/workflows/nix-release.yml` workflow triggers on tag pushes matching `server/v*` and `client/v*`. It performs the Nix build on an Ubuntu runner.

**Authentication Note:**
Because `UEPseudo` is a private submodule of the `Re-UE4SS` organization, the Nix daemon requires authentication to fetch it. The CI uses a **Classic GitHub PAT** (with `repo` scope) passed to the Nix installer via `access-tokens = github.com=PAT`.
*Do not use a fine-grained PAT.* Fine-grained PATs are scoped to specific organizations and will cause Nix to throw HTTP 401 Unauthorized errors when it attempts to fetch public inputs (like `flake-parts`) via the GitHub API using that token.

---

## Deployment

For the full end-to-end deployment workflow (uploading, NixOS config, cache purging, server restart, client distribution), see the [mtdedimod-deploy skill](../.agents/skills/mtdedimod-deploy/SKILL.md) in the parent `amc-server` repository.
