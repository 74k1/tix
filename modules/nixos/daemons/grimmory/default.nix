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

    # 8899: was 8888, which collided with services.atuin (also 8888 on this
    # host) and sat in the path of anyone muscle-memorying "8888 = LLM" —
    # Booklore accepts TCP then black-holes unknown HTTP, which reads as a
    # silent hang (2026-09 parallel-streams investigation).
    port = 8899;
    # Bind all interfaces so the self-managed nginx vhost can reach it at
    # ${allSecrets.per_host.eiri.int_ip}:8899 (module default is 127.0.0.1).
    host = "0.0.0.0";

    libraryDirs = [ "/mnt/btrfs_pool/grimmory" ];

    environmentFile = config.age.secrets."grimmory_env".path;
  };
}
