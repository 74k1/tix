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
    # Bind all interfaces so the self-managed nginx vhost can reach it at
    # ${allSecrets.per_host.eiri.int_ip}:8888 (module default is 127.0.0.1).
    host = "0.0.0.0";

    libraryDirs = [ "/mnt/btrfs_pool/grimmory" ];

    environmentFile = config.age.secrets."grimmory_env".path;
  };
}
