{
  description = "AMC Game Server";

  inputs = {
    self.submodules = true;
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
    motortown-server = {
      url = "path:./motortown-server-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    necesse-server = {
      url = "github:ASEAN-Motor-Club/necesse-server";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    eco-server = {
      url = "path:./eco-server";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    amc-backend = {
      url = "github:ASEAN-Motor-Club/amc-backend";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.ragenix.follows = "ragenix";
    };
    amc-peripheral = {
      url = "github:ASEAN-Motor-Club/amc-peripheral";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ragenix.url = "github:yaxitech/ragenix";
    ragenix.inputs.nixpkgs.follows = "nixpkgs";
    quadlet-nix.url = "github:SEIAROTg/quadlet-nix";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    opencode.url = "github:anomalyco/opencode";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-unstable,
    flake-parts,
    opencode,
    amc-backend,
    amc-peripheral,
    motortown-server,
    necesse-server,
    eco-server,
    ragenix,
    quadlet-nix,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      flake = {
        nixosModules.gameSyslog = {lib, config, ...}: {
          options.services.gameSyslog.relpPort = lib.mkOption {
            type = lib.types.int;
            default = 2514;
            description = "RELP port for log forwarding";
          };
          config.services.rsyslogd = {
            enable = true;
            # We use mkBefore to ensure modules and templates are defined
            # before the individual services try to use them.
            extraConfig = lib.mkBefore ''
              # 1. Load Modules (Only once)
              module(load="imfile")
              module(load="omrelp")

              template(name="with_filename" type="list") {
                property(name="timestamp" dateFormat="rfc3339")
                constant(value=" ")
                property(name="hostname")
                constant(value=" ")
                property(name="syslogtag")
                constant(value=" ")
                property(name="$!metadata!filename")
                property(name="msg" spifno1stsp="on" )
                property(name="msg" droplastlf="on" )
                constant(value="\n")
              }

              Ruleset(name="mt-out") {
                action(type="omrelp"
                  target="127.0.0.1"
                  port="${toString config.services.gameSyslog.relpPort}"
                  template="with_filename"
                )
              }
            '';
          };
        };
        nixosModules.motortown-server-containers = {
          config,
          pkgs,
          lib,
          ...
        }: {
          imports = [motortown-server.nixosModules.containers];
          services.motortown-server-containers-env = {
            programs.bash.promptInit = ''
              # Set a custom prompt color
              PS1='\[\e[38;5;40m\]\u\[\e[38;5;40m\]@\h\[\e[0m\]:\W '
            '';
          };
          services.motortown-server-containers = {
            test = {
              privateNetwork = true;
              hostAddress = "10.250.0.1";
              localAddress = "10.250.0.2";
              extraForwardPorts = [
                { containerPort = 9001; hostPort = 9001; protocol = "tcp"; }
                { containerPort = 8081; hostPort = 8081; protocol = "tcp"; }
                { containerPort = 5001; hostPort = 5001; protocol = "tcp"; }
              ];
              imports = [
                self.nixosModules.gameSyslog
                amc-backend.nixosModules.backend
                amc-backend.nixosModules.log-listener
              ];
              config = {
                # Forward game server logs to the staging RELP listener
                # (runs inside this same container)
                services.gameSyslog.relpPort = 2515;

                # GeoDjango native library paths (needed inside container)
                environment.variables = {
                  GEOS_LIBRARY_PATH = "${pkgs.geos}/lib/libgeos_c.so";
                  GDAL_LIBRARY_PATH = "${pkgs.gdal}/lib/libgdal.so";
                };

                # Allow unfree for timescaledb
                nixpkgs.config.allowUnfree = true;

                # Private network: standard ports, no conflicts with host
                # Trust the veth interface so the host can reach forwarded services
                networking.firewall.trustedInterfaces = [ "eth0" ];

                # --- Staging backend ---
                services.amc-backend = {
                  enable = true;
                  port = 9001;
                  allowedHosts = [
                    "test.aseanmotorclub.com"
                    "localhost"
                    "127.0.0.1"
                  ];
                  environmentFile = "/run/secrets/backend-staging";
                  environment = {
                    GAME_SERVER_API_URL = "http://localhost:8081";
                    MOD_SERVER_API_URL = "http://localhost:5001";
                    WEBHOOK_SERVER_API_URL = "http://localhost:5000";
                    PARTY_BONUS_ENABLED = "1";
                    WEBHOOK_SSE_ENABLED = "1";
                    CACHE_KEY_PREFIX = "test_";
                  };
                };

                # --- Staging log listener (RELP on port 2515) ---
                services.amc-log-listener = {
                  enable = true;
                  relpPort = 2515;
                };

                # Ensure syslog shuts down quickly (default 90s blocks container stop)
                systemd.services.syslog.serviceConfig.TimeoutStopSec = "5s";
              };
              motortown-server = {
                enable = true;
                enableMods = true;
                maxFps = 30;
                restartSchedule = "3000-01-01 00:00:00";
                betaBranch = "beta";
                modVersion = "v0.33.0-rc7";
                enableExternalMods = {
                  CarPartsImport_P = false;
                  MoneyRun_P = true;
                  qxZap_CranyUnlocked_P = false;
                  MajasDetailWorks7_17_P = false;
                  MajasMnTrailerworks7_17_P = false;
                };
                engineIni = ''
                  mh.maxCombinedVehicleLength=4000
                  mh.cargoStackMaxVehicleHeight=420
                  mh.eventRacingMoneyPerKm=300
                  mh.fuelPriceByInventoryMax=5
                  mh.housingValidateHousingArea=0
                  mh.invalidPartsDisableLeaderboard=0
                  mh.cargoPaymentMultiplier=10
                  mh.refuelEVMinPercentPerSeconds=0.001000000026077032
                  mh.refuelkWPerSeconds=0.2
                  mh.trafficSpawnVehicleMaxDistance=20000.0
                  mh.trafficSpawnVehicleMinDistance=10000.0
                  mh.fuelPriceByInventoryMax=10.0
                  mh.fuelPriceByInventoryMin=10.0
                  mh.aiVehicleMaxDistance=50000.0
                  mh.trafficAgentMaxTickDeltaSeconds=5.0
                  mh.trafficTickPerFrame=20.0
                  mh.companyVehicleSlotCostBase=1
                  mh.companyEditorAsDediForCorporation=1
                '';
                enableLogStreaming = true;
                logsTag = "amc-test";
                openFirewall = true;
                port = 27778;
                queryPort = 27016;
                user = "steam";
                relpServerHost = "localhost";
                relpServerPort = 2515;
                environment = {
                  MOD_SERVER_PORT = "5001";
                  MOD_MANAGEMENT_PORT = "5000";
                  MOD_WEBHOOK_ENABLE_EVENTS = "none";
                };
                credentialsFile = config.age.secrets.steam.path;
                dedicatedServerConfig = {
                  ServerName = "※ ASEAN Test Server ※";
                  ServerMessage = ''                    THIS IS A TEST SERVER.
                    Please join ASEAN Motor Club instead'';
                  Password = "";
                  MaxPlayers = 50;
                  MaxVehiclePerPlayer = 10;
                  bAllowPlayerToJoinWithCompanyVehicles = true;
                  bAllowCompanyAIDriver = true;
                  MaxHousingPlotRentalPerPlayer = 20;
                  MaxHousingPlotRentalDays = 180;
                  HousingPlotRentalPriceRatio = 0.0001;
                  bAllowModdedVehicle = true;
                  NPCVehicleDensity = 0.0;
                  NPCPoliceDensity = 0.0;
                  bEnableHostWebAPIServer = true;
                  HostWebAPIServerPassword = "";
                  HostWebAPIServerPort = 8081;
                  Admins = [
                    {
                      UniqueNetId = "76561198378447512";
                      Nickname = "freeman";
                    }
                  ];
                };
              };
            };
            event = {
              imports = [
                self.nixosModules.gameSyslog
              ];
              motortown-server = {
                enable = false;
                enableMods = true;
                modVersion = "v12";
                enableExternalMods = {
                };
                engineIni = ''
                  mh.eventRacingMoneyPerKm=1
                  mh.eventRacingXPPerKm=20
                  mh.rentalCostRatio=0.000001
                  mh.rentalRemoveTimeSeconds=604800
                  mh.parkingTicketTimeSeconds=604800
                  mh.roadsideTowingBaseCost=10000
                  mh.aICharacterCountScale=0.0
                  mh.allowBuilding=1
                  mh.dealerVehicleRespawnTimeSeconds=10.0
                  mh.worldVehicleAbandonedParkingTicketTimeSeconds=604800.0
                  mh.worldVehicleAbandonedRespawnTimeSeconds=604800.0
                  mh.companyVehicleSlotCostBase=1
                  mh.companyEditorAsDediForCorporation=1
                '';
                enableLogStreaming = true;
                logsTag = "amc-event";
                openFirewall = true;
                port = 7779;
                queryPort = 27017;
                user = "steam";
                restartSchedule = "3000-01-01 00:00:00";
                relpServerHost = "localhost";
                environment = {
                  MOD_SERVER_PORT = "5011";
                  MOD_MANAGEMENT_PORT = "5010";
                  MOD_WEBHOOK_ENABLE_EVENTS = "none";
                };
                credentialsFile = config.age.secrets.steam.path;
                dedicatedServerConfig = {
                  ServerName = "■□■□ ASEAN Event Server ■□■□";
                  ServerMessage = ''
                    <Title>Welcome to the ASEAN Event Server</>

                    <Highlight>This server is only used for events.</>
                    If you are looking for the main server, search for the <Focus>ASEAN Motor Club</> on the server list.

                    Use <Event>/events</> to check the event schedule.

                    <Bold>Join the Discord</>
                    Visit aseanmotorclub.com to join the discord server.
                  '';
                  Password = "asean";
                  MaxPlayers = 50;
                  MaxVehiclePerPlayer = 1;
                  bAllowPlayerToJoinWithCompanyVehicles = false;
                  bAllowCompanyAIDriver = false;
                  MaxHousingPlotRentalPerPlayer = 20;
                  MaxHousingPlotRentalDays = 180;
                  HousingPlotRentalPriceRatio = 0.00001;
                  bAllowModdedVehicle = false;
                  NPCVehicleDensity = 0.0;
                  NPCPoliceDensity = 0.0;
                  bEnableHostWebAPIServer = true;
                  HostWebAPIServerPassword = "";
                  HostWebAPIServerPort = 8082;
                  Admins = [
                    {
                      UniqueNetId = "76561198378447512";
                      Nickname = "freeman";
                    }
                    {
                      UniqueNetId = "76561199496159494";
                      Nickname = "ARID";
                    }
                    {
                      UniqueNetId = "76561199174259800";
                      Nickname = "Yuuka";
                    }
                    {
                      UniqueNetId = "76561199109285302";
                      Nickname = "Nunauu";
                    }
                    {
                      UniqueNetId = "76561198093833834";
                      Nickname = "VicSay";
                    }
                    {
                      UniqueNetId = "76561198062644260";
                      Nickname = "Meehoi";
                    }
                    {
                      UniqueNetId = "76561198006148466";
                      Nickname = "dvdurL";
                    }
                    {
                      UniqueNetId = "76561198039953945";
                      Nickname = "Youyu";
                    }
                    {
                      UniqueNetId = "76561198127159716";
                      Nickname = "MeadowVick";
                    }
                    {
                      UniqueNetId = "76561198412768677";
                      Nickname = "BattleSpec";
                    }
                  ];
                };
              };
            };
          };
        };

        # Main Server
        nixosModules.motortown-server = {
          config,
          pkgs,
          lib,
          ...
        }: {
          imports = [
            motortown-server.nixosModules.default
            necesse-server.nixosModules.default
            eco-server.nixosModules.amc
            self.nixosModules.gameSyslog
          ];

          services.necesse-server = {
            enable = false;
            openFirewall = true;
            enableLogStreaming = true;
            ownerName = "freeman";
          };
          services.eco-server = {
            enable = false;
            openFirewall = true;
            enableLogStreaming = false;
            credentialsFile = config.age.secrets.ecoUserToken.path;
            discordlinkSecretFile = config.age.secrets.discordlinkBotToken.path;
          };
          services.motortown-server = {
            enable = true;
            enableMods = true;
            enableLogStreaming = true;
            modVersion = "v0.33.0-rc6";
            enableExternalMods = {
              MajasDetailWorks7_17_P = true;
              MajasMnTrailerworks7_17_P = true;
              qxZap_CranyUnlocked_P = true;
              MoneyRun_P = true;
            };
            engineIni = ''
              mh.maxCombinedVehicleLength=10000
              mh.fuelPriceByInventoryMax=3
              mh.housingValidateHousingArea=0
              mh.invalidPartsDisableLeaderboard=0
              mh.refuelEVMinPercentPerSeconds=0.001000000026077032
              mh.refuelkWPerSeconds=0.2
              mh.trafficSpawnVehicleMaxDistance=40000.0
              mh.trafficSpawnVehicleMinDistance=25000.0
              mh.towPaymentMultiplier=3
              mh.vehicleMaxGVWFinePerTon=1
              mh.vehicleMaxWeightFine=1
              mh.vehicleMaxGVWKg=80000
              mh.deliveryOnlineAccessCostPerHour=1
              mh.eventRacingMoneyPerKm=200
              mh.busPaymentMultiplier=5
              mh.garbageCollectRateDecreasePerSeconds=0.00001
            '';
            openFirewall = true;
            user = "steam";
            credentialsFile = config.age.secrets.steam.path;
            discordWebhookEnvironmentFile = config.age.secrets.backend.path;
            relpServerHost = "localhost";
            environment = {
              MOD_SERVER_PORT = "5001";
              MOD_MANAGEMENT_PORT = "5000";
              MOD_WEBHOOK_ENABLE_EVENTS = "none";
            };
            dedicatedServerConfig = {
              # ServerName = lib.mkDefault "Vanilla+ | ASEAN Motor Club | discord.gg/aseanmotorclub";
              # ServerName = "〈 ASEAN Motor Club 〉 discord.gg/aseanmotorclub";
              ServerName = "★★ ASEAN Motor Club ★★  discord.gg/aseanmotorclub";
              ServerMessage = ''                <Title>ASEAN Motor Club</>
                <Small>Welcome | 你好 | Selamat Datang | Sawasdee Krub | Maligayang Pagdating</>

                <Bold>Slash Commands</>
                Type <Highlight>/help</> to see all available commands, and try them out!
                These custom features are unique to our server.

                <Bold>Read The Rules</>
                - Do not abandon your vehicle and block traffic,
                - Street racing is allowed, but please apologise if you crash into someone,
                - See the discord for all the rules.

                <Bold>Server Settings</>
                - Mods (optional): Road Trains, Maja's Detail Works
                - AI enabled. Max vehicles per player: ${toString config.services.motortown-server.dedicatedServerConfig.MaxVehiclePerPlayer}.
                - Rent lasts ${toString config.services.motortown-server.dedicatedServerConfig.MaxHousingPlotRentalDays} days

                <Bold>Radio</>
                Tune in to our very own Radio ASEAN station!
                www.aseanmotorclub.com/radio
                Submit song requests by using the <Highlight>/song_request</> command.

                <Bold>About ASEAN</>
                The Association of Southeast Asian Nations is made up of 10 Southeast Asian countries:
                Indonesia, Philippines, Vietnam, Thailand, Myanmar, Malaysia, Cambodia, Laos, Singapore, Brunei Darussalam.
              '';
              Password = "";
              MaxPlayers = 80;
              MaxVehiclePerPlayer = 16;
              bAllowPlayerToJoinWithCompanyVehicles = true;
              bAllowAdminToRemoveAdmin = true;
              bAllowCompanyAIDriver = true;
              bAllowCorporation = false;
              MaxHousingPlotRentalPerPlayer = 1;
              MaxHousingPlotRentalDays = 15;
              HousingPlotRentalPriceRatio = 0.1;
              bAllowModdedVehicle = true;
              NPCVehicleDensity = 0.5;
              NPCPoliceDensity = 0.0;
              bEnableHostWebAPIServer = true;
              HostWebAPIServerPassword = "";
              HostWebAPIServerPort = lib.mkDefault 8080;
              Admins = [
                {
                  UniqueNetId = "76561198378447512";
                  Nickname = "freeman";
                }
              ];
            };
          };

          users.users."github-runner-amc-deploy" = {
            isSystemUser = true;
            group = "github-runner-amc-deploy";
          };
          users.groups."github-runner-amc-deploy" = {};

          services.github-runners."amc-deploy" = {
            enable = true;
            url = "https://github.com/ASEAN-Motor-Club/amc-server";
            tokenFile = config.age.secrets.github-runner-token.path;
            package = nixpkgs-unstable.legacyPackages.${pkgs.system}.github-runner;
            extraLabels = ["deploy" "nix"];
            extraPackages = with pkgs; [nix git openssh nixos-rebuild];
            serviceOverrides = {
              # Allow SSH to localhost
              ProtectHome = "none";
            };
          };

          networking.firewall.interfaces."tailscale0".allowedTCPPorts = lib.mkIf config.services.tailscale.enable [
            config.services.motortown-server.dedicatedServerConfig.HostWebAPIServerPort
            (lib.strings.toInt config.services.motortown-server.environment.MOD_SERVER_PORT)
            # Test container ports are forwarded via privateNetwork forwardPorts
            9001   # Staging backend API (forwarded from container)
            8081   # Test game API (forwarded from container)
            5001   # Test mod server (forwarded from container)
          ];
        };

        nixosConfigurations.asean-mt-server = nixpkgs.lib.nixosSystem {
          modules = [
            ./machines/asean-mt-server/configuration.nix
            ragenix.nixosModules.default

            # Use opencode from the official flake — nixpkgs versions are too old
            ({pkgs, ...}: {
              nixpkgs.overlays = [
                (final: prev: {
                  opencode = opencode.packages.${prev.system}.default;
                })
              ];
            })

            ({...}: {
              imports = [
                ragenix.nixosModules.default
              ];
              age.secrets.steam = {
                file = ./secrets/steam.age;
                mode = "400";
                owner = "steam";
              };
              age.secrets.tailscale = {
                file = ./secrets/tailscale.age;
                mode = "400";
              };
              age.secrets.ecoUserToken = {
                file = ./secrets/ecoUserToken.age;
                mode = "400";
                owner = "steam";
              };
              age.secrets.discordlinkBotToken = {
                file = ./secrets/discordlink-bot-token.age;
                mode = "400";
                owner = "steam";
              };
              age.secrets.github-runner-token = {
                file = ./secrets/github-runner-token.age;
                mode = "400";
              };
              age.secrets.github-runner-ssh = {
                file = ./secrets/github-runner-ssh.age;
                mode = "400";
                owner = "github-runner-amc-deploy";
                path = "/var/lib/github-runner-amc-deploy/.ssh/id_ed25519";
              };
              age.secrets.opencode = {
                file = ./secrets/opencode.age;
                mode = "400";
              };
              age.secrets.oauth2-proxy = {
                file = ./secrets/oauth2-proxy.age;
                mode = "400";
              };
              age.secrets.coding-agent-app-key = {
                file = ./secrets/coding-agent-app-key.age;
                owner = "opencode";
                mode = "400";
              };
              age.secrets.backend = {
                file = ./secrets/backend.age;
                mode = "400";
              };
              age.secrets.backend-staging = {
                file = ./secrets/backend-staging.age;
                mode = "400";
              };
            })


            self.nixosModules.motortown-server
            self.nixosModules.motortown-server-containers
            ({
              config,
              pkgs,
              lib,
              ...
            }: let
              # === File-based Restart Bridge ===
              # Backend writes a trigger file → host systemd .path unit watches → starts the restart service.
              restartTriggerDir = "/var/lib/motortown-restart-trigger";

              restartScript = pkgs.writeShellScriptBin "restart-motortown" ''
                echo "restart requested at $(date)" > ${restartTriggerDir}/trigger
              '';
            in {
              imports = [
                amc-backend.nixosModules.backend
                amc-backend.nixosModules.log-listener
                (import ./nix/db_backup.nix)
              ];

              # GeoDjango native library paths
              environment.variables = {
                GEOS_LIBRARY_PATH = "${pkgs.geos}/lib/libgeos_c.so";
                GDAL_LIBRARY_PATH = "${pkgs.gdal}/lib/libgdal.so";
              };

              # Allow unfree for timescaledb
              nixpkgs.config.allowUnfree = true;

              # --- amc-backend service (production) ---
              services.amc-backend = {
                enable = true;
                port = 9000;
                allowedHosts = [
                  "api.aseanmotorclub.com"
                  "localhost"
                  "127.0.0.1"
                  "server.aseanmotorclub.com"
                  "www.aseanmotorclub.com"
                  "admin.aseanmotorclub.com"
                  "asean-mt-server"
                ];
                environmentFile = config.age.secrets.backend.path;
                environment = {
                  MOD_SERVER_API_URL = "http://localhost:5001";
                  GAME_SERVER_API_URL = "http://localhost:8080";
                  EVENT_GAME_SERVER_API_URL = "http://127.0.0.1:8082";
                  EVENT_MOD_SERVER_API_URL = "http://localhost:5011";
                  RESTART_MOTORTOWN_SCRIPT = "${restartScript}/bin/restart-motortown";
                  PARTY_BONUS_ENABLED = "1";
                  WEBHOOK_SSE_ENABLED = "1";
                };
              };

              # Point PostgreSQL at the data directory from Phase 1 bind mount
              services.postgresql.dataDir = "/var/lib/amc-postgresql/16";

              # --- Log listener (rsyslogd + RELP) ---
              services.amc-log-listener = {
                enable = true;
                relpPort = 2514;
              };

              # --- nginx vhost for api.aseanmotorclub.com ---
              services.nginx.virtualHosts."api.aseanmotorclub.com" = {
                enableACME = true;
                forceSSL = true;
                locations = {
                  "/" = {
                    proxyPass = "http://127.0.0.1:9000/api/";
                    recommendedProxySettings = true;
                    extraConfig = ''
                      add_header 'Access-Control-Allow-Origin' '*' always;
                      add_header 'Access-Control-Allow-Methods' 'POST, PUT, DELETE, GET, PATCH, OPTIONS' always;
                    '';
                  };
                  "/api" = {
                    proxyPass = "http://127.0.0.1:9000";
                    recommendedProxySettings = true;
                    extraConfig = ''
                      add_header 'Access-Control-Allow-Origin' '*' always;
                      add_header 'Access-Control-Allow-Methods' 'POST, PUT, DELETE, GET, PATCH, OPTIONS' always;
                    '';
                  };
                  "/admin" = {
                    proxyPass = "http://127.0.0.1:9000";
                    recommendedProxySettings = true;
                  };
                  "/static/" = let
                    inherit (amc-backend.packages.${pkgs.system}) staticRoot;
                  in {
                    alias = "${staticRoot}/";
                  };
                  # DokuWiki OAuth endpoints
                  "/o/" = {
                    proxyPass = "http://127.0.0.1:9000";
                    recommendedProxySettings = true;
                  };
                };
              };

              # --- nginx vhost for test.aseanmotorclub.com (staging backend) ---
              services.nginx.virtualHosts."test.aseanmotorclub.com" = {
                enableACME = true;
                forceSSL = true;
                locations = {
                  "/" = {
                    proxyPass = "http://10.250.0.2:9001/api/";
                    recommendedProxySettings = true;
                    extraConfig = ''
                      add_header 'Access-Control-Allow-Origin' '*' always;
                      add_header 'Access-Control-Allow-Methods' 'POST, PUT, DELETE, GET, PATCH, OPTIONS' always;
                    '';
                  };
                  "/api" = {
                    proxyPass = "http://10.250.0.2:9001";
                    recommendedProxySettings = true;
                    extraConfig = ''
                      add_header 'Access-Control-Allow-Origin' '*' always;
                      add_header 'Access-Control-Allow-Methods' 'POST, PUT, DELETE, GET, PATCH, OPTIONS' always;
                    '';
                  };
                  "/admin" = {
                    proxyPass = "http://10.250.0.2:9001";
                    recommendedProxySettings = true;
                  };
                  "/static/" = let
                    inherit (amc-backend.packages.${pkgs.system}) staticRoot;
                  in {
                    alias = "${staticRoot}/";
                  };
                };
              };

              # --- NAT for private-network container port forwarding ---
              networking.nat = {
                enable = true;
                internalInterfaces = [ "ve-+" ];
              };

              # --- Test container: bind-mount staging secret ---
              containers.motortown-server-test = {
                bindMounts."/run/secrets/backend-staging" = {
                  hostPath = config.age.secrets.backend-staging.path;
                  isReadOnly = true;
                };
              };

              # Prevent nspawn restart race (stale machine registration)
              systemd.services."container@motortown-server-test".serviceConfig = {
                RestartSec = "5s";
                TimeoutStopSec = "30s";
                TimeoutStartSec = lib.mkForce "30m";
                ExecStopPost = [
                  "-${pkgs.coreutils}/bin/rm -rf /run/systemd/nspawn/unix-export/motortown-server-test"
                ];
              };

              # Expose RELP + PostgreSQL on tailscale interface
              networking.firewall.interfaces."tailscale0".allowedTCPPorts = lib.mkIf config.services.tailscale.enable [
                2514  # RELP log listener
                5432  # PostgreSQL (bot read access)
              ];

              systemd.tmpfiles.rules = [
                "d /var/lib/amc-postgresql 0750 postgres postgres -"
                "d ${restartTriggerDir} 0777 root root -"
              ];

              # Host-side: watch for trigger file and start the restart service
              systemd.paths.motortown-restart-trigger = {
                description = "Watch for restart trigger from backend";
                wantedBy = [ "multi-user.target" ];
                pathConfig = {
                  PathChanged = "${restartTriggerDir}/trigger";
                  Unit = "motortown-restart-triggered.service";
                };
              };

              # Triggered by the .path unit — starts the existing motortown-server-restart service
              systemd.services.motortown-restart-triggered = {
                description = "Restart motortown-server (triggered from backend)";
                serviceConfig = {
                  Type = "oneshot";
                };
                script = ''
                  rm -f ${restartTriggerDir}/trigger
                  systemctl start motortown-server-restart.service
                '';
              };
            })
          ];
        };

        nixosConfigurations.amc-peripheral = nixpkgs.lib.nixosSystem {
          modules = [
            ./machines/amc-peripheral/configuration.nix
            ragenix.nixosModules.default
            amc-peripheral.nixosModules.default

            # Use opencode from the official flake — nixpkgs versions are too old
            ({pkgs, ...}: {
              nixpkgs.overlays = [
                (final: prev: {
                  opencode = opencode.packages.${prev.system}.default;
                })
              ];
            })

            ({config, pkgs, ...}: {
              age.secrets.peripheral-bots = {
                file = ./secrets/peripheral-bots.age;
                mode = "400";
              };
              age.secrets.cookies = {
                file = ./secrets/cookies.age;
                mode = "400";
              };
              age.secrets.opencode-peripheral = {
                file = ./secrets/opencode-peripheral.age;
                mode = "400";
                owner = "opencode";
              };
              age.secrets.oauth2-proxy-peripheral = {
                file = ./secrets/oauth2-proxy-peripheral.age;
                mode = "400";
              };
              age.secrets.coding-agent-app-key = {
                file = ./secrets/coding-agent-app-key.age;
                owner = "opencode";
                mode = "400";
              };

              services.amc-peripheral = {
                enable = true;
                environmentFile = config.age.secrets.peripheral-bots.path;
                cookiesPath = config.age.secrets.cookies.path;
                dbPath = "/var/lib/radio/radio.db";
                icecast.admin.password = "aseanmotorclub1234";
                sharry = {
                  enable = true;
                };
              };

              age.secrets.github-runner-token = {
                file = ./secrets/github-runner-token-peripheral.age;
                mode = "400";
              };
              age.secrets.github-runner-ssh = {
                file = ./secrets/github-runner-ssh.age;
                mode = "400";
              };

              services.github-runners."amc-peripheral-deploy" = {
                enable = false;
                replace = true;  # Automatically replace existing runner with same name
                url = "https://github.com/ASEAN-Motor-Club";
                tokenFile = config.age.secrets.github-runner-token.path;
                package = nixpkgs-unstable.legacyPackages.${pkgs.system}.github-runner;
                extraLabels = ["deploy-peripheral" "nix"];
                extraPackages = with pkgs; [nix git openssh nixos-rebuild];
                serviceOverrides = {
                  ProtectHome = "none";
                };
              };
            })
          ];
        };
      };
      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.nil
            pkgs.alejandra
            pkgs.nixos-rebuild
            pkgs.google-cloud-sdk
            pkgs.ffmpeg
            pkgs.rustc
            pkgs.cargo
            pkgs.jq
            pkgs.rsync
            pkgs.gh
            (import ./nix/deploy.nix {inherit pkgs;})
          ];
          buildInputs = [
            (ragenix.packages.${system}.default)
          ];
        };
      };
    };
}
