{
  programs.zathura = {
    enable = true;
    options = {
      guioptions = "none";
      synctex = true;
      # synctex-editor-command = "texlab inverse-search -i %{input} -l %{line}";
      synctex-editor-command = "zed %{input}:%{line}";
    };
  };
}
