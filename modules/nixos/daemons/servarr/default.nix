{ config, lib, pkgs, ... }:
{
  services = {
    # Indexer
    prowlarr.enable = true;

    # Music
    lidarr.enable = true;

    # Movies
    radarr.enable = true;

    # TV
    sonarr.enable = true;
  };

  virtualisation.arion = {
    backend = "docker";
    projects = {
      "homarr".settings.services."homarr".service = {
        image = "ghcr.io/ajnart/homarr:latest";
        restart = "unless-stopped";
        volumes = [
          # optional for docker integration
          #"/var/run/docker.sock:/var/run/docker.sock"
          "/var/lib/homarr/configs:/app/data/configs"
          "/var/lib/homarr/icons:/app/public/icons"
          "/var/lib/homarr/data:/data"
        ];
        ports = [
          ''''${PORT:-7575}:7575''
        ];
      };
      "flaresolverr".settings.services."flaresolverr".service = {
        image = "ghcr.io/flaresolverr/flaresolverr:latest";
        restart = "unless-stopped";
        environment = {
          LOG_LEVEL = ''''${LOG_LEVEL:-info}'';
          LOG_HTML = ''''${LOG_HTML:-false}'';
          CAPTCHA_SOLVER = ''''${CAPTCHA_SOLVER:-none}'';
          TZ = "Europe/Zurich";
        };
        ports = [
          ''''${PORT:-8191}:8191''
        ];
      };
    };
  };
}
