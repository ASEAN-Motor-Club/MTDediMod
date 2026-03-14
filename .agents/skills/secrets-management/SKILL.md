---
name: secrets-management
description: Managing ragenix-encrypted secrets in the AMC monorepo
---

# Secrets Management

## Overview

Secrets are stored as ragenix-encrypted `.age` files in the `secrets/` directory. Plaintext `.env` files exist alongside their `.age` counterparts for editing convenience.

## Secret Files

| Plaintext | Encrypted | Used by |
|-----------|-----------|---------|
| `peripheral-bots.env` | `peripheral-bots.age` | `amc-peripheral` systemd service |
| `backend.age` | — | `amc-backend` NixOS container |

## Re-encrypting After Edits

After modifying a plaintext secrets file, re-encrypt it from the `secrets/` directory:

```bash
cd secrets
cat peripheral-bots.env | ragenix --editor - -e peripheral-bots.age
```

This pipes the plaintext into ragenix as the "editor" input, re-encrypting in place.

> [!IMPORTANT]
> You must re-encrypt before deploying. The NixOS service reads the `.age` file, not the plaintext `.env`.

## How Secrets Are Injected

Secrets flow through: `ragenix .age file` → NixOS `age.secrets` → systemd `EnvironmentFile` → Python `os.environ.get()`.

For `amc-peripheral`, this is configured in `flake.nix`:

```nix
age.secrets.peripheral-bots = {
  file = ./secrets/peripheral-bots.age;
  mode = "400";
};
services.amc-peripheral = {
  environmentFile = config.age.secrets.peripheral-bots.path;
};
```
