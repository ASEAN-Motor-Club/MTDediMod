# net-deps placeholder

This directory is the flake's `netdeps` input: the network-dependency
cache consumed by the PURE `MotorTownMods-dll` / `MotorTownClientMod-dll`
builds (xwin MSVC SDK, CMake FetchContent dirs, cargo-vendored crates).

The committed contents are intentionally just this README. To generate
the real cache:

```bash
nix run --no-update-lock-file --override-input ue4ss "path:<ue4ss-src>" .#regen-net-deps
```

CI (`.github/workflows/nix-release.yml`, `nix-client-release.yml`) caches
it per UE4SS rev and passes it via
`--override-input netdeps "path:..."`. Only regenerate when the UE4SS
rev, toolchain, or third-party deps change.
