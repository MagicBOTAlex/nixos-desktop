{
  inputs = {
    # get pinned version of nixpkgs. update with `nix flake update nixpkgs` or `nix flake update` for all inputs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    nix-meshroom.url = "github:hesiod/nixpkgs/meshroom";
    nix-alice.url = "github:hesiod/nixpkgs/alice-vision";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

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
    { self, nixpkgs-xr, spicetify-nix, nixpkgs, nix-flatpak, minemouth, nix-meshroom, nix-alice, chaotic, ... }@inputs:
    let flake-overlays = [
      (final: prev: {
        libsForQt5 = (prev.libsForQt5 or { }) // {
          layer-shell-qt = prev.kdePackages.layer-shell-qt;
        };
      })
    ];
    in
    {

      # configuration name matches hostname, so this system is chosen by default
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          # pass along all the inputs and stuff to the system function
          specialArgs = { inherit inputs; };
          modules = [
            # import configuration
            (import ./configuration.nix flake-overlays)
            spicetify-nix.nixosModules.default

            chaotic.nixosModules.default

            # home manager part 2
            inputs.home-manager.nixosModules.default

            {
              home-manager.sharedModules =
                [ inputs.plasma-manager.homeManagerModules.plasma-manager ];
            }

            inputs.minesddm.nixosModules.default
            inputs.minegrub-world-sel-theme.nixosModules.default

            inputs.nix-index-database.nixosModules.nix-index

            nixpkgs-xr.nixosModules.nixpkgs-xr
            nix-flatpak.nixosModules.nix-flatpak

            { programs.nix-index-database.comma.enable = true; }
          ];
        };
      };
    };
}
