#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "==> Running Lua type checker on $PROJECT_DIR..."

# Check if lua-language-server is available
if ! command -v lua-language-server &> /dev/null; then
    echo "Error: lua-language-server not found in PATH"
    echo "Run 'nix develop' to enter the dev shell with lua-language-server"
    exit 1
fi

# Verify types/ue4ss symlink exists
if [ ! -L "$PROJECT_DIR/types/ue4ss" ]; then
    echo "Warning: types/ue4ss symlink not found"
    echo "Run 'nix develop' to create it"
fi

# Run type checking
lua-language-server --check "$PROJECT_DIR" --checklevel Error --configpath "$PROJECT_DIR/.luarc.json"

# Check if report was generated
LOG_PATH="${XDG_CACHE_HOME:-$HOME/.cache}/lua-language-server/log"
REPORT="$LOG_PATH/check.json"

if [[ -f "$REPORT" ]]; then
    # Check if there are any diagnostics
    DIAGNOSTIC_COUNT=$(jq 'length' "$REPORT" 2>/dev/null || echo "0")
    if [[ "$DIAGNOSTIC_COUNT" -gt 0 ]]; then
        echo "⚠ Found $DIAGNOSTIC_COUNT diagnostic(s):"
        jq -r '.[] | "\(.uri):\(.range.start.line): \(.message)"' "$REPORT" | head -20
        exit 1
    else
        echo "✓ No type errors found"
    fi
else
    echo "✓ Type check completed (no report generated = no issues)"
fi
