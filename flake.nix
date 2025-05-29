{
  description = "Nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Stylix for theming.
    stylix = {
      url = "github:danth/stylix/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # Matlab
    nix-matlab = {
      url = "gitlab:doronbehar/nix-matlab";
      # TODO: try switching from nixpkgs-unstable back to nixpkgs in 25.05
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Neovim
    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Insanity voice chat.
    insanity = {
      url = "github:nicolaschan/insanity/c2d8d875a659fefeb7f1e01b26d7dda328f77e17";
      # Package takes too long to build..
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
    pkgs-unstable = nixpkgs-unstable.legacyPackages.${"x86_64-linux"};
  in {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      waffle = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          inherit pkgs-unstable;
        };
        # > Our main nixos configuration file <
        modules = [
          inputs.stylix.nixosModules.stylix
          ./nixos/configuration.nix
        ];
      };
    };
  };
}
