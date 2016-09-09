let g:ycm_confirm_extra_conf = 0
Bundle "Valloric/YouCompleteMe.git"
" See tag in preview
" noremap <C-]> <Esc>:exe "ptjump " . expand("<cword>")<Esc>
noremap <C-]> :YcmCompleter GoToDefinitionElseDeclaration<CR>
inoremap <C-]> <C-O>:YcmCompleter GoToDefinitionElseDeclaration<CR>

