{ lib, pkgs, config, ... }:

{
  home.packages = with pkgs; [
    atuin
    zoxide
    fzf
  ];

  # zsh
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    defaultKeymap = "emacs";
    dotDir = ".config/zsh";

    initExtraFirst = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    # promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";

    shellAliases = {
      ":q" = "exit";
      ":E" = "${config.programs.neovim.finalPackage}/bin/nvim +E";
      cat = "${pkgs.bat}/bin/bat";
      cp = "cp -iv";
      cd = "z";
      fetch = "${pkgs.fastfetch}/bin/fastfetch";
      la = "${pkgs.eza}/bin/eza -a";
      ll = "${pkgs.eza}/bin/eza -l";
      ls = "${pkgs.eza}/bin/eza";
      mv = "mv -iv";
      nano = "${config.programs.neovim.finalPackage}/bin/nvim";
      n = "${config.programs.neovim.finalPackage}/bin/nvim";
      rm = "rm -iv";
      tree = "${pkgs.eza}/bin/eza --tree --icons";
      ycr = "youcannotrebuild";
      nlg = "${config.programs.neovim.finalPackage}/bin/nvim +\"Telescope live_grep\" ./";
      nff = "${config.programs.neovim.finalPackage}/bin/nvim +\"Telescope find_files\" ./";
      jo = "${pkgs.joshuto}/bin/joshuto";
      # scrot = "${pkgs.shotgun}/bin/shotgun $(${pkgs.slop}/bin/slop -l -c 0.3,0.4,0.6,0.4 -f '-i %i -g %g') - | xclip -t 'image/png' -selection clipboard";
    };

    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    # ${builtins.readFile ./cfg/functions.zsh}
    initExtra = ''
      export ATUIN_NOBIND="true"
      eval "$(${pkgs.atuin}/bin/atuin init zsh)"
      bindkey '^r' _atuin_search_widget
      eval "$(${pkgs.zoxide}/bin/zoxide init --cmd z zsh)"
      
      # eva reference :^)
      youcannotrebuild () {
        ${
          let
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
            "home-manager"
        } --flake ~/tix ''$''\{1:-switch''\} "''$''\{@:2''\}" |& nix run nixpkgs#nix-output-monitor
      }

      function joshuto() {
        ID="\$\$"
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
    '';
  };

  # programs.carapace = {
  #   enable = true;
  #   enableZshIntegration = true;
  # };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;

    nix-direnv = {
      enable = true;
    };
  };
}
