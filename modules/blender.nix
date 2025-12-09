{ pkgs, ... }:
let
  toggles = import ./../toggles.nix;
  blender = pkgs.blender.overrideAttrs (old: rec {
    version = toggles.blender.version;

    src = pkgs.fetchzip {
      name = "blender-${version}-src";
      url = "https://download.blender.org/source/blender-${version}.tar.xz";
      hash = "sha256-UUHsylDmMWRcr1gGiXuYnno7D6uMjLqTYd9ak4FnZis=";
    };
  });
  blenderConfigVersion = builtins.substring 0 3 toggles.blender.version;

  st2-addon = pkgs.stdenvNoCC.mkDerivation {
    pname = "st2-addon";
    version = "0.18b";

    src = pkgs.fetchzip {
      url = "https://coldtype.xyz/st2/releases/ST2-v0-18b.zip";
      hash = "sha256-D3VDx2d+SEgl7Un2y5QC2Pxg1xZwO7egiTAwQffIaCQ=";
    };

    installPhase = ''
      mkdir -p $out
      cp -r ./* $out/
    '';
  };
in
{
  environment.systemPackages = [
    blender
    st2-addon
  ];

  systemd.tmpfiles.rules = [
    # Ensure directory exists
    "d /home/botmain/.config/blender/${blenderConfigVersion}/scripts/addons 0755 botmain users -"
    # Symlink addon dir to Nix store
    "L+ /home/botmain/.config/blender/${blenderConfigVersion}/scripts/addons/ST2 - - - - ${st2-addon}"
  ];

}
