set number
set autoindent
set expandtab
set relativenumber
set cursorline
set showmatch
set hlsearch
set incsearch
set ignorecase
set showcmd
set showmode

set mouse=a
set encoding=utf-8
set t_Co=256
set tabstop=2
set softtabstop=2
set shiftwidth=4


syntax on
filetype indent on

" plugins
call plug#begin('~/.vim/plugged')

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'preservim/nerdtree'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'edkolev/tmuxline.vim'

call plug#end()

" key mapping

let mapleader=" "

nmap <leader>wq :wq<CR> 
nmap <leader>q :q<CR>
"nmap <leader>v :vsplit 
"nmap <leader>s :split
nmap nh :nohlsearch<CR>

noremap tt :NERDTreeToggle<CR>
nnoremap <leader>n :NERDTreeFocus<CR>

inoremap jj <esc>

nnoremap <leader>w <c-w>w
nnoremap <leader>h <c-w>h
nnoremap <leader>j <c-w>j
nnoremap <leader>k <c-w>k
nnoremap <leader>l <c-w>l

" copy & paste
vmap <leader>c "+y

nmap <leader>v "+p
imap <leader>v <esc>"+p

" airline conf
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
