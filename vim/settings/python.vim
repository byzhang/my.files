let g:pymode_rope = 0
Bundle 'klen/python-mode'

Bundle 'python_match.vim'

let g:jedi#completions_enabled = 0
let g:jedi#use_tabs_not_buffers = 0
let g:jedi#use_splits_not_buffers = "bottom"
let g:jedi#goto_assignments_command = "<leader>pa"
" ycm provides c-]
" let g:jedi#goto_definitions_command = "<leader>p]"
let g:jedi#documentation_command = "K"
let g:jedi#usages_command = "<leader>pu"
let g:jedi#rename_command = "<leader>pr"
let g:jedi#show_call_signatures = "1"
Bundle "davidhalter/jedi-vim"

