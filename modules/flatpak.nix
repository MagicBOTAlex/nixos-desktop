{ pkgs, flatpaks, ... }:
let
  printerIcon = pkgs.fetchurl {
    name = "3DPrinterOC.png";
    url = "https://deprived.dev/assets/zhen/nixos/3DPrinterOC.png";
    hash = "sha256-nJGy/nq/a6HN29oNcT9ghpwvbDTbJYqsouJevK/xFec=";
  };
in

{

  security.polkit.enable = true;

  services.flatpak.enable = true;

  xdg.portal = {
    enable = true;
    # If not using a full DE like GNOME or KDE, enable gtk portal:
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
  environment.persistence."/persist" = {
    directories = [
      "/var/lib/flatpak"
      # Keep uid/gid mappings stable across reboots (silences the impermanence warning).
      "/var/lib/nixos"
    ];
    users.botmain = {
      directories = [
        ".local/share/flatpak"
        ".var/app"
      ];
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
