{ config, lib, pkgs, ... }:
{
  services.vikunja = {
    enable = true;
    setupNginx = true;
    frontendHostname = "192.168.1.65";
    frontendScheme = "http";

    #environmentFiles = [ "/home/taki/vikunja_env_secrets" ];

    settings = {
      service.enableregistration = true;

      defaultsettings = {
        avatar_provider = "gravatar";
        week_start = 1; # monday
      };
    };
  };
}
