{ inputs, outputs, config, lib, pkgs, ... }:
{
  services.atuin = {
    enable = true;
    host = "0.0.0.0";
    maxHistoryLength = 10240;
    port = 8888;
    openRegistration = false;
  };
}
