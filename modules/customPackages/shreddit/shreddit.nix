{ lib, pkgs, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "shreddit";
  version = "1.1.1"; # pick the crate version you want

  src = pkgs.fetchCrate {
    inherit pname version;
    sha256 =
      "sha256-ERcQZ7LLR9kfI1WMCr70EopmuPmK4Y7eXnhM7djvEI4="; # fill after first build
  };

  cargoHash =
    "sha256-9s6wmB4YqKmyHKDS2b5keEYFDBerpdQxtNY1wVqGDxg="; # fill after first build

  postPatch = ''
    substituteInPlace src/things/comment.rs \
      --replace 'comments.json{query_params}' 'overview.json'

    # assert patch applied
    if ! grep -q 'overview.json' src/things/comment.rs; then
      echo "patch DID NOT apply"; exit 1
    fi
  '';
  preBuild = "grep -n 'overview.json' src/things/comment.rs || true";

  nativeBuildInputs = [ pkgs.pkg-config ];
  buildInputs = [ pkgs.openssl ];

  meta = with lib; {
    description = "Shreddit CLI (Rust crate)";
    license = licenses.mit; # adjust if needed
    mainProgram = "shreddit";
  };
}

