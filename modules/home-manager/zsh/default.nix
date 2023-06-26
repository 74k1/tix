{ lib, pkgs, config, ... }:

{
  home.packages = with pkgs; [
    atuin
  ];

  # zsh
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    shellAliases = {
      cat = "${pkgs.bat}/bin/bat";
      ls = "${pkgs.exa}/bin/exa";
      ll = "${pkgs.exa}/bin/exa -l";
      la = "${pkgs.exa}/bin/exa -a";
      cp = "cp -iv";
      mv = "mv -iv";
      rm = "rm -iv";
      fetch = "${pkgs.neofetch}/bin/neofetch";
      nano = "${config.programs.neovim.finalPackage}/bin/nvim";
      nv = "${config.programs.neovim.finalPackage}/bin/nvim";
      ":q" = "exit";
      youcannotrebuild = "sudo nixos-rebuild switch --flake ~/tix#taki |& nix run nixpkgs#nix-output-monitor"; # eva reference :^)
    };

    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    initExtra = ''
      export ATUIN_NOBIND="true"
      eval "$(${pkgs.atuin}/bin/atuin init zsh)"
      bindkey '^r' _atuin_search_widget
      ${builtins.readFile ./cfg/functions.zsh}
    '';

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
      {
        name = "zsh-autosuggestions";
        file = "zsh-autosuggestions.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "a411ef3e0992d4839f0732ebeb9823024afaaaa8";
          sha256 = "sha256-KLUYpUu4DHRumQZ3w59m9aTW6TBKMCXl2UcKi4uMd7w=";
        };
      }
      # {
      #   name = "zsh-autocomplete";
      #   file = "zsh-autocomplete.plugin.zsh";
      #   src = pkgs.fetchFromGitHub {
      #     owner = "marlonrichert";
      #     repo = "zsh-autocomplete";
      #     rev = "6a80e62dd4a1c78e00932f9b02537b526ab2fcce";
      #     sha256 = "sha256-gIJKmJxZCTV7sPON52ixk4ZxoaxbY3ZZghzZ5DiHG6M=";
      #   };
      # }
    ];
  };
}
