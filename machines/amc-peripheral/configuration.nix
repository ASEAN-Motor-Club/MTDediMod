{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot.tmp.cleanOnBoot = true;
  networking.hostName = "amc-peripheral";
  networking.domain = "";
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [22 80 443 8000 8008 1935 1936];
    allowedUDPPorts = [1935];
  };
  networking.networkmanager.enable = true;
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJcMiNGgqQtOeACMso3CgZz2J3X8Ne8RxsZrQcsnoewU fmnxl-m2''
    ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO75UM3IHNzJKUxgABH6OHa/hxfQIoxTs+nGUtSU1TID''
  ];
  users.users.freeman = {
    isNormalUser = true;
    home = "/home/freeman";
    description = "Alice Foobar";
    extraGroups = ["wheel" "networkmanager"];
    openssh.authorizedKeys.keys = [''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJcMiNGgqQtOeACMso3CgZz2J3X8Ne8RxsZrQcsnoewU fmnxl-m2''];
  };
  system.stateVersion = "23.11";
  nix.settings.experimental-features = ["nix-command" "flakes"];

  environment.systemPackages = with pkgs; [
    kakoune
    htop
    ffmpeg
    libopus
  ];

  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedProxySettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    # Only allow PFS-enabled ciphers with AES256
    sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";

    virtualHosts."www.aseanmotorclub.com" = {
      enableACME = true;
      forceSSL = true;
      locations = {
        "/" = {
          root = "/var/www/www.aseanmotorclub.com";
          tryFiles = "$uri $uri.html $uri/index.html /fallback.html";
        };
        "~* \\.(?:css|js|ico|gif|jpg|jpeg|png|svg|webp|woff|woff2)$" = {
          root = "/var/www/www.aseanmotorclub.com";
          extraConfig = ''
            # Set a long expiry time (1 year)
            expires 1y;
            # Add the immutable cache-control header
            add_header Cache-Control "public, max-age=31536000, immutable";
            # Optional: disable access logging for static files
            access_log off;
          '';
        };
        "/map_tiles/" = {
          root = "/var/www/www.aseanmotorclub.com";
          extraConfig = ''
            # 1. CORS Headers
            add_header 'Access-Control-Allow-Origin' '*';
            add_header 'Access-Control-Allow-Methods' 'GET, OPTIONS';

            # 2. Cache Headers (REPEATED)
            # We must repeat these because 'add_header' above clears parent headers
            expires 1y;
            add_header Cache-Control "public, max-age=31536000, immutable";

            # 3. Security Headers (REPEATED - Example)
            # If you define HSTS or other security headers in the server block,
            # you MUST repeat them here or they will be lost for tile requests.
            # add_header Strict-Transport-Security "max-age=31536000";
            access_log off;
            # 4. CORS Preflight
            if ($request_method = 'OPTIONS') {
               add_header 'Access-Control-Allow-Origin' '*';
               add_header 'Access-Control-Max-Age' 1728000;
               add_header 'Content-Type' 'text/plain; charset=utf-8';
               add_header 'Content-Length' 0;
               add_header Cache-Control "public, max-age=31536000, immutable";
               return 204;
            }
          '';
        };
        "/releases/" = {
          alias = "/var/lib/mod-releases/";
          extraConfig = ''
            autoindex on;
          '';
        };
        "/api" = {
          proxyPass = "http://asean-mt-server:9000/api";
        };
        "/admin" = {
          proxyPass = "http://asean-mt-server:9000/admin";
        };
        "/login/token" = {
          proxyPass = "http://asean-mt-server:9000/login/token";
        };
        "/stream" = {
          proxyPass = "http://127.0.0.1:8000/stream";
          extraConfig = ''
            proxy_http_version 1.1;
            proxy_connect_timeout 5s;
            proxy_read_timeout 86400s;
            proxy_send_timeout 86400s;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "keep-alive";
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_buffering off;  # Disable buffering for streaming
            proxy_cache off;      # Ensure no cache is used for streaming data
            gzip off; # Don't try to compress an already compressed media stream
            access_log off; # Optional: prevent logging every chunk of the stream
            # Optionally, add the header to explicitly disable internal buffering
            add_header X-Accel-Buffering no;
          '';
        };
        "/proxy" = {
          proxyPass = "http://127.0.0.1:8001/proxy";
          extraConfig = ''
            add_header Access-Control-Allow-Origin *;
          '';
        };
        "/hls" = {
          root = "/var/lib/radio";
          extraConfig = ''
            add_header Cache-Control "no-cache";
            add_header Access-Control-Allow-Origin "*";
            types { application/vnd.apple.mpegurl m3u8; }
          '';
        };
        "/routes" = {
          root = "/srv/www";
        };
        "/stream_high" = {
          return = "301 /stream";
        };
      };
    };

    virtualHosts."legacy.aseanmotorclub.com" = {
      enableACME = true;
      locations = {
        "/" = {
          proxyPass = "http://127.0.0.1:8001/";
        };
        "/radio" = {
          proxyPass = "http://127.0.0.1:8001/radio";
        };
        "/industries" = {
          proxyPass = "http://127.0.0.1:8001/industries";
        };
        "/track/live" = {
          proxyPass = "http://127.0.0.1:8001/track/live";
        };
        "/proxy" = {
          proxyPass = "http://127.0.0.1:8001/proxy";
          extraConfig = ''
            add_header Access-Control-Allow-Origin *;
          '';
        };
        "/track" = {
          root = "/srv/www";
        };
        "/routes" = {
          root = "/srv/www";
        };
        "/hls" = {
          root = "/var/lib/radio";
        };
        "/stream" = {
          proxyPass = "http://127.0.0.1:8000/stream";
          extraConfig = ''
            proxy_http_version 1.1;
            proxy_connect_timeout 5s;
            proxy_read_timeout 86400s;
            proxy_send_timeout 86400s;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "keep-alive";
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_buffering off;  # Disable buffering for streaming
            proxy_cache off;      # Ensure no cache is used for streaming data
            gzip off; # Don't try to compress an already compressed media stream
            # Optionally, add the header to explicitly disable internal buffering
            add_header X-Accel-Buffering no;
          '';
        };
        "/stream_high" = {
          return = "301 /stream";
        };
        "/stream2" = {
          proxyPass = "http://127.0.0.1:8000/stream2";
          extraConfig = ''
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "keep-alive";
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_buffering off;  # Disable buffering for streaming
            proxy_cache off;      # Ensure no cache is used for streaming data
            # Optionally, add the header to explicitly disable internal buffering
            add_header X-Accel-Buffering no;
          '';
        };
        "/live" = {
          proxyPass = "http://127.0.0.1:8008/live";
          extraConfig = ''
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "keep-alive";
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_buffering off;  # Disable buffering for streaming
            proxy_cache off;      # Ensure no cache is used for streaming data
            # Optionally, add the header to explicitly disable internal buffering
            add_header X-Accel-Buffering no;
          '';
        };
      };
    };
  };

  security.acme.defaults.email = "contact@fmnxl.xyz";
  security.acme.acceptTerms = true;

  # Sharry file sharing virtual host
  services.nginx.virtualHosts."share.aseanmotorclub.com" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:9090";
      extraConfig = ''
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_buffering off;
        client_max_body_size 105M;
        proxy_send_timeout 300s;
        proxy_read_timeout 300s;
        send_timeout 300s;
      '';
    };
  };

  services.icecast = {
    enable = true;
    hostname = "aseanmotorclub.com";
    admin.password = "aseanmotorclub1234"; # Admin password

    # Bind to localhost only since Nginx will proxy
    listen.address = "0.0.0.0";
    listen.port = 8000;

    # Additional Icecast settings
    extraConf = ''
      <location>ASEAN Motor Club</location>
      <admin>admin@aseanmotorclub.com</admin>

      <limits>
        <clients>500</clients>
        <sources>2</sources>
        <queue-size>2097152</queue-size>
        <client-timeout>300</client-timeout>
        <header-timeout>15</header-timeout>
        <source-timeout>30</source-timeout>
        <burst-on-connect>1</burst-on-connect>
        <burst-size>524288</burst-size>
      </limits>

      <mount>
        <mount-name>/stream</mount-name>
        <username>source</username>
        <password>hackme</password>
        <max-listeners>500</max-listeners>
        <public>1</public>
        <stream-name>ASEAN Motor Club Radio</stream-name>
        <stream-description>Your home for automotive enthusiasm in Southeast Asia</stream-description>
        <stream-url>https://aseanmotorclub.com/radio</stream-url>
        <genre>Automotive</genre>
        <fallback-mount>/fallback</fallback-mount>
        <fallback-override>1</fallback-override>
      </mount>


      <mount>
        <mount-name>/fallback</mount-name>
        <username>source</username>
        <password>hackme</password>
        <hidden>1</hidden>
      </mount>
    '';
  };

  users.users.sftpuser = {
    isNormalUser = true;
    createHome = true;
    home = "/home/sftpuser";
    group = "sftpuser";
    extraGroups = ["web-content"];
    openssh.authorizedKeys.keys = [
      (
        "command=\"${pkgs.rrsync}/bin/rrsync /var/www/www.aseanmotorclub.com\" "
        + ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJcMiNGgqQtOeACMso3CgZz2J3X8Ne8RxsZrQcsnoewU fmnxl-m2''
      )
      (
        "command=\"${pkgs.rrsync}/bin/rrsync /var/www/www.aseanmotorclub.com\" "
        + ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO7Gb+mZklKMeqGhnYZzy40Kl6k7CGNyH989jQwEqI3Q deploy''
      )
    ];
  };
  users.groups.sftpuser = {};
  users.groups.web-content = {};
  users.users.nginx.extraGroups = ["web-content"];

  systemd.tmpfiles.rules = [
    "d /var/www 0755 root root -"
    "d /var/www/www.aseanmotorclub.com 0755 sftpuser sftpuser -"
    "d /var/lib/mod-releases 0755 root root -"
    # OpenCode workspace directories
    "d /var/lib/opencode 0755 opencode opencode -"
    "d /var/lib/opencode/workspace 0755 opencode opencode -"
    "d /var/lib/opencode/workspace/worktrees 0755 opencode opencode -"
    "d /var/lib/opencode/tasks 0755 opencode opencode -"
  ];

  services.openssh.extraConfig = ''
    # Match the SFTP user group.
    Match Group sftpuser
      # Chroot the user to their home directory.
      # Disable TCP forwarding and X11 forwarding for security.
      AllowTcpForwarding no
      X11Forwarding no
  '';



  # === OpenCode Coding Agent ===
  users.users.opencode = {
    isSystemUser = true;
    group = "opencode";
    home = "/var/lib/opencode";
    createHome = true;
    shell = pkgs.bash;
  };
  users.groups.opencode = {};

  # ── Workspace sync (one-shot) ──────────────────────────────────────
  # Clones or updates the amc-server repo with submodules.
  # Run manually:  systemctl start opencode-workspace
  systemd.services.opencode-workspace = {
    description = "OpenCode – Sync amc-server workspace to latest main";
    after = ["network-online.target"];
    wants = ["network-online.target"];

    serviceConfig = {
      Type = "oneshot";
      User = "opencode";
      Group = "opencode";
      StateDirectory = "opencode";
      WorkingDirectory = "/var/lib/opencode";
    };

    environment = {
      HOME = "/var/lib/opencode";
      GITHUB_APP_ID = "2922326";
      GITHUB_INSTALLATION_ID = "111712229";
    };

    path = with pkgs; [git openssh coreutils jq openssl curl];

    script = ''
      set -euo pipefail

      REPO_DIR="/var/lib/opencode/workspace/amc-server"

      # --- Generate GitHub App installation token ---
      APP_KEY="${config.age.secrets.coding-agent-app-key.path}"
      NOW=$(date +%s)
      IAT=$((NOW - 60))
      EXP=$((NOW + 600))

      b64url() { openssl base64 -e -A | tr '+/' '-_' | tr -d '='; }
      HEADER=$(echo -n '{"alg":"RS256","typ":"JWT"}' | b64url)
      PAYLOAD=$(echo -n "{\"iat\":$IAT,\"exp\":$EXP,\"iss\":\"$GITHUB_APP_ID\"}" | b64url)
      SIGNATURE=$(echo -n "$HEADER.$PAYLOAD" | openssl dgst -sha256 -sign "$APP_KEY" | b64url)
      JWT="$HEADER.$PAYLOAD.$SIGNATURE"

      RESPONSE=$(curl -s -X POST \
        -H "Authorization: Bearer $JWT" \
        -H "Accept: application/vnd.github+json" \
        "https://api.github.com/app/installations/$GITHUB_INSTALLATION_ID/access_tokens")
      GH_TOKEN=$(echo "$RESPONSE" | jq -r '.token')
      if [ "$GH_TOKEN" = "null" ] || [ -z "$GH_TOKEN" ]; then
        echo "ERROR: Failed to get installation token: $RESPONSE"
        exit 1
      fi

      # Configure git to use HTTPS with token
      git config --global url."https://x-access-token:$GH_TOKEN@github.com/".insteadOf "https://github.com/"
      git config --global url."https://x-access-token:$GH_TOKEN@github.com/".insteadOf "git@github.com:"

      if [ ! -d "$REPO_DIR/.git" ]; then
        echo "Cloning repository..."
        mkdir -p "$(dirname "$REPO_DIR")"
        git clone --recurse-submodules https://github.com/ASEAN-Motor-Club/amc-server.git "$REPO_DIR"
      else
        echo "Fetching latest..."
        cd "$REPO_DIR"
        git fetch origin main
        git checkout main
        git reset --hard origin/main
        git clean -fd
        git submodule update --init --recursive
      fi

      cd "$REPO_DIR"
      git config user.name "AMC Coding Agent[bot]"
      git config user.email "2922326+amc-coding-agent[bot]@users.noreply.github.com"

      # Ensure worktrees directory exists
      mkdir -p /var/lib/opencode/workspace/worktrees

      # Deploy opencode config globally so all instances (worktrees etc.) inherit it
      mkdir -p "$HOME/.config/opencode"
      cat > "$HOME/.config/opencode/opencode.json" << 'OPENCODE_EOF'
      {
        "$schema": "https://opencode.ai/config.json",
        "provider": {
          "openrouter": {}
        },
        "model": "openrouter/anthropic/claude-sonnet-4",
        "command": {
          "pr": {
            "description": "commit, push, and create a PR from current changes",
            "agent": "build",
            "template": "Commit all changes, push the branch, and create a draft pull request.\n\n1. Stage all changes: git add -A\n2. Commit with a descriptive message based on the changes: git commit -m \"$ARGUMENTS\"\n3. Push the branch: git push -f origin HEAD\n4. Create a draft PR: gh pr create --repo ASEAN-Motor-Club/amc-server --base main --fill --draft\n\nIMPORTANT: You MUST run ALL of these commands. Do not skip any step."
          }
        }
      }
      OPENCODE_EOF

      # Global agent rules
      cat > "$HOME/.config/opencode/AGENTS.md" << 'AGENTS_EOF'
      # AMC Coding Agent (Peripheral)

      You are running on the amc-peripheral server. Your workspace is a checkout
      of the amc-server monorepo.

      ## Self-Deploy

      You can trigger a self-deploy (nixos-rebuild switch on this server) by running:
      ```bash
      sudo systemctl start amc-peripheral-deploy
      ```
      Then check the result:
      ```bash
      cat /var/lib/opencode/deploy-result.json
      ```
      AGENTS_EOF

      echo "Workspace ready at $REPO_DIR"
    '';
  };

  # ── OpenCode serve (persistent API server) ─────────────────────────
  systemd.services.opencode-serve = {
    description = "OpenCode Serve (Headless API)";
    after = ["network-online.target" "opencode-workspace.service"];
    wants = ["network-online.target" "opencode-workspace.service"];
    wantedBy = ["multi-user.target"];
    path = with pkgs; [git openssh gh ripgrep fzf coreutils jq openssl curl nix nixos-rebuild];

    environment = {
      HOME = "/var/lib/opencode";
      GITHUB_APP_ID = "2922326";
      GITHUB_INSTALLATION_ID = "111712229";
    };

    serviceConfig = {
      Type = "simple";
      User = "opencode";
      Group = "opencode";
      WorkingDirectory = "/var/lib/opencode/workspace/amc-server";
      EnvironmentFile = config.age.secrets.opencode-peripheral.path;
      Restart = "on-failure";
      RestartSec = 5;
    };

    script = ''
      set -euo pipefail

      # --- Generate GitHub App installation token ---
      APP_KEY="${config.age.secrets.coding-agent-app-key.path}"
      NOW=$(date +%s)
      IAT=$((NOW - 60))
      EXP=$((NOW + 600))

      b64url() { openssl base64 -e -A | tr '+/' '-_' | tr -d '='; }
      HEADER=$(echo -n '{"alg":"RS256","typ":"JWT"}' | b64url)
      PAYLOAD=$(echo -n "{\"iat\":$IAT,\"exp\":$EXP,\"iss\":\"$GITHUB_APP_ID\"}" | b64url)
      SIGNATURE=$(echo -n "$HEADER.$PAYLOAD" | openssl dgst -sha256 -sign "$APP_KEY" | b64url)
      JWT="$HEADER.$PAYLOAD.$SIGNATURE"

      RESPONSE=$(curl -s -X POST \
        -H "Authorization: Bearer $JWT" \
        -H "Accept: application/vnd.github+json" \
        "https://api.github.com/app/installations/$GITHUB_INSTALLATION_ID/access_tokens")

      export GH_TOKEN=$(echo "$RESPONSE" | jq -r '.token')
      if [ "$GH_TOKEN" = "null" ] || [ -z "$GH_TOKEN" ]; then
        echo "ERROR: Failed to get installation token: $RESPONSE"
        exit 1
      fi
      echo "GitHub App token acquired"

      git config --global user.name "AMC Coding Agent[bot]"
      git config --global user.email "2922326+amc-coding-agent[bot]@users.noreply.github.com"
      git config --global url."https://x-access-token:$GH_TOKEN@github.com/".insteadOf "https://github.com/"
      git config --global url."https://x-access-token:$GH_TOKEN@github.com/".insteadOf "git@github.com:"

      # Write auth.json for opencode credential store
      mkdir -p "$HOME/.local/share/opencode"
      echo "{\"openrouter\":{\"apiKey\":\"$OPENROUTER_API_KEY\"}}" \
        | jq . > "$HOME/.local/share/opencode/auth.json"

      exec ${pkgs.opencode}/bin/opencode serve --hostname 127.0.0.1 --port 4096
    '';
  };

  # ── OpenCode web (interactive web UI) ──────────────────────────────
  systemd.services.opencode-web = {
    description = "OpenCode Web UI";
    after = ["network-online.target" "opencode-workspace.service"];
    wants = ["network-online.target" "opencode-workspace.service"];
    wantedBy = ["multi-user.target"];
    path = with pkgs; [git openssh gh ripgrep fzf coreutils jq openssl curl nix nixos-rebuild];

    environment = {
      HOME = "/var/lib/opencode";
      GITHUB_APP_ID = "2922326";
      GITHUB_INSTALLATION_ID = "111712229";
    };

    serviceConfig = {
      Type = "simple";
      User = "opencode";
      Group = "opencode";
      WorkingDirectory = "/var/lib/opencode/workspace/amc-server";
      EnvironmentFile = config.age.secrets.opencode-peripheral.path;
      Restart = "on-failure";
      RestartSec = 5;
    };

    script = ''
      set -euo pipefail

      APP_KEY="${config.age.secrets.coding-agent-app-key.path}"
      NOW=$(date +%s)
      IAT=$((NOW - 60))
      EXP=$((NOW + 600))

      b64url() { openssl base64 -e -A | tr '+/' '-_' | tr -d '='; }
      HEADER=$(echo -n '{"alg":"RS256","typ":"JWT"}' | b64url)
      PAYLOAD=$(echo -n "{\"iat\":$IAT,\"exp\":$EXP,\"iss\":\"$GITHUB_APP_ID\"}" | b64url)
      SIGNATURE=$(echo -n "$HEADER.$PAYLOAD" | openssl dgst -sha256 -sign "$APP_KEY" | b64url)
      JWT="$HEADER.$PAYLOAD.$SIGNATURE"

      RESPONSE=$(curl -s -X POST \
        -H "Authorization: Bearer $JWT" \
        -H "Accept: application/vnd.github+json" \
        "https://api.github.com/app/installations/$GITHUB_INSTALLATION_ID/access_tokens")

      export GH_TOKEN=$(echo "$RESPONSE" | jq -r '.token')
      if [ "$GH_TOKEN" = "null" ] || [ -z "$GH_TOKEN" ]; then
        echo "ERROR: Failed to get installation token: $RESPONSE"
        exit 1
      fi

      git config --global user.name "AMC Coding Agent[bot]"
      git config --global user.email "2922326+amc-coding-agent[bot]@users.noreply.github.com"
      git config --global url."https://x-access-token:$GH_TOKEN@github.com/".insteadOf "https://github.com/"
      git config --global url."https://x-access-token:$GH_TOKEN@github.com/".insteadOf "git@github.com:"

      mkdir -p "$HOME/.local/share/opencode"
      echo "{\"openrouter\":{\"apiKey\":\"$OPENROUTER_API_KEY\"}}" \
        | jq . > "$HOME/.local/share/opencode/auth.json"

      exec ${pkgs.opencode}/bin/opencode web --port 4097 --hostname 127.0.0.1
    '';
  };

  # ── Task runner (worktree-per-task) ────────────────────────────────
  # Template service: systemctl start "opencode-task@<task-id>"
  # Task prompt is read from /var/lib/opencode/tasks/<task-id>/prompt.txt
  systemd.services."opencode-task@" = {
    description = "OpenCode – Run task %i";
    after = ["network-online.target"];
    wants = ["network-online.target"];

    serviceConfig = {
      Type = "oneshot";
      User = "opencode";
      Group = "opencode";
      StateDirectory = "opencode";
      WorkingDirectory = "/var/lib/opencode/workspace/amc-server";
      TimeoutStartSec = "30min";
      EnvironmentFile = config.age.secrets.opencode-peripheral.path;
    };

    environment = {
      HOME = "/var/lib/opencode";
      GITHUB_APP_ID = "2922326";
      GITHUB_INSTALLATION_ID = "111712229";
    };

    path = with pkgs; [git openssh gh coreutils jq openssl curl nix opencode];

    script = ''
      set -euo pipefail

      TASK_ID="%i"
      TASK_DIR="/var/lib/opencode/tasks/$TASK_ID"
      REPO_DIR="/var/lib/opencode/workspace/amc-server"
      WORKTREE_BASE="/var/lib/opencode/workspace/worktrees"

      # Read task prompt
      if [ ! -f "$TASK_DIR/prompt.txt" ]; then
        echo "ERROR: No prompt file at $TASK_DIR/prompt.txt"
        exit 1
      fi
      TASK_DESCRIPTION=$(cat "$TASK_DIR/prompt.txt")

      # --- GitHub App token ---
      APP_KEY="${config.age.secrets.coding-agent-app-key.path}"
      NOW=$(date +%s)
      IAT=$((NOW - 60))
      EXP=$((NOW + 600))

      b64url() { openssl base64 -e -A | tr '+/' '-_' | tr -d '='; }
      HEADER=$(echo -n '{"alg":"RS256","typ":"JWT"}' | b64url)
      PAYLOAD=$(echo -n "{\"iat\":$IAT,\"exp\":$EXP,\"iss\":\"$GITHUB_APP_ID\"}" | b64url)
      SIGNATURE=$(echo -n "$HEADER.$PAYLOAD" | openssl dgst -sha256 -sign "$APP_KEY" | b64url)
      JWT="$HEADER.$PAYLOAD.$SIGNATURE"

      RESPONSE=$(curl -s -X POST \
        -H "Authorization: Bearer $JWT" \
        -H "Accept: application/vnd.github+json" \
        "https://api.github.com/app/installations/$GITHUB_INSTALLATION_ID/access_tokens")

      export GH_TOKEN=$(echo "$RESPONSE" | jq -r '.token')
      if [ "$GH_TOKEN" = "null" ] || [ -z "$GH_TOKEN" ]; then
        echo "ERROR: Failed to get installation token: $RESPONSE"
        exit 1
      fi

      git config --global url."https://x-access-token:$GH_TOKEN@github.com/".insteadOf "https://github.com/"
      git config --global url."https://x-access-token:$GH_TOKEN@github.com/".insteadOf "git@github.com:"

      # Write auth.json
      mkdir -p "$HOME/.local/share/opencode"
      echo "{\"openrouter\":{\"apiKey\":\"$OPENROUTER_API_KEY\"}}" \
        | jq . > "$HOME/.local/share/opencode/auth.json"

      # Derive branch name from task ID
      BRANCH_NAME="agent/$TASK_ID"

      cd "$REPO_DIR"
      git fetch origin main

      # Create isolated worktree
      WORKTREE_PATH="$WORKTREE_BASE/$TASK_ID"
      mkdir -p "$WORKTREE_BASE"
      git worktree add "$WORKTREE_PATH" -b "$BRANCH_NAME" origin/main

      cd "$WORKTREE_PATH"
      git config user.name "AMC Coding Agent[bot]"
      git config user.email "2922326+amc-coding-agent[bot]@users.noreply.github.com"

      # Run the coding agent in the worktree
      opencode run "$TASK_DESCRIPTION"

      # Check if any changes were made
      if git diff --quiet && git diff --cached --quiet; then
        echo "No changes made by agent"
        echo "no_changes" > "$TASK_DIR/result.txt"
        exit 0
      fi

      # Stage and commit
      git add -A
      if ! git diff --cached --quiet; then
        git commit -m "agent: $TASK_ID"
      fi

      # Push the branch
      git push -f origin "$BRANCH_NAME"

      # Create draft PR
      PR_URL=$(gh pr create \
        --repo ASEAN-Motor-Club/amc-server \
        --base main \
        --title "agent: $(echo "$TASK_DESCRIPTION" | head -c 72)" \
        --body "## Changes by Coding Agent

      Task: \`$TASK_ID\`

      ### Description
      $TASK_DESCRIPTION

      ---
      *This PR was created automatically by the AMC Coding Agent.*" \
        --draft 2>&1) || true

      echo "$PR_URL" > "$TASK_DIR/result.txt"
      echo "Task complete. Result: $PR_URL"
    '';
  };

  # ── Self-deploy service ────────────────────────────────────────────
  # Root-owned oneshot that syncs workspace and runs nixos-rebuild switch.
  # Triggered by: sudo systemctl start amc-peripheral-deploy
  systemd.services.amc-peripheral-deploy = {
    description = "Self-deploy – nixos-rebuild from latest main";
    after = ["network-online.target"];
    wants = ["network-online.target"];

    serviceConfig = {
      Type = "oneshot";
      TimeoutStartSec = "30min";
    };

    environment = {
      HOME = "/var/lib/opencode";
      GITHUB_APP_ID = "2922326";
      GITHUB_INSTALLATION_ID = "111712229";
    };

    path = with pkgs; [git openssh nix coreutils jq curl systemd util-linux openssl];

    script = ''
      set -euo pipefail

      REPO_DIR="/var/lib/opencode/workspace/amc-server"
      RESULT_FILE="/var/lib/opencode/deploy-result.json"

      echo '{"status": "running", "step": "starting"}' > "$RESULT_FILE"
      chown opencode:opencode "$RESULT_FILE"

      log_step() {
        echo "$1"
        echo "{\"status\": \"running\", \"step\": \"$1\"}" > "$RESULT_FILE"
      }

      # --- GitHub App token ---
      APP_KEY="${config.age.secrets.coding-agent-app-key.path}"
      NOW=$(date +%s)
      IAT=$((NOW - 60))
      EXP=$((NOW + 600))

      b64url() { openssl base64 -e -A | tr '+/' '-_' | tr -d '='; }
      HEADER=$(echo -n '{"alg":"RS256","typ":"JWT"}' | b64url)
      PAYLOAD=$(echo -n "{\"iat\":$IAT,\"exp\":$EXP,\"iss\":\"$GITHUB_APP_ID\"}" | b64url)
      SIGNATURE=$(echo -n "$HEADER.$PAYLOAD" | openssl dgst -sha256 -sign "$APP_KEY" | b64url)
      JWT="$HEADER.$PAYLOAD.$SIGNATURE"

      RESPONSE=$(curl -s -X POST \
        -H "Authorization: Bearer $JWT" \
        -H "Accept: application/vnd.github+json" \
        "https://api.github.com/app/installations/$GITHUB_INSTALLATION_ID/access_tokens")

      GH_TOKEN=$(echo "$RESPONSE" | jq -r '.token')
      if [ "$GH_TOKEN" = "null" ] || [ -z "$GH_TOKEN" ]; then
        echo '{"status": "failed", "step": "github-auth", "error": "Failed to get token"}' > "$RESULT_FILE"
        exit 1
      fi

      # ── Step 1: Sync workspace ──
      log_step "Syncing workspace to latest main"
      export GIT_CONFIG_COUNT=2
      export GIT_CONFIG_KEY_0=safe.directory
      export GIT_CONFIG_VALUE_0="$REPO_DIR"
      export GIT_CONFIG_KEY_1="url.https://x-access-token:$GH_TOKEN@github.com/.insteadOf"
      export GIT_CONFIG_VALUE_1="https://github.com/"

      runuser -u opencode -- git -C "$REPO_DIR" fetch origin main
      runuser -u opencode -- git -C "$REPO_DIR" checkout main
      runuser -u opencode -- git -C "$REPO_DIR" reset --hard origin/main
      runuser -u opencode -- git -C "$REPO_DIR" clean -fd
      runuser -u opencode -- git -C "$REPO_DIR" submodule update --init --recursive

      COMMIT_SHA=$(git -C "$REPO_DIR" rev-parse --short HEAD)
      COMMIT_MSG=$(git -C "$REPO_DIR" log -1 --format=%s)

      # ── Step 2: NixOS rebuild ──
      log_step "Building NixOS configuration"
      HOME=/root /run/current-system/sw/bin/nixos-rebuild switch --flake "$REPO_DIR#amc-peripheral" 2>&1 || {
        echo "{\"status\": \"failed\", \"step\": \"nixos-rebuild\", \"error\": \"nixos-rebuild switch failed\"}" > "$RESULT_FILE"
        exit 1
      }

      echo "{\"status\": \"success\", \"commit\": \"$COMMIT_SHA\", \"commit_msg\": \"$COMMIT_MSG\"}" > "$RESULT_FILE"
      echo "✅ Deploy complete: $COMMIT_SHA ($COMMIT_MSG)"
    '';
  };

  # ── Sudoers: opencode can only trigger self-deploy ─────────────────
  security.sudo.extraRules = [
    {
      users = ["opencode"];
      commands = [
        {
          command = "/run/current-system/sw/bin/systemctl start amc-peripheral-deploy";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];

  # ── oauth2-proxy: GitHub authentication for OpenCode web UI ────────
  services.oauth2-proxy = {
    enable = true;
    httpAddress = "http://127.0.0.1:4180";
    reverseProxy = true;
    upstream = "http://127.0.0.1:4097";
    provider = "github";
    github.org = "ASEAN-Motor-Club";
    cookie.domain = "code-peripheral.aseanmotorclub.com";
    cookie.secure = true;
    email.domains = ["*"];
    setXauthrequest = true;
    extraConfig = {
      skip-provider-button = "true";
    };
    keyFile = config.age.secrets.oauth2-proxy-peripheral.path;
  };

  # ── Nginx vhost for OpenCode web UI ────────────────────────────────
  services.nginx.virtualHosts."code-peripheral.aseanmotorclub.com" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:4180";
      extraConfig = ''
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
      '';
    };
  };


  # ── Nginx vhost for Radio ASEAN Web Interface (Discord Activity) ──
  services.nginx.virtualHosts."radio.aseanmotorclub.com" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      root = "${(import ../../amc-peripheral/radio-web {inherit pkgs;}).package}";
      tryFiles = "$uri $uri/index.html /index.html";
      extraConfig = ''
        add_header Cache-Control "public, max-age=3600";
      '';
    };
    locations."/api" = {
      proxyPass = "http://127.0.0.1:7001/api";
      extraConfig = ''
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
      '';
    };
    locations."/stream" = {
      proxyPass = "http://127.0.0.1:8000/stream";
      extraConfig = ''
        proxy_http_version 1.1;
        proxy_connect_timeout 5s;
        proxy_read_timeout 86400s;
        proxy_send_timeout 86400s;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "keep-alive";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_buffering off;
        proxy_cache off;
        gzip off;
        access_log off;
        add_header X-Accel-Buffering no;
        add_header Access-Control-Allow-Origin "*";
      '';
    };
  };

  services.tailscale = {
    enable = true;
  };
}
