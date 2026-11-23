#!/usr/bin/env python3
"""Enforce the client release tag policy.

A plain ``client/vX.Y.Z`` tag may only point at a commit that has been merged
into master. An unmerged commit must use ``client/vX.Y.Z-hotfixN`` (or the bare
``-hotfix`` suffix). The VERSION file must contain the base X.Y.Z in both cases.

Used by .github/workflows/nix-client-release.yml and runnable locally:

    python3 scripts/check_client_tag.py --tag client/v0.6.0 --sha HEAD
    python3 scripts/check_client_tag.py --tag client/v0.6.1-hotfix1 --sha HEAD
"""

from __future__ import annotations

import argparse
import re
import subprocess
import sys
from pathlib import Path

TAG_RE = re.compile(r"^client/v(\d+\.\d+\.\d+)(?:-hotfix\d*)?$")


def git(*args: str, cwd: Path) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        ["git", *args], cwd=cwd, text=True, capture_output=True, check=False
    )


def parse_args() -> argparse.Namespace:
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--tag", required=True, help="full tag name, e.g. client/v0.6.0")
    p.add_argument("--sha", required=True, help="commit the tag points at")
    p.add_argument("--version-file", default="VERSION")
    p.add_argument("--master-ref", default="origin/master")
    p.add_argument("--repo", default=".", help="repository working tree")
    p.add_argument(
        "--fetch",
        action="store_true",
        help="fetch the master ref before the ancestry check (CI uses this)",
    )
    return p.parse_args()


def main() -> int:
    a = parse_args()
    repo = Path(a.repo).resolve()
    version = a.version_file and (repo / a.version_file).read_text(
        encoding="utf-8"
    ).strip()
    if not version:
        print(f"ERROR: {a.version_file} is empty", file=sys.stderr)
        return 1

    m = TAG_RE.match(a.tag)
    if not m:
        print(
            f"ERROR: tag '{a.tag}' is not client/v<SEMVER> or "
            "client/v<SEMVER>-hotfix<N>",
            file=sys.stderr,
        )
        return 1
    base, hotfix = m.group(1), "-hotfix" in a.tag
    if version != base:
        print(
            f"ERROR: tag '{a.tag}' base version {base} != VERSION '{version}'",
            file=sys.stderr,
        )
        return 1

    if hotfix:
        print(f"OK: {a.tag} is a hotfix tag; merge into master is not required")
        return 0

    if a.fetch:
        fetch = git("fetch", "origin", "master", "--no-tags", cwd=repo)
        if fetch.returncode != 0:
            print(f"ERROR: git fetch failed: {fetch.stderr.strip()}", file=sys.stderr)
            return 1

    resolved = git("rev-parse", "--verify", a.master_ref, cwd=repo)
    if resolved.returncode != 0:
        print(f"ERROR: cannot resolve {a.master_ref}", file=sys.stderr)
        return 1

    ancestor = git(
        "merge-base", "--is-ancestor", a.sha, a.master_ref, cwd=repo
    )
    if ancestor.returncode != 0:
        print(
            f"ERROR: {a.tag} points at {a.sha}, which is NOT merged into "
            f"{a.master_ref}. Merge the PR into master first, or retag as "
            f"client/v{version}-hotfix1.",
            file=sys.stderr,
        )
        return 1

    print(f"OK: {a.tag} points at {a.sha}, merged into {a.master_ref}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
