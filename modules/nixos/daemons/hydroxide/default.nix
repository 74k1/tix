{
  inputs,
  config,
  pkgs,
  ...
}:
{
  imports = [
    inputs.tixpkgs.nixosModules'.services.hydroxide
  ];

  age.secrets."hydroxide_auth_token" = {
    rekeyFile = "${inputs.self}/secrets/hydroxide_auth_token.json.age";
    # mode = "600";
    # owner = "hydroxide";
    # group = "hydroxide";
  };

  services.hydroxide = {
    enable = true;
    authFile = config.age.secrets."hydroxide_auth_token".path;
    serve = {
      imap.port = 993;
      smtp.port = 587;
      carddav.enable = false;
    };
  };
}
