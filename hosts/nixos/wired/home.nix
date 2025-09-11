{
  inputs,
  outputs,
  lib,
  pkgs,
  config,
  ...
}:

{
  imports = builtins.concatLists [
    # ext
    [
      inputs.stylix.homeModules.stylix
      #inputs.nix-colors.homeManagerModules.default
    ]

    # int
    (with outputs.homeManagerModules; [
      niri
      swaync
      # copyq
      fastfetch
      fuzzel
      walker
      #colors
      git
      jujutsu
      # firefox
      zen
      qutebrowser
      neovim
      # picom
      polybar
      #rofi
      #wofi
      # spotify
      starship
      #theme
      style
      #wall
      wezterm
      ghostty
      # wired
      easyeffects
      waybar
      sherlock
      hyprlock
      # kanshi
      xdg
      zsh
      fish
      yazi
      gpg-agent
    ])
  ];

  # nixpkgs = {
  #   config = {
  #     allowUnfree = true;
  #     permittedInsecurePackages = [
  #       "beekeeper-studio-5.2.12"
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
    pkgs.tix.duvolbr
    # pkgs.tix-unfree.berkeley-nolig-otf
    pkgs.tix-unfree.suisse-intl-mono
    pkgs.tix-unfree.supply-mono
    pkgs.tix-unfree.supply-sans
    fragment-mono
    ibm-plex

    # uhhh clipboard
    wl-clipboard-rs

    # term
    bat
    eza
    feh
    viu
    loupe
    seahorse
    gnome-calculator
    just
    comma
    btop

    nh

    # beekeeper-studio
    pkgs.tix.outerbase-studio-desktop

    pkgs.tix.waterfox

    # planify

    pulsemixer
    gnome-solanum
    qmk
    vial
    pkgs.stable.gaphor
    qalculate-gtk
    libqalculate
    # deploy-rs
    ripgrep
    # scc
    # starship
    tealdeer
    joshuto

    firefox
    plex-desktop

    blueman

    # wezterm
    pkgs.master.ghostty
    bitwarden-desktop
    # clipit
    universal-android-debloater
    # wired
    zellij
    # pkgs.master.zed-editor
    #zoxide
    typst
    moonlight-qt
    parsec-bin
    gradia

    mission-center

    # gui stuff
    # brave
    # osu-lazer-bin
    #inputs.zen-browser.packages."${system}".zen-browser
    # inputs.tixpkgs.packages."${system}".lumen
    # (inputs.zen-browser.packages."${system}".default.overrideAttrs (oldAttrs: {
    #   meta = {};
    # }))
    inputs.affinity-nix.packages."${system}".v3
    # (inputs.affinity-nix.packages."${system}".photo.overrideAttrs (oldAttrs: {
    #   meta = {};
    # }))
    # (inputs.affinity-nix.packages."${system}".designer.overrideAttrs (oldAttrs: {
    #   meta = {};
    # }))
    # (inputs.affinity-nix.packages."${system}".publisher.overrideAttrs (oldAttrs: {
    #   meta = {};
    # }))
    thunderbird

    # tixpkgs
    zui
    brimcap
    # pcmanfm

    # vscode

    # r2modman

    # rustdesk

    nautilus
    opencloud-desktop
    # nextcloud-client
    fractal
    # element-desktop
    fluffychat
    google-chrome
    ungoogled-chromium
    keepassxc
    obsidian
    simple-scan
    aria2
    spotify
    # spotify-tray
    # youtube-music
    # tidal-hifi
    # tidal-dl
    # cider-2
    # feishin
    # aonsoku
    spotify-player
    discord-ptb
    # legcord
    # vesktop

    davinci-resolve

    mpv
    ascii-draw
    ouch

    gnome-keyring
    gnome-clocks
    # paper-plane

    session-desktop

    # akira-unstable
    # vala
    # pantheon.elementary-gtk-theme
    # pantheon.elementary-icon-theme

    # polybar
    # evolution
    # protonvpn-gui
    plasticity

    orca-slicer
    zathura

    # prismlauncher
    # jdk17
    # libGLU

    telegram-desktop

    # inputs.zen-browser.packages."${system}".twilight

    # shortwave # radio
    goodvibes
    plexamp
    # newsflash # rss
    hieroglyphic # find latex symbols

    snapshot

    # zoom-us
    onlyoffice-desktopeditors

    wireshark

    # fonts
    #material-symbols
    #siji

    rage
    age-plugin-yubikey
    inputs.agenix-rekey.packages.x86_64-linux.default
    restic
    # firefox
  ];

  # evolution stuff
  #services.gnome3.evolution-data-server.enable = true;

  # Whether to enable a proxy forwarding Bluetooth MIDI controls via MPRIS2 to control media players.
  services.mpris-proxy.enable = true;

  theme.ukiyo = {
    package = inputs.ukiyo.packages.x86_64-linux.default;
  };

  home.sessionVariables = {
    SHELL = "${pkgs.zsh}/bin/zsh";
    EDITOR = "nvim";
    MANPAGER = "nvim +Man!";
    MANWIDTH = "999";
    QT_STYLE_OVERRIDE = lib.mkForce "";
    QT_QPA_PLATFORM = "wayland";
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
