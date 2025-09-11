{
  lib,
  config,
  self,
  inputs,
  withSystem,
  ...
}:
{
  perSystem =
    {
      self,
      lib,
      pkgs,
      system,
      inputs',
      ...
    }:
    {
      # https://github.com/Mic92/nixfmt-rs
      formatter = pkgs.nixfmt-rs;

      devShells = {
        default = pkgs.mkShellNoCC {
          # buildInputs = [ ];
          shellHook = ''
            export PATH="${
              inputs'.rix101.packages.nix-enraged.override {
                nix' = pkgs.lixPackageSets.stable.lix;
              }
            }/bin:$PATH"
          '';
        };
      };
    };
}
