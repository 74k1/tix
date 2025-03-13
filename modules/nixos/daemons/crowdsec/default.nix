{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    inputs.crowdsec.nixosModules.crowdsec
  ];

  age.secrets."crowdsec_enrollment_secret" = {
    rekeyFile = "${inputs.self}/secrets/crowdsec_enrollment_secret.age";
    mode = "770";
    # generator.script = "alnum";
    owner = "crowdsec";
    # group = "";
  };

  services.crowdsec = let
    yaml = (pkgs.formats.yaml {}).generate;
    acquisitions_file = yaml "acquisitions.yaml" {
      # source = "journalctl";
      # journalctl_filter = [ "_SYSTEMD_UNIT=sshd.service" ];
      # labels.type = "syslog";
      filenames = [
        "/var/log/nginx/*.log"
      ];
      labels.type = "nginx";
    };
  in {
    enable = true;
    enrollKeyFile = config.age.secrets."crowdsec_enrollment_secret".path;
    settings = {
      api.server = {
        listen_uri = "0.0.0.0:8888";
      };
      crowdsec_service.acquisition_path = acquisitions_file;
      # acquisitions = [
        # {
        #   filenames = [
        #     "/var/log/auth.log"
        #   ];
        #   labels.type = "syslog";
        # }
        # {
          # filenames = [
          #   "/var/log/nginx/*.log"
          # ];
          # labels.type = "nginx";
        # }
      # ];
    };
  };
}
