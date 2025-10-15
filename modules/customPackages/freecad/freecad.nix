{ pkgs, lib, ... }:
let
  pname = "freecad";
  version = "1.0.2";
  src = pkgs.fetchurl {
    url = "https://github.com/FreeCAD/FreeCAD/releases/download/1.0.2/FreeCAD_1.0.2-conda-Linux-x86_64-py311.AppImage";
    hash = "sha256-4AvgCtn9sSsFxQAr/Rqi6oEm8sHU4vtgPrdCO3KQT2E=";
  };

  desktopItem = pkgs.makeDesktopItem {
    name = pname;
    desktopName = "FreeCAD";
    genericName = "3D CAD Modeler";
    comment = "General purpose 3D CAD modeler";
    exec = pname; # wrapper ends up at $out/bin/freecad
    icon = "freecad";
    terminal = false;
    categories = [ "Graphics" "Engineering" "Science" ];
    mimeTypes = [ "application/x-extension-fcstd" ];
  };
in
pkgs.appimageTools.wrapType2 {
  inherit pname version src;
  extraBwrapArgs = [
    "--bind-try /etc/nixos/ /etc/nixos/"
    "--tmpfs /etc/nixos"
  ];

  extraInstallCommands = ''
    # desktop file
    mkdir -p "$out/share/applications"
    install -Dm444 ${desktopItem}/share/applications/${pname}.desktop \
      "$out/share/applications/${pname}.desktop"

    # icons + mime (if present) — don’t fail if they’re missing
    for p in \
      "$appimageContents/usr/share/icons" \
      "$appimageContents/share/icons" \
      "$appimageContents/usr/share/mime" \
      "$appimageContents/share/mime"
    do
      [ -d "$p" ] || continue
      dest="$out/share/$(basename "$p")"
      mkdir -p "$dest"
      # copy contents, not the top folder; ignore collisions
      cp -a "$p/." "$dest/" || true
    done
  '';

  meta = with lib; {
    description = "General purpose 3D CAD modeler";
    homepage = "https://www.freecad.org/";
    license = licenses.lgpl2Plus;
    mainProgram = pname; # wrapper ends up at $out/bin/freecad
    platforms = [ "x86_64-linux" ];
  };
}

