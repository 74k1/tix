{ lib, pkgs, config, ... }:
{
  services.picom = {
    enable = true;
    
    shadow = true; # false
    shadowOffsets = [
      (0) (0)
    ]; # (-15) (-15)
    shadowOpacity = 0.2; # 0.75
    # shadowExclude = [
    #   "window type *= 'menu'"
    #   "name ~= 'Firefox$'"
    #   "focused = 1"
    # ];

    activeOpacity = 1.0; # 1.0
    inactiveOpacity = 0.95; # 1.0
    menuOpacity = 0.95; # 1.0
    
    wintypes = {
      normal = {
        blur-background = true;
      };
      unknown = {
        blur-background = false;
      };
      splash = {
        blur-background = false;
      };
    };

    settings = {
      blur = {
        method = "dual_kawase";
        strength = 5;
      };
    };

    backend = "glx"; # xrender

    vSync = true;
  };
}
