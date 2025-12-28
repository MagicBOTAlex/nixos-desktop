{ stdenv
, fetchurl
, autoPatchelfHook
, cairo
, cups
, e2fsprogs
, gtk3
, pango
, postgresql
, pulseaudio
, qt5
, speechd
, unixODBC
, zlib
,
}:

stdenv.mkDerivation (finalAttrs: {
  name = "meshroom-bin";
  version = "2023.3.0";

  src = fetchurl {
    url = "https://github.com/alicevision/Meshroom/releases/download/v${finalAttrs.version}/Meshroom-${finalAttrs.version}-linux.tar.gz";
    hash = "sha256-krgSRjVt8/036gjh0JUZOSiXqqcwhD65/UvQWCkW05E=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    cairo
    cups
    e2fsprogs
    gtk3
    pango
    postgresql
    pulseaudio
    qt5.qtbase
    qt5.qttools
    qt5.qtwebengine
    qt5.qtwebsockets
    qt5.qtwebview
    speechd
    stdenv.cc.libc
    unixODBC
    zlib
  ];

  installPhase = ''
    runHook preInstall
    mkdir --parent -- "$out/bin"
    mv * "$out/"
    ln --relative --symbolic -- "$out/"?eshroom* $out/bin/
    autoPatchelf $out
    runHook postInstall
  '';

  # unsure why, but the fixupPhase breaks the build
  dontFixup = true;
})
