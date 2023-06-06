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
    #./modules/wall
    ./modules/i3wm
    ./modules/autorandr-rs
  ];

  nixpkgs = {
    overlays = [];
    config.allowUnfree = true;
  };

  home = {
    username = "taki";
    homeDirectory = "/home/taki";
    stateVersion = "22.11";
    sessionVariables = { 
      SHELL = "${pkgs.zsh}/bin/zsh";
      EDITOR = "nvim";
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    inputs.ukiyo.packages."x86_64-linux".default papirus-icon-theme
    wezterm
    tree
    brave
    keepassxc
    obsidian
    starship
    spotify
    spotify-tray
    discord
    feh
    rofi
    polybar
    bat-extras.batman
  ];

  services.autorandr-rs = {
    enable = false;
    config = ./modules/autorandr-rs/monitors.toml;
  };

  # set Wall
  #wall.setWall.enable = true;
}
