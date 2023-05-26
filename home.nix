{ inputs, outputs, lib, pkgs, config, ... }:

{
  imports = [
  ];

  nixpkgs = {
    overlays = [];

    config.allowUnfree = true;
  };

  home = {
    username = "taki";
    homeDirectory = "/home/taki";
    stateVersion = "22.11";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    brave
    keepassxc
    starship
    wl-clipboard
    mako
    wezterm
    wofi
    waybar
  ];

  # Use sway desktop environment with Wayland display server
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    # Sway-specific Configuration
    config = {
      terminal = "wezterm";
      menu = "wofi --show run";
      # Status bar(s)
      bars = [{
        fonts.size = 15.0;
        # command = "waybar"; You can change it if you want
        position = "bottom";
      }];
      # Display device configuration
      output = {
        eDP-1 = {
          # Set HIDP scale (pixel integer scaling)
          scale = "1";
        };
      };
    };
    # End of Sway-specificc Configuration
  };

}
