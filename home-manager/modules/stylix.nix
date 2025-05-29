{pkgs, ...}: {
  stylix = {
    enable = true;
    autoEnable = false;
    image = ./../../background-pics/Earth2k.jpg;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/ayu-dark.yaml";
    opacity.terminal = 0.9;
    fonts.monospace = {
      package = pkgs.cascadia-code;
      name = "Cascadia Code NF";
    };
    targets = {
      firefox.enable = false;
      fish.enable = true;
      fzf.enable = true;
      starship.enable = true;
      gnome.enable = true;
      gtk.enable = false;
      vim.enable = true;
      nixvim.enable = true;
      nixvim.transparentBackground.main = true;
      nixvim.transparentBackground.signColumn = true;
      vscode.enable = true;
      wezterm.enable = true;
      zellij.enable = true;
      zathura.enable = true;
      ghostty.enable = true;
      btop.enable = true;
      zed.enable = true;
    };
  };
}
