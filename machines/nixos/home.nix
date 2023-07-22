{ inputs, outputs, lib, pkgs, config, ... }:

{
  imports = with outputs.homeManagerModules; [
    starship
    zsh
    wezterm
    nvim
    i3wm
    wall
    # gtk
    polybar
    rofi
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
#    rofi
    polybar
    bat-extras.batman
    evolution dconf
    qmk
    ly
  ];
  
  # evolution stuff
  #programs.dconf.enable = true;
  #services.gnome3.evolution-data-server.enable = true;

  home.sessionVariables = {
    SHELL = "${pkgs.zsh}/bin/zsh";
    EDITOR = "nvim";
  };

  # set Wall
  services.wallpaper = {
    enable = true;
  };
 }
