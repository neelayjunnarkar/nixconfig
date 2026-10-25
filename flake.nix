{
  description = "Nix config";

  inputs = {
    # Primary nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Stylix for theming
    stylix = {
      url = "github:nix-community/stylix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Neovim
    nixvim = {
      url = "github:nix-community/nixvim/nixos-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Insanity voice chat
    insanity = {
      url = "github:nicolaschan/insanity/v1.7.8";
      # Package takes too long to rebuild every nixpkgs update
      # inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config = {allowUnfree = true;};
    };

    pkgs-unstable = import nixpkgs-unstable {
      inherit system;
      config = {allowUnfree = true;};
    };

    commonSpecialArgs = {inherit inputs outputs pkgs-unstable;};
  in {
    nixosConfigurations = {
      waffle = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./nixos/common.nix
          ./nixos/waffle/waffle.nix
          inputs.home-manager.nixosModules.home-manager
        ];
        specialArgs = commonSpecialArgs;
      };

      backpack = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./nixos/common.nix
          ./nixos/backpack/backpack.nix
          inputs.home-manager.nixosModules.home-manager
        ];
        specialArgs = commonSpecialArgs;
      };
    };
  };
}
