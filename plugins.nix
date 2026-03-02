{ pkgs }:
with pkgs.vimPlugins; [
  telescope-zoxide
  nvim-treesitter.withAllGrammars
  nvim-tree-lua          # replaces nerdtree
  Coqtail
  vim-kitty-navigator
  auto-reload-nvim
]
