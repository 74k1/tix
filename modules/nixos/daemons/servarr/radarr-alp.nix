{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.services.radarr-alp;
in
{
  options = {
    services.radarr-alp = {
      enable = mkEnableOption "Radarr-alp, a UsetNet/BitTorrent movie downloader";

      package = mkPackageOption pkgs "radarr" { };

      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/radarr-alp/.config/Radarr-alp";
        description = "The directory where Radarr-alp stores its data files.";
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = "Open ports in the firewall for the Radarr-alp web interface.";
      };

      user = mkOption {
        type = types.str;
        default = "radarr-alp";
        description = "User account under which Radarr-alp runs.";
      };

      group = mkOption {
        type = types.str;
        default = "radarr-alp";
        description = "Group under which Radarr-alp runs.";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.settings."10-radarr-alp".${cfg.dataDir}.d = {
      inherit (cfg) user group;
      mode = "0700";
    };

    systemd.services.radarr-alp = {
      description = "Radarr-alp";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${cfg.package}/bin/Radarr -nobrowser -data='${cfg.dataDir}'";
        Restart = "on-failure";
      };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ 7880 ];
    };

    users.users = mkIf (cfg.user == "radarr-alp") {
      radarr-alp = {
        group = cfg.group;
        home = cfg.dataDir;
        uid = 279;
      };
    };

    users.groups = mkIf (cfg.group == "radarr-alp") {
      radarr-alp.gid = 279;
    };
  };
}
