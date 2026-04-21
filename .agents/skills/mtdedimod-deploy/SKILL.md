---
name: mtdedimod-deploy
description: Building, packaging, and deploying MTDediMod releases (server and client mods)
---

# MTDediMod Deployment

## Overview

MTDediMod is the UE4SS C++ mod for Motor Town. The repo produces **two independent artifacts**:

| Artifact | Tag prefix | Source | Proxy DLL | Distribution |
|----------|-----------|--------|-----------|-------------|
| **Server mod** (`MotorTownMods-package.zip`) | `server/v*` | `src/`, `Scripts/`, `shared/` | `version.dll` | Downloaded by game server at startup via `curl` |
| **Client mod** (`MotorTownClientMod-package.zip`) | `client/v*` | `ClientScripts/`, `shared/` | `dwmapi.dll` | Distributed to players (manual install / Discord) |

Each artifact has **independent semver** — a server hotfix does not bump the client version and vice versa.

> [!IMPORTANT]
> Every deploy — test or production — **must** have a corresponding git commit and tag. Do not build from a dirty tree. Do not reuse version numbers with different code.

---

## Versioning

### Tag scheme

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

### Experimental tags

Exploratory builds that live on `exp/*` branches and are **never promoted to production**. The pattern is:

```
server/v<version>-exp.<topic>.<N>
```

- **`<version>`** — the target base version (what it would become if merged to `main`)
- **`<topic>`** — short slug identifying the experiment branch (e.g. `cargo-rewrite`, `live-fuel`)
- **`<N>`** — sequential build number within that experiment

Examples:

```
server/v0.35.0-exp.cargo-rewrite.1     # branch: exp/cargo-rewrite
server/v0.35.0-exp.live-fuel.1         # branch: exp/live-fuel
server/v0.35.0-exp.live-fuel.2         # second iteration of same experiment
```

Rules:
- Experimental tags live on `exp/*` branches, **not** `main`
- They are never promoted to production — when the experiment is ready, squash/cherry-pick onto `main` and tag as `-rc1` (fresh sequence)
- Different branches never collide — the topic slug is unique per experiment
- If two experiments both make it to `main`, the second one bumps to `0.36.0-rc1`
- Experimental tags can be deleted later (`git tag -d` + `git push origin :refs/tags/...`)
- Changelog entries for experimental builds are optional but if used, go under an `### Experimental` subsection

### Listing existing tags

```bash
cd MTDediMod
git tag -l 'server/*' --sort=-v:refname | head -5   # Server versions
git tag -l 'client/*' --sort=-v:refname | head -5   # Client versions
```

> [!NOTE]
> Legacy tags (`v0.20.x` through `v0.34.0-rc4`) predate the split and cover server-only releases.

---

## Changelog

Every release **must** update [`CHANGELOG.md`](../../../MTDediMod/CHANGELOG.md) before tagging.

### Format

