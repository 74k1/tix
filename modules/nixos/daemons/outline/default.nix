{ config, lib, pkgs, ...}:
{
  services.outline = {
    enable = true;
    port = 3030;
    publicUrl = "https://docs.example.com/";
    storage = {
      storageType = "local";
      localRootDir = "/var/lib/outline/data";
    };
  };
}
