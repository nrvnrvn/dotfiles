set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
Plugin 'altercation/vim-colors-solarized'
Plugin 'fatih/vim-go'
Plugin 'klen/python-mode'
Plugin 'scrooloose/syntastic'
Plugin 'tpope/vim-fugitive'
Plugin 'Valloric/YouCompleteMe'
Plugin 'bling/vim-airline'
Plugin 'airblade/vim-gitgutter'
Plugin 'scrooloose/nerdtree'
" Track the engine.
Plugin 'SirVer/ultisnips'
Plugin 'nginx.vim'
" Snippets are separated from the engine. Add this if you want them:
Plugin 'honza/vim-snippets'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
syntax enable
set textwidth=79
set colorcolumn=80
set tabstop=4
set softtabstop=4
set expandtab
set autoindent
set number
set showcmd
set cursorline
set ruler
set t_Co=16
hi Folded ctermfg=10
let g:solarized_termcolors=16
colorscheme solarized
set background=dark
set backspace=indent,eol,start
"new settings go heere
" Search
set incsearch           " search as characters are entered
set hlsearch            " highlight matches

" airline
set laststatus=2
let g:airline_left_sep=''
let g:airline_right_sep=''

" python-mode
let g:pymode_rope = 1
let g:pymode_lint = 1
let g:pymode_virtualenv = 1
let g:pymode_folding = 0

" make YCM compatible with UltiSnips (using supertab)
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'

" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
autocmd BufWritePre * :%s/\s\+$//e
autocmd BufWritePre *.py :call pymode#rope#organize_imports()
