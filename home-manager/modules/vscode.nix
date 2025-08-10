{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;
    extensions = with pkgs.vscode-extensions; [
      ms-vscode-remote.remote-ssh
      charliermarsh.ruff
    ];
      # astral-sh.ty
      #Google.geminicodeassist
      #] ++ (with pkgs.nix-vscode-extensions.vscode-marketplace; [
        # Google.geminicodeassist
      #ms-toolsai.tensorboard
    #]);
  };
}
