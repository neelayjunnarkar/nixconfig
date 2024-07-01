{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      # Remove greeting from fish.
      set fish_greeting
    '';
  };
}
