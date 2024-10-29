{ lib
, stdenv
, fetchFromGitHub
, nodejs_18
, mongodb
}:

stdenv.mkDerivation rec {
  pname = "librechat";
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "danny-avila";
    repo = "LibreChat";
    rev = "v${version}";
    sha256 = "sha256-HSZAA+Te3EDbu40teH08unsw1HZwYZevzzIlUGE/c1A=";
  };

  nativeBuildInputs = [
    nodejs_18
  ];

  buildPhase = ''
    export HOME=$(mktemp -d)
    npm ci
    npm run frontend
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -r . $out/lib/librechat
    cat > $out/bin/librechat <<EOF
    #!${stdenv.shell}
    cd $out/lib/librechat
    exec ${nodejs_18}/bin/node backend/server.js
    EOF
    chmod +x $out/bin/librechat
  '';

  meta = with lib; {
    description = "Self-hosted ChatGPT clone";
    homepage = "https://librechat.ai";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ "74k1" ];
  };
}
