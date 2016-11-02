" Neovim
let g:python_host_prog = $HOME.'/.virtualenvs/neovim_PY27/bin/python'
let g:python3_host_prog = $HOME.'/.virtualenvs/neovim_PY35/bin/python'

" Vim-plug
call plug#begin('~/.vim/plugged')
"Plug 'chase/vim-ansible-yaml'
Plug 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins'}
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'airblade/vim-gitgutter'
Plug 'altercation/vim-colors-solarized'
Plug 'bling/vim-airline'
Plug 'bronson/vim-trailing-whitespace'
Plug 'davidhalter/jedi-vim', {'for': 'python'}
Plug 'edkolev/tmuxline.vim'
Plug 'fatih/vim-go', {'for': 'go'}
Plug 'hynek/vim-python-pep8-indent', {'for': 'python'}
Plug 'jiangmiao/auto-pairs'
Plug 'klen/python-mode', {'for': 'python'}
Plug 'lepture/vim-velocity'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/syntastic'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline-themes'
Plug 'zchee/deoplete-go', {'for': 'go', 'do': 'make'}

call plug#end()
filetype plugin indent on    " required
syntax enable
set lz
set cb=unnamed

" Appearance
autocmd FileType python setlocal colorcolumn=80
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set number
"set showmatch

" Color
hi Folded ctermfg=10
colorscheme solarized
set background=light

" Search
set ignorecase
set smartcase

" Key mappings
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz
nnoremap B ^
nnoremap E $

" Airline
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled = 1

" Tmuxline
let g:tmuxline_preset = {
      \'a'    : '#I',
      \'b'    : '',
      \'c'    : '',
      \'win'  : '#I #W#F',
      \'cwin' : '#I #W#F',
      \'x'    : '',
      \'y'    : '',
      \'z'    : '%Y-%m-%d %R'}

" Deoplete
let g:deoplete#enable_at_startup = 1

" Python-mode
let g:pymode_folding = 0
let g:pymode_indent = 0
let g:pymode_lint = 1
let g:pymode_rope = 0
let g:pymode_rope_complete_on_dot = 0
let g:pymode_rope_completion = 0
let g:pymode_run = 0
let g:pymode_virtualenv = 1

" Make YCM compatible with UltiSnips (using supertab)
"let g:ycm_key_list_select_completion = ['<C-j>', '<Down>']
"let g:ycm_key_list_previous_completion = ['<C-k>', '<Up>']
"nnoremap <leader>jj :YcmCompleter GoTo<CR>

" Better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

" NERDTree
let NERDTreeIgnore = ['\.pyc$', '__pycache__$', '\.egg-info$']

" Trim whitespace
autocmd BufWritePre * :%s/\s\+$//e
