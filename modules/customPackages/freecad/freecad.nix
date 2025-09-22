{ pkgs, lib, ... }:
let
  pname = "freecad";
  version = "1.0.2";
  src = pkgs.fetchurl {
    url =
      "https://github.com/FreeCAD/FreeCAD/releases/download/1.0.2/FreeCAD_1.0.2-conda-Linux-x86_64-py311.AppImage";
    hash = "sha256-4AvgCtn9sSsFxQAr/Rqi6oEm8sHU4vtgPrdCO3KQT2E=";
  };
in pkgs.appimageTools.wrapType2 {
  inherit pname version src;

  # Fix the bwrap chdir issue
  extraBwrapArgs = [
    "--bind-try /etc/nixos/ /etc/nixos/"
    "--tmpfs /etc/nixos" # Create temporary /etc/nixos if it doesn't exist
  ];

  extraInstall = appimageContents: ''
    # Install desktop file if available
    if [ -f ${appimageContents}/usr/share/applications/org.freecad.FreeCAD.desktop ]; then
      install -m 444 -D ${appimageContents}/usr/share/applications/org.freecad.FreeCAD.desktop \
        $out/share/applications/${pname}.desktop
      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace 'Exec=AppRun' 'Exec=${pname}' \
        --replace 'Exec=freecad' 'Exec=${pname}'
    fi

    # Install icons and MIME types
    if [ -d ${appimageContents}/usr/share/icons ]; then
      cp -r ${appimageContents}/usr/share/icons $out/share/
    fi
    if [ -d ${appimageContents}/usr/share/mime ]; then
      cp -r ${appimageContents}/usr/share/mime $out/share/
    fi
  '';

  meta = with lib; {
    description = "General purpose 3D CAD modeler";
    homepage = "https://www.freecad.org/";
    license = licenses.lgpl2Plus;
    platforms = [ "x86_64-linux" ];
  };
}
