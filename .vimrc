set nocompatible
filetype on
filetype indent on
filetype plugin on
filetype plugin indent on

set encoding=utf-8
set number
set relativenumber

set autoindent
set showmatch
set cursorline
set wrap

set showcmd
set showmode
set wildmenu
set laststatus=2

" search
set hlsearch
set incsearch
set ignorecase
set smartcase

set mouse=a
set clipboard^=unnamed,unnamedplus
set encoding=utf-8
" enable 256 colors
set t_Co=256

" transform tab to whitespace
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2

set scrolloff=10

let mapleader=' '
syntax on


" plugins
call plug#begin('~/.vim/plugged')

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'preservim/nerdtree'
Plug 'edkolev/tmuxline.vim'
Plug 'tpope/vim-surround'
Plug 'Lokaltog/vim-easymotion'

call plug#end()


" key mapping
inoremap jj <esc>

nnoremap <leader>wq :wq<CR>
nnoremap <leader>q :q<CR>
nnoremap <Backspace> :nohl<CR>

nnoremap J 5j
nnoremap K 5k

" navigate
nnoremap <leader>w <c-w>w
nnoremap <leader>h <c-w>h
nnoremap <leader>j <c-w>j
nnoremap <leader>k <c-w>k
nnoremap <leader>l <c-w>l

" split
nnoremap <leader>sv :vsplit<CR>
nnoremap <leader>sh :split<CR>

" copy & paste
vnoremap <C-y> "+y
nnoremap <C-p> "*p

" nerdtree
nnoremap tt :NERDTreeToggle<CR>
nnoremap <leader>n :NERDTreeFocus<CR>
" airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline#extensions#tabline#formatter = 'default'
" tmuxline
let g:airline#extensions#tmuxline#enabled = 1
let airline#extensions#tmuxline#snapshot_file = "~/.tmux-status.conf"

