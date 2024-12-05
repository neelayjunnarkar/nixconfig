{
  programs.zed-editor = {
    enable = true;
    extensions = [ "typst" "nix" "rainbow-csv" ];
    userSettings = {
      theme.light = "Ayu Light";
      theme.dark = "Ayu Dark";
    };
  };
}
