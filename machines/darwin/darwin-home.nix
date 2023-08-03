{ inputs, outputs, lib, pkgs, config, ... }:

{
  imports = with outputs.homeManagerModules; [
    starship
    zsh
    nvim
  ];

  home = {
    username = lib.mkForce "74k1";
    homeDirectory = lib.mkForce "/Users/74k1";
    stateVersion = "23.05";
  };

  # let home-manager install and manage itself
  programs.home-manager.enable = true;

  nixpkgs = {
    overlays = [];
    config.allowUnfree = true;
  };


  home.packages = with pkgs; [
    yabai
    skhd
    
    bat-extras.batman
    keepassxc
    discord
    obsidian
    qbittorrent
    # neovim
    # karabiner-elements
  ];

  # install macos applications to the user env if the targetplatform is darwin
  home.file."Applications/home-manager".source = let
  apps = pkgs.buildEnv {
    name = "home-manager-applications";
    paths = config.home.packages;
    pathsToLink = "/Applications";
  };
  in lib.mkIf pkgs.stdenv.targetPlatform.isDarwin "${apps}/Applications";

  disabledModules = [
    "targets/darwin/linkapps.nix"
  ];

  home.sessionVariables = {
    SHELL = "${pkgs.zsh}/bin/zsh";
    EDITOR = "nvim";
  };
}
