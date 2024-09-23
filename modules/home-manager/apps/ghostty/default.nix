{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
{
  config.home = {
    file.".config/ghostty/config".text = builtins.readFile ./cfg/config;
    packages = [
      inputs.ghostty.packages.x86_64-linux.default
    ];
  };
}
