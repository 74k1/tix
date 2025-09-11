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
      devShells = {
        default = pkgs.mkShell {
          # buildInputs = [ ];
          shellHook = ''
            export PATH="${inputs'.rix101.packages.nix-enraged}/bin:$PATH"
          '';
        };
      };
    };
}
