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
    (with outputs.homeManagerModules; [
      git
      neovim
      zsh
    ])
  ];

  home = {
    username = "taki";
    homeDirectory = "/home/taki";
    stateVersion = "23.11";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    bat
    eza
    ripgrep
    tealdeer
    zellij
  ];

  home.sessionVariables = {
    SHELL = "${pkgs.zsh}/bin/zsh";
    EDITOR = "nvim";
  };
}
