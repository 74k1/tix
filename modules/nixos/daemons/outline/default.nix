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

    smtp = {
      host = allSecrets.global.mail.sender.host;
      port = lib.strings.toInt allSecrets.global.mail.sender.port;
      username = allSecrets.global.mail.sender.username;
      passwordFile = config.age.secrets."outline_smtp_password".path;
      replyEmail = allSecrets.global.mail.sender.username;
      fromEmail = allSecrets.global.mail.sender.username;
      secure = false;
    };

    oidcAuthentication = {
      authUrl = allSecrets.global.oidc.authUrl;
      tokenUrl = allSecrets.global.oidc.tokenUrl;
      userinfoUrl = allSecrets.global.oidc.userinfoUrl;
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
