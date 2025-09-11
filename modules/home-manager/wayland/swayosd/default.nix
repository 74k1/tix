{ pkgs, ... }:
{
  services.swayosd = {
    enable = true;
    stylePath = pkgs.writeText "swayosd-style.css" /* css */ ''
      *, *::before, *::after {
        border-radius: 0px !important;
        box-shadow: none !important;
      }
    '';
  };
}
