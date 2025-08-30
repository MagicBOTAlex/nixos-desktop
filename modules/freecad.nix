{ pkgs, ... }: {
  environment.systemPackages = [
    pkgs.freecad-wayland
    # (pkgs.callPackage ./submodules/orca.nix { })
    pkgs.orca-slicer

  ];

  nixpkgs.config.permittedInsecurePackages = [ "libsoup-2.74.3" ];
}
