{ inputs, outputs, config, lib, pkgs, ... }:
{
  age.secrets."vikunja_secret" = {
    rekeyFile = "${inputs.self}/secrets/vikunja_secret.age";
    # mode = "770";
    # owner = "";
    # group = "";
  };
  services = {
    vikunja = {
      enable = true;
      frontendHostname = "td.example.com";
      frontendScheme = "https";

      # doesnt exist v
      # environmentFile = config.age.secrets."vikunja_secret".path;

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
        # do they have file pass?
        # };
      };
    };

    nginx = {
      enable = true;
    };
  };
}
