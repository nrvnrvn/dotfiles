" Reference: https://vimhelp.org/options.txt.html#options.txt

" Defaults from https://neovim.io/doc/user/vim_diff.html
syntax enable
filetype plugin indent on
set autoindent
set autoread
set belloff=all
set backspace=indent,eol,start
set nocompatible
set complete-=i
set display="lastline,msgsep"
set encoding=utf-8
set fillchars="vert:|,fold:·,sep:│"
set formatoptions=tcqj
set nofsync
set history=10000
set hlsearch
set incsearch
set laststatus=2
set listchars="tab:> ,trail:-,nbsp:+"
set nrformats="bin,hex"
set ruler
set sessionoptions-=options
set shortmess-=S
set shortmess+=F
set showcmd
set sidescroll=1
set smarttab
set nostartofline
set tabpagemax=50
set ttimeoutlen=50
set ttyfast
set wildmenu
set wildoptions="pum,tagfile"

" Some more tuning
set hidden
set lazyredraw
set nobackup
set noerrorbells
set noswapfile
set nowrap
set title
set undolevels=1000
set visualbell

" Search
set ignorecase
set smartcase

" Wildmenu
set wildignore+=*.dll,*.o,*.pyc,*.bak,*.exe,*.jpg,*.jpeg,*.png,*.gif,*$py.class,*.class,*/*.dSYM/*,*.dylib

" Appearance
autocmd FileType python setlocal colorcolumn=80
colorscheme flattened_dark
set copyindent
set smarttab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set number
set showmatch

" Key mappings
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz
nnoremap B ^
nnoremap E $

" Easy window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Speed up Syntax Highlighting
augroup vimrc
   autocmd!
   autocmd BufWinEnter,Syntax * syn sync minlines=500 maxlines=500
augroup END

" Autoresize windows
autocmd VimResized * :wincmd =

" Trim whitespace
autocmd BufWritePre * :%s/\s\+$//e
