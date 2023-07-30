{ lib, pkgs, config, ... }:
{
  services.picom = {
    enable = true;
    
    shadow = true; # false
    shadowOffsets = [
      (0) (0)
    ]; # (-15) (-15)
    shadowOpacity = 0.2; # 0.75
    shadowExclude = [
      "window_type *= 'dock'"
      # "name ~= 'Firefox$'"
      # "focused = 1"
    ];

    activeOpacity = 1.0; # 1.0
    inactiveOpacity = 0.95; # 1.0
    menuOpacity = 0.95; # 1.0
    
    wintypes = {
      normal = {
        blur-background = true;
      };
    };

    settings = {
      blur = {
        method = "dual_kawase";
        strength = 5;
        background = true;
        background-frame = true;
        background-fixed = true;
      };
      blur-background-exclude = [
        # "window_type = 'dock'"
        # "window_type = 'desktop'"
        # "window_type = 'notification'"
        "class_g ~= 'slop'"
        "class_g ~= 'Polybar'"
      ];
    };

    backend = "glx"; # xrender

    vSync = true;
  };
}
