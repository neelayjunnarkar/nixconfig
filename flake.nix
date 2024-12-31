{
  description = "Nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    nixpkgs_unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Stylix for theming.
    stylix = {
      url = "github:danth/stylix/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # Status bar for zellij
    zjstatus = {
      url = "github:dj95/zjstatus";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Matlab
    nix-matlab = {
      url = "gitlab:doronbehar/nix-matlab";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Neovim
    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # Ghostty terminal emulator.
    ghostty = {
      url = "github:ghostty-org/ghostty";
      inputs.nixpkgs-stable.follows = "nixpkgs";
      inputs.nixpkgs-unstable.follows = "nixpkgs_unstable";
    };

    # Insanity voice chat.
    insanity = {
      url = "github:nicolaschan/insanity/v1.5.3";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    stylix,
    zjstatus,
    nix-matlab,
    nixvim,
    ...
  } @ inputs: let
    inherit (self) outputs;
  in {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      waffle = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        # > Our main nixos configuration file <
        modules = [
          stylix.nixosModules.stylix
          ./nixos/configuration.nix
        ];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    # homeConfigurations = {
    #   "neelay@waffle" = home-manager.lib.homeManagerConfiguration {
    #     pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
    #     extraSpecialArgs = {inherit inputs outputs;};
    #     # > Our main home-manager configuration file <
    #     modules = [./home-manager/home.nix];
    #   };
    # };
  };
}
