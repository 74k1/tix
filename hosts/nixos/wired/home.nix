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
      # walker
      #colors
      git
      jujutsu
      # firefox
      qutebrowser

      waterfox
      neovim
      # picom
      # polybar
      #rofi
      #wofi
      spotify
      starship
      #theme
      style
      #wall
      mpv
      wezterm
      ghostty
      # wired
      easyeffects
      waybar
      sherlock
      hyprlock
      # ashell
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
    # inputs.hythera-waterfox.outputs.legacyPackages.${system}.waterfox

    uutils-coreutils-noprefix

    # theme
    papirus-icon-theme

    # my own scriptiboo
    # pkgs.tix-unfree.berkeley-nolig-otf
    pkgs.tix-unfree.suisse-intl-mono
    pkgs.tix-unfree.supply-mono
    pkgs.tix-unfree.supply-sans
    fragment-mono
    ibm-plex

    pkgs.tix.arcbrush

    inputs.aurora.outputs.packages.x86_64-linux.default
    inputs.vesper.outputs.packages.x86_64-linux.default

    # uhhh clipboard
    wl-clipboard-rs

    # term
    bat
    eza
    feh
    viu
    viddy
    loupe
    seahorse
    gnome-calculator
    just
    comma
    btop

    nh
    cachix

    pixieditor
    pi-coding-agent
    claude-code

    # beekeeper-studio
    pkgs.tix.outerbase-studio-desktop

    # pkgs.tix.waterfox

    pkgs.master.graphite

    # planify

    pulsemixer
    gh
    gnome-solanum
    inkscape
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

    remmina
    parsec-bin

    mumble

    # wezterm
    pkgs.master.ghostty
    # clipit
    universal-android-debloater
    # wired
    zellij
    pkgs.zed-editor
    pkgs.master.opencode
    #zoxide
    typst
    # moonlight-qt
    pkgs.tix.moonlight-qt-fork
    parsec-bin
    gradia
    scrcpy

    v4l-utils
    cameractrls
    cameractrls-gtk4

    krita

    reaper
    reaper-sws-extension
    reaper-reapack-extension
    renoise

    mission-center

    gnome-font-viewer

    ptouch-print

    # gui stuff
    # brave
    pkgs.master.osu-lazer-bin
    # inputs.tixpkgs.packages."${system}".lumen
    inputs.affinity-nix.packages.${pkgs.stdenv.hostPlatform.system}.v3
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
    # fractal
    element-desktop
    # fluffychat
    google-chrome
    ungoogled-chromium
    keepassxc
    obsidian
    simple-scan
    aria2
    # spotify (replaced by spicetify-nix module)
    # spotify-tray
    # youtube-music
    # tidal-hifi
    # tidal-dl
    pkgs.tix-unfree.cider
    # cider-2
    # feishin
    # aonsoku
    # spotify-player
    # (ncspot.override { withCover = true; })
    discord-ptb

    meow

    teamspeak6-client

    rapidraw
    rawtherapee
    darktable
    # legcord
    # vesktop

    davinci-resolve

    mpv
    ascii-draw
    ouch

    gnome-keyring
    gnome-clocks
    # paper-plane

    # akira-unstable
    # vala
    # pantheon.elementary-gtk-theme
    # pantheon.elementary-icon-theme

    # polybar
    # evolution
    # protonvpn-gui
    proton-vpn-cli
    plasticity

    orca-slicer
    zathura

    # prismlauncher
    # jdk17
    # libGLU

    telegram-desktop

    pkgs.master.shortwave

    goodvibes
    plexamp
    # newsflash # rss
    hieroglyphic # find latex symbols

    snapshot

    # zoom-us
    onlyoffice-desktopeditors

    # wireshark

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
    XDG_DATA_DIRS = "$XDG_DATA_DIRS:${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}";
  };

  # set Wall
  #services.wallpaper = {
  #  enable = true;
  #  setWallCommand = "${lib.getExe pkgs.awww} img $tempfile";
  #};

  # enable wezterm transparency
  programs.wezterm = {
    transparency = true;
  };

  systemd.user.services.grant-camera-portal = {
    Unit = {
      Description = "Pre-authorize camera portal for unsandboxed apps";
      After = [ "xdg-permission-store.service" ];
      Requires = [ "xdg-permission-store.service" ];
    };
    Service = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart =
        let
          busctl = "${pkgs.dbus}/bin/busctl";
        in
        "${busctl} --user call org.freedesktop.impl.portal.PermissionStore /org/freedesktop/impl/portal/PermissionStore org.freedesktop.impl.portal.PermissionStore SetPermission sbssas devices true camera '' 1 yes";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
