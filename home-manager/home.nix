# Thisis your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  # Script to run programs on the nvidia gpu
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" (builtins.readFile ./scripts/nvidia-offload);
in {
  # You can import other home-manager modules here
  imports = [
    ./modules
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      (final: prev: {
        zjstatus = inputs.zjstatus.packages.${prev.system}.default;
      })
      inputs.nix-matlab.overlay
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "neelay";
    homeDirectory = "/home/neelay";
  };

  home.packages = with pkgs; [
    ripgrep
    fd
    tealdeer
    tree
    cheat
    fzf
    htop
    unzip
    zip
    texliveFull
    # Use wl-copy and wl-paste to copy/paste in terminal in wayland.
    wl-clipboard
    restic
    yt-dlp
    distrobox
    nil # Nix language server, supposedly better than nixd
    tinymist # Typst language server and more
    typst
    # Graphical applications
    firefox
    microsoft-edge
    signal-desktop
    zotero
    rhythmbox
    easyeffects
    discord
    matlab
    zoom-us
    slack
    onlyoffice-bin_latest
    kicad
    prismlauncher
    prusa-slicer
    freecad-wayland
    inkscape
    syncthing
    # Fonts
    iosevka
    newcomputermodern
  ] ++ [
    # Use the home manager module when available.
    # Also set the configuration and change the gnome module.
    inputs.ghostty.packages.x86_64-linux.default
  ];

  # Enable home-manager
  programs.home-manager.enable = true;

  xdg.desktopEntries.matlab = {
    categories = ["Utility" "TextEditor" "Development" "IDE"];
    icon = "matlab";
    # keywords = ["science" "math" "matrix" "numerical" "computation" "plotting"];
    mimeType = ["text/x-octave" "text/x-matlab"];
    name = "Matlab";
    type = "Application";
    # version = "1.4";
    exec = "nvidia-offload matlab -desktop %F";
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
