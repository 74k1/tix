{
  plex = import ./daemons/plex;
  fail2ban = import ./daemons/fail2ban;
  couchdb = import ./daemons/couchdb;
  authelia = import ./daemons/authelia;
  openssh = import ./daemons/openssh;
  outline = import ./daemons/outline;
  vikunja = import ./daemons/vikunja;
  gitea = import ./daemons/gitea;
  vaultwarden = import ./daemons/vaultwarden;
  wireguard = import ./daemons/wireguard;
  n8n = import ./daemons/n8n;
  locale = import ./locale;
  ly = import ./daemons/ly;
  nix = import ./nix;
  taki = import ./taki;
  nvidia = import ./nvidia;
  vm-test = import ./vm-test;
}
