Bundle 'troydm/easybuffer.vim'
nmap <leader>be :EasyBufferToggle<enter>

" Fast saving and closing current buffer without closing windows displaying the
" buffer
nmap <leader>wq :w!<cr>:Bclose<cr>

" Easy buffer navigation
noremap <leader>bp :bprevious<cr>
noremap <leader>bn :bnext<cr>

