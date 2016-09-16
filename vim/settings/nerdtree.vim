Plugin 'scrooloose/nerdtree'
nmap <leader>n :NERDTreeToggle<CR>
" Open the project tree and expose current file in the nerdtree with Ctrl-\
nnoremap <silent> <C-\> :NERDTreeFind<CR>:vertical res 30<CR>

" Disable the scrollbars (NERDTree)
set guioptions-=r
set guioptions-=L
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let g:NERDTreeWinSize = 30
