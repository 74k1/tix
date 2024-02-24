{
  authelia = import ./daemons/authelia;
  couchdb = import ./daemons/couchdb;
  fail2ban = import ./daemons/fail2ban;
  forgejo = import ./daemons/forgejo;
  n8n = import ./daemons/n8n;
  openssh = import ./daemons/openssh;
  outline = import ./daemons/outline;
  plex = import ./daemons/plex;
  vaultwarden = import ./daemons/vaultwarden;
  vikunja = import ./daemons/vikunja;
  wireguard = import ./daemons/wireguard;
  locale = import ./locale;
  ly = import ./daemons/ly;
  mailserver = import ./mailserver;
  nix = import ./nix;
  nvidia = import ./nvidia;
  taki = import ./taki;
  vm-test = import ./vm-test;
}
