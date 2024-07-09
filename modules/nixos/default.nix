{
  arion = import ./arion;
  authelia = import ./daemons/authelia;
  couchdb = import ./daemons/couchdb;
  immich = import ./daemons/immich;
  fail2ban = import ./daemons/fail2ban;
  forgejo = import ./daemons/forgejo;
  locale = import ./locale;
  ly = import ./daemons/ly;
  miniflux = import ./daemons/miniflux;
  n8n = import ./daemons/n8n;
  nextcloud = import ./daemons/nextcloud;
  nix = import ./nix;
  nvidia = import ./nvidia;
  affine = import ./daemons/affine;
  openssh = import ./daemons/openssh;
  outline = import ./daemons/outline;
  plex = import ./daemons/plex;
  send = import ./daemons/send;
  servarr = import ./daemons/servarr;
  steam = import ./steam;
  taki = import ./taki;
  transmission = import ./daemons/transmission;
  vaultwarden = import ./daemons/vaultwarden;
  vikunja = import ./daemons/vikunja;
  vm-test = import ./vm-test;
  wireguard = import ./daemons/wireguard;
}
