{ lib, pkgs, config, ... }:

{
  # zsh
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    shellAliases = {
      # ll = "ls -l";
      youcannotrebuild = "sudo nixos-rebuild switch --flake /home/taki/tix#taki"; # eva reference :^)
    };

    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    plugins = [
      {
        name = "fast-syntax-highlighting";
        file = "fast-syntax-highlighting.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "zdharma-continuum";
          repo = "fast-syntax-highlighting";
          rev = "13d7b4e63468307b6dcb2dadf6150818f242cbff";
          sha256 = "sha256-AmsexwVombgVmRvl4O9Kd/WbnVJHPTXETxBv18PDHz4=";
        };
      }
      # TODO: https://github.com/NixOS/nixpkgs/blob/nixos-22.11/pkgs/shells/zsh/zsh-autocomplete/default.nix
    ];
  };

  #programs.zsh-autocomplete = { enable = true; };
}
