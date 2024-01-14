{ config, lib, pkgs, ... }:
{
  services = {
    vikunja = {
      enable = true;
      setupNginx = true;
      frontendHostname = "example.com";
      frontendScheme = "http";

      #environmentFiles = [ "/home/taki/vikunja_env_secrets" ];

      settings = {
        service.enableregistration = false;

        defaultsettings = {
          avatar_provider = "gravatar";
          week_start = 1; # monday
        };
      };
    };

    # hm
    nginx = {
      enable = true;
    };
  };
}
