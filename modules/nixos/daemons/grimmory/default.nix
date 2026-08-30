{
  allSecrets,
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    inputs.tixpkgs.nixosModules'.services.grimmory
  ];

  age.secrets."grimmory_env" = {
    rekeyFile = "${inputs.self}/secrets/grimmory_env.age";
  };

  services.grimmory = {
    enable = true;
    database.createLocally = true;

    port = 8888;

    # Books live on the btrfs pool (see /mnt/btrfs_pool); ProtectSystem=strict
    # would otherwise block writes, so grant the service access here.
    libraryDirs = [ "/mnt/btrfs_pool/grimmory" ];

    hostname = "books.i.${allSecrets.global.domain03}";
    nginx = {
      addSSL = true;
      useACMEHost = "i.${allSecrets.global.domain03}";
    };
    settings.maxBodySize = "1000M";

    environmentFile = config.age.secrets."grimmory_env".path;
  };
}
