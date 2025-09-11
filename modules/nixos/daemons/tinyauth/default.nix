{
  allSecrets,
  config,
  inputs,
  lib,
  outputs,
  pkgs,
  ...
}:
{
  age.secrets."tinyauth_env" = {
    rekeyFile = "${inputs.self}/secrets/tinyauth_env.age";
    # mode = "770";
    # owner = "syncthing";
    # group = "syncthing";
  };

  services.tinyauth = {
    enable = true;
    package = pkgs.master.tinyauth;

    # TINYAUTH_OAUTH_PROVIDERS_POCKETID_CLIENTID
    # TINYAUTH_OAUTH_PROVIDERS_POCKETID_CLIENTSECRET
    environmentFile = config.age.secrets."tinyauth_env".path;

    settings = {
      APPURL = "https://auth.${allSecrets.global.domain01}";
      SERVER_PORT = 3030;
      SERVER_ADDRESS = "0.0.0.0";
      OAUTH_AUTOREDIRECT = "pocketid";

      OAUTH_PROVIDERS_POCKETID_AUTHURL = allSecrets.global.oidc.authUrl;
      OAUTH_PROVIDERS_POCKETID_TOKENURL = allSecrets.global.oidc.tokenUrl;
      OAUTH_PROVIDERS_POCKETID_USERINFOURL = allSecrets.global.oidc.userinfoUrl;
      OAUTH_PROVIDERS_POCKETID_REDIRECTURL = "https://auth.${allSecrets.global.domain01}/api/oauth/callback/pocketid";
      OAUTH_PROVIDERS_POCKETID_SCOPES = "openid email profile groups";
      OAUTH_PROVIDERS_POCKETID_NAME = "Pocket ID";

      # app specific
      # where [NAME] is: "https://[NAME].example.com/"
      # APPS_[NAME]_OAUTH_GROUPS
      APPS_SCROBBLE_OAUTH_GROUPS = "tinyauth_scrobble_user";
    };
  };
}
