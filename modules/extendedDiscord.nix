{ pkgs, lib, ... }:
let
  toggles = import ./../toggles.nix;


  limit = toggles.discord.limit or false;
  extended = toggles.discord.extended or false;
  discord =
    if limit then [ limitedDiscord limitedDiscordBin ]
    else if extended then [ pkgs.legcord ]
    else [ pkgs.discord ];


  limitedDiscordBin = pkgs.writeShellScriptBin "limited-discord" ''
    ( sleep ${toString toggles.discord.allowedTime}; ${pkgs.psmisc}/bin/killall -q .Discord-wrappe || true ) &
    exec ${discord}/bin/discord "$@"
  '';


  limitedDiscord = pkgs.makeDesktopItem {
    name = "limited-discord";
    desktopName = "Discord (Limited)";
    genericName = "Custom Discord";
    icon = "discord";
    exec = "limited-discord %U";
    terminal = false;
    type = "Application";
    categories = [ "Network" "InstantMessaging" ];
    keywords = [ "discord" "chat" ];
    startupNotify = false;
  };


in
{
  environment.systemPackages = [ ] ++ discord;
}

