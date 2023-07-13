{ inputs, outputs, lib, pkgs, config, ... }:

{
  imports = with outputs.homeManagerModules; [
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
