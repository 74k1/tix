{ inputs, outputs, lib, pkgs, config, ... }:

{
  home = {
    packages = with pkgs; [
      zsh-powerlevel10k
      atuin
      zoxide
      fzf
    ];
  };

  # zsh
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    defaultKeymap = "emacs";
    dotDir = "${config.xdg.configHome}/zsh";

    shellAliases = {
      ":q" = "exit";
      ":E" = "${config.programs.neovim.finalPackage}/bin/nvim +E";
      cat = "${pkgs.bat}/bin/bat";
      cp = "cp -iv";
      cd = "z";
      j = "z";
      fetch = "${pkgs.fastfetch}/bin/fastfetch";
      la = "${pkgs.eza}/bin/eza -a --icons=auto";
      ll = "${pkgs.eza}/bin/eza -l --icons=auto";
      ls = "${pkgs.eza}/bin/eza --icons=auto";
      mv = "mv -iv";
      nano = "${config.programs.neovim.finalPackage}/bin/nvim";
      n = "${config.programs.neovim.finalPackage}/bin/nvim";
      nd = "nix develop";
      ns = "nix shell";
      nr = "nix run";
      nb = "nix build";
      rm = "rm -iv";
      tree = "${pkgs.eza}/bin/eza --tree --icons";
      ycr = "youcannotrebuild";
      nlg = "${config.programs.neovim.finalPackage}/bin/nvim +\"Telescope live_grep\" ./";
      nff = "${config.programs.neovim.finalPackage}/bin/nvim +\"Telescope find_files\" ./";
      jo = "${pkgs.joshuto}/bin/joshuto";
      fyf = "${pkgs.fzf}/bin/fzf";
      # scrot = "${pkgs.shotgun}/bin/shotgun $(${pkgs.slop}/bin/slop -l -c 0.3,0.4,0.6,0.4 -f '-i %i -g %g') - | xclip -t 'image/png' -selection clipboard";
      ga = "${lib.getExe config.programs.git.package} add .";
      # gac = "ga && ${lib.getExe config.programs.git.package} commit -m \"$(lumen draft --context 'use conventional commits (at the start, use feat:/fix:/chore:/...) & leave all characters lowercase')\"";
      # gacp = "gac && ${lib.getExe config.programs.git.package} push";
    };

    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    localVariables = {
      MANPAGER = "${lib.getExe config.programs.neovim.finalPackage} +Man!";
    };

    # ${builtins.readFile ./cfg/functions.zsh}
    initContent = lib.mkBefore /* sh */ '' 
      # source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      # export XDG_RUNTIME_DIR=/run/user/$(id -u)

      # Atuin
      # export ATUIN_NOBIND="true"
      # eval "$(${pkgs.atuin}/bin/atuin init zsh)"
      # bindkey '^r' _atuin_search_widget

      # Zoxide
      # eval "$(${pkgs.zoxide}/bin/zoxide init --cmd z zsh)"

      if [[ $(ps -o command= -p "$PPID" | awk '{print $1}') != 'fish' ]]
      then
          exec ${pkgs.fish}/bin/fish -l
      fi
    '';
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;

    nix-direnv = {
      enable = true;
    };
  };
}
