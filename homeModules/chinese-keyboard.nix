{ pkgs, lib, ... }:
let toggles = import ./../toggles.nix;
in
{
  config = lib.mkIf toggles.chinese-keyboard.enable or false {
    programs.plasma = {
      configFile = {

        "kxkbrc"."Layout"."Use" = true;
        "kxkbrc"."Layout"."DisplayNames" = ",";
        "kxkbrc"."Layout"."LayoutList" = "dk,cn";
        "kxkbrc"."Layout"."VariantList" = "winkeys,";
        "kwinrc"."Wayland"."InputMethod" = "/run/current-system/sw/share/applications/fcitx5-wayland-launcher.desktop";
      };
    };
  };
}
