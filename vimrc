let on_mac = ($HOME ==  '/Users/jsteill')
let hostname = substitute(system('hostname'), '\n', '', '')
let on_biostat = (hostname =~ "biostat")
let g:ycm_server_python_interpreter="/usr/bin/python"

set nocompatible	" Req'd for Vundle
filetype off		" Req'd for Vundle, can turn on later
set rtp+=~/.vim/bundle/Vundle.Vim
call vundle#begin()
" 	alternatively, pass a path where Vundle should install plugins
"	call vundle#begin('~/some/path/here')
Plugin 'VundleVim/Vundle.Vim'
Plugin 'gmarik/Vundle'
if !on_mac
    Plugin 'Valloric/YouCompleteMe'
    Plugin '2072/PHP-Indenting-for-VIm'
    Plugin 'NLKNguyen/papercolor-theme'
    Plugin 'tpope/vim-fugitive'
    Plugin 'ambv/black', {'rtp': 'vim'}
    let g:black_linelength=79
    "Plugin 'StanAngeloff/php.vim'
    "Plugin 'ajh17/VimCompletesMe'
    colorscheme PaperColor
    autocmd BufWritePost *.py call Flake8()
    
else
    set guifont=Menlo\ Regular:h12
    colorscheme molokai
    ""colorscheme solarized
    ""colorscheme mayansmoke
endif
call vundle#end()
if !on_mac
    execute pathogen#infect()
endif
if &diff
    set noreadonly
endif
filetype plugin indent on
filetype indent on
syntax on
set t_Co=256
set backspace=indent,eol,start
:let mapleader = ","


set tabstop=4 
set softtabstop=4 
set shiftwidth=4
set expandtab 
set foldmethod=indent
set foldlevelstart=99
set background=dark
set number
set relativenumber
set ruler
:nnoremap <leader>ev :vsplit $MYVIMRC<cr>
:nnoremap <leader>sv :source $MYVIMRC<cr>
:noremap <leader>" viw<esc>a"<esc>bi"<esc>lel
:noremap <leader>' viw<esc>a'<esc>bi'<esc>lel
