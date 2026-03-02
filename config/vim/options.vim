set shiftwidth=4 smarttab
set expandtab
set tabstop=8 softtabstop=0
set clipboard=unnamedplus
set number
set foldlevel=99
set updatetime=200

tnoremap <Esc> <C-\><C-n>
let g:kitty_navigator_no_mappings = 1
nnoremap <silent> <C-h> :KittyNavigateLeft<cr>
nnoremap <silent> <C-j> :KittyNavigateDown<cr>
nnoremap <silent> <C-k> :KittyNavigateUp<cr>
nnoremap <silent> <C-l> :KittyNavigateRight<cr>

autocmd FileType tex nnoremap <leader>r :w<CR>:!pdflatex %<CR>
autocmd FileType tex nnoremap <leader>c :w<CR>:!git add .<CR>:!git commit -m '.'<CR>:!git push<CR>
