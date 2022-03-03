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

syntax on
filetype indent on

" plugins
call plug#begin('~/.vim/plugged')

Plug 'vim-airline/vim-airline'
Plug 'preservim/nerdtree'

call plug#end()

" key mapping

let mapleader=" "

nmap <leader>wq :wq<CR> 
nmap nh :nohlsearch<CR>

noremap tt :NERDTreeToggle<CR>
nnoremap <leader>n :NERDTreeFocus<CR>

inoremap jj <esc>
