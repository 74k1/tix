{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
{
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "74k1";
        email = "git.t@betsumei.com";
      };
      git = {
        fetch = [ "origin" ];
        push = "origin";
        # private-commits = "description(glob:'wip:*')";
        auto-local-bookmark = true;
      };
      signing = {
        backend = "gpg";
        behavior = "own";
        key = "46F3422F63A313697EAB83D51CF155F76F213503";
      };
      fsmonitor = {
        backend = "watchman";
        watchman.register-snapshot-trigger = true;
      };
      ui = {
        color = "always";
        show-cryptographic-signatures = true;
        pager = "delta";
        editor = "nvim";
        diff-editor = [
          "${lib.getExe pkgs.delta}"
          # "-c"
          # "DiffEditor $left $right $output"
        ];
      };
      aliases = {
        l = [
          "log"
          "--no-pager"
        ];
      };
      templates = {
        # log_node = ''
        #   coalesce(
        #     if(current_working_copy, "●"),
        #     if(immutable, "⊗", "○"),
        #   )
        # '';
        git_push_bookmark = ''"74k1/" ++ change_id.short()'';
      };
    };
  };
}
