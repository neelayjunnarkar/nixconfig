{
  pkgs,
  pkgs-unstable,
  ...
}: {
  programs.opencode = {
    enable = true;
    package = pkgs-unstable.opencode;
    extraPackages = with pkgs; [rust-analyzer];
    settings = {
      lsp = {
        rust = {
          command = ["rust-analyzer"];
          env.RUST_LOG = "debug";
        };
      };
    };
  };
}
