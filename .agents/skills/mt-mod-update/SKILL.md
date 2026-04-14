# Update Motor Town External Mods

## When to use

When Motor Town releases a game update that breaks existing third-party `.pak` mods, or mod authors release new versions (e.g., Maja's Detail Works, Maja's Trailer Works).

## Prerequisites

- New `.pak` files downloaded from the mod author (typically Nexus Mods)
- SSH access to `amc-peripheral` via Tailscale

## Steps

### 1. Identify pak filenames

Extract the `.pak` files from the downloaded zip and note their exact filenames. The filename (without `.pak` extension) becomes the mod key in the NixOS config.

Example pak names:
```
MajasDetailWorksV3-7.18_P.pak     → key: "MajasDetailWorksV3-7.18_P"
MajasMnTrailerworksV6-7.18_P.pak  → key: "MajasMnTrailerworksV6-7.18_P"
```

### 2. Upload paks to amc-peripheral

The nginx on `amc-peripheral` serves `https://www.aseanmotorclub.com/releases/` from `/var/lib/mod-releases/`. The download URL is `https://www.aseanmotorclub.com/releases/mods/{name}.pak`, so paks go in the `mods/` subdirectory.

```bash
scp ~/Downloads/mt-mods/MajasDetailWorksV3-7.18_P.pak root@amc-peripheral:/var/lib/mod-releases/mods/
scp ~/Downloads/mt-mods/MajasMnTrailerworksV6-7.18_P.pak root@amc-peripheral:/var/lib/mod-releases/mods/
```

> **Note**: Upload to `amc-peripheral`, NOT `asean-mt-server`. The game server container downloads from the web URL served by amc-peripheral's nginx.

### 3. Update flake.nix

Edit `flake.nix` in the appropriate server config (test container or production). Update `enableExternalMods`:

```nix
enableExternalMods = {
  # Remove old mod names
  # Add new mod names
  "MajasDetailWorksV3-7.18_P" = true;
  "MajasMnTrailerworksV6-7.18_P" = true;
};
```

**Nix quoting rule**: Attribute names containing dashes or dots must be quoted: `"MajasDetailWorksV3-7.18_P"`.

### 4. Deploy

```bash
# For the game server (asean-mt-server)
nix develop --command deploy root@asean-mt-server
```

### 5. Verify

Check container logs for download confirmation:

```bash
ssh root@asean-mt-server "journalctl -u container@motortown-server-test -f"
```

Look for `Downloading external mod: {name}` entries. If a mod fails with HTTP 404, verify the pak exists at the correct path:

```bash
curl -I https://www.aseanmotorclub.com/releases/mods/MajasDetailWorksV3-7.18_P.pak
```

## Architecture

- **Pak hosting**: `amc-peripheral` nginx → `/var/lib/mod-releases/mods/` (bind-mounted from `/var/lib/data/mod-releases/mods/`)
- **Game server**: `asean-mt-server` container downloads paks at startup via `mods.nix` install script
- **Caching**: Downloaded paks cached at `$STATE_DIRECTORY/.mod-cache/paks/` inside the container

## Old pak cleanup

Old paks can be removed from amc-peripheral when no longer referenced:

```bash
ssh root@amc-peripheral "rm /var/lib/mod-releases/mods/MajasDetailWorks7_17_P.pak"
```
