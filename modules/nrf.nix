{ pkgs, lib, ... }: {
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.segger-jlink.acceptLicense = true;
  environment.systemPackages = with pkgs; [ nrfconnect nrfutil nrf-udev segger-jlink ];
  nixpkgs.config.permittedInsecurePackages = [ "segger-jlink-qt4-874" ];

}
