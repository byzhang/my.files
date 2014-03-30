Bundle "vim-scripts/camelcasemotion.git"
Bundle 'terryma/vim-multiple-cursors'
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

Bundle "skwp/vim-easymotion"
" This remaps easymotion to show us only the left
" hand home row keys as navigation options which
" may mean more typing to get to a particular spot
" but it'll all be isolated to one area of the keyboard
call EasyMotion#InitOptions({
\   'leader_key'      : '<Leader><Leader>'
\ , 'keys'            : 'fjdksewoavn'
\ , 'do_shade'        : 1
\ , 'do_mapping'      : 1
\ , 'grouping'        : 1
\
\ , 'hl_group_target' : 'Type'
\ , 'hl_group_shade'  : 'Comment'
\ })

" Make 0 go to the first character rather than the beginning
" of the line. When we're programming, we're almost always
" interested in working with text rather than empty space. If
" you want the traditional beginning of line, use ^
nnoremap 0 ^
nnoremap ^ 0
