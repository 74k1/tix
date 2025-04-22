{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  allSecrets,
  ...
}: {
  environment.systemPackages = with pkgs; [
    kanidm
    kanidm-provision
  ];

  # kanidm
  services.kanidm = {
    enableServer = true;
    package = pkgs.kanidm_1_6; # TODO: update whenever possible? & check breaking
    serverSettings = {
      # https://kanidm.github.io/kanidm/stable/server_configuration.html
      # Must set: domain, origin, tls_chain, tls_key
      version = "2";
      tls_chain = "/var/lib/acme/auth.${allSecrets.global.domain00}/fullchain.pem";
      tls_key = "/var/lib/acme/auth.${allSecrets.global.domain00}/key.pem";
      bindaddress = "0.0.0.0:8443";
      ldapbindaddress = "0.0.0.0:3636";
      domain = "auth.${allSecrets.global.domain00}";
      origin = "https://auth.${allSecrets.global.domain00}";
      http_client_address_info = {
        x-forward-for = ["10.100.0.2"];
      };
      online_backup = {
        path = "/var/lib/kanidm/backup";
        schedule = "0 0 * * *";
      };
    };
  };

  users.users."kanidm".extraGroups = ["nginx"];

  security.acme.certs."auth.${allSecrets.global.domain00}" = {
    postRun = ''
      ${lib.getExe pkgs.rsync} -e "ssh -i /home/taki/.ssh/id_ed25519 -p 2202" *.pem "cert_sync@10.100.0.2:/var/lib/acme/auth.${allSecrets.global.domain00}/"
    '';
    # reloadServices = [ "kanidm.service" ];
    # group = "kanidm";
    dnsProvider = "namecheap";
    dnsPropagationCheck = true;
    environmentFile = config.age.secrets."namecheap_api_secrets".path;
    # credentialFiles = {
    #   "NAMECHEAP_API_KEY_FILE" = ;
    #   "NAMECHEAP_API_USER_FILE" = ;
    # };
    # extraDomainNames = [
    #   "*.eiri.${domain01}"
    # ];
    webroot = null;
  };
}
