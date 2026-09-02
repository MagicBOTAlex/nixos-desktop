{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "rexit";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "MPult";
    repo = "Rexit";
    rev = "v${version}";
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # Leave dummy hash initially
  };

  # Native build inputs needed at build time
  nativeBuildInputs = [
    pkg-config
  ];

  # Runtime dependencies (OpenSSL is commonly needed for Rust networking crates)
  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  cargoHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # Leave dummy hash initially

  meta = with lib; {
    description = "Export Reddit chats into CSV, JSON, and TXT";
    homepage = "https://github.com/MPult/Rexit";
    license = licenses.gpl3Only;
    mainProgram = "rexit";
  };
}
