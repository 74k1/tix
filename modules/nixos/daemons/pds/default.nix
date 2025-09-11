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
  age.secrets."bluesky_pds_env" = {
    rekeyFile = "${inputs.self}/secrets/bluesky_pds_env.age";
    # mode = "770";
    owner = "pds";
    group = "pds";
  };

  services.bluesky-pds = {
    enable = true;
    settings = {
      PDS_ADMIN_EMAIL = "mail@${allSecrets.global.domain01}";
      PDS_HOST = "0.0.0.0";
      PDS_HOSTNAME = "pds.${allSecrets.global.domain01}";
      PDS_PORT = 7777;
      PDS_CRAWLERS = lib.concatStringsSep "," [
        "https://bsky.network"
        "https://relay.upcloud.world"
        "https://relay.fire.hose.cam"
        "https://relay2.fire.hose.cam"
        "https://relay3.fr.hose.cam"
        "https://relay.hayescmd.net"
        "https://relay.xero.systems"
        "https://relay.upcloud.world"
      ];
      PDS_SERVICE_HANDLE_DOMAINS = ".${allSecrets.global.domain01}";
    };
    environmentFiles = [
      # PDS_ADMIN_PASSWORD
      # PDS_JWT_SECRET
      # PDS_PLC_ROTATION_KEY_K256_PRIVATE_KEY_HEX
      # PDS_EMAIL_SMTP_URL
      # PDS_EMAIL_FROM_ADDRESS
      config.age.secrets."bluesky_pds_env".path
    ];
    pdsadmin.enable = true;
  };
}
