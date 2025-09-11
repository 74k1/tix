{
  inputs,
  lib,
  pkgs,
}:
pkgs.buildNpmPackage {
  pname = "zeroclaw-dashboard";
  version = "0.8.5";
  src = "${inputs.zeroclaw}/web";

  npmDepsHash = "sha256-vY5eHo9VkW7h1d0zQwS70FAClDjCTO9frJ5GzgI9INM=";

  prePatch = ''
    substituteInPlace package.json \
      --replace-fail '"build": "npm run check:generated && tsc -b && vite build"' '"build": "vite build"'
    cp ${./web-generated}/*.ts src/lib/
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share
    cp -r dist $out/share/dashboard
    runHook postInstall
  '';

  meta = {
    description = "ZeroClaw gateway web dashboard";
    license = lib.licenses.mit;
  };
}
