{
  lib,
  config,
  inputs,
  pkgs,
  ...
}: {
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
        push-bookmark-prefix = "74k1/";
      };
      signing = {
        backend = "gpg";
        behavior = "own";
        key = "46F3422F63A313697EAB83D51CF155F76F213503";
      };
      core = {
        fsmonitor = "watchman";
        watchman = {
          register_snapshot_trigger = true;
        };
      };
      ui = {
        color = "always";
        show-cryptographic-signatures = true;
        # pager = "nvim";
        editor = "nvim";
        diff-editor = [
          "nvim"
          "-c"
          "DiffEditor $left $right $output"
        ];
      };
      templates = {
        log_node = ''
          coalesce(
            if(current_working_copy, "●"),
            if(immutable, "⊗", "○"),
          )
        '';
      };
    };
  };
}
