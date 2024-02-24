{ config, pkgs, inputs, outputs, ... }:
{
  mailserver = {
    enable = true;
    debug = true;
    fqdn = "mail.example.com";
    domains = [ "example.com" ];

    loginAccounts = {
      "taki@example.com" = {
        # nix-shell -p mkpasswd --run 'mkpasswd -sm bcrypt'
        hashedPasswordFile = "/home/taki/hashed_mailserver_password_secret";
        aliases = [ "boss@example.com" ];
      };
    };

    openFirewall = true;
    certificateScheme = "acme-nginx";
  };

  security.acme.acceptTerms = true;
  security.acme.defaults.email = "security@example.com";
}
