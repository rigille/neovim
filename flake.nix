# inspired by https://primamateria.github.io/blog/neovim-nix/
{
  description = "Rígille's neovim flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    neovim = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    auto-reload-nvim = {
      url = "github:ycdzj/auto-reload.nvim";
      flake = false;
    };
  };
  outputs = { self, nixpkgs, flake-utils, neovim, auto-reload-nvim }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlayFlakeInputs = prev: final: {
          neovim = neovim.packages.${system}.neovim;
          vimPlugins = final.vimPlugins // {
            auto-reload-nvim = prev.vimUtils.buildVimPlugin {
              name = "auto-reload-nvim";
              src = auto-reload-nvim;
            };
          };
        };

        overlayMyNeovim = prev: final: {
          myNeovim = import ./packages/myNeovim.nix { pkgs = final; };
        };

        pkgs = import nixpkgs {
          inherit system;
          overlays = [ overlayFlakeInputs overlayMyNeovim ];
        };
      in {
        packages.default = pkgs.myNeovim;
        apps.default = {
          type = "app";
          program = "${pkgs.myNeovim}/bin/nvim";
        };
      });
}
