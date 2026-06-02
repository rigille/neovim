local langs = { 'c', 'cpp', 'python', 'scheme', 'javascript', 'bash', 'rust' }

local filetype_to_lang = {
  sh = 'bash',
}

vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    local ft = vim.bo[args.buf].filetype
    local lang = filetype_to_lang[ft] or ft
    if not vim.tbl_contains(langs, lang) then
      return
    end
    pcall(vim.treesitter.start, args.buf, lang)
  end,
})
