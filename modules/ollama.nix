{ pkgs, lib, ... }: {
  nixpkgs.overlays = [
    (final: prev: {
      ollama-cuda = prev.ollama-cuda.overrideAttrs (oldAttrs: rec {
        version = "0.33.3";
        src = prev.fetchFromGitHub {
          owner = "ollama";
          repo = "ollama";
          tag = "v${version}";
          hash = "sha256-ipmDW1tMxbQsAOKfDPU0wRqvI7w7Mfv4ucr2sCw47w0=";
        };
        vendorHash = "sha256-RxmV/VgCydZRGfhWoxDUo3lw8ujCnfQiB1o7PcIikLw=";
        passthru = (oldAttrs.passthru or { }) // {
          llamaCppVersion = "b10760";
          llamaCppSrc = prev.fetchFromGitHub {
            owner = "ggml-org";
            repo = "llama.cpp";
            tag = "b10760";
            hash = "sha256-+WI/1TAJWG1m9ttS2RO43C+1oL/5xpZTaHn7vQh4+kc=";
          };
        };
      });
    })
  ];

  services.ollama = {
    enable = true;
    host = "0.0.0.0";
    package = pkgs.ollama-cuda;
    environmentVariables = {
      CUDA_VISIBLE_DEVICES = "0";
    };
  };
}
