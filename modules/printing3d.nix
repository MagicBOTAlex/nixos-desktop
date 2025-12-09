{ pkgs, fetchurl, ... }:
let
  orcaLogo = pkgs.fetchurl {
    url =
      "https://raw.githubusercontent.com/SoftFever/OrcaSlicer/main/resources/images/OrcaSlicer.png";
    sha256 = "02438fvggqsglxgpc4pvyjdr0la51j0ak99g8lz7b3a8hqdg3wpw";
  };
  orcaPkg =
    pkgs.orca-slicer;
  # (pkgs.callPackage ./customPackages/orcaslicer/orcaslicer.nix { });
  orcaSlicerDesktopItem = pkgs.makeDesktopItem {
    name = "orca-slicer-dri";
    desktopName = "OrcaSlicer (DRI)";
    genericName = "3D Printing Software";
    icon = orcaLogo;
    exec =
      "env __GLX_VENDOR_LIBRARY_NAME=mesa __EGL_VENDOR_LIBRARY_FILENAMES=/run/opengl-driver/share/glvnd/egl_vendor.d/50_mesa.json MESA_LOADER_DRIVER_OVERRIDE=zink GALLIUM_DRIVER=zink WEBKIT_DISABLE_DMABUF_RENDERER=1  ${orcaPkg}/bin/orca-slicer %U";
    terminal = false;
    type = "Application";
    mimeTypes = [
      "model/stl"
      "model/3mf"
      "application/vnd.ms-3mfdocument"
      "application/prs.wavefront-obj"
      "application/x-amf"
      "x-scheme-handler/orcaslicer"
    ];
    categories = [ "Graphics" "3DGraphics" "Engineering" ];
    keywords = [
      "3D"
      "Printing"
      "Slicer"
      "slice"
      "3D"
      "printer"
      "convert"
      "gcode"
      "stl"
      "obj"
      "amf"
      "SLA"
    ];
    startupNotify = false;
    startupWMClass = "orca-slicer";
  };

  mimeappsListContent = ''
    [Default Applications]
    model/stl=orca-slicer-dri.desktop;
    model/3mf=orca-slicer-dri.desktop;
    application/vnd.ms-3mfdocument=orca-slicer-dri.desktop;
    application/prs.wavefront-obj=orca-slicer-dri.desktop;
    application/x-amf=orca-slicer-dri.desktop;

    [Added Associations]
    model/stl=orca-slicer-dri.desktop;
    model/3mf=orca-slicer-dri.desktop;
    application/vnd.ms-3mfdocument=orca-slicer-dri.desktop;
    application/prs.wavefront-obj=orca-slicer-dri.desktop;
    application/x-amf=orca-slicer-dri.desktop;
  '';

  orcaSlicerMimeappsList =
    pkgs.writeText "orca-slicer-mimeapps.list" mimeappsListContent;


  # freecad-nightly = pkgs.freecad.overrideAttrs
  #   (fina: prev: {
  #
  #     patches = [ ];
  #     version = "9e7b5f6";
  #     src = pkgs.fetchFromGitHub {
  #       owner = "FreeCAD";
  #       repo = "FreeCAD";
  #       rev = "9e7b5f6";
  #       hash = "sha256-fkdRbIT6pITetwHK54t2dWAAVtxOzJH0z+EVlcPc3iQ=";
  #     };
  #   });

  freecadAppImageSrc = pkgs.fetchurl {
    url = "https://github.com/FreeCAD/FreeCAD/releases/download/weekly-2025.11.26/FreeCAD_weekly-2025.11.26-Linux-x86_64-py311.AppImage";
    sha256 = "sha256-THtOFjyJZZ5OpumD2Wz5jWCD2iZBNTWpHLc1vESWy9c=";
  };

  freecadAppImage = pkgs.stdenvNoCC.mkDerivation {
    pname = "freecad-weekly-appimage";
    version = "2025.11.05";
    src = freecadAppImageSrc;
    dontUnpack = true;

    installPhase = ''
      mkdir -p $out/opt/freecad-weekly
      cp "$src" "$out/opt/freecad-weekly/FreeCAD_weekly-2025.11.05-Linux-x86_64-py311.AppImage"
      chmod +x "$out/opt/freecad-weekly/FreeCAD_weekly-2025.11.05-Linux-x86_64-py311.AppImage"
    '';
  };

  freecadWrapper = pkgs.writeShellScriptBin "freecad-weekly" ''
    exec ${pkgs.appimage-run}/bin/appimage-run \
      ${freecadAppImage}/opt/freecad-weekly/FreeCAD_weekly-2025.11.05-Linux-x86_64-py311.AppImage "$@"
  '';

  freecadDesktop = pkgs.makeDesktopItem {
    name = "freecad-weekly";
    desktopName = "FreeCAD";
    comment = "FreeCAD 1.1 weekly preview (2025-11-05)";
    exec = "freecad-weekly";
    icon = "freecad";
    categories = [ "Graphics" "3DGraphics" "Engineering" ];
    terminal = false;
  };
in
{
  environment.systemPackages = with pkgs; [
    # pkgs.freecad
    # (pkgs.callPackage ./customPackages/freecad/freecad.nix { })
    # (pkgs.callPackage ./customPackages/orcaslicer/orcaslicer.nix { })
    # pkgs.orca-slicer
    # orcaSlicerDesktopItem
    # orcaPkg
    freecadAppImage
    freecadWrapper
    freecadDesktop
    # nanum
    # nanum-gothic-coding
  ];
  # environment.variables = { QT_QPA_PLATFORM = "xcb"; };

  # nixpkgs.config.permittedInsecurePackages = [ "libsoup-2.74.3" ];
  # environment.etc."xdg/mimeapps.list".source = orcaSlicerMimeappsList;
  # environment.etc."xdg/mimeapps.list".mode = "0644";
}
