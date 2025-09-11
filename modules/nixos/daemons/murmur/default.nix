{
  allSecrets,
  config,
  inputs,
  pkgs,
  ...
}:
{
  age.secrets."murmur_env" = {
    rekeyFile = "${inputs.self}/secrets/murmur_env.age";
    # mode = "770";
    owner = "murmur";
    group = "murmur";
  };

  services.murmur = {
    enable = true;

    allowHtml = true;
    autobanAttempts = 10;
    bandwidth = 128000;
    bonjour = false;
    clientCertRequired = true;

    # MURMUR_PASSWORD
    # MURMUR_REGISTER_PASSWORD
    environmentFile = config.age.secrets."murmur_env".path;

    imgMsgLength = 8 * 1024 * 1024;
    # password = "$MURMUR_PASSWORD";
    port = 64738;

    registerHostname = "m.${allSecrets.global.domain01}";
    registerName = "74k1's VC";
    registerPassword = "$MURMUR_REGISTER_PASSWORD";
    registerUrl = "https://${allSecrets.global.domain01}";

    sendVersion = false;

    tls.useACMEHost = "m.${allSecrets.global.domain01}";

    users = 24; # max users
    welcometext = ":3";
  };

  security.acme.certs."m.${allSecrets.global.domain01}".postRun = ''
    ${pkgs.acl}/bin/setfacl -m u:${config.services.murmur.user}:rx ${config.security.acme.certs."m.${allSecrets.global.domain01}".directory}
    ${pkgs.acl}/bin/setfacl -m g:${config.services.murmur.group}:r ${config.security.acme.certs."m.${allSecrets.global.domain01}".directory}/{chain,cert,key}.pem
  '';
}
