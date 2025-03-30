{ inputs, outputs, config, lib, pkgs, allSecrets, ... }:
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
      frontendHostname = "td.${allSecrets.global.domain0}";
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
        #   host = "${allSecrets.global.mail.sender.host}";
        #   port = "${allSecrets.global.mail.sender.port}";
        #   authtype = "plain";
        #   username = "${allSecrets.global.mail.sender.username}";
        #   password = "${allSecrets.global.mail.sender.password}";
        # };
      };
    };

    nginx = {
      enable = true;
    };
  };
}
