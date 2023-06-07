{ inputs, outputs, lib, pkgs, config, ... }:

{
  # imports =
  #   (base:
  #     (builtins.map
  #       (module:
  #         base + "/" + module)
  #       (builtins.attrNames
  #         (builtins.readDir
  #           base))))
  #   ./modules;

  imports = [
    ./modules/starship
    ./modules/zsh
    ./modules/wezterm
    ./modules/nvim
    ./modules/i3wm
    ./modules/wall
  ];

  nixpkgs = {
    overlays = [];
    config.allowUnfree = true;
  };

  home = {
    username = "taki";
    homeDirectory = "/home/taki";
    stateVersion = "22.11";
    sessionVariables = { 
      SHELL = "${pkgs.zsh}/bin/zsh";
      EDITOR = "nvim";
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    inputs.ukiyo.packages."x86_64-linux".default papirus-icon-theme
    wezterm
    tree
    brave
    keepassxc
    obsidian
    starship
    spotify
    spotify-tray
    discord
    feh
    rofi
    polybar
    bat-extras.batman
  ];
  
  # xsession = {
  #   enable = true;
  #   initExtra = ''
  #     tempfile=$(${pkgs.coreutils}/bin/mktemp)
  #     ${pkgs.curl}/bin/curl https://wall.74k1.sh/ --output $tempfile && ${pkgs.feh}/bin/feh --bg-fill $tempfile && rm $tempfile
  #   '';
  # };

  # set Wall
  services.wallpaper = {
    enable = true;
  };

  # # set Wall :)
  # services.wallpaper = {
  #   enable = true;
  # #  runOnce = true;
  # };

  # home.file.".background-image" = {
  #   source = pkgs.fetchurl {
  #     url = "https://wall.74k1.sh/radhika-agarwal-bQWp1wPtlnI-unsplash.png";
  #     sha256 = "sha256-kXJfr5Z0GME2G/0ccGjhEn/lUjZ/IZ/nkUogvloakIA=";
  #   };
  #   # source = outputs.packages."x86_64-linux".image.overrideAttrs (oldAttrs:
  #   #   {
  #   #     src = pkgs.fetchurl {
  #   #       url = "https://wall.74k1.sh/";
  #   #       sha256 = "sha256-ZPSFq31EXL2eUtA4FmQNSRfrEZnOTeW3reLGDnkhy0A=";
  #   #     };
  #   #   }
  #   # );
  # };
 }
