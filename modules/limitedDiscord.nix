{ pkgs, ... }:
let
  limitedDiscordBin = pkgs.writeShellScriptBin "limited-discord" ''
    ( sleep 120; ${pkgs.psmisc}/bin/killall -q .Discord-wrappe || true ) &
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
  environment.systemPackages = [
    limitedDiscordBin
    limitedDiscord
  ];
}

