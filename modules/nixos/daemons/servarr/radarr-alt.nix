{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.services.radarr-alt;
in
{
  options = {
    services.radarr-alt = {
      enable = mkEnableOption "Radarr-alt, a UsetNet/BitTorrent movie downloader";

      package = mkPackageOption pkgs "radarr" { };

      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/radarr-alt/.config/Radarr-alt";
        description = "The directory where Radarr-alt stores its data files.";
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = "Open ports in the firewall for the Radarr-alt web interface.";
      };

      user = mkOption {
        type = types.str;
        default = "radarr-alt";
        description = "User account under which Radarr-alt runs.";
      };

      group = mkOption {
        type = types.str;
        default = "radarr-alt";
        description = "Group under which Radarr-alt runs.";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.settings."10-radarr-alt".${cfg.dataDir}.d = {
      inherit (cfg) user group;
      mode = "0700";
    };

    systemd.services.radarr-alt = {
      description = "Radarr-alt";
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
      allowedTCPPorts = [ 7879 ];
    };

    users.users = mkIf (cfg.user == "radarr-alt") {
      radarr-alt = {
        group = cfg.group;
        home = cfg.dataDir;
        uid = 277;
      };
    };

    users.groups = mkIf (cfg.group == "radarr-alt") {
      radarr-alt.gid = 277;
    };
  };
}
