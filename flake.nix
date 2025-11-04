{
  inputs = {
    # get pinned version of nixpkgs. update with `nix flake update nixpkgs` or `nix flake update` for all inputs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

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

    nix-matlab = {
      # nix-matlab's Nixpkgs input follows Nixpkgs' nixos-unstable branch. However
      # your Nixpkgs revision might not follow the same branch. You'd want to
      # match your Nixpkgs and nix-matlab to ensure fontconfig related
      # compatibility.
      inputs.nixpkgs.follows = "nixpkgs";
      url = "gitlab:doronbehar/nix-matlab";
    };

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
  };
  outputs =
    { self, nixpkgs-xr, spicetify-nix, nixpkgs, nix-matlab, nix-flatpak, ... }@inputs:
    let flake-overlays = [ nix-matlab.overlay ];
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

            # home manager part 2
            inputs.home-manager.nixosModules.default

            {
              home-manager.sharedModules =
                [ inputs.plasma-manager.homeManagerModules.plasma-manager ];
            }

            inputs.nix-index-database.nixosModules.nix-index

            nixpkgs-xr.nixosModules.nixpkgs-xr
            nix-flatpak.nixosModules.nix-flatpak

            { programs.nix-index-database.comma.enable = true; }
          ];
        };
      };
    };
}
