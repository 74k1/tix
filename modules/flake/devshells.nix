{ lib, config, self, inputs, withSystem, ... }:
{
  perSystem = { self, lib, pkgs, system, inputs', ... }: {
    devShells = {
      # usage:
      # `nix develop `
      default = pkgs.mkShell {
        buildInputs = [
          pkgs.git
          inputs'.agenix-rekey.packages.agenix-rekey
          inputs'.deploy-rs.packages.deploy-rs
        ];
      };
      with-wireguard-tools = pkgs.mkShell {
        buildInputs = with pkgs; [
          wireguard-tools
        ];
      };
      macchina = pkgs.mkShell {
        buildInputs = with pkgs; [
          macchina
        ];
      };
    };
  };
}
