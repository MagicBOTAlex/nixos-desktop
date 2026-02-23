{ pkgs, ... }:
let
  compassIcon = pkgs.fetchurl {
    name = "firefox-compass-icon.png";
    url = "https://static.wikia.nocookie.net/hexxit/images/f/fa/Compass_ig.png/revision/latest/thumbnail/width/360/height/450?cb=20131208093514";
    hash = "sha256-WUEGanu1hhrS9tKM/wVunZ5Qc9/jX12x6W/Fxq5Upr8=";
  };
  bookIcon = pkgs.fetchurl {
    name = "dolphin-book-icon.png";
    url = "https://static.wikia.nocookie.net/minecraft_gamepedia/images/5/50/Book_JE2_BE2.png/revision/latest/thumbnail/width/360/height/360?cb=20210427032255";
    hash = "sha256-N65DabZMMhZJ7yfDJ3zACFL31V3W+tCGnGwsJsAd7S4=";
  };
in
{
  nixpkgs.overlays = [
    (final: prev: {
      firefox = prev.firefox.overrideAttrs (old: {
        buildCommand = old.buildCommand + ''
          # This runs at the very end of the Firefox build
          sed -i "s|^Icon=.*|Icon=${compassIcon}|" $out/share/applications/firefox.desktop
        '';
      });
      kdePackages = prev.kdePackages // {
        dolphin = prev.kdePackages.dolphin.overrideAttrs (old: {
          postInstall = (old.postInstall or "") + ''
            sed -i "s|^Icon=.*|Icon=${bookIcon}|" $out/share/applications/org.kde.dolphin.desktop
          '';
        });
      };
    })
  ];

  # environment.systemPackages = with pkgs; [ discord ];
}
