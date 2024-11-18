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
      # firefox
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
      gpg-agent
    ])
  ];
  

  # nixpkgs = {
  #   # overlays = [
  #   #   (final: prev: {
  #   #     duvolbr = outputs.packages.${pkgs.hostPlatform.system}.duvolbr;
  #   #     berkeley-ttf = outputs.packages.${pkgs.hostPlatform.system}.berkeley-ttf;
  #   #   })
  #   #   inputs.wired-notify.overlays.default
  #   # ];
  #   # config = {
  #   #   allowUnfree = true;
  #   #   permittedInsecurePackages = [
  #   #     "electron-25.9.0"
  #   #   ];
  #   # };
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
    clipit
    wired
    zellij
    #zoxide

    # gui stuff
    brave
    #inputs.zen-browser.packages."${system}".zen-browser
    inputs.self.packages."${system}".lumen
    inputs.zen-browser.packages."${system}".default
    thunderbird
    pcmanfm
    google-chrome
    ungoogled-chromium
    keepassxc
    obsidian
    simple-scan
    qbittorrent
    # spotify
    #spotify-tray
    # inputs.nixpkgs-master.outputs.legacyPackages.x86_64-linux.spotify-player
    spotify-player
    discord
    vesktop
    # polybar
    # ly
    # evolution
    mullvad-vpn
    plasticity
    # cura
    # curaengine_stable
    # inputs.nixpkgs-master.outputs.legacyPackages.x86_64-linux.orca-slicer
    # orca-slicer
    prusa-slicer
    zathura

    prismlauncher
    jdk17
    libGLU

    telegram-desktop

    # shortwave # radio
    goodvibes
    newsflash # rss
    hieroglyphic # find latex symbols

    zoom-us
    # onlyoffice-bin
    libreoffice-qt

    # fonts
    #material-symbols
    #siji

    rage
    age-plugin-yubikey
    inputs.agenix-rekey.packages.x86_64-linux.default
    restic
    firefox
  ];
  
  # evolution stuff
  #services.gnome3.evolution-data-server.enable = true;

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
