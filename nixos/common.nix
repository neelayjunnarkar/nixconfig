{
  config,
  lib,
  pkgs,
  inputs,
  pkgs-unstable,
  ...
}:
# Common NixOS module shared by multiple hosts.
{
  ###########################################################################
  # Nixpkgs / nix configuration (flake-aware)
  ###########################################################################

  nixpkgs = {
    # Place for site overlays; keep empty here by default.
    overlays = [
      # Example: inputs.someOverlay.overlay
    ];

    # Configure nixpkgs behaviour for the system
    config = {
      allowUnfree = true;
    };
  };

  # Expose flake-derived nix settings so the system uses flakes and the
  # flake inputs are represented in the nix path/registry.
  nix = let
    # collect only flake inputs from the `inputs` attribute set
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      # Enable the new Nix CLI and flakes
      experimental-features = "nix-command flakes";

      # Opinionated: disable global registry unless you explicitly want it
      flake-registry = "";

      # Workaround to allow modules to read nix-path when necessary
      nix-path = config.nix.nixPath;
    };

    # Disable legacy channels by default
    channel.enable = false;

    # Represent flake inputs as the flake registry and nix-path so modules
    # and build processes can refer to `flake:...` names.
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  ###########################################################################
  # Basic system / localization
  ###########################################################################
  time.timeZone = "America/Los_Angeles";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  ###########################################################################
  # Boot / EFI defaults
  ###########################################################################
  boot.kernelPackages = pkgs.linuxPackages;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  ###########################################################################
  # Networking
  ###########################################################################
  networking.networkmanager.enable = true;

  ###########################################################################
  # Desktop / display
  ###########################################################################
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.desktopManager.cosmic.enable = true;

  services.xserver = {
    xkb.layout = "us";
  };

  ###########################################################################
  # Printing, audio, input
  ###########################################################################
  services.printing.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.libinput.enable = true;

  ###########################################################################
  # Graphics defaults
  ###########################################################################
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver
    ];
  };

  ###########################################################################
  # Virtualisation / containers
  ###########################################################################
  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  ###########################################################################
  # Common user(s)
  ###########################################################################
  users.users = {
    neelay = {
      isNormalUser = true;
      description = "Neelay";
      openssh.authorizedKeys.keys = [
        # Insert authorized keys at the host or user level.
      ];
      extraGroups = ["networkmanager" "wheel"];
      shell = pkgs.fish;
    };
  };

  ###########################################################################
  # Programs
  ###########################################################################
  programs = {
    fish.enable = true;

    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
  };

  fonts.fontconfig.enable = true;

  ###########################################################################
  # Miscellaneous
  ###########################################################################

  system.stateVersion = "24.05";
}
