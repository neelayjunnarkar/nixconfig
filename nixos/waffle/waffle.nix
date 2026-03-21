{
  config,
  pkgs,
  lib,
  inputs,
  outputs,
  pkgs-unstable,
  ...
}:
# Minimal host overlay for 'waffle'.
{
  imports = [./waffle-hardware-configuration.nix];

  networking.hostName = "waffle";

  # Home-manager integration for this host.
  home-manager = {
    extraSpecialArgs = {
      inherit inputs outputs;
      inherit pkgs-unstable;
    };
    users = {
      neelay = import ../../home-manager/waffle-home.nix;
    };
  };

  services.xserver.videoDrivers = [
    "modesetting"
    "nvidia"
  ];

  hardware.nvidia-container-toolkit.enable = true;

  hardware.nvidia = {
    modesetting.enable = true;

    powerManagement.enable = true;
    powerManagement.finegrained = true;

    open = true;

    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.latest;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
}
