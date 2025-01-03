{
  programs.zed-editor = {
    enable = true;
    extensions = ["typst" "nix" "rainbow-csv"];
    # TODO: use this when it becomes an option
    # extraPackages = with pkgs; [ alejandra nil tinymist ]; # Rn doesn't have the option
    userSettings = {
      auto_update = false;
      theme.light = "Ayu Light";
      theme.dark = "Ayu Dark";
      lsp = {
        rust-analyzer.binary.path_lookup = true;
        nix.binary.path_lookup = true;
        nil.binary.path_lookup = true;
        tinymist = {
          initialization_options = {
            exportPdf = "onType";
            outputPath = "$root/$dir/$name";
          };
          binary.path_lookup = true;
        };
      };
      languages = {
        "Nix" = {
          language_servers = ["nil" "!nixd"];
          format_on_save.external.command = "alejandra";
        };
      };
    };
  };
}
