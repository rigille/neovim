{ pkgs }:
with pkgs.vimPlugins; [
  telescope-zoxide
  nvim-treesitter.withAllGrammars
  nvim-tree-lua          # replaces nerdtree
  nvim-lspconfig         # ships lsp/<name>.lua so vim.lsp.enable() can spawn servers
  Coqtail
  vim-kitty-navigator
  auto-reload-nvim
]
