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

    open = false;

    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.production;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  services.power-profiles-daemon.enable = false;

  services.tlp = {
    enable = true;
    settings = {
      #   #   # CPU_SCALING_GOVERNOR_ON_AC = "performance";
      #   #   CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
      #   #   CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      PLATFORM_PROFILE_ON_AC = "balanced";
      #   #   PLATFORM_PROFILE_ON_BAT = "low-power";
      #   #   # RUNTIME_PM_ON_AC = "on";
      #   #   RUNTIME_PM_ON_BAT = "auto";
      #   #   # PCIE_ASPM_ON_AC = "default";
      PCIE_ASPM_ON_BAT = "powersupersave";
      #   START_CHARGE_THRESH_BAT0 = 75;
      #   STOP_CHARGE_THRESH_BAT0 = 80;
    };
  };

  specialisation.igpu-only.configuration = {
    system.nixos.tags = ["igpu-only"];

    # The critical line: drops "nvidia" from videoDrivers so the NixOS
    # nvidia module stops injecting boot.kernelModules. Without this,
    # systemd-modules-load loads the driver despite any blacklist.
    services.xserver.videoDrivers = lib.mkForce ["modesetting"];

    hardware.nvidia-container-toolkit.enable = lib.mkForce false;
    hardware.nvidia.modesetting.enable = lib.mkForce false;
    hardware.nvidia.powerManagement.enable = lib.mkForce false;
    hardware.nvidia.powerManagement.finegrained = lib.mkForce false;
    hardware.nvidia.prime.offload.enable = lib.mkForce false;
    hardware.nvidia.prime.offload.enableOffloadCmd = lib.mkForce false;

    boot.blacklistedKernelModules = [
      "nvidia"
      "nvidia_drm"
      "nvidia_modeset"
      "nvidia_uvm"
      "nouveau"
    ];
  };
}
