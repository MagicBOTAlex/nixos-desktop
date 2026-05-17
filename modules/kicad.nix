{ pkgs, ... }:
let
  selectedKicad = pkgs.kicad;
  libVersions = "10.0.2";

  symbols = pkgs.fetchFromGitLab {
    owner = "kicad/libraries";
    repo = "kicad-symbols";
    rev = libVersions;
    sha256 = "sha256-1LWP28kxM87/JZVHzeWRKaXNn+1Xz1g0uVNA9vxqCBY=";
  };

  footprints = pkgs.fetchFromGitLab {
    owner = "kicad/libraries";
    repo = "kicad-footprints";
    rev = libVersions;
    sha256 = "sha256-BNEiFuBGwnGyoY5VMK1G2OkOZTrrxBDrxnvTwjAhO8A=";
  };

  packages3d = pkgs.fetchFromGitLab {
    owner = "kicad/libraries";
    repo = "kicad-packages3D";
    rev = libVersions;
    sha256 = "sha256-tONvm3QFu/JvzBzUkqVGNkVXGx3CMKeq8xAkNDSTywY=";
  };
in
{
  environment.systemPackages = with pkgs; [
    (symlinkJoin {
      name = "kicad";
      paths = [ selectedKicad ];
      buildInputs = [ makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/kicad \
          --set GDK_BACKEND x11
      '';
    })
  ];
  environment.sessionVariables = {
    KICAD9_SYMBOL_DIR = "${symbols}";
    KICAD9_FOOTPRINT_DIR = "${footprints}";
    KICAD9_3DMODEL_DIR = "${packages3d}";
    KICAD10_SYMBOL_DIR = "${symbols}";
    KICAD10_FOOTPRINT_DIR = "${footprints}";
    KICAD10_3DMODEL_DIR = "${packages3d}";
  };
}
