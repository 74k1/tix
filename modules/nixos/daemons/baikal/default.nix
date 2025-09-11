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
  services.baikal = {
    enable = true;
    virtualHost = "baikal.i.${allSecrets.global.domain03}";
  };
}
