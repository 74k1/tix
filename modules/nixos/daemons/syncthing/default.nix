{ inputs, outputs, config, lib, pkgs, ... }:
{
  disabledModules = [ "services/networking/syncthing.nix" ];

  imports = [
    ../../../syncthing.nix
  ];
  # age.secrets = {
  #   "syncthing_cert" = {
  #     rekeyFile = "${inputs.self}/secrets/syncthing_cert_pem";
  #     # mode = "770";
  #     owner = "syncthing";
  #     group = "syncthing";
  #   };
  #   "syncthing_key" = {
  #     rekeyFile = "${inputs.self}/secrets/syncthing_key_pem";
  #     # mode = "770";
  #     owner = "syncthing";
  #     group = "syncthing";
  #   };
  # };
  services.syncthing = {
    enable = true;

    package = pkgs.stable.syncthing;

    # Declarative node IDs
    # cert = config.age.secrets."syncthing_cert".path;
    # key = config.age.secrets."syncthing_key".path;

    guiAddress = "0.0.0.0:8384";
    dataDir = "/mnt/btrfs_pool/syncthing_data";
    openDefaultPorts = true;
    overrideDevices = false;
    overrideFolders = false;
    settings = {
      relaysEnabled = true;
      urAccepted = -1;
    };
  };

  # systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true"; # Don't create default ~/Sync folder
}
