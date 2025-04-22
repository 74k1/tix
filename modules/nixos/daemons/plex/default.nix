{ config, lib, pkgs, ... }:
{
  # PLEX
  hardware.graphics = {
    enable = true;
    #driSupport = true;
    #driSupport32Bit = true;
    extraPackages = with pkgs; [
      vaapiVdpau
      libvdpau-va-gl
      nvidia-vaapi-driver
    ];
  };

  services = {
    plex = {
      enable = true;
      package = pkgs.master.plex;
      dataDir = "/var/lib/plex";
    };
    
    tautulli.enable = true;
  };
}
