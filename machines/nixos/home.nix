{ inputs, outputs, lib, pkgs, config, ... }:

{
  imports = builtins.concatLists [
    # ext
    [
      inputs.wired.homeManagerModules.default
    ]
    
    # int
    (with outputs.homeManagerModules; [
      git
      #i3wm
      nvim
      bspwm
      picom
      sxhkd
      spotify
      polybar
      rofi
      starship
      theme
      wall
      wezterm
      wired
      xdg
      xorg
      zsh
    ])
  ];

  nixpkgs = {
    overlays = [
      (final: prev: {
        duvolbr = outputs.packages."x86_64-linux".duvolbr;
      })
      inputs.wired.overlays.default
    ];
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
    duvolbr

    # term
    bat bat-extras.batman
    eza
    feh viu
    pulsemixer
    qmk
    ripgrep
    scc
    starship
    tealdeer
    wezterm
    wired
    zellij

    # gui stuff
    brave
    keepassxc
    obsidian
    #spotify
    #spotify-tray
    discord
    # polybar
    # ly
    # evolution

    # fonts
    #material-symbols
    #siji
  ];
  
  # evolution stuff
  #services.gnome3.evolution-data-server.enable = true;

  theme.ukiyo = {
    package = inputs.ukiyo.packages.x86_64-linux.default;
  };

  home.sessionVariables = {
    SHELL = "${pkgs.zsh}/bin/zsh";
    EDITOR = "nvim";
  };

  # set Wall
  services.wallpaper = {
    enable = true;
    # setWallCommand = "xfconf-query -c xfce4-desktop -p $(xfconf-query -c xfce4-desktop -l | grep 'workspace0/last-image') -s $tempfile";
  };

  # enable wezterm transparency
  programs.wezterm = {
    transparency = true;
  };
}
