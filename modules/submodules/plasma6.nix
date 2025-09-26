{ pkgs, ... }: {
  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6 = { enable = true; };
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    bluedevil # baller
    dolphin
  ];
  services.blueman.enable =
    true; # fuck KDE's default bluetooth. blueman can auto connect

  imports = [ ./../chinese-keyboard.nix ];

  environment.systemPackages = with pkgs; [
    kdePackages.kdegraphics-thumbnailers
    kdePackages.ffmpegthumbs
    # (pkgs.callPackage ./../customPackages/stl-thumb/package.nix { })

  ];
}
