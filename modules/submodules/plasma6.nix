{ pkgs, ... }: {
  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6 = { enable = true; };
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    bluedevil
    bluez-qt
    baloo
    baloo-widgets
    pkgs.openobex
    pkgs.obexftp
  ];
  # baloo is a runtime dep of plasma-workspace/plasma-desktop/dolphin, so
  # excludePackages cannot remove it. Disable the indexer at the config level.
  environment.etc."xdg/baloofilerc".text = ''
    [Basic Settings]
    Indexing-Enabled=false
  '';
  services.blueman.enable =
    true;

  imports = [ ./../chinese-keyboard.nix ];

  environment.systemPackages = with pkgs; [
    kdePackages.kdegraphics-thumbnailers
    kdePackages.ffmpegthumbs
    # (pkgs.callPackage ./../customPackages/stl-thumb/package.nix { })

  ];
}
