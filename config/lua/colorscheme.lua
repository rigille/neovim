vim.opt.termguicolors = false
vim.opt.background = 'dark'
vim.cmd.colorscheme('vim')

local function pitch_black()
  for _, group in ipairs({
    'Normal', 'NormalNC', 'NormalFloat',
    'SignColumn', 'EndOfBuffer',
  }) do
    vim.api.nvim_set_hl(0, group, { ctermbg = 'Black' })
  end
end

pitch_black()
vim.api.nvim_create_autocmd('ColorScheme', { callback = pitch_black })
