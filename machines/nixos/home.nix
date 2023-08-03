{ inputs, outputs, lib, pkgs, config, ... }:

{
  imports = with outputs.homeManagerModules; [
    git
    gtk
    i3wm
    nvim
    picom
    polybar
    rofi
    starship
    wall
    wezterm
    xdg
    xorg
    zsh
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
    # theme
    papirus-icon-theme
    
    # my own scriptiboo
    (import ../../modules/home-manager/i3wm/duvolbr.nix { inherit pkgs; })

    # term
    wezterm
    starship
    feh viu
    bat bat-extras.batman
    dunst
    exa
    ripgrep
    scc
    tealdeer
    xplr
    zellij
    qmk

    # gui stuff
    brave
    keepassxc
    obsidian
    spotify
    spotify-tray
    discord
    polybar # move to config.nix
    # ly
    # evolution
  ];
  
  # evolution stuff
  #services.gnome3.evolution-data-server.enable = true;

  gtk.ukiyo = {
    package = inputs.ukiyo.packages.x86_64-linux.default;
  };

  home.sessionVariables = {
    SHELL = "${pkgs.zsh}/bin/zsh";
    EDITOR = "nvim";
  };

  # set Wall
  services.wallpaper = {
    enable = true;
  };

  # enable wezterm transparency
  programs.wezterm = {
    transparency = true;
  };
}
