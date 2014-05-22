Bundle "vim-scripts/IndexedSearch"
Bundle "nelstrom/vim-visual-star-search"

Bundle 'rking/ag.vim'
" Open the Ag command and place the cursor into the quotes
nmap ,ag :Ag ""<Left>
nmap ,agf :AgFile ""<Left>

Bundle "skwp/greplace.vim"
set grepprg=git\ grep
let g:grep_cmd_opts = '--line-number'

" . searching {{{

" sane regexes
nnoremap / /\v
vnoremap / /\v

set ignorecase      " Ignore case when searching...
set smartcase       " ...unless we type a capital
set showmatch
set incsearch       " Find the next match as we type the search
set hlsearch        " Hilight searches by default
" Type ,hl to toggle highlighting on/off, and show current value.
noremap ,hl :set hlsearch! hlsearch?<CR>

" clear search matching
noremap <leader><space> :noh<cr>:call clearmatches()<cr>

" Don't jump when using * for search
nnoremap * *<c-o>

" Keep search matches in the middle of the window.
nnoremap n nzzzv
nnoremap N Nzzzv

" Same when jumping around
nnoremap g; g;zz
nnoremap g, g,zz

" Open a Quickfix window for the last search.
nnoremap <silent> <leader>? :execute 'vimgrep /'.@/.'/g %'<CR>:copen<CR>
" ,q to toggle quickfix window (where you have stuff like Ag)
" nmap <silent> ,qc :cclose<CR>

" Highlight word {{{
nnoremap <silent> <leader>hh :execute 'match InterestingWord1 /\<<c-r><c-w>\>/'<cr>
nnoremap <silent> <leader>h1 :execute 'match InterestingWord1 /\<<c-r><c-w>\>/'<cr>
nnoremap <silent> <leader>h2 :execute '2match InterestingWord2 /\<<c-r><c-w>\>/'<cr>
nnoremap <silent> <leader>h3 :execute '3match InterestingWord3 /\<<c-r><c-w>\>/'<cr>

" }}}

