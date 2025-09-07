{
  inputs,
  outputs,
  lib,
  pkgs,
  config,
  ...
}:

{
  home = {
    packages = with pkgs; [
      yazi
    ];

    # file.".config/.p10k.zsh".source = ./cfg/p10k.zsh;
  };

  # yazi
  programs.yazi = {
    enable = true;
    package = pkgs.yazi;

    shellWrapperName = "y";

    enableBashIntegration = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;

    # https://yazi-rs.github.io/docs/configuration/yazi
    settings = {
      log = {
        enabled = false;
      };
      manager = {
        show_hidden = false;
        # sort_by = "mtime";
        # sort_dir_first = true;
        # sort_reverse = true;
      };
    };

    # https://yazi-rs.github.io/docs/configuration/keymap
    keymap = {
      input.prepend_keymap = [
        {
          run = "close";
          on = [ "<c-q>" ];
        }
        {
          run = "close --submit";
          on = [ "<enter>" ];
        }
        # { run = "escape"; on = [ "<esc>" ]; }
        # { run = "backspace"; on = [ "<backspace>" ]; }
      ];
      # manager.prepend_keymap = [
      #   { run = "escape"; on = [ "<esc>" ]; }
      #   { run = "quit"; on = [ "q" ]; }
      #   { run = "close"; on = [ "<c-q>" ]; }
      # ];
    };

    # https://yazi-rs.github.io/docs/plugins/overview
    # plugins = {
    #   foo = ./foo;
    #   bar = pkgs.bar;
    # };

    # https://yazi-rs.github.io/docs/flavors/overview
    # flavors = {
    #   foo = ./foo;
    #   bar = pkgs.bar;
    # };

    # https://yazi-rs.github.io/docs/configuration/theme
    # theme = {
    #   filetype = {
    #     rules = [
    #       { fg = "#7AD9E5"; mime = "image/*"; }
    #       { fg = "#F3D398"; mime = "video/*"; }
    #       { fg = "#F3D398"; mime = "audio/*"; }
    #       { fg = "#CD9EFC"; mime = "application/bzip"; }
    #     ];
    #   };
    # };

    # init.lua for Yazi itself
    # initLua = ''
    #
    # '';
  };
}
