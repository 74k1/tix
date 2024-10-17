{ pkgs }:
pkgs.stdenv.mkDerivation {
  pname = "berkeley-ttf";
  version = "1.009";

  # src = /home/taki/berkeley-mono-typeface_noLig.zip;
  src = ./pkgs/assets/berkeley-mono-typeface_noLig.zip;

  unpackPhase = ''
    runHook preUnpack
    ${pkgs.unzip}/bin/unzip $src

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    ${pkgs.nerd-font-patcher}/bin/nerd-font-patcher -s -c berkeley-mono/TTF/BerkeleyMono-Bold.ttf
    ${pkgs.nerd-font-patcher}/bin/nerd-font-patcher -s -c berkeley-mono/TTF/BerkeleyMono-BoldItalic.ttf
    ${pkgs.nerd-font-patcher}/bin/nerd-font-patcher -s -c berkeley-mono/TTF/BerkeleyMono-Italic.ttf
    ${pkgs.nerd-font-patcher}/bin/nerd-font-patcher -s -c berkeley-mono/TTF/BerkeleyMono-Regular.ttf

    install -Dm644 berkeley-mono/TTF/*.ttf -t $out/share/fonts/truetype
    install -Dm644 *.ttf -t $out/share/fonts/truetype

    runHook postInstall
  '';
}
