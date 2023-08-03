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
      ":q" = "exit";
      cat = "${pkgs.bat}/bin/bat";
      cp = "cp -iv";
      fetch = "${pkgs.neofetch}/bin/neofetch"; la = "${pkgs.exa}/bin/exa -a";
      ll = "${pkgs.exa}/bin/exa -l";
      ls = "${pkgs.exa}/bin/exa";
      mv = "mv -iv";
      nano = "${config.programs.neovim.finalPackage}/bin/nvim";
      nv = "${config.programs.neovim.finalPackage}/bin/nvim";
      rm = "rm -iv";
      tree = "${pkgs.exa}/bin/exa --tree --icons";
      # scrot = "${pkgs.shotgun}/bin/shotgun $(${pkgs.slop}/bin/slop -l -c 0.3,0.4,0.6,0.4 -f '-i %i -g %g') - | xclip -t 'image/png' -selection clipboard";
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
      
      # eva reference :^)
      youcannotrebuild () {
        ${
          let
            inherit (lib.strings)
              hasInfix;
            inherit (pkgs.hostPlatform)
              isx86_64 isAarch64
              isLinux isDarwin;
          in
          if isx86_64 && isLinux then
            "sudo --validate && sudo nixos-rebuild"
          else if isDarwin then
            "darwin-rebuild"
          else if isAarch64 then
            "nix-on-droid"
          else
            "home-manager" # what is this? plain home-manager, works on every system? ye, like wsl, not darwin, not nixos, not android :holeymoley: havent used yes on such a system but in theory all home mnanager modules would work on it aha. alr alr :hm:
        } --flake ~/tix ''$''\{1:-switch''\} "''$''\{@:2''\}" |& nix run nixpkgs#nix-output-monitor
      }
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
