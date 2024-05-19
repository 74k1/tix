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
    zellij
  ];
  
  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 86400;
    maxCacheTtl = 86400;
    enableZshIntegration = true;
    pinentryPackage = pkgs.pinentry-curses;
    enableSshSupport = true;
  };

  home.sessionVariables = {
    SHELL = "${pkgs.zsh}/bin/zsh";
    EDITOR = "nvim";
  };
}
