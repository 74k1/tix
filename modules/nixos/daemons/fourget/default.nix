{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  allSecrets,
  ...
}:
{
  imports = [
    inputs.tixpkgs.nixosModules'.services.fourget
  ];

  # age.secrets."forgejo_runner_token" = {
  #   rekeyFile = "${inputs.self}/secrets/forgejo_runner_token.age";
  #   # mode = "770";
  #   # owner = "forgejo";
  #   # group = "forgejo";
  # };

  services.fourget = {
    enable = true;

    nginx = {
      enable = true;
      hostName = "6get.eiri.${allSecrets.global.domain01}";
      useACMEHost = "eiri.${allSecrets.global.domain01}";
      forceSSL = true;
      # openFirewall = true;
    };

    settings = {
      SERVER_NAME = "Example 4get";
      SERVER_LONG_DESCRIPTION = "Private search instance";
      # ALT_ADDRESSES = [ "https://search-alt.example.com" ];
    };

    environment = {
      # Optional: needed for some Cloudflare-protected scrapers such as Yep.
      LD_PRELOAD = "/usr/local/lib/libcurl-impersonate-ff.so";
      CURL_IMPERSONATE = "firefox117";
    };
  };
}
