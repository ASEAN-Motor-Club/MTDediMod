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

## Debugging Crash Dumps

The cross-compilation build pipeline generates **PDB debug symbols** for every C++ build, enabling crash-dump analysis on Linux/macOS without Visual Studio.

### How it works

- **Compiler flag** `/Zi` — embeds debug info in object files (Release builds)
- **Linker flag** `/DEBUG:FULL` — produces `.pdb` files next to every `.dll`
- **PE debug directory patcher** (`tools/patch-pe-debug-dir.py`) — `lld-link` creates valid PDBs but fails to write the `IMAGE_DEBUG_DIRECTORY` entry; the patcher fixes this post-link so minidumps contain matching CV records
- **Package scripts** copy PDBs to local `symbols/` (server) and `symbols-client/` (client) directories; they are **not** shipped in release zips

### Quick analysis with `minidump_stackwalk`

The `breakpad` package provides `minidump_stackwalk` and `minidump_dump`:

```bash
# Find latest dump on server
ssh root@amc-peripheral 'ls -lt /var/lib/motortown-server/MotorTown/Saved/Crashes/*/UEMinidump.dmp | head -5'

# Copy locally
scp root@amc-peripheral:.../UEMinidump.dmp /tmp/latest.dmp

# Generate Breakpad .sym from PDB
nix-shell -p dump_syms --run "dump_syms symbols-archive/<tag>/UE4SS.pdb > /tmp/UE4SS.sym"

# Run stackwalk
nix-shell -p breakpad --run "minidump_stackwalk /tmp/latest.dmp symbols-archive/<tag>/"
```

Look for `Thread 0 (crashed)` to find the faulting instruction. The `.sym` file resolves function names and source lines.

### Quick analysis with LLDB

The dev shell includes `lldb`, which can read Windows minidumps directly:

```bash
nix run --no-update-lock-file .#analyze-crash -- /path/to/crash.dmp
```

This loads the minidump and attaches `MotorTownMods.dll` + its PDB for basic inspection.

### Important: PDBs must match the crashing build exactly

A PDB is cryptographically bound to its DLL by a GUID + age stamp generated at link time. A new build produces a new PDB — it **will not work** for an old crash dump. You must archive PDBs for every release so you can debug historical crashes.

### Archiving symbols per release

After packaging, archive the PDBs with the current git tag:

```bash
nix run --no-update-lock-file .#archive-symbols
```

This copies `symbols/` and `symbols-client/` into `symbols-archive/<git-tag>/` and records the exact git revision. When a crash arrives, use the matching tag's PDB.

### Prerequisites

1. Build and package the mod so PDBs are generated:
   ```bash
   nix run --no-update-lock-file .#configure
   nix run --no-update-lock-file .#build
   nix run --no-update-lock-file .#package
   ```
2. Archive the symbols:
   ```bash
   nix run --no-update-lock-file .#archive-symbols
   ```
3. Verify PDBs exist in `symbols/` or `symbols-archive/<tag>/` before analyzing a dump.

---

## Known Issues

### lld-link PE debug directory bug

`lld-link` with `/DEBUG:FULL` creates valid PDBs and embeds RSDS CodeView records in the PE binary, but **fails to write the `IMAGE_DEBUG_DIRECTORY` entry** that points to the RSDS record. This means:
- PDBs exist and have matching GUIDs to the DLLs
- The DLL contains the RSDS record with the GUID
- But the PE header's debug directory is empty/all-zero
- UE5's crash reporter writes minidumps that **lack CV records** (no GUIDs in the module list)
- `minidump-stackwalk` and LLDB cannot auto-match PDBs to modules in the dump

**Fix**: `tools/patch-pe-debug-dir.py` locates the embedded RSDS record and writes the missing `IMAGE_DEBUG_DIRECTORY` (type=2 CODEVIEW) entry. Integrated into `buildScript` and `buildClientScript` in `flake.nix` so it auto-runs after `cmake --build`.

### UE4SS Lua GC corruption (luaC_checkfinalizer crash)

**Symptom**: `EXCEPTION_ACCESS_VIOLATION_READ` at `0x0` in `UE4SS.dll`, crash inside `luaC_checkfinalizer` at `lgc.c:1035`. Call stack includes `convert_struct_to_lua_table` → `UFunction::construct` → `lua_setmetatable` → `luaC_checkfinalizer`.

**Trigger**: Heavy nested struct-to-table conversion, e.g. `/player_vehicles/*/list?complete=1` iterating through `Net_Parts` with nested TArrays.

**Root cause**: Two interacting bugs:

1. **Lua 5.4.7 weak-table + metatable GC bug** (upstream, fixed in Lua master but not 5.4.7):
   When a metatable is created on an all-weak table during the GC propagate phase, the table must be re-linked to `grayagain` so its metatable is traversed. Without this the GC lists become corrupted.
   
   Fix: `patches-ue4ss/lua-lgc-weak-table-metatable-fix.patch`

2. **UE4SS `convert_struct_to_lua_table` creates userdata via `UFunction::construct`**:
   Delegate/function properties trigger `UFunction::construct` which calls `lua_setmetatable` on fresh userdata. This is the exact path that crashes when GC lists are corrupted.
   
   Fix: `patches-ue4ss/ue4ss-skip-delegate-properties-in-struct-conversion.patch` — skips delegate/function properties during struct-to-table conversion.

**Related upstream PRs**:
- PR #1201 "Increased stability for Lua mods" — thread safety and callback deferral, does NOT fix this GC bug directly
- PR #1130 "Exposes AsyncCompute and JSON to Lua API" — unrelated

## Deployment

For the full end-to-end deployment workflow (uploading, NixOS config, cache purging, server restart, client distribution), see the [mtdedimod-deploy skill](../.agents/skills/mtdedimod-deploy/SKILL.md) in the parent `amc-server` repository.
