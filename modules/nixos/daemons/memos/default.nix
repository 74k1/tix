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
  };

  services.memos = rec {
    enable = true;
    dataDir = "/mnt/btrfs_pool/memos_data/";
    settings = {
      MEMOS_MODE = "prod";
      MEMOS_ADDR = "0.0.0.0";
      MEMOS_PORT = "5230";
      MEMOS_DATA = dataDir;
      MEMOS_DRIVER = "sqlite";
      MEMOS_INSTANCE_URL = "https://notes.${allSecrets.global.domain00}";
    };
  };
}
