{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  allSecrets,
  ...
}:
{
  imports = [
    inputs.tixpkgs.nixosModules'.services.yopass
  ];

  # age.secrets."multi-scrobbler_env" = {
  #   rekeyFile = "${inputs.self}/secrets/multi-scrobbler_env.age";
  #   # mode = "770";
  #   # owner = "multi-scrobbler";
  #   # group = "multi-scrobbler";
  # };

  services.yopass = {
    enable = true;
    address = "0.0.0.0";
    port = 1337;
  };
}
