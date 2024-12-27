{
  config,
  lib,
  pkgs,
  inputs,
  outputs,
  ...
}: {
  services.rustdesk-server = {
    enable = true;
  };
}
