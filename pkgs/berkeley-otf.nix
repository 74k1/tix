{ pkgs }:
pkgs.stdenv.mkDerivation {
  pname = "berkeley-otf";
  version = "2.002";

  # Ligatures
  # src = ./assets/241231YPKWKRW653.zip;
  # No Ligatures
  src = ./assets/241231QMY3Y7K61Q.zip; # TODO

  unpackPhase = /* bash */ ''
    runHook preUnpack
    ${pkgs.unzip}/bin/unzip $src

    runHook postUnpack
  '';

  installPhase = /* bash */ ''
    runHook preInstall

    ${pkgs.nerd-font-patcher}/bin/nerd-font-patcher -c 241231QMY3Y7K61Q/TX-02-9JMJ7W8P/TX-02-Regular.otf
    ${pkgs.nerd-font-patcher}/bin/nerd-font-patcher -c 241231QMY3Y7K61Q/TX-02-9JMJ7W8P/TX-02-Bold.otf
    ${pkgs.nerd-font-patcher}/bin/nerd-font-patcher -c 241231QMY3Y7K61Q/TX-02-9JMJ7W8P/TX-02-Oblique.otf
    ${pkgs.nerd-font-patcher}/bin/nerd-font-patcher -c 241231QMY3Y7K61Q/TX-02-9JMJ7W8P/TX-02-Bold-Oblique.otf
    

    # ${pkgs.nerd-font-patcher}/bin/nerd-font-patcher -c 241231YPKWKRW653/TX-02-9L5L05QX/TX-02-Regular.otf
    # ${pkgs.nerd-font-patcher}/bin/nerd-font-patcher -c 241231YPKWKRW653/TX-02-9L5L05QX/TX-02-Bold.otf
    # ${pkgs.nerd-font-patcher}/bin/nerd-font-patcher -c 241231YPKWKRW653/TX-02-9L5L05QX/TX-02-Oblique.otf
    # ${pkgs.nerd-font-patcher}/bin/nerd-font-patcher -c 241231YPKWKRW653/TX-02-9L5L05QX/TX-02-Bold-Oblique.otf

    # install -Dm644 241231YPKWKRW653/TX-02-9L5L05QX/*.otf -t $out/share/fonts/truetype
    install -Dm644 241231QMY3Y7K61Q/TX-02-9JMJ7W8P/*.otf -t $out/share/fonts/truetype
    install -Dm644 *.otf -t $out/share/fonts/truetype

    runHook postInstall
  '';
}
