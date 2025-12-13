{ pkgs, ... }: {

  console.keyMap = "dk-latin1";
  services.xserver.xkb = {
    layout = "dk";
    variant = "";
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      # Wayland support (required for Plasma 6)
      waylandFrontend = true;

      addons = with pkgs; [
        # Standard GTK support (keeps GTK apps happy)
        fcitx5-gtk

        # REQUIRED for Plasma 6: The Qt6 integration
        kdePackages.fcitx5-qt

        # REQUIRED for Pinyin: The Qt6 build of chinese-addons
        # This replaces the old 'fcitx5-chinese-addons'
        kdePackages.fcitx5-chinese-addons

        # Optional: A nice dark theme (usually generic, but check if errors arise)
        fcitx5-nord
      ];
    };
  };

}
