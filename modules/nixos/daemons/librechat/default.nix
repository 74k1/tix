{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    "${inputs.tixpkgs}/modules/nixos/misc/librechat.nix"
  ];
  age.secrets."librechat_env" = {
    rekeyFile = "${inputs.self}/secrets/librechat_env.age";
    # mode = "770";
    # owner = "librechat";
    # group = "librechat";
  };
  services.librechat = {
    enable = true;
    port = 3080;
    environmentFile = config.age.secrets."librechat_env".path;
    database = {
      createLocally = true;
      # url = "mongodb://external-host:27017/LibreChat";  # if using external MongoDB
    };
  };
}
