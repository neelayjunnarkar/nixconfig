{
  inputs,
  lib,
  config,
  pkgs,
  pkgs-unstable,
  ...
}:
# Backpack-specific home-manager overrides.
{
  imports = [
    ./common.nix
  ];

  # Extend the shared package set with backpack-specific packages.
  home.packages = with pkgs; [
    amdgpu_top
    blender-hip
  ];

  xdg.desktopEntries.matlab = lib.mkForce {
    categories = ["Utility" "TextEditor" "Development" "IDE"];
    icon = "/home/neelay/distrobox/main/MATLAB/R2025b/bin/glnxa64/cef_resources/matlab_icon.png";
    mimeType = ["text/x-octave" "text/x-matlab"];
    name = "Matlab";
    type = "Application";
    exec = "/home/neelay/.local/bin/matlab -desktop %F";
  };
}
