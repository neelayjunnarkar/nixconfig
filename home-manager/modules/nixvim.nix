{inputs, ...}: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    opts = {
      number = true;
      relativenumber = true;
      incsearch = true;
      ignorecase = true;
      smartcase = true;
      termguicolors = true;

      tabstop = 8;
      softtabstop = 0;
      shiftwidth = 2;
      expandtab = true;
      autoindent = true;
    };
    plugins = {
      lsp = {
        enable = true;
        servers = {
          ruff.enable = true; # Python
          typst-lsp.enable = true; # Typst
          nixd.enable = true; # Nix
        };
      };

      treesitter = {
        enable = true;
        indent = true;
      };

      cmp.enable = true;
      cmp-nvim-lsp.enable = true;
      cmp-buffer.enable = true;
      cmp-path.enable = true;
      cmp-cmdline.enable = true;
    };
  };
}
