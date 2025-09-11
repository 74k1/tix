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
        e = [ "edit" ];
        d = [ "diff" ];
        la = [
          "log"
          "--revisions"
          "::"
        ];

        drag = [
          "bookmark"
          "advance"
        ];
        sync = [
          "git"
          "fetch"
          "--all-remotes"
        ];
        evolve = [
          "rebase"
          "--skip-emptied"
          "--simplify-parents"
          "--onto"
          "trunk()"
        ];
        pullup = [
          "evolve"
          "-b"
          "stragglers"
        ];
        touch = [
          "describe"
          "--reset-author"
          "--no-edit"
        ];
      };
      revset-aliases = {
        stragglers = "(visible_heads() & mine()) ~ trunk()";
        bases = "master | main";
        "closest_bookmark(to)" = "heads(::to & bookmarks())";
        "closest_pushable(to)" =
          "heads(::to & mutable() & ~description(exact:\"\") & (~empty() | merges()))";
        "downstream(x,y)" = "(x::y) & y";
        branches = "downstream(trunk(), bookmarks()) & mine()";
        branchesandheads = "branches | (heads(trunk()::) & mine())";
        currbranch = "latest(branches::@- & branches)";
        nextbranch = "roots(@:: & branchesandheads)";
      };

      template-aliases = {
        "format_timestamp(ts)" = ''
          if(
            ts.after("2 weeks ago"),
            ts.ago(),
            ts.format("%b %d, %Y %H:%M")
          )
        '';
        is_stray = ''
          !immutable &&
          !hidden &&
          !self.contained_in("trunk()::") &&
          !(remote_bookmarks.len() > 0 && !has_matching_local_remote)
        '';
      };
      templates = {
        # log_node = ''
        #   coalesce(
        #     if(current_working_copy, "●"),
        #     if(immutable, "⊗", "○"),
        #   )
        # '';
        git_push_bookmark = ''"74k1/" ++ change_id.short()'';
        draft_commit_description = "builtin_draft_commit_description_with_diff";
      };
      revsets = {
        bookmark-advance-to = "@-";
      };
    };
  };
}