The changelog uses [Keep a Changelog](https://keepachangelog.com/) format with separate `## Server` and `## Client` sections. Each version entry goes under its respective section:

```markdown
## Server

### [server/v0.35.0-rc1] — 2026-04-10

#### Added
- New webhook endpoint for cargo events

#### Fixed
- Race condition in player teleport handler

---

## Client

### [client/v0.2.0] — 2026-04-10

#### Added
- New keybind for quick vehicle spawn

#### Changed
- Improved gamepad shortcut responsiveness
```

### Categories

Use these categories (omit empty ones):
- **Added** — new features or endpoints
- **Changed** — modifications to existing behavior
- **Fixed** — bug fixes
- **Removed** — removed features or endpoints
- **Security** — security-related changes

### Rules

1. **Add the entry before tagging** — the changelog update should be part of the tagged commit or an earlier commit in the same release
2. **New entries go at the top** of their section (Server or Client), right after the `## Server` / `## Client` heading
3. **One entry per tag** — each tag gets exactly one `### [tag] — date` block
4. **Use the tag as the heading** — e.g. `### [server/v0.35.0-rc1] — 2026-04-10`
5. **Date format** — `YYYY-MM-DD`
6. **Keep descriptions concise** — one line per change, written from a user/operator perspective

---

## Server Mod Release Workflow

### 1. Commit all changes

All changes must be committed before building. The tree must be clean.

```bash
cd MTDediMod
git status  # Must show "nothing to commit, working tree clean"
```

### 2. Tag the next server version

```bash
git tag -l 'server/*' --sort=-v:refname | head -5
# Example: server/v0.34.0-rc4 → Next: server/v0.34.0-rc5

git tag server/v0.34.0-rc5
```

### 3. Build the mod (C++ changes only)

From the `MTDediMod` directory, check if C++ sources changed since the previous server tag. Only run the build if they did — Lua-only changes skip this step.

```bash
cd MTDediMod

PREV_TAG=$(git tag -l 'server/*' --sort=-v:refname | sed -n '2p')
git diff --name-only "$PREV_TAG" HEAD | grep -q '^src/' && nix run .#build || echo "No C++ changes, skipping build"
```

> [!WARNING]
> If you see `warning: Git tree is dirty`, **stop**. Go back to step 1. Building from a dirty tree means the zip won't match the tag.

### 4. Package the zip

```bash
cd MTDediMod
nix run .#package
# Output: MotorTownMods-package.zip
```

This automatically:
- Bundles `version.dll`, `UE4SS.dll`, mod DLL, Lua scripts, shared deps
- Downloads legacy Lua binaries (luasocket, cjson, mime) from the v0.30.0 release via a Nix `fetchzip` derivation
- Patches UE4SS settings for production (disables console/debug GUI)

### 5. Upload to the release server

```bash
scp MotorTownMods-package.zip root@amc-peripheral:/var/lib/mod-releases/MotorTownMods_server-v0.34.0-rc5.zip
```

Mod zips are served from `/var/lib/mod-releases/` on `amc-peripheral` (via nginx at `aseanmotorclub.com/releases/`). Both the main server and test server download mods at startup via `curl` from this URL.

### 6. Set the version in Nix config

In the root `flake.nix`, update the `modVersion` for the **target server only**:

```nix
# Test server — update this for test deploys
modVersion = "server-v0.34.0-rc5";

# Main server (in nixosModules.motortown-server) — update separately when promoting
modVersion = "server-v0.33.0-rc7";
```

**No hash calculation needed** — the mod is downloaded at runtime via `curl` during service `preStart`.

### 7. Deploy and restart

```bash
# From amc-server root (inside nix develop or with direnv)
deploy root@amc-peripheral    # Test server
deploy root@asean-mt-server   # Main server (when promoting)
```

Then purge the old cache and restart:

```bash
# 1. Remove cached zip AND extracted directory for the OLD version
ssh root@amc-peripheral "\
  rm -f  /var/lib/motortown-server/.mod-cache/MotorTownMods_server-v0.34.0-rc4.zip && \
  rm -rf /var/lib/motortown-server/.mod-cache/extracted-server-v0.34.0-rc4"

# 2. Fix version.dll ownership if it was previously written by root
#    (the steam user can't overwrite a root-owned file)
ssh root@amc-peripheral "\
  chown steam:modders /var/lib/motortown-server/MotorTown/Binaries/Win64/version.dll 2>/dev/null || true"

# 3. Restart the service (this triggers preStart → download → extract → launch)
ssh root@amc-peripheral "systemctl restart motortown-server"

# 4. Wait ~20s for the game server to boot, then check UE4SS logs
ssh root@amc-peripheral "tail -n 50 /var/lib/motortown-server/MotorTown/Binaries/Win64/ue4ss/UE4SS.log | grep MotorTownMods"
```

> **Common pitfall:** If you manually `unzip` a mod package into the game directory as root (e.g. during debugging), the `version.dll` file ends up owned by `root:root`. The `steam` user cannot overwrite it during `preStart`, causing repeated `Permission denied` failures. Always fix ownership with step 2 above, or avoid manual extraction.

**Success indicators:**
- `INFO: Webserver listening to host 0.0.0.0 on port XXXXX`
- `INFO: Mod loaded`
- No `ERROR` lines about missing modules

### 8. Push the tag

After verifying the deploy is healthy:

```bash
cd MTDediMod
git push origin server/v0.34.0-rc5
```

### Promoting to production

When a test RC is validated and ready for the main server:

1. Update `modVersion` in the main server section of `flake.nix` to match the tested RC version
2. `deploy root@asean-mt-server`
3. Purge the old main server cache and restart:
   ```bash
   ssh root@asean-mt-server "\
     rm -f  /var/lib/motortown-server/.mod-cache/MotorTownMods_server-v0.34.0-rc4.zip && \
     rm -rf /var/lib/motortown-server/.mod-cache/extracted-server-v0.34.0-rc4"
   ssh root@asean-mt-server "systemctl restart motortown-server"
   ```
4. No new tag needed — the RC tag already tracks the code

---

## Experimental Server Release Workflow

For exploratory builds on `exp/*` branches that are **not** destined for production.

### 1. Create an experiment branch

```bash
cd MTDediMod
git checkout -b exp/cargo-rewrite
```

### 2. Commit changes and tag

```bash
git add -A && git commit
git tag server/v0.35.0-exp.cargo-rewrite.1
```

### 3. Build and package (same as normal server release)

```bash
cd MTDediMod

PREV_TAG=$(git tag -l 'server/*' --sort=-v:refname | sed -n '2p')
git diff --name-only "$PREV_TAG" HEAD | grep -q '^src/' && nix run .#build || echo "No C++ changes, skipping build"

nix run .#package
```

### 4. Upload to the release server

```bash
scp MotorTownMods-package.zip root@amc-peripheral:/var/lib/mod-releases/MotorTownMods_server-v0.35.0-exp.cargo-rewrite.1.zip
```

### 5. Set the version in Nix config (test server only)

```nix
modVersion = "server-v0.35.0-exp.cargo-rewrite.1";
```

### 6. Deploy and restart (test server only)

```bash
deploy root@amc-peripheral
# Then purge cache and restart as usual (see Server Mod Release Workflow step 7)
```

### 7. Push the branch and tag

```bash
git push -u origin exp/cargo-rewrite
git push origin server/v0.35.0-exp.cargo-rewrite.1
```

### Iterating on the same experiment

Subsequent builds increment the sequence number:

```bash
cd MTDediMod

git tag server/v0.35.0-exp.cargo-rewrite.2

PREV_TAG=$(git tag -l 'server/*' --sort=-v:refname | sed -n '2p')
git diff --name-only "$PREV_TAG" HEAD | grep -q '^src/' && nix run .#build || echo "No C++ changes, skipping build"
nix run .#package

scp MotorTownMods-package.zip root@amc-peripheral:/var/lib/mod-releases/MotorTownMods_server-v0.35.0-exp.cargo-rewrite.2.zip
# Update modVersion in flake.nix, deploy, restart
```

### Promoting an experiment to production

When the experiment is ready:

1. Squash or cherry-pick onto `main`
2. Tag as `-rc1` on `main`: `git tag server/v0.35.0-rc1`
3. Build, package, and follow the normal Server Mod Release Workflow
4. Delete the experimental branch and tags if desired

---

## Client Mod Release Workflow

### 1. Commit all changes

Same as server — tree must be clean.

### 2. Tag the next client version

```bash
git tag -l 'client/*' --sort=-v:refname | head -5
# Example: client/v0.1.0 → Next: client/v0.2.0

git tag client/v0.2.0
```

### 3. Build the client mod (C++ changes only)

From the `MTDediMod` directory, check if C++ sources changed since the previous client tag. Only run the build if they did.

```bash
cd MTDediMod

PREV_TAG=$(git tag -l 'client/*' --sort=-v:refname | sed -n '2p')
git diff --name-only "$PREV_TAG" HEAD | grep -q '^src/' && nix run .#build-client || echo "No C++ changes, skipping build"
```

### 4. Package the client zip

```bash
cd MTDediMod
nix run .#package-client
# Output: MotorTownClientMod-package.zip
```

This automatically:
- Bundles `dwmapi.dll` (proxy), `UE4SS.dll`, Lua scripts from `ClientScripts/`, shared deps
- Copies `UE4SS_Signatures` for Motor Town client
- Patches UE4SS settings for client use (console + hot reload enabled)

### 5. Distribute

Upload to the releases server for player download:

```bash
scp MotorTownClientMod-package.zip \
  root@amc-peripheral:/var/lib/mod-releases/MotorTownClientMod_client-v0.2.0.zip
```

The zip is then available at `https://www.aseanmotorclub.com/releases/MotorTownClientMod_client-v0.2.0.zip`.

Share the download link with players (e.g. via Discord announcement).

### 6. Push the tag

```bash
cd MTDediMod
git push origin client/v0.2.0
```

---

## Dual Release (both mods changed)

When a commit touches both server and client code (e.g. changes in `shared/`):

1. Commit and clean the tree
2. Tag **both**: `git tag server/v0.35.0-rc1 && git tag client/v0.2.0`
3. Build and package both from the `MTDediMod` directory:
   ```bash
   cd MTDediMod

   PREV_SERVER=$(git tag -l 'server/*' --sort=-v:refname | sed -n '2p')
   git diff --name-only "$PREV_SERVER" HEAD | grep -q '^src/' && nix run .#build || echo "No C++ changes, skipping server build"
   nix run .#package

   PREV_CLIENT=$(git tag -l 'client/*' --sort=-v:refname | sed -n '2p')
   git diff --name-only "$PREV_CLIENT" HEAD | grep -q '^src/' && nix run .#build-client || echo "No C++ changes, skipping client build"
   nix run .#package-client
   ```
4. Upload and deploy each artifact via its respective workflow above
5. Push both tags: `git push origin server/v0.35.0-rc1 client/v0.2.0`

---

## Quick Lua-Only Hot Reload (debugging only)

> [!CAUTION]
> Hot reload is for **live debugging only**. If the fix is good, commit → tag → deploy properly before calling it done. Untracked hot reloads create ghost versions that can't be reproduced.

### Server-side hot reload

For Lua-only changes (no C++ DLL rebuild), skip the full deploy cycle. SCP scripts directly to the installed directory and hit the reload endpoint:

```bash
# 1. SCP changed scripts (test server on amc-peripheral)
scp MTDediMod/Scripts/*.lua \
  root@amc-peripheral:/var/lib/motortown-server/MotorTown/Binaries/Win64/ue4ss/Mods/MotorTownMods/Scripts/

# 2. Hot-reload (connection resets — that's expected, mod restarts in ~5s)
ssh root@amc-peripheral "curl -s -X POST http://localhost:5001/mods/reload"
```

> [!WARNING]
> For the **main server** on `asean-mt-server`, use `root@asean-mt-server` and `/var/lib/motortown-server/` paths. Never call the main server's mod port directly from your local machine — always SSH to the host first.

Players stay connected. The mod webserver restarts and re-registers all handlers. No service restart, no cache purge, no NixOS deploy needed.

### Client-side hot reload

Client mods support UE4SS hot reload via `Ctrl+R` in-game (enabled in client UE4SS settings). For testing:

1. Copy updated scripts to the player's local install directory
2. Press `Ctrl+R` in-game to reload

**After hot-reload debugging:** If the changes are keepers, go back and do a proper versioned release.

---

## GitHub Actions CI

The `.github/workflows/nix-release.yml` workflow triggers on tag pushes matching `v*`. This will need updating to support the new `server/v*` and `client/v*` prefixes:

```yaml
on:
  push:
    tags:
      - 'server/v*'
      - 'client/v*'
```

Currently, CI only builds the **server** mod. A separate job or conditional matrix will be needed if client builds should also be automated via CI.

---

## How Runtime Download Works

`mods.nix` generates an `install-mt-mods` script that runs in systemd `preStart`:

1. Resolves `modVersion` to a download URL:
   - `v0.2*` → GitHub releases (`github.com/ASEAN-Motor-Club/MTDediMod/releases/`)
   - Everything else → `aseanmotorclub.com/releases/`
   - `"dev"` → Skips download, uses bind mount from `/var/lib/mtdedimod-dev/ue4ss`
2. Downloads and caches the zip in `$STATE_DIRECTORY/.mod-cache/`
3. Extracts and installs into the game directory

## File Locations on Server

| Server | Host | State Directory |
|--------|------|-----------------|
| Test server | `amc-peripheral` | `/var/lib/motortown-server/` |
| Main server | `asean-mt-server` | `/var/lib/motortown-server/` |

Common subdirectories (under state directory):

| Path | Description |
|------|-------------|
| `MotorTown/Binaries/Win64/ue4ss/` | Installed UE4SS + mod files |
| `MotorTown/Binaries/Win64/ue4ss/UE4SS.log` | UE4SS log file |
| `.mod-cache/` | Cached mod downloads |

## Test Server Access

The test server runs directly on `amc-peripheral` (bare-metal, no container).

### Port Access

| Port | Service | Access Pattern |
|------|---------|---------------|
| 5000 | C++ management server (events) | `ssh root@amc-peripheral "curl -s http://localhost:5000/events"` |
| 5001 | Lua webserver (HTTP endpoints) | `ssh root@amc-peripheral "curl -s http://localhost:5001/..."` |

### Checking events from the test server

```bash
# From your local machine (SSH to host):
ssh root@amc-peripheral "curl -s http://localhost:5000/events" | jq '.events[]'

# For the Lua webserver:
ssh root@amc-peripheral "curl -s http://localhost:5001/players"
```

### Checking UE4SS logs

```bash
ssh root@amc-peripheral "grep 'MotorTownMods' /var/lib/motortown-server/MotorTown/Binaries/Win64/ue4ss/UE4SS.log | tail -20"
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
ssh root@amc-peripheral "rm -rf /var/lib/motortown-server/.mod-cache/paks/"
ssh root@asean-mt-server "rm -rf /var/lib/motortown-server/.mod-cache/paks/"
# Then restart the relevant server
```

## Game Server API Reference

The Motor Town game server exposes a native HTTP API (port 8081, password configured via `HostWebAPIServerPassword` in `DedicatedServerConfig`). All endpoints accept a `password` query parameter.

### Checking delivery points and storage (recipes)

Use `/delivery/sites` to inspect delivery point inventory, production, and cargo types. This is useful for verifying new recipes, mod pak changes, or storage configs.

```bash
# All delivery sites (verbose)
ssh root@amc-peripheral 'curl -s "http://localhost:8081/delivery/sites?password=" | python3 -m json.tool'

# Find a specific site by name
ssh root@amc-peripheral 'curl -s "http://localhost:8081/delivery/sites?password=" | python3 -c "
import json, sys
data = json.load(sys.stdin)
for site in data.get(\"data\", {}).values():
    name = site.get(\"name\", \"\")
    if \"copper\" in name.lower():
        print(f\"=== {name} ===\")
        print(json.dumps(site, indent=2))
"'

# Check output inventory (production) at a site
ssh root@amc-peripheral 'curl -s "http://localhost:8081/delivery/sites?password=" | python3 -c "
import json, sys
data = json.load(sys.stdin)
for site in data.get(\"data\", {}).values():
    output = site.get(\"OutputInventory\", {})
    if output:
        name = site.get(\"name\", \"\")
        for slot in output.values():
            cargo = slot.get(\"cargo\", {})
            print(f\"{name}: {slot.get(\\\"amount\\\", 0)}x {cargo.get(\\\"name\\\", \\\"?\\\")} ({cargo.get(\\\"cargo_key\\\", \\\"?\\\")})\")
"'

# Check input inventory (requirements) at a site
ssh root@amc-peripheral 'curl -s "http://localhost:8081/delivery/sites?password=" | python3 -c "
import json, sys
data = json.load(sys.stdin)
for site in data.get(\"data\", {}).values():
    inp = site.get(\"InputInventory\", {})
    if inp:
        name = site.get(\"name\", \"\")
        for slot in inp.values():
            cargo = slot.get(\"cargo\", {})
            print(f\"{name}: needs {slot.get(\\\"amount\\\", 0)}x {cargo.get(\\\"name\\\", \\\"?\\\")} ({cargo.get(\\\"cargo_key\\\", \\\"?\\\")})\")
"'
```

Key fields in `/delivery/sites` response:

| Field | Description |
|-------|-------------|
| `name` | Delivery point display name (e.g. "Copper Mine -G") |
| `guid` | Unique identifier for the site |
| `Deliveries` | Active delivery missions from this site |
| `InputInventory` | Items the site consumes (production inputs) |
| `OutputInventory` | Items the site produces (with current `amount` and `capacity`) |
| `OutputInventory[].cargo.cargo_key` | Internal cargo key (e.g. `"Moonshine"`, `"CopperOre"`) |
| `OutputInventory[].amount` | Current stock of that cargo type |
| `OutputInventory[].cargo.spawn_probability` | Likely a production chance (0–10 scale) |

### Other useful endpoints

```bash
# Player list (native API)
ssh root@amc-peripheral 'curl -s "http://localhost:8081/player/list?password=" | python3 -m json.tool'

# Mod API (port 5001) - delivery points with more detail
ssh root@amc-peripheral 'curl -s "http://localhost:5001/delivery/points" | python3 -m json.tool'

# Player vehicles and cargo
ssh root@amc-peripheral 'curl -s "http://localhost:5001/players" | python3 -m json.tool'
```

For the **main server** on `asean-mt-server`, replace `localhost:8081` with `localhost:8080` and `localhost:5001` with `localhost:5001` (same ports, different host).

## Version History

| Version | UE4SS | Notes |
|---------|-------|-------|
| `v12` | v4 | Legacy event server mod, includes `bcrypt.dll`, `ssl.dll` |
| `v0.20.x` | v5 | Stable releases on GitHub |
| `v0.30.0` | v5 | Last GitHub release |
| `v0.31.0+` | v5 | Hosted on aseanmotorclub.com (legacy `v*` tags) |
| `server/v0.34.0-rc5` | v5 | First tag under new `server/` prefix scheme |
| `client/v0.1.0` | v5 | First tag under new `client/` prefix scheme |
| `server/v0.35.0-exp.cargo-rewrite.1` | v5 | First experimental tag (example) |
