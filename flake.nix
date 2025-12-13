{
  inputs = {
    # get pinned version of nixpkgs. update with `nix flake update nixpkgs` or `nix flake update` for all inputs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";
    flatpaks.url = "github:in-a-dil-emma/declarative-flatpak/latest";
    nix-meshroom.url = "github:hesiod/nixpkgs/meshroom";
    nix-alice.url = "github:hesiod/nixpkgs/alice-vision";
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

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
  };
  outputs =
    { self, nixpkgs-xr, spicetify-nix, nixpkgs, flatpaks, chaotic, nix-cachyos-kernel, minemouth, nix-meshroom, nix-alice, ... }@inputs:
    let
      flake-overlays = [
        (final: prev: {
          libsForQt5 = (prev.libsForQt5 or { }) // {
            layer-shell-qt = prev.kdePackages.layer-shell-qt;
          };
        })
        inputs.nix-cachyos-kernel.overlays.default
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

            inputs.chaotic.nixosModules.default
            {
              home-manager.sharedModules =
                [ inputs.plasma-manager.homeManagerModules.plasma-manager ];
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
