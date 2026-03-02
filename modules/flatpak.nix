{ pkgs, flatpaks, ... }:
let
  printerIcon = pkgs.fetchurl {
    name = "3DPrinterOC.png";
    url = "https://deprived.dev/assets/zhen/nixos/3DPrinterOC.png";
    hash = "sha256-nJGy/nq/a6HN29oNcT9ghpwvbDTbJYqsouJevK/xFec=";
  };
in

{

  services.flatpak = {
    enable = true;

    remotes = {
      "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
    };

    packages = [
      ":${
        pkgs.fetchurl {
          url = "https://github.com/OrcaSlicer/OrcaSlicer/releases/download/nightly-builds/OrcaSlicer-Linux-flatpak_nightly_x86_64.flatpak";
          sha256 = "sha256:0d805andch8bmx0l5h7wnn7z9f92ryrhzrw9w0bghfccipnpnd2x";
        }
      }"
      "flathub:app/org.vinegarhq.Sober//stable"
    ];

    overrides = {
      "io.github.softfever.OrcaSlicer" = {
        Context.filesystems = [
          "/mnt/win"
        ];

        "Desktop Entry" = {
          "Icon" = "${printerIcon}";
        };

        Environment = {
          "LC_ALL" = "C";
          "MESA_LOADER_DRIVER_OVERRIDE" = "zink";
          "WEBKIT_DISABLE_DMABUF_RENDERER" = "1";
          "__EGL_VENDOR_LIBRARY_FILENAMES" = "${pkgs.mesa}/share/glvnd/egl_vendor.d/50_mesa.json";
          "GALLIUM_DRIVER" = "zink";
        };
      };
    };
  };
}

# flatpak override --user \
#   --env=LC_ALL=C \
#   --env=MESA_LOADER_DRIVER_OVERRIDE=zink \
#   --env=WEBKIT_DISABLE_DMABUF_RENDERER=1 \
#   --env=__EGL_VENDOR_LIBRARY_FILENAMES=/usr/lib/x86_64-linux-gnu/GL/default/share/glvnd/egl_vendor.d/50_mesa.json \
#   --env=GALLIUM_DRIVER=zink \
#   io.github.softfever.OrcaSlicer
#
