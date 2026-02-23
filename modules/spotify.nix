# https://github.com/the-argus/spicetify-nix/blob/master/pkgs/themes.nix

{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};

  # 1. Define the custom icon
  jukeboxIcon = pkgs.fetchurl {
    name = "spotify-custom-icon.png";
    url = "https://static.wikia.nocookie.net/minecraft_gamepedia/images/e/ee/Jukebox_JE2_BE2.png/revision/latest?cb=20201202075007";
    # Run 'nix build', get the hash, and paste it here
    hash = "sha256-V/9vAV3Ln1gyDGmkBkRGieOfdsnLyMk1OrYJh27dMSc=";
  };

in
{
  # 2. Overlay to modify the base Spotify package's desktop file
  nixpkgs.overlays = [
    (final: prev: {
      spotify = prev.spotify.overrideAttrs (old: {
        # We modify the desktop file in place during the install phase.
        # This replaces "Icon=spotify-client" with "Icon=/nix/store/.../spotify-custom-icon.png"
        postInstall = (old.postInstall or "") + ''
          sed -i 's|^Icon=.*|Icon=${jukeboxIcon}|' $out/share/applications/spotify.desktop
        '';
      });
    })
  ];

  # 3. Spicetify Configuration
  programs.spicetify = {
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [
      adblock
      fullAppDisplay
    ];
    enabledCustomApps = with spicePkgs.apps; [ ];
    enabledSnippets = with spicePkgs.snippets; [ ];
    theme = spicePkgs.themes.comfy;
  };
}
