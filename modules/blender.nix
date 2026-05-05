{ pkgs, lib, ... }:
let
  toggles = import ./../toggles.nix;
  
  # 1. Use lib.versions for the config path
  blenderMajorMinor = lib.versions.majorMinor toggles.blender.version;

  # 2. Extract the addon to its own let-binding
  st2-addon = pkgs.fetchzip {
    name = "st2-addon";
    url = "https://coldtype.xyz/st2/releases/ST2-v0-18b.zip";
    hash = "sha256-D3VDx2d+SEgl7Un2y5QC2Pxg1xZwO7egiTAwQffIaCQ=";
  };

  # 3. Simple Blender override (Assuming the version in nixpkgs is close enough)
  customBlender = pkgs.blender.override { cudaSupport = true; };
in
{
  environment.systemPackages = [
    customBlender
    pkgs.cudaPackages.cudnn
    pkgs.cudaPackages.cuda_cccl
  ];

  # Using systemd.tmpfiles if you aren't using Home Manager
  systemd.tmpfiles.rules = [
    "L+ /home/botmain/.config/blender/${blenderMajorMinor}/scripts/addons/ST2 - - - - ${st2-addon}"
  ];
}
