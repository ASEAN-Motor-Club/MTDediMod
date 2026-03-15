# AMC Server — Agent Guide

## Overview

This is the **ASEAN Motor Club** monorepo, managing game servers, backend services, and peripheral services for Motor Town community infrastructure.

## Architecture

```
amc-server/                  # NixOS flake monorepo
├── amc-backend/             # Django backend (submodule) — API, arq worker, Discord bot
├── amc-peripheral/          # Peripheral services (submodule) — radio, Discord bots
├── motortown-server-flake/  # Motor Town game server (submodule)
├── necesse-server/          # Necesse game server (submodule)
├── eco-server/              # Eco game server (submodule)
├── machines/                # Machine-specific NixOS configurations
│   ├── asean-mt-server/     # Main server (game + backend)
│   └── amc-peripheral/      # Peripheral server (radio, sharry)
├── secrets/                 # Encrypted secrets (ragenix)
├── nix/                     # Shared Nix utilities
└── flake.nix                # Root flake wiring everything together
```

## Servers

| Hostname            | SSH Access                   | Role                                       |
|---------------------|------------------------------|---------------------------------------------|
| `asean-mt-server`   | `ssh root@asean-mt-server`   | Motor Town game server + amc-backend        |
| `amc-peripheral`    | `ssh root@amc-peripheral`    | Radio station, Sharry, peripheral Discord bots |

Both servers are accessed via **Tailscale** SSH.

## Key Subsystems

### amc-backend (inside NixOS container on `asean-mt-server`)

The backend runs inside a **NixOS container** called `amc-backend`. See [`.agents/skills/server-access/SKILL.md`](.agents/skills/server-access/SKILL.md) for access patterns.

Key services inside the container:
- `amc-backend` — Django API via uvicorn
- `amc-worker` — arq worker + Discord bot (runs together in one process)

### amc-peripheral (on `amc-peripheral` server)

Runs radio station and peripheral Discord bots as a regular systemd service.

## Deployment

Deployment is done using the `deploy` script from the root of the monorepo. The script lives in `devShells.default`, so use `nix develop`:

```bash
nix develop --command deploy root@asean-mt-server   # Deploy to main server
nix develop --command deploy root@amc-peripheral    # Deploy to peripheral server
```

The script wraps `nixos-rebuild switch` with `--override-input` to use local submodule checkouts (`amc-backend/`, `amc-peripheral/`, `motortown-server-flake/`), `--build-host` to build on the target, and `--fast` to skip evaluation caching. See [`nix/deploy.nix`](nix/deploy.nix).

## Skills

| Skill | Description |
|-------|-------------|
| [server-access](.agents/skills/server-access/SKILL.md) | SSH access, container access, and debugging on AMC servers |
| [secrets-management](.agents/skills/secrets-management/SKILL.md) | Managing ragenix-encrypted secrets |
