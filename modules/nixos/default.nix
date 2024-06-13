{
  authelia = import ./daemons/authelia;
  steam = import ./steam;
  arion = import ./arion;
  couchdb = import ./daemons/couchdb;
  fail2ban = import ./daemons/fail2ban;
  forgejo = import ./daemons/forgejo;
  locale = import ./locale;
  ly = import ./daemons/ly;
  n8n = import ./daemons/n8n;
  nextcloud = import ./daemons/nextcloud;
  nix = import ./nix;
  nvidia = import ./nvidia;
  openssh = import ./daemons/openssh;
  outline = import ./daemons/outline;
  plex = import ./daemons/plex;
  servarr = import ./daemons/servarr;
  taki = import ./taki;
  transmission = import ./daemons/transmission;
  vaultwarden = import ./daemons/vaultwarden;
  vikunja = import ./daemons/vikunja;
  vm-test = import ./vm-test;
  wireguard = import ./daemons/wireguard;
}
