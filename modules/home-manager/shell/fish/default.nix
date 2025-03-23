{
  inputs,
  outputs,
  lib,
  pkgs,
  config,
  ...
}: {
  home = {
    packages = with pkgs; [
      atuin
      zoxide
      fzf
    ];
  };

  programs.fish = {
    enable = true;
    generateCompletions = true;
    plugins = [
      { name = "pure"; src = pkgs.fishPlugins.pure.src; }
      { name = "bass"; src = pkgs.fishPlugins.bass.src; }
      { name = "puffer"; src = pkgs.fishPlugins.puffer.src; }
      { name = "autopair"; src = pkgs.fishPlugins.autopair.src; }
    ];
    functions = {
      fish_command_not_found.body = ''
        echo "Command $argv[1] not found!"
        echo "You could perhaps do:"
        echo "nix run nixpkgs#$argv[1] -- $argv[2..]"
      '';
    };
    shellAliases = {
      ":E" = "${config.programs.neovim.finalPackage}/bin/nvim +E";
      ":q" = "exit";
      cat = "${pkgs.bat}/bin/bat";
      cp = "cp -iv";
      fetch = "${pkgs.neofetch}/bin/neofetch";
      la = "${pkgs.eza}/bin/eza -a --icons=auto";
      ll = "${pkgs.eza}/bin/eza -l --icons=auto";
      ls = "${pkgs.eza}/bin/eza --icons=auto";
      mv = "mv -iv";
      nano = "${config.programs.neovim.finalPackage}/bin/nvim";
      nv = "${config.programs.neovim.finalPackage}/bin/nvim";
      rm = "rm -iv";
      cd = "z";
      #j = "z";
      tree = "${pkgs.eza}/bin/eza --tree --icons=auto";
      youcannotrebuild = "sudo nixos-rebuild switch --flake ~/tix";
      ycr = "youcannotrebuild";
      nfu = "nix flake update";
      nb = "nix build";
      nr = "nix run";
      nd = "nix develop";
      #jo = "${pkgs.joshuto}/bin/joshuto";
      ga = "${lib.getExe config.programs.git.package} add .";
      gac = "ga && ${lib.getExe config.programs.git.package} commit -m \"$(lumen draft --context 'use conventional commits (at the start, use feat:/fix:/chore:/...) & leave all characters lowercase')\"";
      gacp = "gac && ${lib.getExe config.programs.git.package} push";
      "today" = "date '+%Y-%m-%d' | tr -d '\n'";
      today-1 = "date -d yesterday '+%Y-%m-%d' | tr -d '\n'";
    };
    interactiveShellInit = /* fish */ ''
      atuin init fish | source
      zoxide init --cmd z fish | source
      COMPLETE=fish jj | source
    '';
  };
}
