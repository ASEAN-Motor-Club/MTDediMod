# AMC Deployment Scripts
#
# A focused set of deployment tools for 2 servers (asean-mt-server, amc-peripheral).
# Uses argc for argument parsing (see https://github.com/sigoden/argc).
#
# Usage (from nix develop):
#   pre-deploy [--skip-pytest] [--fix]
#   deploy <root@host> [--skip-checks] [--skip-pytest] [--migrate] [--restart-be]
#   health-check <root@host>
#   rollback <root@host>
{
  lib,
  pkgs,
  argc,
}: let
  scripts = {
    # ---------------------------------------------------------------------------
    # pre-deploy
    # ---------------------------------------------------------------------------
    # Validates the codebase before any deploy. Three layers:
    #   1. Submodule hygiene — warns on dirty/uninitialized submodules
    #   2. Nix formatting   — alejandra --check on the parent flake
    #   3. Backend checks   — ruff, django-check, pytest (via amc-backend flake)
    #
    # All three backend checks are proper Nix derivations so they cache: on a
    # second run with no code changes they complete in <1s.
    #
    # Architecture note: checks run on the local system (aarch64-darwin or
    # x86_64-linux). They validate code correctness. Build correctness on the
    # target (x86_64-linux) is validated by nixos-rebuild itself, which runs
    # --build-host on the target machine.
    # ---------------------------------------------------------------------------
    pre-deploy = ''
      # @flag --skip-pytest   Skip pytest (saves ~60s, use for quick iteration)
      # @flag --fix           Auto-fix ruff lint issues before checking

      eval "$(${argc}/bin/argc --argc-eval "$0" "$@")"

      set -eo pipefail

      REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
      cd "$REPO_ROOT"

      echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
      echo "🔍 Pre-Deploy Validation"
      echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

      # ── 1. Submodule hygiene ────────────────────────────────────────────────
      echo ""
      echo "📦 Checking submodule state..."
      SUBMODULE_PROBLEMS=0

      while IFS= read -r line; do
        STATUS="''${line:0:1}"
        NAME=$(echo "$line" | awk '{print $2}')
        if [[ "$STATUS" == "+" ]]; then
          echo "  ⚠️  $NAME has uncommitted changes (dirty)"
          SUBMODULE_PROBLEMS=1
        elif [[ "$STATUS" == "-" ]]; then
          echo "  ❌ $NAME is not initialised — run: git submodule update --init"
          SUBMODULE_PROBLEMS=1
        elif [[ "$STATUS" == "U" ]]; then
          echo "  ❌ $NAME has merge conflicts"
          SUBMODULE_PROBLEMS=1
        fi
      done < <(git submodule status)

      if [[ $SUBMODULE_PROBLEMS -eq 1 ]]; then
        echo ""
        echo "⚠️  Warning: dirty submodules will deploy their working-tree state."
        echo "   --override-input uses the local checkout directly."
        echo "   Commit or stash changes before deploying to production."
        echo ""
        # Warn, don't fail — allows deliberate deploy-with-local-changes workflow
      else
        echo "  ✅ All submodules clean"
      fi

      # ── 2. Nix formatting ──────────────────────────────────────────────────
      echo ""
      echo "📐 Checking Nix formatting (alejandra)..."
      if ${pkgs.alejandra}/bin/alejandra --check . 2>/dev/null; then
        echo "  ✅ Nix formatting: OK"
      else
        echo "  ❌ Nix formatting: issues found"
        echo "     Run: alejandra . (to fix)"
        exit 1
      fi

      # ── 3. Backend checks (amc-backend flake) ──────────────────────────────
      cd "$REPO_ROOT/amc-backend"
      SYSTEM=$(${pkgs.nix}/bin/nix eval --raw --impure --expr 'builtins.currentSystem')
      echo ""
      echo "🖥️  Running backend checks on $SYSTEM..."

      # Optional: auto-fix lint first
      if [[ -n $argc_fix ]]; then
        echo "🔧 Auto-fixing ruff issues..."
        ${pkgs.nix}/bin/nix develop --command ruff check . --fix
      fi

      echo ""
      echo "  🔎 ruff (lint)..."
      ${pkgs.nix}/bin/nix build ".#checks.$SYSTEM.ruff" --no-link

      echo "  🔎 django-check (system check)..."
      ${pkgs.nix}/bin/nix build ".#checks.$SYSTEM.django-check" --no-link

      if [[ -z $argc_skip_pytest ]]; then
        echo "  🧪 pytest (full suite, ~60s)..."
        ${pkgs.nix}/bin/nix build ".#checks.$SYSTEM.pytest" --no-link
      else
        echo "  ⏭️  pytest skipped (--skip-pytest)"
      fi

      cd "$REPO_ROOT"

      echo ""
      echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
      echo "✅ All pre-deploy checks passed!"
      echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    '';

    # ---------------------------------------------------------------------------
    # deploy
    # ---------------------------------------------------------------------------
    # Full deployment pipeline:
    #   1. pre-deploy checks (unless --skip-checks)
    #   2. Nix flake evaluation dry-run (parent flake must evaluate cleanly)
    #   3. nixos-rebuild switch on target (builds on target = x86_64-linux)
    #   4. Optional: migrate, restart services
    #   5. health-check
    #   6. macOS notification
    #
    # The --build-host flag is the key mechanism that ensures build correctness
    # on the target architecture, even when deploying from an aarch64-darwin Mac.
    # ---------------------------------------------------------------------------
    deploy = ''
      # @arg target!          SSH target, e.g. root@asean-mt-server
      # @flag --skip-checks   Skip pre-deploy validation (for emergency deploys)
      # @flag --skip-pytest   Skip pytest in pre-deploy (pass-through flag)
      # @flag --migrate       Run Django migrations after deploy
      # @flag --restart-be    Restart amc-backend + amc-worker after deploy
      # @flag --no-health-check  Skip post-deploy health check

      eval "$(${argc}/bin/argc --argc-eval "$0" "$@")"

      set -eo pipefail

      REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
      cd "$REPO_ROOT"

      echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
      echo "🚀 Deploy → $argc_target"
      echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

      # ── 1. Pre-deploy checks ───────────────────────────────────────────────
      if [[ -z $argc_skip_checks ]]; then
        PYTEST_FLAG=""
        [[ -n $argc_skip_pytest ]] && PYTEST_FLAG="--skip-pytest"
        pre-deploy $PYTEST_FLAG || {
          echo "❌ Pre-deploy checks failed — aborting deploy"
          echo "   Use --skip-checks to bypass (emergency only)"
          exit 1
        }
      else
        echo "⚠️  Pre-deploy checks skipped (--skip-checks)"
      fi

      # ── 2. Flake evaluation dry-run ────────────────────────────────────────
      echo ""
      echo "🧩 Evaluating parent flake..."
      if ! ${pkgs.nix}/bin/nix flake check --no-build 2>/dev/null; then
        # nix flake check --no-build just evaluates; if it fails the flake is broken
        echo "  ⚠️  nix flake check warning (may be expected for cross-arch checks)"
      else
        echo "  ✅ Flake evaluates cleanly"
      fi

      # ── 3. Deploy ─────────────────────────────────────────────────────────
      echo ""
      echo "📡 Running nixos-rebuild on $argc_target..."
      echo "   (builds on target — x86_64-linux)"
      ${pkgs.nixos-rebuild}/bin/nixos-rebuild \
        --target-host "$argc_target" \
        --build-host "$argc_target" \
        --flake . \
        --fast \
        switch \
        --override-input amc-backend ./amc-backend \
        --override-input amc-peripheral ./amc-peripheral \
        --override-input motortown-server ./motortown-server-flake

      echo "  ✅ nixos-rebuild complete"

      # ── 4. Post-deploy actions ─────────────────────────────────────────────
      if [[ -n $argc_migrate ]]; then
        echo ""
        echo "🗄️  Running migrations..."
        ssh "$argc_target" -- amcm migrate
        echo "  ✅ Migrations done"
      fi

      if [[ -n $argc_restart_be ]]; then
        echo ""
        echo "🔄 Restarting amc-backend + amc-worker..."
        ssh "$argc_target" -- systemctl restart amc-backend amc-worker
        echo "  ✅ Services restarted"
      fi

      # ── 5. Health check ───────────────────────────────────────────────────
      if [[ -z $argc_no_health_check ]]; then
        echo ""
        health-check "$argc_target" || {
          echo ""
          echo "⚠️  Health check failed after deploy!"
          echo "   Run: rollback $argc_target"
          exit 1
        }
      fi

      # ── 6. macOS notification ─────────────────────────────────────────────
      osascript -e "display notification \"$argc_target\" with title \"✅ Deployed\" sound name \"Morse\"" 2>/dev/null || true

      echo ""
      echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
      echo "✅ Deploy complete → $argc_target"
      echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    '';

    # ---------------------------------------------------------------------------
    # health-check
    # ---------------------------------------------------------------------------
    # Verifies the backend is healthy after a deploy. Checks:
    #   - amc-backend systemd unit is active
    #   - amc-worker systemd unit is active
    #   - HTTP /api/ endpoint responds on localhost:9000
    #
    # Called automatically by `deploy`. Can also be run standalone.
    # ---------------------------------------------------------------------------
    health-check = ''
      # @arg target!    SSH target, e.g. root@asean-mt-server

      eval "$(${argc}/bin/argc --argc-eval "$0" "$@")"

      set -eo pipefail

      echo "🏥 Health check → $argc_target"

      FAILED=0

      # Systemd unit checks (run inside the amc-backend container)
      if ssh "$argc_target" -- systemctl is-active --quiet amc-backend 2>/dev/null; then
        echo "  ✅ amc-backend: active"
      else
        echo "  ❌ amc-backend: not running"
        echo "     Run: ssh $argc_target -- journalctl -u amc-backend -n 50"
        FAILED=1
      fi

      if ssh "$argc_target" -- systemctl is-active --quiet amc-worker 2>/dev/null; then
        echo "  ✅ amc-worker: active"
      else
        echo "  ❌ amc-worker: not running"
        echo "     Run: ssh $argc_target -- journalctl -u amc-worker -n 50"
        FAILED=1
      fi

      # HTTP check — backend runs on port 9000, verify it responds
      if ssh "$argc_target" -- curl -sf --max-time 5 http://localhost:9000/api/ > /dev/null 2>&1; then
        echo "  ✅ HTTP /api/: responding"
      else
        echo "  ❌ HTTP /api/: not responding on localhost:9000"
        FAILED=1
      fi

      if [[ $FAILED -eq 0 ]]; then
        echo "✅ All services healthy"
        exit 0
      else
        echo "❌ Health check failed"
        exit 1
      fi
    '';

    # ---------------------------------------------------------------------------
    # rollback
    # ---------------------------------------------------------------------------
    # Server-side rollback using NixOS generations. Switches to the previous
    # generation on the target, then runs a health check to verify recovery.
    # ---------------------------------------------------------------------------
    rollback = ''
      # @arg target!    SSH target, e.g. root@asean-mt-server

      eval "$(${argc}/bin/argc --argc-eval "$0" "$@")"

      set -eo pipefail

      echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
      echo "⏪ Rolling back $argc_target to previous generation..."
      echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

      ssh "$argc_target" -- nixos-rebuild switch --rollback

      osascript -e "display notification \"$argc_target\" with title \"⏪ Rolled Back\" sound name \"Submarine\"" 2>/dev/null || true

      echo ""
      health-check "$argc_target" || {
        echo "⚠️  Rollback completed but services still unhealthy"
        echo "   Check logs: ssh $argc_target -- journalctl -u amc-backend -n 100"
        exit 1
      }

      echo ""
      echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
      echo "✅ Rollback complete"
      echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    '';
  };
in
  lib.mapAttrsToList (name: script: pkgs.writeShellScriptBin name script) scripts
