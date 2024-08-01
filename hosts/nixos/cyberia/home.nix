{ inputs, outputs, lib, pkgs, config, ... }:

{
  imports = builtins.concatLists [
    # ext
    [
      inputs.wired-notify.homeManagerModules.default
      inputs.stylix.homeManagerModules.stylix
      #inputs.nix-colors.homeManagerModules.default
    ]
    
    # int
    (with outputs.homeManagerModules; [
      hyprland
      # i3wm
      # bspwm
      #colors
      git
      nvim
      picom
      # polybar
      #rofi
      # wofi
      #spotify
      starship
      # sxhkd
      #theme
      style
      #wall
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
      inputs.wired-notify.overlays.default
    ];
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "electron-25.9.0"
      ];
    };
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
    joshuto
    spotify-player
    wezterm
    wired
    zellij
    #zoxide

    # gui stuff
    brave
    ungoogled-chromium
    krita
    keepassxc
    obsidian
    gnome.simple-scan
    # spotify
    #spotify-tray
    # discord
    vesktop
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
  #services.wallpaper = {
  #  enable = true;
  #  setWallCommand = "${pkgs.swww}/bin/swww img $tempfile";
  #};

  # enable wezterm transparency
  programs.wezterm = {
    transparency = true;
  };
}
