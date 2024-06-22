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
