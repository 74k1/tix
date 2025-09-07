{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 86400;
    maxCacheTtl = 86400;
    pinentry.package = pkgs.pinentry-gnome3; # pinentry-mac for aarch64-darwin
    enableSshSupport = true;
  };

  programs.zsh.initContent =
    let
      gpgconf = lib.getExe' pkgs.gnupg "gpgconf";
      gpg-connect-agent = lib.getExe' pkgs.gnupg "gpg-connect-agent";
      tty = lib.getExe' pkgs.toybox "tty";
    in
    ''
      unset SSH_AGENT_PID
      export SSH_AUTH_SOCK=$(${gpgconf} --list-dirs agent-ssh-socket)
      ${gpg-connect-agent} updatestartuptty /bye >/dev/null
      export GPG_TTY=$(${tty})
    '';
}
