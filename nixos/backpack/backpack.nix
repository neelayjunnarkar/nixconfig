{
  config,
  pkgs,
  lib,
  inputs,
  outputs,
  pkgs-unstable,
  ...
}:
# Host-specific NixOS overlay for 'backpack'.
{
  imports = [./backpack-hardware-configuration.nix];

  networking.hostName = "backpack";

  # Home-manager integration
  home-manager = {
    extraSpecialArgs = {
      inherit inputs outputs;
      inherit pkgs-unstable;
    };
    users = {
      neelay = import ../../home-manager/backpack-home.nix;
    };
  };

  services.xserver.videoDrivers = ["modesetting" "amdgpu"];
}
