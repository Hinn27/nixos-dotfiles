{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Sops-nix for secrets management
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    # Antigravity Nix
    antigravity.url = "github:jacopone/antigravity-nix";
    antigravity.inputs.nixpkgs.follows = "nixpkgs";

    # Thorium Browser
    thorium.url = "github:Rishabh5321/thorium_flake";
    thorium.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs-unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs pkgs-unstable; };
        # > Our main nixos configuration file <
        modules = [./nixos/configuration.nix];
      };
      arch = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs pkgs-unstable; };
        modules = [./nixos/configuration.nix];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      "hinne@nixos" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs = { inherit inputs pkgs-unstable; };
        # > Our main home-manager configuration file <
        modules = [
          inputs.sops-nix.homeManagerModules.sops
          ./home-manager/home.nix
        ];
      };
    };
  };
}
