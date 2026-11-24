#!/usr/bin/env python3
"""Fail if client Lua reintroduces a polling loop.

The native bridge removed every timer-driven Lua callback: UMG buttons use
OnClicked delegates, gamepad uses the InputKey hook, drone re-show uses the
SetHiddenInGame hook, and RP state is re-asserted by visibility/RPC hooks.
Any of these patterns means someone put the poll back.
"""
from __future__ import annotations

import pathlib
import re
import sys

ROOT = pathlib.Path(__file__).resolve().parents[1]
SCAN = [ROOT / "ClientScripts"]

BANNED = {
    "LoopInGameThreadWithDelay": "repeating Lua timer on the game thread",
    "LoopAsync": "repeating Lua timer on a background thread",
    "ExecuteInGameThreadWithDelay": "deferred Lua timer",
    "IsInputKeyDown": "gamepad/key state poll",
    ":IsPressed()": "button state poll",
}

errors: list[str] = []
for base in SCAN:
    if not base.exists():
        continue
    for path in sorted(base.rglob("*.lua")):
        text = path.read_text(encoding="utf-8", errors="replace")
        for lineno, line in enumerate(text.splitlines(), 1):
            stripped = line.strip()
            if stripped.startswith("--"):
                continue
            for token, why in BANNED.items():
                if token in line:
                    rel = path.relative_to(ROOT)
                    errors.append(f"{rel}:{lineno}: {token} ({why})")

if errors:
    print("Polling found in client Lua:")
    for e in errors:
        print("  " + e)
    sys.exit(1)

print("OK: no Lua polling loops in ClientScripts")
