{ pkgs }:
with pkgs.vimPlugins; [
  plenary-nvim
  telescope-nvim
  telescope-zoxide
  (nvim-treesitter.withPlugins (p: with p; [
    tree-sitter-c
    tree-sitter-cpp
    tree-sitter-python
    tree-sitter-scheme
    tree-sitter-javascript
    tree-sitter-bash
    tree-sitter-rust
  ]))
  nvim-tree-lua          # replaces nerdtree
  nvim-lspconfig         # ships lsp/<name>.lua so vim.lsp.enable() can spawn servers
  Coqtail
  vim-kitty-navigator
  auto-reload-nvim
]
