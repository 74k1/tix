{
  plex = import ./daemons/plex;
  openssh = import ./daemons/openssh;
  vikunja = import ./daemons/vikunja;
  gitea = import ./daemons/gitea;
  vaultwarden = import ./daemons/vaultwarden;
  locale = import ./locale;
  ly = import ./daemons/ly;
  nix = import ./nix;
  nvidia = import ./nvidia;
  vm-test = import ./vm-test;
}
