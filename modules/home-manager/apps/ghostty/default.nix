{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
{
  home = {
    file.".config/ghostty/config".source = ./config;
    packages = [
      pkgs.master.ghostty
    ];
  };
}
