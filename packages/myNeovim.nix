{ pkgs }:
let
  customRC = import ../config { inherit pkgs; };
  plugins = import ../plugins.nix { inherit pkgs; };
in
let
  myNeovimUnwrapped = pkgs.wrapNeovim pkgs.neovim-unwrapped {
    withPython3 = true;
    extraPython3Packages = ps: with ps; [ pynvim ];
    configure = {
      inherit customRC;
      packages.myVimPackage.start = plugins;
    };
  };
in pkgs.writeShellApplication {
  name = "nvim";
  runtimeInputs = with pkgs; [
    fd
    ripgrep
    basedpyright
    ruff
    rust-analyzer
    nil
    ccls
    # Coq/Rocq deliberately not bundled: enter the project's `nix develop`
    # shell so its pinned Coq (and matching .vo libs) take over PATH.
  ];
  text = ''
    ${myNeovimUnwrapped}/bin/nvim "$@"
  '';
}
