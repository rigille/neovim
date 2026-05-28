-- config/lua/lsp.lua
vim.lsp.config('basedpyright', {
  settings = {
    basedpyright = {
      analysis = {
        exclude = { '**/*.ipynb', '**/node_modules', '**/__pycache__' },
      },
    },
  },
})
vim.lsp.config('ruff', {})
vim.lsp.config('rust_analyzer', {})
vim.lsp.config('nil_ls', {})
vim.lsp.config('ccls', {})

vim.lsp.enable({ 'basedpyright', 'ruff', 'rust_analyzer', 'nil_ls', 'ccls' })

vim.diagnostic.enable(false)

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})
