{ pkgs, lib, ... }:
let
  toggles = import ./../toggles.nix;

  limit = toggles.discord.limit or false;
  extended = toggles.discord.extended or false;
  discord =
    if limit then
      [
        modDiscord
        limitedDiscordBin
      ]
    else if extended then
      [ pkgs.legcord ]
    else
      [ modDiscord ];

  limitedDiscordBin = pkgs.writeShellScriptBin "limited-discord" ''
    ( sleep ${toString toggles.discord.allowedTime}; ${pkgs.psmisc}/bin/killall -q .Discord-wrappe || true ) &
    exec ${pkgs.discord}/bin/discord "$@"
  '';

  chatIcon = pkgs.fetchurl {
    name = "discord-icon.png";
    url = "https://www.pngall.com/wp-content/uploads/19/Minecraft-Text-Bubble-Iconic-Representation-PNG.png";
    hash = "sha256-rfB2hg4jYsikmTRczE3KuVqtsuXmLTrIhqelHB87iXg=";
  };

  modDiscord = pkgs.makeDesktopItem {
    name = "discord";
    desktopName = "Discord";
    icon = chatIcon;
    exec =
      if limit then "${limitedDiscordBin}/bin/limited-discord %U" else "${pkgs.discord}/bin/discord %U";
    terminal = false;
    type = "Application";
    categories = [
      "Network"
      "InstantMessaging"
    ];
    keywords = [
      "discord"
      "chat"
    ];
    startupNotify = false;
  };

in
{
  environment.systemPackages = [ ] ++ discord;
}
