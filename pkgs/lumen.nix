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
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "jnsahaj";
    repo = "lumen";
    rev = "v${version}";
    hash = "sha256-6FkYzby7LBcgdobcgwXvBV97wkZTNb3jhnQgGpch7Pg=";
  };

  cargoHash = "sha256-3vTt2QeY0Z4quGV/EOPFBslulZj2b8auc0TH1h2CeAw=";

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

  env.OPENSSL_NO_VENDOR = 1;

  meta = {
    description = "Instant AI Git Commit message generator";
    homepage = "https://github.com/jnsahaj/lumen";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
}
