{ pkgs, lib, ... }:
let
  toggles = import ./../toggles.nix;


  limit = toggles.discord.limit or false;
  extended = toggles.discord.extended or false;
  discord =
    if limit then [ modDiscord limitedDiscordBin ]
    else if extended then [ pkgs.legcord ]
    else [ pkgs.discord ];


  limitedDiscordBin = pkgs.writeShellScriptBin "limited-discord" ''
    ( sleep ${toString toggles.discord.allowedTime}; ${pkgs.psmisc}/bin/killall -q .Discord-wrappe || true ) &
    exec ${pkgs.discord}/bin/discord "$@"
  '';


  modDiscord = pkgs.makeDesktopItem {
    name = "discord";
    desktopName = "Discord";
    icon = "discord";
    exec = if limit then "${limitedDiscordBin}/bin/limited-discord %U" else ''exec ${discord}/bin/discord "$@"'';
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

