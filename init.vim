" Neovim
let g:python_host_prog = $HOME.'/.virtualenvs/neovim_PY27/bin/python'
let g:python3_host_prog = $HOME.'/.virtualenvs/neovim_PY35/bin/python'

" Vim-plug
call plug#begin('~/.vim/plugged')
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'Shougo/deoplete.nvim' | Plug 'zchee/deoplete-go', {'for': 'go'}
Plug 'jiangmiao/auto-pairs'
Plug 'airblade/vim-gitgutter'
Plug 'altercation/vim-colors-solarized'
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
"Plug 'chase/vim-ansible-yaml'
Plug 'davidhalter/jedi-vim', {'for': 'python'}
Plug 'lepture/vim-velocity' 
Plug 'fatih/vim-go'
Plug 'hynek/vim-python-pep8-indent', {'for': 'python'}
Plug 'klen/python-mode', {'for': 'python'}
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/syntastic'
"Plug 'nginx.vim'

call plug#end()
filetype plugin indent on    " required
syntax enable

" Appearance
autocmd FileType python setlocal colorcolumn=80 tabstop=4 softtabstop=4 shiftwidth=4
set expandtab
set number
set showmatch

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
let g:neocomplete#enable_at_startup = 1

" NERDTree
let NERDTreeIgnore = ['\.pyc$', '__pycache__$', '\.egg-info$']

" Trim whitespace
autocmd BufWritePost * :%s/\s\+$//e
