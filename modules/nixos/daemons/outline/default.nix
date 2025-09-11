{
  config,
  pkgs,
  lib,
  inputs,
  outputs,
  allSecrets,
  ...
}:
{
  age.secrets = {
    "outline_secret_key" = {
      rekeyFile = "${inputs.self}/secrets/outline_secret_key.age";
      # mode = "770";
      owner = "outline";
      group = "outline";
    };
    # "outline_utils_secret" = {
    #   rekeyFile = "${inputs.self}/secrets/outline_utils_secret.age";
    #   # mode = "770";
    #   # owner = "";
    #   # group = "";
    # };
    "outline_oidc_client_secret" = {
      rekeyFile = "${inputs.self}/secrets/outline_oidc_client_secret.age";
      # mode = "770";
      owner = "outline";
      group = "outline";
    };
    "outline_smtp_password" = {
      rekeyFile = "${inputs.self}/secrets/outline_smtp_password.age";
      # mode = "770";
      owner = "outline";
      group = "outline";
    };
  };

  services.outline = {
    enable = true;
    package = pkgs.master.outline;
    publicUrl = "https://wiki.${allSecrets.global.domain00}";
    port = 3303;
    forceHttps = false;

    secretKeyFile = config.age.secrets."outline_secret_key".path;
    # utilsSecretFile = config.age.secrets."outline_utils_secret".path;

    storage = {
      storageType = "local";
      localRootDir = "/mnt/btrfs_pool/outline_data/";
    };

    databaseUrl = "local";
    redisUrl = "local";

    concurrency = 1; # for under 1000 users..
    maximumImportSize = 5120000;

    smtp = 
      let
        inherit (allSecrets.global.mail.sender) host username;
      in
      {
        inherit host username;
        port = lib.strings.toInt allSecrets.global.mail.sender.port;
        passwordFile = config.age.secrets."outline_smtp_password".path;
        replyEmail = username;
        fromEmail = username;
        secure = false;
      };

    oidcAuthentication = 
      let 
        inherit (allSecrets.global.oidc) authUrl tokenUrl userinfoUrl;
      in 
      {
        inherit authUrl tokenUrl userinfoUrl;
        clientId = "outline";
        clientSecretFile = config.age.secrets."outline_oidc_client_secret".path;
        scopes = [ "openid" "email" "profile" ];
        usernameClaim = "preferred_username";
        displayName = "Pocket ID";
      };
  };

  # NOTE: for debug purposes
  # systemd.services.outline.environment = {
  #   DEBUG = lib.mkForce "*";
  #   LOG_LEVEL = "debug";
  # };
}
