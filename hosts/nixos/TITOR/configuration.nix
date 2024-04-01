{ inputs, outputs, lib, config, pkgs, ... }:
{
  imports = with outputs.nixosModules; [
    ./hardware-configuration.nix

    # vm-test
    locale
    nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.hostName = "TITOR";
  networking.wireless.enable = true;

  networking.networkmanager.enable = true;

  services = {
    wayland = {
      enable = true;

      windowManager.sway = {
        enable = true;
        config = rec {
          modifier = "Mod4";

          terminal = "kitty";
          startup = [
            {command = "firefox";}
          ];
        };
      };
    };
  };
}
