{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;
    extensions = with pkgs.vscode-extensions; [
      myriad-dreamin.tinymist
      nvarner.typst-lsp
      yzhang.markdown-all-in-one
      tomoki1207.pdf
      bbenoist.nix
      mechatroner.rainbow-csv
      ms-python.python
      charliermarsh.ruff
      jock.svg
      rust-lang.rust-analyzer
    ];
    userSettings = {
      "editor.minimap.enabled" = false;
    };
  };
}
