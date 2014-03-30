Bundle 'maxbrunsfeld/vim-yankstack'

Bundle 'vim-scripts/YankRing.vim'
let g:yankring_replace_n_pkey = '<leader>['
let g:yankring_replace_n_nkey = '<leader>]'
let g:yankring_history_dir = '~/.vim/tmp/'
nmap <leader>y :YRShow<cr>

" Yank from current cursor position to end of line
nnoremap Y y$
function! YRRunAfterMaps()
  nnoremap Y   :<C-U>YRYankCount 'y$'<CR>
endfunction

" Yank content in OS's clipboard. `o` stands for "OS's Clipoard".
vnoremap <leader>yo "*y
" Paste content from OS's clipboard
nnoremap <leader>po "*p
