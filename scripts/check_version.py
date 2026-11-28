#!/usr/bin/env python3
"""Validate MTDediMod version files and release tags.

Policy:
  * VERSION and SERVER_VERSION are plain MAJOR.MINOR.PATCH - no rc suffix.
  * A stable release tag is client/v<VERSION> or server/v<SERVER_VERSION>.
  * A prerelease tag is that stable tag plus -rcN (N >= 1). RC tags are
    deliberate previews, not the normal way to ship a change.

Usage:
  python3 scripts/check_version.py [--root DIR] [--tag TAG ...]
"""
import argparse
import re
import sys
from pathlib import Path

SEMVER = re.compile(r"^(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)$")
TAG = re.compile(r"^(client|server)/v([0-9]+\.[0-9]+\.[0-9]+)(?:-rc([1-9][0-9]*))?$")
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
        raise ValueError(f"{tag}: expected client/vX.Y.Z or server/vX.Y.Z[-rcN]")
    kind, base, rc = match.groups()
    expected = versions[kind]
    if base != expected:
        raise ValueError(f"{tag}: base version {base} != {kind} version file {expected}")
    return {"kind": kind, "version": base, "prerelease": rc is not None}


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
