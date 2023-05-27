{ lib, pkgs, config, ... }:

{
  home.packages = with pkgs; [
    wezterm
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];

  programs.wezterm = {
    enable = true;
    extraConfig = builtins.readFile ./wezterm.lua;
  };
}
