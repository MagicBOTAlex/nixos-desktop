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
    libX11
    libxcb
    libXext
    libXrandr
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
    libX11
    libXcursor
    libXi
    libXrandr
    libXext

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
