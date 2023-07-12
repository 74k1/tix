{ inputs, outputs, lib, pkgs, config, ... }:

{
  imports = builtins.map (module: import (../../../modules/home-manager + "/" + module)) [
    starship
    zsh
    nvim
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # bat-extras.batman
  ];
 }
