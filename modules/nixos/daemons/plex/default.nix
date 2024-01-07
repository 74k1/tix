{ config, lib, pkgs, ... }:
{
  # PLEX
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      vaapiVdpau
      libvdpau-va-gl
      nvidia-vaapi-driver
    ];
  };

  services = {
    plex = {
      enable = true;
      dataDir = "/var/lib/plex";
    };
    
    tautulli.enable = true;
  };
}
