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

  xdg.dataFile."vicinae/themes/yueye-dark.toml".text = /* toml */ ''
    [meta]
    version = "0.2.4"
    name = "YuèYè"
    description = "YueYe is a high contrast, dark base16 theme. It consists of 16 colors (duh) and multiple themes/ports that I (and hopefully soon, others) created."
    variant = "dark"
    # icon = "yueye.png"

    [colors.core]
    background = "#07060B"           # base
    foreground = "#BFBDCA"           # text
    secondary_background = "#1C1B28" # surface
    border = "#323246"               # overlay (subtle border)
    accent = "#7089FF"

    [colors.accents]
    blue = "#7089FF"
    green = "#54FF80"
    magenta = "#E366D9"
    orange = "#FF9A5B"
    purple = "#AB72FF"
    red = "#FF4B72"
    yellow = "#FFE15A"
    cyan = "#5BEBEB"

    [colors.list.item.selection]
    background = "#1C1B28"           # overlay
    secondary_background = "#1C1B28" # highlight_med

    [colors.list.item.hover]
    background = "#1C1B28"           # highlight_low with reduced opacity
  '';

  services.vicinae = {
    enable = true;
    autoStart = true;
    package = inputs.vicinae.packages.${pkgs.system}.default;
    settings = {
      closeOnFocusLoss = true;
      faviconService = "twenty";
      font = {
        normal = "PP Supply Mono Medium";
        size = 11;
      };
      keybinding = "default";
      popToRootOnClose = true;
      rootSearch.searchFiles = false;
      # theme.name = "yueye-dark";
      theme = {
        iconTheme = "Colloid-Dark";
        name = "yueye-dark";
      };
      window = {
        csd = true;
        opacity = 1.0;
        rounding = 0.0;
      };
    };
  };
}
