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
      };
      remotes = {
        origin.auto-track-bookmarks = "glob:*";
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
        default-command = "l";
        color = "always";
        show-cryptographic-signatures = true;
        pager = "${lib.getExe pkgs.delta}";
        editor = "nvim";
        # diff-editor = [
        #   "${lib.getExe pkgs.neovim}"
        #   # "-c"
        #   # "DiffEditor $left $right $output"
        # ];
      };
      aliases = {
        l = [
          "log"
          "--no-pager"
        ];
        ll = [
          "log"
          "--revisions"
          "ancestors(@, 5)"
        ];

        # mine
        e = ["edit"];
        d = ["diff"];
        la = [ "log" "--revisions" "::" ];

        drag = ["bookmark" "advance"];
        sync = ["git" "fetch" "--all-remotes"];
        evolve = ["rebase" "--skip-emptied" "--simplify-parents" "--onto" "trunk()"];
        pullup = ["evolve" "-b" "stragglers"];
        touch = ["describe" "--reset-author" "--no-edit"];
      };
      templates = {
        # log_node = ''
        #   coalesce(
        #     if(current_working_copy, "●"),
        #     if(immutable, "⊗", "○"),
        #   )
        # '';
        git_push_bookmark = ''"74k1/" ++ change_id.short()'';
        draft_commit_description = ''builtin_draft_commit_description_with_diff'';
      };
      revsets = {
        bookmark-advance-to = "@-";
      };
    };
  };
}
