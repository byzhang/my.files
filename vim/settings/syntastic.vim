Plugin 'scrooloose/syntastic'
"mark syntax errors with :signs
let g:syntastic_enable_signs=2
let g:syntastic_error_symbol='✗'
"automatically jump to the error when saving the file
let g:syntastic_auto_jump=0
"show the error list automatically
let g:syntastic_auto_loc_list=1
"don't care about warnings
let g:syntastic_quiet_messages = {'level': 'warnings'}
let g:syntastic_mode_map = { 'mode': 'active', 'active_filetypes': ['ruby'], 'passive_filetypes': ['html', 'css', 'slim'] }
" use py-mode and autoformat
let g:syntastic_enable_python_checker = 0
" let g:syntastic_python_checkers=['forsted', 'pylama']
" let g:syntastic_python_pylama_args='--ignore=E501'
