set nocompatible
syntax on
filetype off
filetype plugin indent on
let on_mac = ($HOME ==  '/Users/jsteill')
let hostname = substitute(system('hostname'), '\n', '', '')
let on_biostat = (hostname =~ "biostat")
if on_mac
    set rtp+=~/.vim/bundle/Vundle.vim
    set guifont=Menlo\ Regular:h12
elseif on_biostat
    set rtp+=/ua/steill/.vim/bundle/Vundle.vim
else
    set rtp+=/w4home/jsteill/.vim/bundle/Vundle.vim
endif
call vundle#begin()
Plugin 'VundleVim/Vundle.Vim'
Plugin 'Valloric/YouCompleteMe'
if !on_mac
    Plugin 'NLKNguyen/papercolor-theme'
    Plugin 'StanAngeloff/php.vim'
endif
call vundle#end()
set t_Co=256   " This is may or may not needed.
if on_mac
    ""colorscheme molokai
    colorscheme solarized
    ""colorscheme mayansmoke
else
    colorscheme PaperColor
endif
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
