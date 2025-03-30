{ lib, pkgs, config, ... }:

{
  home.packages = with pkgs; [
    atuin
    zoxide
  ];

  programs = {
    zoxide = {
      enable = true;
      enableBashIntegration = true;
    };

    atuin = {
      enable = true;
      enableBashIntegration = true;
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;

      nix-direnv = {
        enable = true;
      };
    };
    
    # blesh (https://github.com/nix-community/home-manager/pull/3238)
    # programs.blesh = {
    #   enable = true;
    # };

    # BASH
    bash = {
      enable = true;

      enableCompletion = true;
      enableVteIntegration = true;

      shellAliases = {
        ":q" = "exit";
        ":E" = "${config.programs.neovim.finalPackage}/bin/nvim +E";
        cat = "${pkgs.bat}/bin/bat";
        # testt = lib.strings.fileContents config.age.secrets.test_secret.path;
        cp = "cp -iv";
        cd = "z";
        fetch = "${pkgs.macchina}/bin/neofetch";
        la = "${pkgs.eza}/bin/eza -a";
        ll = "${pkgs.eza}/bin/eza -l";
        ls = "${pkgs.eza}/bin/eza";
        mv = "mv -iv";
        nano = "${config.programs.neovim.finalPackage}/bin/nvim";
        nv = "${config.programs.neovim.finalPackage}/bin/nvim";
        rm = "rm -iv";
        tree = "${pkgs.eza}/bin/eza --tree --icons";
        jo = "${pkgs.joshuto}/bin/joshuto";
        # scrot = "${pkgs.shotgun}/bin/shotgun $(${pkgs.slop}/bin/slop -l -c 0.3,0.4,0.6,0.4 -f '-i %i -g %g') - | xclip -t 'image/png' -selection clipboard";
        ycr = "youcannotrebuild";
      };

      # history = {
      #   size = 10000;
      #   path = "${config.xdg.dataHome}/bash/history";
      # };

      historySize = 10000;
      historyFile = "${config.xdg.dataHome}/bash/history";

      initExtra = ''
        export ATUIN_NOBIND="true"
        eval "$(${pkgs.atuin}/bin/atuin init bash)"
        bindkey '^r' _atuin_search_widget
        # eval "$(${pkgs.zoxide}/bin/zoxide init --cmd y bash)"
        
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

        function joshuto() {
          ID="$$"
          mkdir -p /tmp/$USER
          OUTPUT_FILE="/tmp/$USER/joshuto-cwd-$ID"
          env joshuto --output-file "$OUTPUT_FILE" $@
          exit_code=$?
          case "$exit_code" in
            # regular exit
            0)
              ;;
            # output contains current directory
            101)
              JOSHUTO_CWD=$(cat "$OUTPUT_FILE")
              cd "$JOSHUTO_CWD"
              ;;
            # output selected files
            102)
              ;;
            *)
              echo "Exit code: $exit_code"
              ;;
          esac
        }

        function fish_complete() {
          local cmd="$1"
          shift
          fish -c 
        }

        function _fish_completion() {
          local IFS=$'\n'
          local COMP_WORDS_ESCAPED
          COMP_WORDS_ESCAPED=$(printf "%q " "''${COMP_WORDS[@]}")
          COMPREPLY=($(fish_complete "''${COMP_WORDS[0]}" ''${COMP_WORDS_ESCAPED}))
        }

        complete -F _fish_completion -o default -o bashdefault $(compgen -c)
      '';


      # plugins = [
      #   {
      #     name = "fast-syntax-highlighting";
      #     file = "fast-syntax-highlighting.plugin.zsh";
      #     src = pkgs.fetchFromGitHub {
      #       owner = "zdharma-continuum";
      #       repo = "fast-syntax-highlighting";
      #       rev = "13d7b4e63468307b6dcb2dadf6150818f242cbff";
      #       sha256 = "sha256-AmsexwVombgVmRvl4O9Kd/WbnVJHPTXETxBv18PDHz4=";
      #     };
      #   }
      #   {
      #     name = "zsh-autosuggestions";
      #     file = "zsh-autosuggestions.plugin.zsh";
      #     src = pkgs.fetchFromGitHub {
      #       owner = "zsh-users";
      #       repo = "zsh-autosuggestions";
      #       rev = "a411ef3e0992d4839f0732ebeb9823024afaaaa8";
      #       sha256 = "sha256-KLUYpUu4DHRumQZ3w59m9aTW6TBKMCXl2UcKi4uMd7w=";
      #     };
      #   }
      #   # {
      #   #   name = "zsh-autocomplete";
      #   #   file = "zsh-autocomplete.plugin.zsh";
      #   #   src = pkgs.fetchFromGitHub {
      #   #     owner = "marlonrichert";
      #   #     repo = "zsh-autocomplete";
      #   #     rev = "6a80e62dd4a1c78e00932f9b02537b526ab2fcce";
      #   #     sha256 = "sha256-gIJKmJxZCTV7sPON52ixk4ZxoaxbY3ZZghzZ5DiHG6M=";
      #   #   };
      #   # }
      # ];
    };
  };
}
