{ pkgs, ... }: {
  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  imports = [ ./../chinese-keyboard.nix ];

  environment.systemPackages = with pkgs; [
    kdePackages.kdegraphics-thumbnailers
    kdePackages.ffmpegthumbs
  ];
}
