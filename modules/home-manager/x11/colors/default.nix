{
  lib,
  pkgs,
  config,
  ...
}:
{
  colorScheme = {
    slug = "kokuyoseki";
    name = "Kokuyoseki";
    author = "taki (https://github.com/74k1)";
    colors = {
      base00 = "#04012b"; # ----
      base01 = "#17064f"; # ---
      base02 = "#330d70"; # --
      base03 = "#442886"; # -
      base04 = "#594b9e"; # +
      base05 = "#887fb9"; # ++
      base06 = "#b9b5d5"; # +++
      base07 = "#EBEBF0"; # ++++
      base08 = "#FF577F"; # red
      base09 = "#FF9561"; # orange
      base0A = "#FFE26E"; # yellow
      base0B = "#45FF82"; # green
      base0C = "#46ECF8"; # cyan
      base0D = "#6A78F7"; # blue
      base0E = "#DB6AFF"; # purple
      base0F = "#F7B2D9"; # pink
    };
  };
}
