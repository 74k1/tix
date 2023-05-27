{ inputs, outputs, lib, pkgs, config, ... }:

{
  imports = [
    ./home-manager-modules/starship
    ./home-manager-modules/zsh
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
    inputs.ukiyo.packages."x86_64-linux".default
    brave
    keepassxc
    starship
    wezterm
  ];
}
