{
  programs.ghostty = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      background-opacity = 0.95;
      window-decoration = false;
      window-height = 1000;
      window-width = 1000;
      # Todo: set theme via stylix when option becomes available;
      theme = "ayu";
    };
  };
}
