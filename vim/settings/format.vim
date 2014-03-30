let g:formatprg_args_cpp = "-A14s2"
Bundle "Chiel92/vim-autoformat"
nmap <leader>af :Autoformat<CR><CR>

Bundle 'Yggdroot/indentLine'
nmap <leader>i :IndentLinesToggle<CR>
let g:indentLine_fileType=['python']
let g:indentLine_color_term = 111
let g:indentLine_color_gui = '#DADADA'
let g:indentLine_char = 'c'
"let g:indentLine_char = '∙▹¦'
let g:indentLine_char = '∙'

set list
set listchars=tab:▸\ ,extends:❯,precedes:❮,trail:␣

" Trailing whitespace {{{
" Only shown when not in insert mode so I don't go insane.
augroup trailing
    au!
    au InsertEnter * :set listchars-=trail:␣
    au InsertLeave * :set listchars+=trail:␣
augroup END

" via: http://rails-bestpractices.com/posts/60-remove-trailing-whitespace
" Strip trailing whitespace
function! <SID>StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    %s#\($\n\s*\)\+\%$##
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
command! StripTrailingWhitespaces call <SID>StripTrailingWhitespaces()
nmap ,w :StripTrailingWhitespaces<CR>

" }}}

set autoindent
set smartindent
set smarttab
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab

filetype indent on
