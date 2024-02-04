{ config, lib, pkgs, ...}:
{
  services.outline = {
    enable = true;
    port = 3030;
    publicUrl = "https://wiki.example.com/";
    storage = {
      storageType = "local";
      localRootDir = "/var/lib/outline/data";
    };
  };
}
