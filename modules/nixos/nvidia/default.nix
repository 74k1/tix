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
  ];

  hardware = {
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.stable;
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
        enable = true;
        finegrained = false;
      };

      open = false;
      nvidiaSettings = true;
      nvidiaPersistenced = true;
      forceFullCompositionPipeline = true;
    };

    graphics = {
      extraPackages = with pkgs; [ nvidia-vaapi-driver ];
      extraPackages32 = with pkgs.pkgsi686Linux; [ nvidia-vaapi-driver ];
    };
  };
}
