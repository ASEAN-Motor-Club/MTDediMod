#!/usr/bin/env python3
"""Validate MTDediMod version files and release tags.

Policy:
  * VERSION and SERVER_VERSION are plain MAJOR.MINOR.PATCH — no prerelease suffix.
  * A stable release tag is client/v<VERSION> or server/v<SERVER_VERSION>.
  * A prerelease tag is client/vX.Y.Z-rcN, -rc.N, or -exp.<name>.<N> (N >= 1).
    Prerelease tags are manual branch previews, never the default release path,
    and may target a next version not yet bumped in VERSION / SERVER_VERSION.

Usage:
  python3 scripts/check_version.py [--root DIR] [--tag TAG ...]
"""
import argparse
import re
import sys
from pathlib import Path

SEMVER = re.compile(r"^(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)$")
TAG = re.compile(
    r"^(client|server)/v((?:0|[1-9][0-9]*)\.(?:0|[1-9][0-9]*)\.(?:0|[1-9][0-9]*))"
    r"(?:-((?:rc\.?[1-9][0-9]*)|(?:exp\.[a-z0-9][a-z0-9-]*\.[1-9][0-9]*)))?$"
)
VERSION_FILES = {"client": "VERSION", "server": "SERVER_VERSION"}


def read_version(root: Path, name: str) -> str:
    raw = (root / name).read_text(encoding="utf-8").strip()
    if not SEMVER.fullmatch(raw):
        raise ValueError(f"{name}: expected MAJOR.MINOR.PATCH, got {raw!r}")
    return raw


def read_versions(root: Path) -> dict:
    return {kind: read_version(root, name) for kind, name in VERSION_FILES.items()}


def check_tag(tag: str, versions: dict) -> dict:
    match = TAG.fullmatch(tag)
    if not match:
        raise ValueError(
            f"{tag}: expected (client|server)/vX.Y.Z or -rc[.N] / -exp.<name>.<N>"
        )
    kind, base, pre = match.groups()
    prerelease = pre is not None
    expected = versions[kind]
    if not prerelease and base != expected:
        raise ValueError(
            f"{tag}: stable tag version {base} != {kind} version file {expected}"
        )
    return {
        "kind": kind,
        "version": f"{base}-{pre}" if prerelease else base,
        "base": base,
        "prerelease": prerelease,
    }


def main(argv=None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", default=".", help="repository root (default: cwd)")
    parser.add_argument("--tag", action="append", default=[], help="release tag to validate")
    args = parser.parse_args(argv)

    root = Path(args.root)
    try:
        versions = read_versions(root)
        for kind in ("client", "server"):
            print(f"{VERSION_FILES[kind]}={versions[kind]}")
        for tag in args.tag:
            result = check_tag(tag, versions)
            suffix = " (prerelease)" if result["prerelease"] else ""
            print(f"tag {tag}: ok{suffix}")
    except (OSError, ValueError) as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
