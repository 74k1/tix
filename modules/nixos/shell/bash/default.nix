{
  inputs,
  outputs,
  lib,
  pkgs,
  config,
  ...
}:
{
  programs.bash = {
    # promptInit = /* bash */ ''
    #   # Provide a nice prompt if the terminal supports it.
    #   if [ "$TERM" != "dumb" ] || [ -n "$INSIDE_EMACS" ]; then
    #     PROMPT_COLOR="1;31m"
    #     ((UID)) &amp;&amp; PROMPT_COLOR="1;32m"
    #     if [ -n "$INSIDE_EMACS" ]; then
    #       # Emacs term mode doesn't support xterm title escape sequence (\e]0;)
    #       PS1="\n\[\033[$PROMPT_COLOR\][\u@\h:\w]\\$\[\033[0m\] "
    #     else
    #       PS1="\n\[\033[$PROMPT_COLOR\][\[\e]0;\u@\h: \w\a\]\u@\h:\w]\\$\[\033[0m\] "
    #     fi
    #     if test "$TERM" = "xterm"; then
    #       PS1="\[\033]2;\h:\u:\w\007\]$PS1"
    #     fi
    #   fi
    # '';
    shellAliases = {
      ":q" = "exit";
      ":E" = "${pkgs.neovim}/bin/nvim +E";
      cat = "${pkgs.bat}/bin/bat";
      cd = "z"; # zoxide
      fetch = "${pkgs.fastfetch}/bin/fastfetch";
      ls = "${pkgs.eza}/bin/eza";
      la = "${pkgs.eza}/bin/eza -a";
      ll = "${pkgs.eza}/bin/eza -l";
      tree = "${pkgs.eza}/bin/eza --tree --icons";
      nano = "${pkgs.neovim}/bin/nvim";
      nv = "${pkgs.neovim}/bin/nvim";
      n = "${pkgs.neovim}/bin/nvim";
      rm = "rm -iv";
      mv = "mv -iv";
      cp = "cp -iv";
      jo = "${pkgs.joshuto}/bin/joshuto";
      youcannotrebuild = "sudo nixos-rebuild switch --flake ~/tix";
      ycr = "youcannotrebuild";
      nfu = "nix flake update";
      nb = "nix build";
      nr = "nix run";
      nd = "nix develop";
    };
    shellInit = /* bash */ ''
      export ATUIN_NOBIND="true"
      eval "$(${pkgs.atuin}/bin/atuin init bash)"
      bindkey '^r' _atuin_search_widget


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
    blesh.enable = true;
  };
}
