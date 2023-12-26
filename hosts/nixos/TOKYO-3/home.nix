{ inputs, outputs, lib, pkgs, config, ... }:

{
  imports = builtins.concatLists [
    # int
    (with outputs.homeManagerModules; [
      git
      nvim
      starship
      zsh
    ])
  ];

  nixpkgs.config.allowUnfree = true;

  home = {
    username = "taki";
    homeDirectory = "/home/taki";
    stateVersion = "23.05";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # term
    #zoxide
    bat bat-extras.batman
    eza
    feh viu
    ripgrep
    scc
    starship
    tealdeer
    wezterm
    zellij
  ];
  
  home.sessionVariables = {
    SHELL = "${pkgs.zsh}/bin/zsh";
    EDITOR = "nvim";
  };
}
