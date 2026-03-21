{
  inputs,
  lib,
  config,
  pkgs,
  pkgs-unstable,
  ...
}: let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" (builtins.readFile ./scripts/nvidia-offload);
in {
  imports = [./common.nix];

  # Extend the shared package set with waffle-specific packages.
  home.packages =
    [nvidia-offload]
    ++ (with pkgs; [
      nvidia-container-toolkit
      blender
    ]);

  xdg.desktopEntries.matlab = lib.mkForce {
    categories = ["Utility" "TextEditor" "Development" "IDE"];
    icon = "matlab";
    mimeType = ["text/x-octave" "text/x-matlab"];
    name = "Matlab";
    type = "Application";
    exec = "nvidia-offload /home/neelay/.local/bin/matlab -desktop -nosoftwareopengl %F";
  };
}
