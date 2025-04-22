{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  ...
}: let
  cfg_sonarr = config.services.sonarr;
in {
  disabledModules = [ "services/misc/servarr/prowlarr.nix" ];

  imports = [
    "${inputs.jf-uu-overseerr}/nixos/modules/services/misc/overseerr.nix"
    "${inputs.nixpkgs-master}/nixos/modules/services/misc/servarr/prowlarr.nix"
    ./radarr-alt.nix
    ./sonarr-alt.nix
    ./radarr-alp.nix
    ./sonarr-alp.nix
  ];

  services = {
    # Request
    overseerr = {
      enable = true;
      package = inputs.jf-uu-overseerr.outputs.legacyPackages.x86_64-linux.overseerr;
      user = "taki";
      group = "users";
    };

    # Indexer
    prowlarr = {
      enable = true;
      settings.update.automatically = false;
    };

    # Music
    # lidarr = {
    #   enable = true;
    #   package = pkgs.tix.lidarr;
    # };

    # Movies
    radarr = {
      enable = true;
      settings.update.automatically = false;
    };
    radarr-alt = {
      enable = true;
    };
    radarr-alp = {
      enable = true;
    };

    # TV
    sonarr = {
      enable = true;
      settings.update.automatically = false;
    };
    sonarr-alt = {
      enable = true;
    };
    sonarr-alp = {
      enable = true;
    };
  };

  users.users = {
    # lidarr.extraGroups = ["plex" "transmission"];
    radarr.extraGroups = ["plex" "transmission"];
    radarr-alt.extraGroups = ["plex" "transmission"];
    radarr-alp.extraGroups = ["plex" "transmission"];
    sonarr.extraGroups = ["plex" "transmission"];
    sonarr-alp.extraGroups = ["plex" "transmission"];
  };

  virtualisation.quadlet = let 
    inherit (config.virtualisation.quadlet) networks pods;
  in {
    containers = { 
  #     "homarr" = {
  #       autoStart = true;
  #       serviceConfig = {
  #         RestartSec = "10";
  #         Restart = "always";
  #       };
  #       containerConfig = {
  #         image = "ghcr.io/ajnart/homarr:latest";
  #         publishPorts = [ "7575:7575" ];
  #         userns = "keep-id";
  #         networks = [ networks.podman-bridge.ref ]; 
  #         # networks = [ "podman" networks.podman-bridge.ref ];
  #         # pod = pods.servarr.ref;
  #         volumes = [
  #           # optional for docker integration
  #           #"/var/run/docker.sock:/var/run/docker.sock"
  #           "/var/lib/homarr/configs:/app/data/configs"
  #           "/var/lib/homarr/icons:/app/public/icons"
  #           "/var/lib/homarr/data:/data"
  #         ];
  #       };
  #     };
  #     "overseerr" = {
  #       autoStart = true;
  #       serviceConfig = {
  #         RestartSec = "10";
  #         Restart = "always";
  #       };
  #       containerConfig = {
  #         image = "sctx/overseerr:1.32.5";
  #         # publishPorts = [ "5055:5055" ];
  #         # userns = "keep-id";
  #         # networks = [ "host" ]; 
  #         networks = [ "host" ]; 
  #         # dns = [ "9.9.9.9" "149.112.112.112" ];
  #         # networks = [ "podman" networks.podman-bridge.ref ];
  #         # pod = pods.servarr.ref;
  #         volumes = [
  #           "/var/lib/overseerr/config:/app/config"
  #         ];
  #         environments = {
  #           LOG_LEVEL = "warn";
  #           TZ = "Europe/Zurich";
  #           # optional
  #           #PORT = "5055";
  #         };
  #       };
  #     };
      "flaresolverr" = {
        autoStart = true;
        serviceConfig = {
          RestartSec = "10";
          Restart = "always";
        };
        containerConfig = {
          image = "ghcr.io/flaresolverr/flaresolverr:latest";
          publishPorts = [ "8191:8191" ];
          networks = [ "podman" ];
          # networks = [ networks.podman-bridge.ref ]; 
          # networks = [ "podman" networks.podman-bridge.ref ];
          # pod = pods.servarr.ref;
          environments = {
            LOG_LEVEL = "info";
            LOG_HTML = "false";
            CAPTCHA_SOLVER = "none";
            TZ = "Europe/Zurich";
          };
        };
      };
    };
  };
}
