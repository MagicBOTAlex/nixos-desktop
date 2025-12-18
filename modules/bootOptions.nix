{ config, lib, pkgs, inputs, ... }:
let
  toggles = import ./../toggles.nix;
in
{
  config = lib.mkMerge [
    {
      hardware.enableRedistributableFirmware = true;
      boot.initrd.kernelModules = [ "amdgpu" ];
      boot.kernelParams = [ "quiet" "splash" "usbcore.autosuspend=120" "nr_hugepages=4096" ];
      # boot.consoleLogLevel = 0;
      boot.loader.grub = {
        enable = true;
        efiSupport = true;
        devices = [ "nodev" ]; # UEFI: don’t write to a disk MBR
        default = "0";
        useOSProber = true;
      };
      boot.loader.efi.canTouchEfiVariables = true;
      boot.loader.efi.efiSysMountPoint = "/boot";

    }

    # CachyOS kernel
    (
      lib.mkIf (toggles.kernel.useCachyOS) {
        boot.kernelPackages = pkgs.linuxPackages_cachyos-lto;
      }
    )

    (
      lib.mkIf (toggles.boot.mineboot.enable or false) {
        boot.plymouth = {
          enable = true;
          theme = "mc";
          themePackages = [
            inputs.minemouth.packages.${pkgs.system}.plymouth-minecraft-theme
          ];
        };

        boot.loader.grub = {
          minegrub-world-sel = {
            enable = true;
            customIcons = [{
              name = "nixos";
              lineTop = "NixOS W";
              lineBottom = "Survival Mode, No Cheats, Version: 23.11";
              imgName = "nixos";
              # customImg = builtins.path {
              #   path = ./nixos-logo.png;
              #   name = "nixos-img";
              # };
            }];
          };
        };

        services.displayManager.sddm.settings.Theme.Current = "minesddm";
      }
    )
  ];
}


