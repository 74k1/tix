{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    inputs.vicinae.homeManagerModules.default
  ];

  services.vicinae = {
    enable = true;
    autoStart = true;
    # themes = {
    #   yueye-dark = {
    #     version = "0.2.4";
    #     appearance = "dark";
    #     # icon = /path/to/icon.png;
    #     name = "YueYe default dark";
    #     description = "YueYe is a high contrast, dark base16 theme.";
    #     palette = {
    #       background = "#1C1B28";
    #       # secondary_background = "#07060B";
    #       # border = "#4C4B69";
    #       foreground = "#BFBDCA";
    #       # accent = "#7089FF";
    #       blue = "#7089FF";
    #       green = "#54FF80";
    #       magenta = "#E366D9";
    #       orange = "#FF9A5B";
    #       purple = "#AB72FF";
    #       red = "#FF4B72";
    #       yellow = "#FFE15A";
    #       cyan = "#5BEBEB";
    #     };
    #   };
    # };
    settings = {
      closeOnFocusLoss = true;
      faviconService = "twenty";
      font = {
        normal = "PP Supply Mono";
        size = 11;
      };
      keybinding = "default";
      popToRootOnClose = true;
      rootSearch.searchFiles = false;
      # theme.name = "yueye-dark";
      theme = {
        iconTheme = "Colloid-Dark";
        name = "rose-pine";
      };
      window = {
        csd = true;
        opacity = 0.95;
        rounding = 0.0;
      };
    };
  };
}
