{ config, pkgs, ... }:

{
  environment.systemPackages = [ pkgs.obs-studio ];

  # Build and expose the out-of-tree kernel module
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];

  # Optional: Automatically load the module at boot
  boot.kernelModules = [ "v4l2loopback" ];

  # Set module parameters declaratively
  boot.extraModprobeConfig = ''
    options v4l2loopback exclusive_caps=1 card_label="OBS Virtual Camera"
  '';
}
