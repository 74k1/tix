{
  plex = import ./daemons/plex;
  openssh = import ./daemons/openssh;
  gitea = import ./daemons/gitea;
  vaultwarden = import ./daemons/vaultwarden;
  locale = import ./locale;
  ly = import ./ly;
  nix = import ./nix;
  nvidia = import ./nvidia;
  vm-test = import ./vm-test;
}
