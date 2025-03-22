{ inputs, outputs, config, lib, pkgs, ... }:
{
  # imports = [
  #   "${inputs.nixpkgs-master}/nixos/modules/services/web-apps/immich.nix"
  # ];

  services.immich = {
    enable = true;
    package = pkgs.master.immich;
    mediaLocation = "/mnt/btrfs_pool/immich_media/";
    # environment = '''';
    # secretsFile = /tmp/immich_secret;
    host = "0.0.0.0";
    port = 3001;
    machine-learning.enable = true;
  };
}
