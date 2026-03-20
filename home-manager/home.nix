# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  pkgs-unstable,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    ./modules
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule
    inputs.stylix.homeModules.stylix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # inputs.nix-matlab.overlay
      # inputs.nix-vscode-extensions.overlays.default
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
      # allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "neelay";
    homeDirectory = "/home/neelay";
  };

  home.packages =
    (with pkgs; [
      ripgrep
      fd # find replacement
      tealdeer
      tree
      cheat
      fzf
      htop
      unzip
      zip
      texliveFull
      pciutils
      dust # du replacement
      duf # df repacement
      # Use wl-copy and wl-paste to copy/paste in terminal in wayland.
      wl-clipboard
      restic
      yt-dlp
      distrobox
      typst
      polylux2pdfpc # polylux notes generator for pdfpc
      pdfpc # pdf presentation software
      (python3.withPackages (ps: [ps.numpy ps.scipy ps.cvxpy ps.matplotlib ps.sympy ps.jupyterlab ps.torch]))
      amdgpu_top
      nvtopPackages.full
      xauth
      xhost
      waypipe
      # Graphical applications
      firefox
      chromium
      signal-desktop
      zotero
      rhythmbox
      easyeffects
      discord
      lmstudio
      heroic
      zoom-us
      slack
      onlyoffice-desktopeditors
      # kicad
      prismlauncher
      orca-slicer
      freecad-wayland
      plasticity
      inkscape
      syncthing
      # unityhub # for asset-guarding engagements project
      vlc
      bottles
      blender-hip
      # Fonts
      iosevka
      newcomputermodern
    ])
    ++ (with pkgs-unstable; [
      # grayjay
    ])
    ++ [
      inputs.insanity.packages.${pkgs.system}.default
    ];

  fonts.fontconfig.enable = true;

  # Enable home-manager
  programs.home-manager.enable = true;

  # Matlab desktop entry
  xdg.desktopEntries.matlab = {
    categories = ["Utility" "TextEditor" "Development" "IDE"];
    icon = "/home/neelay/distrobox/main/MATLAB/R2025b/bin/glnxa64/cef_resources/matlab_icon.png";
    # keywords = ["science" "math" "matrix" "numerical" "computation" "plotting"];
    mimeType = ["text/x-octave" "text/x-matlab"];
    name = "Matlab";
    type = "Application";
    # version = "1.4";
    exec = "/home/neelay/.local/bin/matlab -desktop %F";
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
