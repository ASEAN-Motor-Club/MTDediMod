#!/usr/bin/env python3
"""Fail if any LoopInGameThreadWithDelay callback can be garbage-collected.

UE4SS 3.0.1 frees loop callbacks that do not `return true`. A freed callback
that still fires is a native crash which pcall cannot catch, and the only
warning is `[FCallbackGarbageCollector] Freed invalid callbacks!` in UE4SS.log.

Usage:
    python3 scripts/check_lua_loop_callbacks.py ClientScripts
"""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

LOOP = re.compile(r"LoopInGameThreadWithDelay\s*\(")
RETURN = re.compile(r"\breturn\b(?!\s*true\b)")


def check_file(path: Path) -> list[str]:
    lines = path.read_text(encoding="utf-8", errors="replace").splitlines()
    problems: list[str] = []
    for idx, line in enumerate(lines):
        if not LOOP.search(line):
            continue
        indent = len(line) - len(line.lstrip())
        end_re = re.compile(rf"^{' ' * indent}end\)")
        body: list[tuple[int, str]] = []
        for j in range(idx + 1, len(lines)):
            if end_re.match(lines[j]):
                break
            body.append((j + 1, lines[j]))
        else:
            problems.append(f"{path}:{idx + 1}: unterminated loop callback")
            continue
        bare = [(n, s.strip()) for n, s in body if RETURN.search(s)]
        if bare:
            n, text = bare[0]
            problems.append(
                f"{path}:{idx + 1}: callback has bare return at line {n}: {text}"
            )
        if not any(re.search(r"\breturn\s+true\b", s) for _, s in body):
            problems.append(
                f"{path}:{idx + 1}: callback never returns true "
                "(UE4SS callback GC will free it)"
            )
    return problems


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("paths", nargs="+", help="Lua files or directories to scan")
    a = ap.parse_args()

    files: list[Path] = []
    for raw in a.paths:
        p = Path(raw)
        files.extend(sorted(p.rglob("*.lua")) if p.is_dir() else [p])

    problems: list[str] = []
    for f in files:
        problems.extend(check_file(f))

    if problems:
        print("Loop callback check FAILED:", file=sys.stderr)
        for line in problems:
            print(f"  {line}", file=sys.stderr)
        return 1
    print(f"Loop callback check OK: {len(files)} Lua file(s)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
