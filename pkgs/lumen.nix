{
  lib
  , stdenv
  , fetchFromGitHub
  , pkg-config
  , openssl
  , git
  , fzf
  , mdcat
  , rustPlatform
  , darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "lumen";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "jnsahaj";
    repo = "lumen";
    rev = "v${version}";
    hash = "sha256-TCtLgU32q1E5ZoV8FsGXFf8P/+C+W03dTOQm6xXF+nU=";
  };

  cargoSha256 = "sha256-SCrRlhwfEDe9BbBYAB1wJW27px1mgcsG2SmDmYrrG0U=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    git
    fzf
    mdcat
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  OPENSSL_NO_VENDOR = 1;

  meta = with lib; {
    description = "Instant AI Git Commit message generator";
    homepage = "https://github.com/jnsahaj/lumen";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
