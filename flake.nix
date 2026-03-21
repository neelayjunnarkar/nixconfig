{
  description = "Nix config";

  inputs = {
    # Primary nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Stylix for theming
    stylix = {
      url = "github:nix-community/stylix/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Neovim
    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    # Insanity voice chat
    insanity = {
      url = "github:nicolaschan/insanity/e30e18618fb0b27a179082712d1b964b46c8cde8";
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

    # Home Manager top-level configurations
    # homeConfigurations = {
    #   neelay-waffle = home-manager.lib.homeManagerConfiguration {
    #     inherit pkgs;
    #     modules = [./home-manager/waffle-home.nix];
    #     extraSpecialArgs = commonSpecialArgs;
    #   };

    #   neelay-backpack = home-manager.lib.homeManagerConfiguration {
    #     inherit pkgs;
    #     modules = [./home-manager/backpack-home.nix];
    #     extraSpecialArgs = commonSpecialArgs;
    #   };
    # };
  };
}
