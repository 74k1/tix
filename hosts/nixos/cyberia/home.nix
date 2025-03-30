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
      fastfetch
      hyprland
      niri
      river
      cliphist
      # i3wm
      # bspwm
      #colors
      git
      jujutsu
      firefox
      nvim
      picom
      polybar
      #rofi
      # wofi
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
      fish
      yazi
      gpg-agent
    ])
  ];

  # nixpkgs = {
  #   overlays = [
  #     (final: prev: {
  #       duvolbr = outputs.packages."x86_64-linux".duvolbr;
  #     })
  #     inputs.wired-notify.overlays.default
  #   ];
  #   config = {
  #     allowUnfree = true;
  #     permittedInsecurePackages = [
  #       "electron-25.9.0"
  #     ];
  #   };
  # };

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
    berkeley-otf

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

    wezterm
    ghostty
    wired
    zellij
    #zoxide

    # gui stuff
    # brave
    plex-desktop
    # swaylock-fancy
    ungoogled-chromium
    krita
    keepassxc
    obsidian
    simple-scan
    # spotify
    #spotify-tray
    discord
    # polybar
    # ly
    # evolution

    thunderbird

    zui
    brimcap

    nautilus
    fractal
    google-chrome
    qbittorrent

    spotify-player

    mpv
    ascii-draw

    gnome-keyring

    vala
    pantheon.elementary-gtk-theme
    pantheon.elementary-icon-theme

    protonvpn-cli_2

    orca-slicer

    zathura

    prismlauncher
    jdk17
    libGLU

    telegram-desktop

    inputs.zen-browser.packages."${system}".twilight

    goodvibes
    newsflash
    hieroglyphic

    zoom-us

    onlyoffice-bin
    libreoffice-qt

    wireshark

    rage
    age-plugin-yubikey
    inputs.agenix-rekey.packages.x86_64-linux.default
    restic

    # fonts
    #material-symbols
    #siji
  ];
  
  # evolution stuff
  #services.gnome3.evolution-data-server.enable = true;

  # Whether to enable a proxy forwarding Bluetooth MIDI controls via MPRIS2 to control media players.
  services.mpris-proxy.enable = true;

  theme.ukiyo = {
    package = inputs.ukiyo.packages.x86_64-linux.default;
  };

  gtk = {
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
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
