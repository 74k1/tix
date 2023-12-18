{ inputs, outputs, lib, pkgs, config, ... }:

{
  imports = builtins.concatLists [
    # ext
    [
      inputs.wired.homeManagerModules.default
      inputs.nix-colors.homeManagerModules.default
    ]
    
    # int
    (with outputs.homeManagerModules; [
      colors
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
    bat bat-extras.batman
    eza
    feh viu
    ripgrep
    scc
    starship
    tealdeer
    wezterm
    wired
    zellij
    #zoxide
  ];
  
  home.sessionVariables = {
    SHELL = "${pkgs.zsh}/bin/zsh";
    EDITOR = "nvim";
  };
}
