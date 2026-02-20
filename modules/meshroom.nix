{ config, pkgs, inputs, ... }:

let
  stablePkgs = import inputs.nixpkgs-stable {
    system = pkgs.system;
    config.allowUnfree = true;
  };

  aliceVisionOverlay = final: prev: {
    # --- Keep your AliceVision fixes (CLI Tools) ---
    nanoflann = prev.nanoflann.overrideAttrs (old: {
      cmakeFlags = (old.cmakeFlags or [ ]) ++ [ "-DNANOFLANN_BUILD_EXAMPLES=OFF" "-DNANOFLANN_BUILD_TESTS=OFF" ];
      doCheck = false;
    });

    onnxruntime = stablePkgs.onnxruntime;

    cctag = prev.cctag.overrideAttrs (old: {
      doCheck = false;
    });

    # (Removed the broken 'meshroom' entry)
  };

  prPkgs = import inputs.alice-vision-pr {
    system = pkgs.system;
    config.allowUnfree = true;
    overlays = [ aliceVisionOverlay ];
  };

in
{
  environment.systemPackages = [
    # 1. The Native CLI Tools (photogrammetry engine)
    prPkgs.alice-vision

    # 2. The Tool to run the Meshroom GUI
    pkgs.appimage-run
  ];
}
