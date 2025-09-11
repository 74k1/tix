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
      PDS_HOSTNAME = allSecrets.global.domain01;
      PDS_PORT = "3333";
      PDS_HOST = "0.0.0.0";
    };
    environmentFiles = [
      # PDS_ADMIN_PASSWORD
      # PDS_JWT_SECRET
      # PDS_PLC_ROTATION_KEY_K256_PRIVATE_KEY_HEX
      config.age.secrets."bluesky_pds_env".path
    ];
  };
}
