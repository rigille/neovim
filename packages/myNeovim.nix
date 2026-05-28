{ pkgs }:
let
  customRC = import ../config { inherit pkgs; };
  plugins = import ../plugins.nix { inherit pkgs; };
in
let
  myNeovimUnwrapped = pkgs.wrapNeovim pkgs.neovim {
    configure = {
      inherit customRC;
      packages.myVimPackage.start = plugins;
    };
  };
in pkgs.writeShellApplication {
  name = "nvim";
  runtimeInputs = with pkgs; [
    basedpyright
    ruff
    rust-analyzer
    nil
    ccls
    coqPackages.coq-lsp
  ];
  text = ''
    ${myNeovimUnwrapped}/bin/nvim "$@"
  '';
}
