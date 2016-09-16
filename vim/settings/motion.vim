Plugin 'vim-scripts/camelcasemotion.git'
Plugin 'terryma/vim-multiple-cursors'
" Turn off default key mappings
let g:multi_cursor_use_default_mapping=0

" Switch to multicursor mode with ,mc
let g:multi_cursor_start_key=',mc'

" Ctrl-n, Ctrl-p, Ctrl-x, and <Esc> are mapped in the special multicursor
" mode once you've added at least one virtual cursor to the buffer
let g:multi_cursor_next_key='<C-n>'
let g:multi_cursor_prev_key='<C-p>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc>'

" Make 0 go to the first character rather than the beginning
" of the line. When we're programming, we're almost always
" interested in working with text rather than empty space. If
" you want the traditional beginning of line, use ^
nnoremap 0 ^
nnoremap ^ 0
