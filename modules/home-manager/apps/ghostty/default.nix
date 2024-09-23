{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
{
  home = {
    file.".config/ghostty/config".text = builtins.readFile ./config;
    packages = [
      inputs.ghostty.packages.x86_64-linux.default
    ];
  };
}
