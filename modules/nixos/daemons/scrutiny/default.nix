{
  pkgs,
  lib,
  config,
  ...
}: {
  services.scrutiny = {
    enable = true;
    settings = {
      web.listen = {
        host = "0.0.0.0";
        port = 8883;
      };
    };
    collector = {
      enable = true;
      settings.devices = [
        { device = "/dev/nvme0n1"; type = "nvme"; }
        { device = "/dev/sda"; type = "scsi"; }
        { device = "/dev/sdb"; type = "scsi"; }
        { device = "/dev/sdc"; type = "scsi"; }
        { device = "/dev/sdd"; type = "scsi"; }
      ];
    };
  };
}
