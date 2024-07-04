{ config, lib, pkgs, ... }:

{
  # NVIDIA
  services.xserver.videoDrivers = [ "nvidia" ];

  environment.systemPackages = with pkgs; [
    nvtopPackages.nvidia

    # mesa
    mesa

    # vulkan
    vulkan-tools
    vulkan-loader
    vulkan-validation-layers
    vulkan-extension-layer

    # libva
    libva
    libva-utils
    
    # vaapi
    nvidia-vaapi-driver
  ];

  hardware = {
    nvidia = {
      #package = config.boot.kernelPackages.nvidiaPackages.stable;
      modesetting.enable = true;

      # prime.offload =
      #   let
      #     isHybrid = device.gpu == "hybrid-nv";
      #   in
      # {
      #   enable = isHybrid;
      #   enableOffloadCmd = isHybrid;
      # };

      powerManagement = {
        enable = false;
        finegrained = false;
      };

      open = false;
      nvidiaSettings = true;
      nvidiaPersistenced = true;
      forceFullCompositionPipeline = true;
    };

    opengl.enable = true;

    graphics = {
      extraPackages = with pkgs; [ nvidia-vaapi-driver ];
      extraPackages32 = with pkgs.pkgsi686Linux; [ nvidia-vaapi-driver ];
    };
  };
}
