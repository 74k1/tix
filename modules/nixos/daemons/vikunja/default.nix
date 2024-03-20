{ config, lib, pkgs, ... }:
{
  services = {
    vikunja = {
      enable = true;
      frontendHostname = "td.example.com";
      frontendScheme = "https";

      #environmentFiles = [ "/home/taki/vikunja_env_secrets" ];

      settings = {
        service.enableregistration = false;

        defaultsettings = {
          avatar_provider = "gravatar";
          week_start = 1; # monday
        };
      };
    };

    nginx = {
      enable = true;
    };
  };
}
