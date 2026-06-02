local art = {
  [[      |\      _,,,---,,_]],
  [[ZZZzz /,`.-'`'    -.  ;-;;,_]],
  [[     |,4-  ) )-,_. ,\ (  `'-']],
  [[    '---''(_/--'  `-'\_)]],
  '',
  'Program like Dijkstra is watching',
}

vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    if vim.fn.argc() > 0 then return end
    local buf = vim.api.nvim_get_current_buf()
    if vim.api.nvim_buf_get_name(buf) ~= '' then return end
    if vim.bo[buf].modified then return end
    if vim.api.nvim_buf_line_count(buf) > 1 then return end
    local first = vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1]
    if first and first ~= '' then return end

    local win = vim.api.nvim_get_current_win()
    local width = vim.api.nvim_win_get_width(win)
    local height = vim.api.nvim_win_get_height(win)

    local max_len = 0
    for _, line in ipairs(art) do
      max_len = math.max(max_len, vim.fn.strdisplaywidth(line))
    end

    local left = math.max(0, math.floor((width - max_len) / 2))
    local top = math.max(0, math.floor((height - #art) / 2))
    local lpad = string.rep(' ', left)

    local lines = {}
    for _ = 1, top do lines[#lines + 1] = '' end
    for _, line in ipairs(art) do lines[#lines + 1] = lpad .. line end

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo[buf].modified = false
    vim.wo.number = false
    vim.wo.relativenumber = false

    vim.api.nvim_create_autocmd('InsertEnter', {
      buffer = buf,
      once = true,
      callback = function()
        if not vim.api.nvim_buf_is_valid(buf) then return end
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, { '' })
        vim.api.nvim_win_set_cursor(0, { 1, 0 })
        vim.bo[buf].modified = false
      end,
    })
  end,
})
