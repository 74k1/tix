{
  inputs,
  outputs,
  config,
  allSecrets,
  ...
}:
let
  prometheusDir = "/mnt/btrfs_pool/prometheus";
in
{
  systemd.tmpfiles.rules = [
    "d ${prometheusDir} 0750 prometheus prometheus - -"
    "d /var/lib/prometheus2 0750 prometheus prometheus - -"
    "L+ /var/lib/prometheus2/data - - - - ${prometheusDir}"
  ];

  systemd.services.prometheus.unitConfig.RequiresMountsFor = prometheusDir;

  services = {
    prometheus = {
      enable = true;
      port = 8000;
      retentionTime = "365d";

      extraFlags = [
        "--web.enable-remote-write-receiver"
      ];
    };
  };
}
