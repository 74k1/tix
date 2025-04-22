{ inputs, outputs, lib, pkgs, config, ... }:

{
  imports = builtins.concatLists [
    # ext
    [
      inputs.stylix.homeModules.stylix
      #inputs.nix-colors.homeManagerModules.default
    ]
    
    # int
    (with outputs.homeManagerModules; [
      # hyprland
      niri
      cliphist
      fastfetch
      # i3wm
      # bspwm
      #colors
      git
      jujutsu
      # firefox
      zen
      neovim
      picom
      polybar
      #rofi
      #wofi
      # spotify
      starship
      # sxhkd
      #theme
      style
      #wall
      wezterm
      ghostty
      # wired
      # eww
      easyeffects
      ironbar
      anyrun
      xdg
      xorg
      zsh
      fish 
      yazi
      gpg-agent
    ])
  ];
  

  # nixpkgs = {
    # config = {
      # allowUnfree = true;
      # permittedInsecurePackages = [
      #   "electron-25.9.0"
      # ];
    # };
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
    # inputs.unfree-fonts.packages.x86_64-linux.berkeley-nolig-otf
    inputs.unfree-fonts.packages.x86_64-linux.suisse-intl-mono
    inputs.unfree-fonts.packages.x86_64-linux.supply-mono
    inputs.unfree-fonts.packages.x86_64-linux.supply-sans
    fragment-mono
    ibm-plex

    # uhhh clipboard
    wl-clipboard-rs
    
    # term
    bat
    eza
    feh viu
    loupe
    seahorse
    gnome-calculator
    just
    comma
    btop
    
    pulsemixer
    qmk
    ripgrep
    scc
    starship
    tealdeer
    joshuto

    blueman

    wezterm
    ghostty
    # clipit
    wired
    zellij
    zed-editor
    #zoxide
    typst
    moonlight-qt
    parsec-bin

    # gui stuff
    # brave
    osu-lazer-bin
    #inputs.zen-browser.packages."${system}".zen-browser
    # inputs.tixpkgs.packages."${system}".lumen
    # (inputs.zen-browser.packages."${system}".default.overrideAttrs (oldAttrs: {
    #   meta = {};
    # }))
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
  
    vscode

    r2modman

    rustdesk

    # TEMP
    # ocenaudio

    nautilus
    nextcloud-client
    fractal
    google-chrome
    ungoogled-chromium
    keepassxc
    obsidian
    simple-scan
    qbittorrent
    spotify
    spotify-tray
    tidal-hifi
    tidal-dl
    cider-2
    # pkgs.master.spotify-player
    feishin
    # spotify-player
    discord
    # legcord
    vesktop

    mpv
    ascii-draw
    ouch

    gnome-keyring
    paper-plane

    session-desktop

    # akira-unstable
    vala
    # pantheon.elementary-gtk-theme
    # pantheon.elementary-icon-theme

    # polybar
    # ly
    # evolution
    protonvpn-gui
    plasticity
    # cura
    # curaengine_stable

    # inputs.orca-fix.outputs.legacyPackages.x86_64-linux.orca-slicer
    # pkgs.master.orca-slicer
    orca-slicer
    # prusa-slicer
    zathura

    prismlauncher
    jdk17
    libGLU

    telegram-desktop

    # inputs.zen-browser.packages."${system}".twilight

    # shortwave # radio
    goodvibes
    plexamp
    newsflash # rss
    hieroglyphic # find latex symbols

    snapshot

    zoom-us
    onlyoffice-bin
    libreoffice-qt

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
