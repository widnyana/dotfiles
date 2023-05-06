set nocompatible              " be iMproved, required
" Vundle part {
    filetype off                  " required

    " set the runtime path to include Vundle and initialize
    set rtp+=~/.vim/bundle/Vundle.vim
    call vundle#begin()

    " vundle Plugin {
        " let Vundle manage Vundle, required
        Plugin 'gmarik/Vundle.vim'
        Bundle 'tpope/vim-fugitive'
        Bundle 'tpope/vim-sensible'
        Bundle 'altercation/vim-colors-solarized'
        Bundle 'nanotech/jellybeans.vim'
        Bundle 'Lokaltog/vim-powerline'

        " Nerdtree {
            Bundle 'scrooloose/nerdtree'
            " Show the Bookmarks
            let g:NERDTreeShowBookmarks=1
        " }
    " }


    " All of your Plugins must be added before the following line
    call vundle#end()            " required
    filetype plugin indent on    " required
" }


" some setting {
    set modifiable
    set cursorline
    set smartindent
    set ruler
    set tabstop=4
    set shiftwidth=4
    set expandtab
    set number
    set encoding=utf-8
    set ignorecase
    set smartcase

    " No backup and swap {
        set nobackup
        set noswapfile
    "}

    " better line wrapping {
        set nowrap
        set textwidth=80
        set formatoptions=qrnl
    " }

    " shortcut {
        noremap <tab> <c-w><c-w>
        nnoremap <f2> :NERDTreeToggle<cr>
    " }


    " Color scheme {
        syntax on
        set background=dark
        colorscheme solarized
    " }

    " Switching window {
        nmap <silent> <A-Up> :wincmd k<CR>
        nmap <silent> <A-Down> :wincmd j<CR>
        nmap <silent> <A-Left> :wincmd h<CR>
        nmap <silent> <A-Right> :wincmd l<CR>
    " }
" }
