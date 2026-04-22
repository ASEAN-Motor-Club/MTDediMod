---
name: mtdedimod-debugging
description: Debugging crash dumps, PDB symbols, and UE4SS Lua GC issues in MTDediMod
---

# MTDediMod Debugging

## Overview

The MTDediMod cross-compilation build pipeline produces Windows DLLs from Linux/macOS via Clang/LLD. The server runs on NixOS under Wine/Proton. UE5 generates minidumps that must be matched with PDB symbols for analysis.

## Crash Dump Analysis Workflow

### 1. Locate the latest minidump on the server

```bash
ssh root@amc-peripheral 'ls -lt /var/lib/motortown-server/MotorTown/Saved/Crashes/*/UEMinidump.dmp | head -5'
```

UE5's built-in crash reporter writes dumps to `MotorTown/Saved/Crashes/UECC-Windows-*/UEMinidump.dmp`. No custom exception filter is needed.

### 2. Copy the dump locally and identify the build

```bash
scp root@amc-peripheral:/var/lib/motortown-server/MotorTown/Saved/Crashes/.../UEMinidump.dmp /tmp/latest.dmp
ssh root@amc-peripheral 'cat /var/lib/motortown-server/.mod-cache/extracted-*/BUILD_REVISION.txt'
```

### 3. Convert PDBs to Breakpad `.sym` format

```bash
nix-shell -p dump_syms --run "dump_syms symbols-archive/<tag>/UE4SS.pdb > /tmp/UE4SS.sym"
```

### 4. Run `minidump_stackwalk`

```bash
nix-shell -p breakpad --run "minidump_stackwalk /tmp/latest.dmp symbols-archive/<tag>/"
```

This prints thread stacks. Look for `Thread 0 (crashed)` to find the faulting instruction.

### 5. Resolve symbols with the `.sym` file

```python
# Python script to resolve addresses from the .sym file
with open('/tmp/UE4SS.sym') as f:
    syms = f.read().splitlines()

funcs = []
for line in syms:
    if line.startswith('FUNC '):
        parts = line.split()
        addr = int(parts[1], 16)
        size = int(parts[2], 16)
        name = parts[4] if len(parts) > 4 else parts[3]
        funcs.append((addr, size, name))

def resolve(addr):
    for a, s, n in funcs:
        if a <= addr < a + s:
            return f'{n} + {hex(addr - a)}'
    return f'[unknown {hex(addr)}]'
```

## Known Issues

### lld-link PE debug directory bug

**Symptom**: PDBs exist and have matching GUIDs, but `minidump-stackwalk` cannot auto-match them. `minidump_dump` shows no CODEVIEW records in the module list.

**Root cause**: `lld-link` with `/DEBUG:FULL` creates valid PDBs and embeds RSDS CodeView records in the PE binary, but **fails to write the `IMAGE_DEBUG_DIRECTORY` entry** that points to the RSDS record.

**Fix**: A Python post-link patcher (`tools/patch-pe-debug-dir.py`) locates the embedded RSDS record and writes the missing `IMAGE_DEBUG_DIRECTORY` (type=2 CODEVIEW) entry. Integrated into `buildScript` and `buildClientScript` in `flake.nix` so it auto-runs after linking.

### UE4SS Lua GC corruption (luaC_checkfinalizer crash)

**Symptom**: `EXCEPTION_ACCESS_VIOLATION_READ` at `0x0` in `UE4SS.dll`, crash inside `luaC_checkfinalizer` at `lgc.c:1035`. Call stack includes:
- `convert_struct_to_lua_table`
- `UFunction::construct`
- `lua_setmetatable`
- `luaC_checkfinalizer`

**Trigger**: Heavy nested struct-to-table conversion, e.g. `/player_vehicles/*/list?complete=1` iterating through `Net_Parts` with nested TArrays.

**Root cause**: Two interacting bugs:

1. **Lua 5.4.7 weak-table + metatable GC bug** (upstream, fixed in Lua master but not 5.4.7):
   When a metatable is created on an all-weak table during the GC propagate phase, the table must be re-linked to `grayagain` so its metatable is traversed. Without this fix the GC lists become corrupted.
   
   Patch (`patches-ue4ss/lua-lgc-weak-table-metatable-fix.patch`):
   ```c
   else {  /* all weak */
     if (g->gcstate == GCSpropagate)
       linkgclist(h, g->grayagain);  /* must visit again its metatable */
     else
       linkgclist(h, g->allweak);  /* must clear collected entries */
   }
   ```

2. **UE4SS `convert_struct_to_lua_table` creates userdata via `UFunction::construct`**:
   Delegate/function properties trigger `UFunction::construct` which calls `lua_setmetatable` on fresh userdata. This is the exact path that crashes when GC lists are corrupted.
   
   Patch (`patches-ue4ss/ue4ss-skip-delegate-properties-in-struct-conversion.patch`):
   Skip delegate/function properties during struct-to-table conversion:
   ```cpp
   if (can_handle && (field->IsA<Unreal::FDelegateProperty>() ||
                      field->IsA<Unreal::FMulticastDelegateProperty>() ||
                      field->IsA<Unreal::FMulticastInlineDelegateProperty>() ||
                      field->IsA<Unreal::FMulticastSparseDelegateProperty>()))
   {
       can_handle = false;
   }
   ```

**Related upstream PRs**:
- PR #1201 "Increased stability for Lua mods" — thread safety and callback deferral, does NOT fix this GC bug directly
- PR #1130 "Exposes AsyncCompute and JSON to Lua API" — unrelated

## PDB/Symbol Management

### Every release must archive PDBs

```bash
nix run --no-update-lock-file .#archive-symbols
```

This copies `symbols/` into `symbols-archive/<git-tag>/` with `BUILD_REVISION.txt`.

### PDBs are cryptographically bound to their DLL

A new build produces a new PDB — it will **not** work for old crash dumps. You must keep archived PDBs per-release.

### LLDB quick analysis

```bash
nix run --no-update-lock-file .#analyze-crash -- /path/to/crash.dmp
```

This loads the minidump and attaches the matching PDBs for basic inspection.

## Build Pipeline Debug Flags

In `toolchain.cmake` and `setup_cross_compile.sh`:
- `/Zi` — compiler debug info (release builds)
- `/DEBUG:FULL` — linker produces full PDBs

The package scripts extract PDBs into `symbols/` (server) and `symbols-client/` (client) — these are **not** shipped in release zips.

## Deployment Target

- **Test server**: `amc-peripheral` via NixOS `deploy`
- **Production**: `asean-mt-server` via NixOS `deploy`

Both servers are accessed via Tailscale SSH.
