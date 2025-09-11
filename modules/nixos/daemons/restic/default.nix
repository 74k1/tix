{
  inputs,
  outputs,
  config,
  pkgs,
  ...
}:
{
  age.secrets."restic_password" = {
    rekeyFile = "${inputs.self}/secrets/restic_password.age";
  };

  services.restic.backups =
    let
      eiri_data = [
        "/var/lib/acme"

        "/var/lib/bitwarden_rs"
        "/var/lib/vaultwarden.bak"

        "/var/lib/pocket-id"

        "/var/lib/nextcloud"
        "/mnt/btrfs_pool/nextcloud_data"

        "/var/lib/forgejo"
        "/var/lib/gitea"

        "/var/lib/paperless"
        "/mnt/btrfs_pool/paperless"

        "/var/lib/karakeep"
        "/mnt/btrfs_pool/karakeep"

        "/var/lib/n8n"

        "/var/lib/lego"

        "/var/lib/plex"
        "/var/lib/plexpy"
        "/var/lib/overseerr"

        "/var/lib/vikunja"

        "/var/lib/open-webui"
        "/var/lib/litellm"

        "/var/lib/immich"
        "/mnt/btrfs_pool/immich_media"

        "/mnt/btrfs_pool/syncthing_data"

        "/var/lib/outline"
        "/mnt/btrfs_pool/outline_data"

        "/mnt/btrfs_pool/memos_data"
      ];
    in
    {
      # "mc" = {
      #   initialize = true;
      #   passwordFile = config.age.secrets."restic_password".path;
      #   paths = [
      #     "/home/taki/minecraft"
      #   ];
      #   repository = "/home/taki/minecraft_backup";
      #   timerConfig = {
      #     OnCalendar = "hourly";
      #     Persistent = true;
      #   };
      #   pruneOpts = [
      #     "--keep-daily 31"
      #   ];
      # };
      "local" = {
        initialize = true;
        passwordFile = config.age.secrets."restic_password".path;
        paths = eiri_data;
        repository = "/mnt/btrfs_pool/restic_backup";
        timerConfig = {
          OnCalendar = "daily";
          Persistent = true;
        };
        pruneOpts = [
          "--keep-daily 31" # one backup per day for the last 31 days
          "--keep-weekly 8" # one backup per week for the last 8 weeks
          "--keep-monthly 24" # one backup per month for the last 13 months
          "--keep-yearly 75" # one backup per year, for the last 75 years
        ];
      };
      "external" = {
        initialize = true;
        passwordFile = config.age.secrets."restic_password".path;
        paths = eiri_data;
        repository = "/mnt/koi/";
        timerConfig = {
          OnCalendar = "daily";
          Persistent = true;
        };
        pruneOpts = [
          "--keep-daily 31" # one backup per day for the last 31 days
          "--keep-weekly 8" # one backup per week for the last 8 weeks
          "--keep-monthly 24" # one backup per month for the last 13 months
          "--keep-yearly 75" # one backup per year, for the last 75 years
        ];
      };
      # TODO
      # "remote" = {};
    };
}
