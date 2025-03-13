{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    inputs.crowdsec.nixosModules.crowdsec-firewall-bouncer
  ];

  # age.secrets."crowdsec_enrollment_secret" = {
  #   rekeyFile = "${inputs.self}/secrets/crowdsec_enrollment_secret.age";
  #   mode = "770";
  #   # generator.script = "alnum";
  #   owner = "crowdsec";
  #   # group = "";
  # };

  services.crowdsec-firewall-bouncer = {
    enable = true;
    package = inputs.crowdsec.packages.x86_64-linux.crowdsec-firewall-bouncer;
    settings = {
      api.server = {
        api_uri = "http://10.0.0.1:8888";
      };
    };
  };
}
