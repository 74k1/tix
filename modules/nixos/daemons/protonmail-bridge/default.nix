{
  pkgs,
  ...
}:
{
  environment.systemPackages = [
    pkgs.protonmail-bridge
    pkgs.pass
    pkgs.gnupg
  ];

  services.protonmail-bridge = {
    enable = false;
    path = [
      pkgs.pass
    ];
  };
}
