{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    rustup
    pkg-config
    alsa-lib
    dbus
    fontconfig
    glib
    libGL
    xorg.libX11
    xorg.libxcb
    xorg.libXext
    xorg.libXrandr
    libxkbcommon
    openxr-loader
    pipewire
    wayland
    glib
    gobject-introspection
    atk
    pango
    cairo
    gdk-pixbuf
    gtk3
    xorg.libX11
    xorg.libXcursor
    xorg.libXi
    xorg.libXrandr
    xorg.libXext

    wayland
    wayland-protocols

    # PipeWire
    pipewire
    pipewire.dev

    # ALSA
    alsa-lib

    # Shaderc build requirements
    cmake
    ninja
  ];
}
