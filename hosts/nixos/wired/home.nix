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
      river
      # i3wm
      # bspwm
      #colors
      git
      nvim
      picom
      polybar
      #rofi
      #wofi
      #spotify
      starship
      # sxhkd
      #theme
      style
      #wall
      wezterm
      ghostty
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
        berkeley-ttf = outputs.packages."x86_64-linux".berkeley-ttf;
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
    berkeley-ttf 

    # uhhh clipboard
    wl-clipboard-rs
    
    # term
    bat
    eza
    feh viu
    pulsemixer
    qmk
    ripgrep
    scc
    starship
    tealdeer
    joshuto

    wezterm
    inputs.ghostty.packages."${system}".default
    wired
    zellij
    #zoxide

    # gui stuff
    brave
    #inputs.zen-browser.packages."${system}".zen-browser
    inputs.zen-browser.packages."${system}".default
    thunderbird
    pcmanfm
    google-chrome
    ungoogled-chromium
    keepassxc
    obsidian
    simple-scan
    # spotify
    #spotify-tray
    inputs.nixpkgs-master.outputs.legacyPackages.x86_64-linux.spotify-player
    # spotify-player
    discord
    vesktop
    # polybar
    # ly
    # evolution
    mullvad-vpn
    plasticity
    # cura
    # curaengine_stable
    orca-slicer

    prismlauncher
    jdk17
    libGLU

    zoom-us

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
