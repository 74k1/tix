{ config, lib, pkgs, ... }:

{
  # NVIDIA
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    # prime = {
    #   sync.enable = true;
    #   reverseSync.enable = true;
    # };

    powerManagement = {
      enable = false;
      finegrained = false;
    };

    open = false;
    
    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
