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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # WM
    yabai
    skhd
    
    bat-extras.batman
    keepassxc
    # discord
    obsidian
    # neovim
    # karabiner-elements
  ];

  nixpkgs.config.allowUnfree = true;

  home.sessionVariables = {
    SHELL = "${pkgs.zsh}/bin/zsh";
    EDITOR = "nvim";
  };
}
