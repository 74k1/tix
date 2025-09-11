{
  inputs,
  lib,
  pkgs,
}:
let
  system = pkgs.stdenv.hostPlatform.system;
  toolchain = inputs.fenix.packages.${system}.stable.withComponents [
    "cargo"
    "rustc"
    "rust-src"
  ];
  rustPlatform = pkgs.makeRustPlatform {
    cargo = toolchain;
    rustc = toolchain;
  };
  features = [
    "acp-bridge"
    "agent-runtime"
    "channel-acp-server"
    "channel-discord"
    "channel-email"
    "channel-filesystem"
    "channel-git"
    "channel-lark"
    "channel-matrix"
    "channel-telegram"
    "channel-webhook"
    "gateway"
    "observability-prometheus"
    "schema-export"
    "whatsapp-web"
  ];
in
rustPlatform.buildRustPackage {
  pname = "zeroclaw";
  version = "0.8.5";
  src = inputs.zeroclaw;

  # discord ack-reaction resolver arm (see ./discord-ack.patch)
  patches = [ ./discord-ack.patch ];

  cargoLock.lockFile = "${inputs.zeroclaw}/Cargo.lock";

  cargoBuildFlags = [
    "-p"
    "zeroclaw"
    "--no-default-features"
    "--features"
    (lib.concatStringsSep "," features)
  ];
  doCheck = false;
  buildInputs = [ pkgs.stdenv.cc.cc ];

  meta = {
    mainProgram = "zeroclaw";
    description = "ZeroClaw agent";
    license = lib.licenses.mit;
  };
}
