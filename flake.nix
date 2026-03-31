{
  inputs = {
    # get pinned version of nixpkgs. update with `nix flake update nixpkgs` or `nix flake update` for all inputs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";
    flatpaks.url = "github:in-a-dil-emma/declarative-flatpak/latest";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel";

    # home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    minemouth.url = "github:nikp123/minecraft-plymouth-theme";
    minegrub-world-sel-theme.url = "github:Lxtharia/minegrub-world-sel-theme";
    minesddm = {
      url = "github:Davi-S/sddm-theme-minesddm";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.11";
    alice-vision-pr.url = "github:NixOS/nixpkgs/pull/256115/head";
    alice-vision-pr.inputs.nixpkgs.follows = "nixpkgs-stable";

    android-nixpkgs.url = "github:tadfisher/android-nixpkgs";


    microvm = {
      url = "github:astro/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
  };
  outputs =
    { self
    , nixpkgs-xr
    , microvm
    , spicetify-nix
    , nixpkgs
    , flatpaks
    , chaotic
    , nix-cachyos-kernel
    , minemouth
    , alice-vision-pr
    , android-nixpkgs
    , ...
    }@inputs:
    let
      flake-overlays = [
        (final: prev: {
          libsForQt5 = (prev.libsForQt5 or { }) // {
            layer-shell-qt = prev.kdePackages.layer-shell-qt;
            libsForQt5 = prev.libsForQt5 // {
              qt5 = prev.libsForQt5.qt5 // {
                qtwebengine = prev.libsForQt5.qt5.qtwebengine.overrideAttrs (old: {
                  postPatch = (old.postPatch or "") + ''
                    target="src/3rdparty/chromium/third_party/perfetto/include/perfetto/ext/tracing/core/trace_packet.h"
                    if [ -f "$target" ] && ! grep -q '^#include <cstdint>$' "$target"; then
                    sed -i '/^#include "perfetto\/ext\/tracing\/core\/slice\.h"$/a #include <cstdint>' "$target"
                    fi
                  '';
                });
              };
            };

          };
        })
        inputs.nix-cachyos-kernel.overlays.pinned
      ];
    in
    {

      # configuration name matches hostname, so this system is chosen by default
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {

          # pass along all the inputs and stuff to the system function
          specialArgs = {
            inherit inputs;
          };
          modules = [
            # import configuration
            {
              nixpkgs.hostPlatform = "x86_64-linux";
              nixpkgs.config.replaceStdenv = { pkgs }: pkgs.stdenv;
            }
            (import ./configuration.nix flake-overlays)
            spicetify-nix.nixosModules.default

            # (
            #   { pkgs, ... }: {
            #     # nixpkgs.overlays = [ nix-cachyos-kernel.overlays ];
            #     # nixpkgs.config.allowUnfree = true;
            #     # boot.kernelPackages = inputs.cachyos-kernel.legacyPackages.x86_64-linux.linuxPackages-cachyos-lts-lto;
            #     boot.kernelPackages = nixpkgs.cachyosKernels.linuxPackages-cachyos-latest;
            #   }
            # )

            # home manager part 2
            inputs.home-manager.nixosModules.default

            inputs.microvm.nixosModules.host

            inputs.chaotic.nixosModules.default
            {
              home-manager.sharedModules = [ inputs.plasma-manager.homeModules.plasma-manager ];
            }

            inputs.minesddm.nixosModules.default
            inputs.minegrub-world-sel-theme.nixosModules.default

            inputs.nix-index-database.nixosModules.nix-index

            nixpkgs-xr.nixosModules.nixpkgs-xr
            inputs.flatpaks.nixosModules.default

            { programs.nix-index-database.comma.enable = true; }
          ];
        };
      };
    };
}
