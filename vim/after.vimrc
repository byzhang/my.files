" General {{{
filetype plugin on

syntax on

" Highlight VCS conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'
" }}}

" ================ General Config ====================
set number                      "Line numbers are good
set numberwidth=3
set backspace=indent,eol,start  "Allow backspace in insert mode
set history=1000                "Store lots of :cmdline history
set showcmd                     "Show incomplete cmds down the bottom
set showmode                    "Show current mode down the bottom
set gcr=a:blinkon0              "Disable cursor blink
set visualbell                  "No sounds
set autoread                    "Reload files changed outside vim
set nowrap                      "Don't wrap lines
set linebreak                   "Wrap lines at convenient points
set encoding=utf-8

" This makes vim act like all other editors, buffers can
" exist in the background without being in a window.
" http://items.sjbach.com/319/configuring-vim-right
set hidden

" Don't redraw while executing macros
set nolazyredraw

" It defines where to look for the buffer user demanding (current window, all
" windows in other tabs, or nowhere, i.e. open file from scratch every time) and
" how to open the buffer (in the new split, tab, or in the current window).

" This orders Vim to open the buffer.
set switchbuf=useopen

set ruler
if executable('zsh')
  set shell=zsh\ -l
endif

set exrc
set secure

set matchtime=2

set dictionary=/usr/share/dict/words

" ================ Completion =======================
set wildmode=list:longest,list:full
set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=.svn,CVS,.git,.hg,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif,.DS_Store,*.aux,*.out,*.toc,tmp,*.scssc,*.pyc
set wildignore+=eggs/**
set wildignore+=*.egg-info/**
" Fix the error for completion
set completeopt-=preview

" ================ Scrolling ========================
set scrolloff=8             "Start scrolling when we're 8 lines away from margins
set sidescrolloff=15
set sidescroll=1

" ================ Folds ============================
set foldmethod=indent   "fold based on indent
set foldnestmax=3       "deepest fold is 3 levels
set nofoldenable        "dont fold by default

" Cursorline {{{
" Only show cursorline in the current window and in normal mode.
augroup cline
    au!
    au WinLeave * set nocursorline
    au WinEnter * set cursorline
    au InsertEnter * set nocursorline
    au InsertLeave * set cursorline
augroup END
" }}}

" _ Vim {{{
augroup ft_vim
    au!

"    au FileType vim setlocal foldmethod=marker
    au FileType help setlocal textwidth=78
    au BufWinEnter *.txt if &ft == 'help' | wincmd L | endif
augroup END
" When vimrc is edited, reload it
autocmd! BufWritePost vimrc source ~/.vimrc
" }}}

