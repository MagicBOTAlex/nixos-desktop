{ pkgs, lib, ... }:
let
  toggles = import ./../toggles.nix;
  limitedDiscordBin = pkgs.writeShellScriptBin "limited-discord" ''
    ( sleep ${toString toggles.discord.allowedTime}; ${pkgs.psmisc}/bin/killall -q .Discord-wrappe || true ) &
    exec ${pkgs.discord}/bin/discord "$@"
  '';

  limitedDiscord = pkgs.makeDesktopItem {
    name = "limited-discord";
    desktopName = "Discord (Limited)";
    genericName = "Custom Discord";
    icon = "discord"; # uses system icon theme
    exec = "limited-discord %U";
    terminal = false;
    type = "Application";
    categories = [ "Network" "InstantMessaging" ];
    keywords = [ "discord" "chat" ];
    startupNotify = false;
  };


in
{
  environment.systemPackages =
    [ ]
    ++ lib.optional (!(toggles.discord.limit or false)) pkgs.discord
    ++ lib.optionals (toggles.discord.limit or false) [ limitedDiscord limitedDiscordBin ];

}

