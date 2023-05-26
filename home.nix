{ inputs, outputs, lib, pkgs, config, ... }:

{
  imports = [
  ];

  nixpkgs = {
    overlays = [];

    config.allowUnfree = true;
  };

  home = {
    username = "taki";
    homeDirectory = "/home/taki";
    stateVersion = "22.11";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    brave
    keepassxc
    starship
  ];

  # other stuff, like sway
}
