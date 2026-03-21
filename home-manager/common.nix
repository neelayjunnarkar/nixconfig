{
  inputs,
  lib,
  pkgs,
  ...
}: let
  sharedPackages = with pkgs;
    [
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
      pciutils
      dust
      duf
      wl-clipboard
      restic
      yt-dlp
      distrobox
      typst
      polylux2pdfpc
      pdfpc
      (python3.withPackages (ps: [ps.numpy ps.scipy ps.cvxpy ps.matplotlib ps.sympy ps.jupyterlab ps.torch]))
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
      zoom-us
      slack
      onlyoffice-desktopeditors
      prismlauncher
      orca-slicer
      freecad-wayland
      inkscape
      syncthing
      vlc
      bottles
      plasticity
      lmstudio
      heroic
      # Fonts
      iosevka
      newcomputermodern
    ]
    ++ (with pkgs-unstable; [
      ])
    ++ [
      inputs.insanity.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

  commonImports = [
    ./modules
    inputs.stylix.homeModules.stylix
  ];
in {
  home.username = "neelay";
  home.homeDirectory = "/home/neelay";

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  imports = commonImports;

  home.packages = sharedPackages;

  programs.home-manager.enable = true;
  fonts.fontconfig.enable = true;

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "24.05";
}
