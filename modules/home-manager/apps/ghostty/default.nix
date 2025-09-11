{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
{
  programs.ghostty = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    # installBatSyntax = true;
    # installVimSyntax = true;
    package = pkgs.master.ghostty;
    systemd.enable = true;
    settings = {
      cursor-style = "block";
      font-family = [
        "PP Supply Mono"
        "Sarasa Gothic SC"
      ];
      font-size = 14.5;
      background-opacity = 0.9;
      shell-integration-features = "no-sudo,title";
      keybind = [
        "unconsumed:alt+d=scroll_page_fractional:0.5"
        "unconsumed:alt+u=scroll_page_fractional:-0.5"
        "ctrl+shift+1=increase_font_size:1"
      ];
      macos-titlebar-style = "tabs";
      macos-secure-input-indication = true;
      gtk-titlebar = false;
    };
  };
}
