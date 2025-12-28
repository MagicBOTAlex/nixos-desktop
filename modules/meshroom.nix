{ config, pkgs, inputs, ... }:

let
  meshroomPkgs = inputs.nix-meshroom.legacyPackages.${pkgs.system};
in
{
  environment.systemPackages = with pkgs; [
    (pkgs.callPackage ./customPackages/meshroom/meshroom.nix { })
  ];
}

