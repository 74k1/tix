{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  ghostty = pkgs.master.ghostty;
in
{
  programs.ghostty = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    # installBatSyntax = true;
    # installVimSyntax = true;
    package = ghostty;
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
      gtk-single-instance = true;
      quit-after-last-window-closed = false;
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

  # Home Manager links Ghostty's D-Bus/systemd unit, but it does not
  # currently create the WantedBy symlink for it here. Create it explicitly so
  # Ghostty is warmed at graphical-session startup and `ghostty +new-window`
  # only has to do IPC.
  xdg.configFile."systemd/user/graphical-session.target.wants/app-com.mitchellh.ghostty.service".source =
    "${ghostty}/share/systemd/user/app-com.mitchellh.ghostty.service";
}
