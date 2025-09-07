{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.services.sonarr-alp;
in
{
  options = {
    services.sonarr-alp = {
      enable = mkEnableOption "Sonarr-alp";

      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/sonarr-alp/.config/NzbDrone";
        description = "The directory where Sonarr-alp stores its data files.";
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Open ports in the firewall for the Sonarr-alp web interface
        '';
      };

      user = mkOption {
        type = types.str;
        default = "sonarr-alp";
        description = "User account under which Sonarr-alp runs.";
      };

      group = mkOption {
        type = types.str;
        default = "sonarr-alp";
        description = "Group under which Sonarr-alp runs.";
      };

      package = mkPackageOption pkgs "sonarr" { };
    };
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}' 0700 ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services.sonarr-alp = {
      description = "Sonarr-alp";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${cfg.package}/bin/NzbDrone -nobrowser -data='${cfg.dataDir}'";
        Restart = "on-failure";
      };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ 8989 ];
    };

    users.users = mkIf (cfg.user == "sonarr-alp") {
      sonarr-alp = {
        group = cfg.group;
        home = cfg.dataDir;
        uid = 278;
      };
    };

    users.groups = mkIf (cfg.group == "sonarr-alp") {
      sonarr-alp.gid = 278;
    };
  };
}
