{ config, lib, pkgs, ... }:
{
  services.pcscd = {
    enable = true;
    plugins = [];
    extraArgs = [];
    readerConfig = ''
    '';
  };
}
