{ pkgs, config, ... }:
let
  compassIcon = pkgs.fetchurl {
    name = "firefox-compass-icon.png";
    url = "https://static.wikia.nocookie.net/hexxit/images/f/fa/Compass_ig.png/revision/latest/thumbnail/width/360/height/450?cb=20131208093514";
    hash = "sha256-WUEGanu1hhrS9tKM/wVunZ5Qc9/jX12x6W/Fxq5Upr8=";
  };
in
{
  programs.firefox = {
    enable = true;
    # package = pkgs.firefox.overrideAttrs (oldAttrs: {
    #   postInstall = (oldAttrs.postInstall or "") + ''
    #     # 1. Replace the icon reference in the desktop file
    #     # We target the file the wrapper just installed
    #     sed -i "s|^Icon=.*|Icon=${compassIcon}|" $out/share/applications/*.desktop
    #
    #     # 2. Place the actual icon file where the system expects it
    #     # This ensures the taskbar/dock also shows the compass
    #     mkdir -p $out/share/icons/hicolor/128x128/apps
    #     cp ${compassIcon} $out/share/icons/hicolor/128x128/apps/firefox.png
    #   '';
    # });

    profiles.default.settings = {
      "ui.key.menuAccessKeyFocuses" = false;
      "ui.key.menuAccessKey" = 0;
      "widget.use-xdg-desktop-portal.file-picker" = 1;
    };
  };
}
