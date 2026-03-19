{
  pkgs,
  pkgs-unstable,
  ...
}: {
  programs.zed-editor = {
    enable = true;
    package = pkgs.zed-editor;
    extensions = [
      "typst"
      "nix"
      "rainbow-csv"
      "csharp"
      "matlab"
      "ruff"
    ];
    extraPackages = with pkgs; [
      alejandra
      nil
      tinymist
      rust-analyzer
      omnisharp-roslyn
      ruff
      ty
    ];
    userSettings = {
      auto_update = false;
      # theme set with Stylix
      lsp = {
        rust-analyzer = {
          binary.path_lookup = true;
          initialization_options.cargo.features = "all";
        };
        nil.binary.path_lookup = true;
        alejandra.binary = {
          path = "alejandra";
          path_lookup = true;
        };
        tinymist = {
          settings = {
            exportPdf = "onType";
            outputPath = "$root/$dir/$name";
          };
          binary.path_lookup = true;
        };
        omnisharp.binary.path_lookup = true;
        ruff.binary.path_lookup = true;
        ty.binary = {
          path = "ty";
          path_lookup = true;
          arguments = ["server"];
        };
      };
      languages = {
        "Nix" = {
          language_servers = [
            "alejandra"
            "nil"
            "!nixd"
          ];
          formatter.external.command = "alejandra";
        };
        "Typst" = {
          soft_wrap = "editor_width";
        };
        "Markdown" = {
          soft_wrap = "editor_width";
        };
        "Python" = {
          language_servers = [
            "ty"
            "ruff"
            "!basedpyright"
            "..."
          ];
          format_on_save = "on";
          code_actions_on_format = {
            "source.organizeImports.ruff" = true;
            "source.fixAll.ruff" = true;
          };
          formatter.language_server.name = "ruff";
        };
      };
    };
  };
}
