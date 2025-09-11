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
    inputs.tixpkgs.nixosModules'.services.booklore
  ];

  age.secrets."booklore_env" = {
    rekeyFile = "${inputs.self}/secrets/booklore_env.age";
    # mode = "770";
    # owner = "nextcloud";
    # group = "nextcloud";
  };

  services.booklore = {
    enable = true;
    database = {
      createLocally = true;
    };
    nginx = {
      enable = true;
      virtualHost = "localhost";
    };
    port = 8888;
    settings.maxBodySize = "1000M";
    environmentFile = config.age.secrets."booklore_env".path;
  };
}
