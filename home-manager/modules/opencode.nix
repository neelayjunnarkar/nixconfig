{
  pkgs,
  pkgs-unstable,
  ...
}: {
  programs.opencode = {
    enable = true;
    # package = pkgs-unstable.opencode;
    package = pkgs-unstable.opencode.overrideAttrs (
      final: prev: {
        postPatch =
          prev.postPatch
          + ''
            # fix for bun 1.4.x
            substituteInPlace packages/opencode/script/build.ts \
              --replace-fail 'splitting: true,' 'splitting: false,'
          '';
      }
    );
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
