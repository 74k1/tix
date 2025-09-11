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
    virtualHost = "baikal.eiri.${allSecrets.global.domain01}";
  };
}
