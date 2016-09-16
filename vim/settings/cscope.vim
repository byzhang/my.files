let g:cscope_ignore_files=1
let g:cscope_ignore_strict=1
Plugin 'vim-scripts/cscope.vim'
let g:cscope_ignore_files=g:cscope_ignore_files.'\|\.caffemodel$\|\.solverstate$'
" Rebuild cscope db
map <leader>fb :CscopeGen()<CR>

