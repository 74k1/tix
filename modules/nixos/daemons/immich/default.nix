{ inputs, outputs, config, lib, pkgs, ... }:
{
  imports = [
    "${inputs.nixpkgs-master}/nixos/modules/services/web-apps/immich.nix"
  ];

  services.immich = {
    enable = true;
    # default would try to get it from pkgs
    package = inputs.nixpkgs-master.outputs.legacyPackages.x86_64-linux.immich;
    mediaLocation = "/mnt/btrfs_pool/immich_media/";
    # environment = '''';
    # secretsFile = /tmp/immich_secret; # als need to look at this now... try to do it without to see whar happen
    host = "0.0.0.0";
    port = 3001;
    # takes too long to build. disabling AI
    machine-learning.enable = false;
  };
}
