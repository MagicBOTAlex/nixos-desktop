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
  me-controller = pkgs.fetchurl {
    name = "me-controller.png";
    url = "https://guide-assets.appliedenergistics.org/minecraft-1.20.1/ae2/items-blocks-machines/controller_blockimage1.Lm3T9bFApBbY.png";
    hash = "sha256-hWMAFN1UWqaiISr7+5vDzM7vLcCIXiOk1+K6rqXEu2E=";
  };
  jukeboxIcon = pkgs.fetchurl {
    name = "spotify-custom-icon.png";
    url = "https://static.wikia.nocookie.net/minecraft_gamepedia/images/e/ee/Jukebox_JE2_BE2.png/revision/latest?cb=20201202075007";
    # Run 'nix build', get the hash, and paste it here
    hash = "sha256-V/9vAV3Ln1gyDGmkBkRGieOfdsnLyMk1OrYJh27dMSc=";
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
      spotify = prev.spotify.overrideAttrs (old: {
        postInstall = (old.postInstall or "") + ''
          sed -i 's|^Icon=.*|Icon=${jukeboxIcon}|' $out/share/applications/spotify.desktop
        '';
      });

      vscodium = prev.vscodium.overrideAttrs (old: {
        # We use postInstall to append to the existing installation logic
        postInstall = (old.postInstall or "") + ''
          # 1. Update the .desktop file (handling all occurrences of Icon=)
          # The file is actually named codium.desktop based on your file upload
          DESKTOP_FILE="$out/share/applications/codium.desktop"

          if [ -f "$DESKTOP_FILE" ]; then
            # 'g' at the end ensures it replaces the icon in [Desktop Action] sections too
            sed -i "s|^Icon=.*|Icon=${me-controller}|g" "$DESKTOP_FILE"
          fi

          # 2. Force the system to use your icon by overwriting the default png/svg 
          # This helps environments that ignore the .desktop Icon path
          for size in 16 32 48 64 128 256 512; do
            mkdir -p "$out/share/icons/hicolor/''${size}x''${size}/apps"
            cp -f "${me-controller}" "$out/share/icons/hicolor/''${size}x''${size}/apps/vscodium.png" 2>/dev/null || true
          done

          mkdir -p "$out/share/icons/hicolor/scalable/apps"
          cp -f "${me-controller}" "$out/share/icons/hicolor/scalable/apps/vscodium.svg" 2>/dev/null || true
        '';
      });
      vscode = prev.vscode.overrideAttrs (old: {
        postFixup = (old.postFixup or "") + ''
          # 1. Create a master source with the correct .png extension
          mkdir -p "$out/share/vscode-custom"
          cp -f "${me-controller}" "$out/share/vscode-custom/icon.png"

          # 2. Wipe existing icons and point them to our master PNG
          # We include .svg in the search to replace those too
          find "$out/share/icons" -type f \( -name "vscode.*" -o -name "code.*" \) \
            -not -path "$out/share/vscode-custom/*" | while read -r icon; do
              rm -f "$icon"
              ln -sf "$out/share/vscode-custom/icon.png" "$icon"
          done

          # 3. Fix the .desktop files to use the .png path
          if [ -d "$out/share/applications" ]; then
            for f in "$out/share/applications/"*.desktop; do
              # This replaces every 'Icon=' line, including the ones in [Desktop Action]
              sed -i "s|^Icon=.*|Icon=$out/share/vscode-custom/icon.png|g" "$f"
            done
          fi
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
