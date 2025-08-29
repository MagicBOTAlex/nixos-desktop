{
  inputs = {
    # get pinned version of nixpkgs. update with `nix flake update nixpkgs` or `nix flake update` for all inputs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";

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

    avalonia = {
      url = "github:dfgHiatus/VRCFaceTracking.Avalonia";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
  };
  outputs =
    { self, nixpkgs-xr, spicetify-nix, nixpkgs, avalonia, ... }@inputs: {
      # configuration name matches hostname, so this system is chosen by default
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        # pass along all the inputs and stuff to the system function
        specialArgs = { inherit inputs; };
        modules = [
          # import configuration
          ./configuration.nix
          spicetify-nix.nixosModules.default

          # home manager part 2
          inputs.home-manager.nixosModules.default

          {
            home-manager.sharedModules =
              [ inputs.plasma-manager.homeManagerModules.plasma-manager ];
          }

          inputs.nix-index-database.nixosModules.nix-index

          nixpkgs-xr.nixosModules.nixpkgs-xr

          { programs.nix-index-database.comma.enable = true; }
        ];
      };
    };
}
