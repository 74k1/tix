{ inputs, outputs, lib, pkgs, config, ... }:

{
  # imports =
  #   (base:
  #     (builtins.map
  #       (module:
  #         base + "/" + module)
  #       (builtins.attrNames
  #         (builtins.readDir
  #           base))))
  #   ./modules;

  imports = [
    ./modules/starship
    ./modules/zsh
    ./modules/wezterm
    ./modules/nvim
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
    inputs.ukiyo.packages."x86_64-linux".default papirus-icon-theme
    tree
    brave
    keepassxc
    starship
    wezterm
  ];
}
