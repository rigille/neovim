# inspired by https://primamateria.github.io/blog/neovim-nix/
{
  description = "Rígille's neovim flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=23.05";
    flake-utils.url = "github:numtide/flake-utils";
    neovim = {
      url = "github:neovim/neovim/stable?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, flake-utils, neovim }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        nvim = neovim.packages.${system}.neovim;
        nvim_wrapped = pkgs.wrapNeovim nvim {
            configure = {
              packages.myVimPackage = {
                start = with pkgs.vimPlugins; [
                  telescope-zoxide
                  nvim-treesitter.withAllGrammars
                  nvim-lspconfig
                  nerdtree
                  Coqtail
                  vim-kitty-navigator
                ];
              };
              customRC = ''
                set shiftwidth=4 smarttab
                set expandtab
                set tabstop=8 softtabstop=0
                set clipboard=unnamedplus
                set number

                set foldlevel=99

                nnoremap <C-n> :NERDTreeToggle<CR>
                tnoremap <Esc> <C-\><C-n>

                let g:kitty_navigator_no_mappings = 1

                nnoremap <silent> <C-h> :KittyNavigateLeft<cr>
                nnoremap <silent> <C-j> :KittyNavigateDown<cr>
                nnoremap <silent> <C-k> :KittyNavigateUp<cr>
                nnoremap <silent> <C-l> :KittyNavigateRight<cr>
                lua << EOF
                local vim = vim
                local opt = vim.opt

                local builtin = require('telescope.builtin')
                vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
                vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
                vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
                vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
                vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
                vim.keymap.set('n', '<leader>fd', builtin.treesitter, {})
                vim.keymap.set('n', 'gr', builtin.lsp_references,{})
                
                local lspconfig = require('lspconfig')
                lspconfig.pyright.setup {}
                lspconfig.nil_ls.setup {}
                lspconfig.ccls.setup {}

                -- Global mappings.
                -- Use LspAttach autocommand to only map the following keys
                -- after the language server attaches to the current buffer
                vim.api.nvim_create_autocmd('LspAttach', {
                  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
                  callback = function(ev)
                    -- Enable completion triggered by <c-x><c-o>
                    vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'

                    -- Buffer local mappings.
                    -- See `:help vim.lsp.*` for documentation on any of the below functions
                    local opts = { buffer = ev.buf }
                    vim.diagnostic.disable()
                    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
                    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
                    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
                    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
                    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
                    vim.keymap.set('n', '<space>wl', function()
                      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                    end, opts)
                    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
                    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
                    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
                    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
                    vim.keymap.set('n', '<space>f', function()
                      vim.lsp.buf.format { async = true }
                    end, opts)
                  end,
                })
                EOF
              '';
            };
        };
      in {
        packages.default = pkgs.writeShellApplication {
	  name = "nvim";
	  runtimeInputs = [ pkgs.nodePackages.pyright pkgs.nil pkgs.ccls ];
	  text = ''
	    ${nvim_wrapped}/bin/nvim "$@"
	  '';
	};
      });
}
