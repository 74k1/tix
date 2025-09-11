{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Set your time zone.
  time.timeZone = "Europe/Zurich";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  i18n.inputMethod.package = pkgs.kdePackages.fcitx5-with-addons;

  # Configure keymap in X11
  # services.xserver.xkb = {
  #   layout = "ch";
  #   variant = "";
  # };

  services.udev.extraHwdb = ''
    evdev:name:*:*
      XKBLAYOUT=ch
      XKBVARIANT=de

    evdev:name:HAILUCK CO.,LTD USB KEYBOARD:*
      XKBLAYOUT=us
  '';

  # Configure console keymap
  # console.keyMap = "sg";
}
