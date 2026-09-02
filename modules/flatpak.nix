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
  };

  # systemd.services.flatpak-repo = {
  #   wantedBy = [ "multi-user.target" ];
  #   after = [ "network-online.target" ];
  #   wants = [ "network-online.target" ];
  #   path = [ pkgs.flatpak ];
  #   serviceConfig = {
  #     Type = "oneshot";
  #     Restart = "on-failure";
  #     RestartSec = "5s";
  #   };
  #   script = ''
  #     flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
  #   '';
  # };
  environment.persistence."/persist" = {
    directories = [
      "/var/lib/flatpak"
    ];
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
