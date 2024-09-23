{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
{
  home.file.".config/ghostty/config".text = builtins.readFile ./cfg/config;
  config.home.packages = [
    inputs.ghostty.packages.x86_64-linux.default
  ];
}
