{ inputs, outputs, lib, pkgs, config, ... }:

{
  imports = builtins.concatLists [
    # ext
    # [
    #   inputs.wired-notify.homeManagerModules.default
    #   inputs.stylix.homeManagerModules.stylix
    #   #inputs.nix-colors.homeManagerModules.default
    # ]
    
    # int
    (with outputs.homeManagerModules; [
      # hyprland
      # i3wm
      # bspwm
      #colors
      git
      nvim
      # picom
      # polybar
      #rofi
      #wofi
      #spotify
      # starship
      # sxhkd
      #theme
      # style
      #wall
      # wezterm
      # ghostty
      # wired
      # xdg
      # xorg
      zsh
    ])
  ];
  

  nixpkgs = {
    # overlays = [
    #   inputs.wired-notify.overlays.default
    # ];
    config = {
      allowUnfree = true;
      # permittedInsecurePackages = [
      #   "electron-25.9.0"
      # ];
    };
  };

  home = {
    username = "taki";
    homeDirectory = lib.mkForce "/mnt/c/Users/taki";
    stateVersion = "22.11";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # theme
    # papirus-icon-theme
    
    # my own scriptiboo
    # pkgs.tix.duvolbr
    # inputs.unfree-fonts.packages.x86_64-linux.berkeley-nolig-nerd-otf

    # uhhh clipboard
    # wl-clipboard-rs
    
    # term
    bat
    eza
    feh viu
    pulsemixer
    qmk
    ripgrep
    scc
    # starship
    tealdeer
    joshuto

    # wezterm
    # inputs.ghostty.packages."${system}".default
    # wired
    zellij
    #zoxide

    # gui stuff
    # brave
    # inputs.zen-browser.packages."${system}".zen-browser
    # ungoogled-chromium
    # keepassxc
    # obsidian
    # simple-scan
    # spotify
    #spotify-tray
    # spotify-player
    # discord
    # polybar
    # ly
    # evolution

    # fonts
    #material-symbols
    #siji
  ];
  
  # evolution stuff
  #services.gnome3.evolution-data-server.enable = true;

  # theme.ukiyo = {
  #   package = inputs.ukiyo.packages.x86_64-linux.default;
  # };

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
  # programs.wezterm = {
  #   transparency = true;
  # };
}

