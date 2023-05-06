"No compatibility to traditional vi
set nocompatible

"language settings
if has("macunix")
  language en_US
else
  language en_US.utf8
endif

"Syntax highlighting.
syntax on

" filetype thingy
filetype plugin indent on


" change the leader key from "\" to "," (";" is also popular)
let mapleader = ","

" Visual and Motion 
    set ruler           " Display current cursor position on lower right corner
    set showmatch       " set show matching parenthesis
    set number          " Show lines numbers
    set cursorline      " highlight cursorline
    set showmode        " always show what mode we're currently editing in
    set scrolloff=8     " keep 4 lines off the edges of the screen when scrolling
    set mousehide       " Hide Mouse when typing
    set linespace=2     " Prefer a slightly higher line height

    set novisualbell    " don't beep
    set noerrorbells    " don't beep

    set showcmd         " Show command in bottom right of the screen
    set title           " set terminal title

    set backspace=indent,eol,start      " Allow backspacing in insert mode
    set virtualedit=all                 " allow the cursor to go in to 'invalid' places

set timeoutlen=500  " Lower timeout leader key + command
set hidden          " Switch between buffers without saving
set autoread        " autoread external modification
set incsearch               " incremental search

set modeline
set expandtab
set tabstop=4
set shiftwidth=4
set exrc " .vimrc in local project dir
set secure
autocmd BufRead,BufNewFile * set signcolumn=yes
autocmd FileType tagbar,nerdtree set signcolumn=no
set foldmethod=syntax
set nofoldenable
set belloff=""
set lazyredraw
set ttyfast
set spell spelllang=en_us
set noswapfile            " disable creating swap file


au CursorHold,CursorHoldI * checktime

if (has('nvim'))
    set diffopt+=vertical

    "vim-plug
    call plug#begin('~/.config/nvim/plugged')
    "Plugin list ------------------------------------------------------------------
        Plug 'neovim/nvim-lspconfig'
        Plug 'ojroques/nvim-lspfuzzy'
        

        Plug 'morhetz/gruvbox'
        Plug 'vim-airline/vim-airline'
        Plug 'vim-airline/vim-airline-themes'
        Plug 'airblade/vim-gitgutter'

        " File Search
        Plug 'junegunn/fzf.vim'
        Plug '~/.fzf'

        " Brings physics-based smooth scrolling to the Vim/Neovim world!
        Plug 'yuttie/comfortable-motion.vim'
        
        " VimWiki is a personal wiki for Vim
        Plug 'vimwiki/vimwiki'

        "File Browser:
        Plug 'preservim/nerdtree'
        Plug 'jistr/vim-nerdtree-tabs'
        Plug 'mkitt/tabline.vim'
        Plug 'ryanoasis/vim-devicons'
        Plug 'Xuyuanp/nerdtree-git-plugin'

        "Golang:
        Plug 'fatih/vim-go'

        "Snippets:
        Plug 'ncm2/ncm2-ultisnips'
        Plug 'SirVer/ultisnips'
        "Git:
        Plug 'tpope/vim-fugitive'

        " Plug 'sonph/onehalf', {'rtp': 'vim/'}
        " Plug 'hrsh7th/nvim-compe'
        " Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
        " Plug 'puremourning/vimspector'
        " Plug 'szw/vim-maximizer'
        " Plug 'dense-analysis/ale'


    "End plugin list --------------------------------------------------------------
    call plug#end()

    "-- PLUGIN CONFIGS --
    luafile ~/.config/nvim/plugin-config/lspfuzzy.lua
    source ~/.config/nvim/plugin-config/comfortable_motion.vim
    source ~/.config/nvim/plugin-config/fzf.vim
    source ~/.config/nvim/plugin-config/theme.vim
    source ~/.config/nvim/plugin-config/vimwiki.vim 


    " source ~/.config/nvim/plugin-config/treesitter.vim
    " luafile ~/.config/nvim/plugin-config/compe.lua
    " source ~/.config/nvim/plugin-config/lsp_config.vim
    " source ~/.config/nvim/plugin-config/ale.vim
    " source ~/.config/nvim/plugin-config/vimspector.vim
    " source ~/.config/nvim/plugin-config/maximizer.vim

    "-- EXTERNAL CONFIGS --
    source ~/.config/nvim/plugin-config/autoclose.vim
    source ~/.config/nvim/plugin-config/custom_map.vim
    source ~/.config/nvim/plugin-config/session.vim
    
    " The last one
    source ~/.config/nvim/plugin-config/ubuntu.vim
endif
