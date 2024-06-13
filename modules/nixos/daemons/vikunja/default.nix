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

        # mailer = {
        #   enabled = true;
        #   host = "example.com";
        #   port = "587";
        #   authtype = "plain";
        #   username = "mail@example.com";
        #   password = "pass"; # TODO; once secret management is working
        # };
      };
    };

    nginx = {
      enable = true;
    };
  };
}
