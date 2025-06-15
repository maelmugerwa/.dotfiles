" options.vim - Neovim settings and options
" This file contains all the settings, options, and parameters for Neovim
" Sourced from init.vim

" Display settings
set number                " Show line numbers
set relativenumber        " Show relative line numbers
set cursorline            " Highlight current line
set showmatch             " Highlight matching brackets
set signcolumn=yes        " Always show sign column
set scrolloff=8           " Start scrolling when 8 lines from the bottom
set termguicolors         " Enable true color support

" Text and editing settings
set expandtab             " Use spaces instead of tabs
set shiftwidth=2          " One tab = 2 spaces
set tabstop=2             " One tab = 2 spaces
set softtabstop=2         " One tab = 2 spaces
set autoindent            " Auto indent
set smartindent           " Smart indent
set wrap                  " Wrap lines
set linebreak             " Break lines at word

" Search settings
set ignorecase            " Case insensitive search
set smartcase             " Case sensitive when uppercase present
set hlsearch              " Highlight search results
set incsearch             " Show matches while typing

" System settings
set hidden                " Allow hidden buffers
set noswapfile            " Don't use swapfile
set nobackup              " Don't create backup files
set undofile              " Persistent undo
set undodir=~/.config/nvim/undodir  " Undo directory
set updatetime=300        " Faster completion
set timeoutlen=500        " By default timeoutlen is 1000ms

" Additional options for better experience
set completeopt=menuone,noinsert,noselect  " Better completion experience
set shortmess+=c          " Don't pass messages to ins-completion-menu
set mouse=a               " Enable mouse support
set clipboard+=unnamedplus  " Use system clipboard
set splitright            " Split windows right
set splitbelow            " Split windows below
set conceallevel=0        " Don't hide markdown syntax
