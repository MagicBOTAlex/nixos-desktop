{ config, pkgs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      filezilla = prev.filezilla.overrideAttrs (oldAttrs: {
        patches = (oldAttrs.patches or [ ]) ++ [
          ./filezilla-concurrent-transfers.patch
        ];
      });
    })
  ];

  # Ensure filezilla is in your system packages
  environment.systemPackages = [ pkgs.filezilla ];
}
