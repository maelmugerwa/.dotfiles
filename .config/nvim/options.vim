" options.vim - Neovim settings. init.vim sources this file.

" Display
set number
set relativenumber
set cursorline
set showmatch
set signcolumn=yes
set scrolloff=8
set termguicolors

" Indentation and wrapping. Two spaces, never a tab.
set expandtab
set shiftwidth=2
set tabstop=2
set softtabstop=2
set autoindent
set smartindent
set wrap
set linebreak             " Wrap at word boundaries.

" Search
set ignorecase
set smartcase             " An uppercase letter forces a case-sensitive search.
set hlsearch
set incsearch

" Files, undo and timing
set hidden                " Leave a modified buffer without saving it.
set noswapfile
set nobackup
set undofile
set undodir=~/.config/nvim/undodir
set updatetime=300        " Drives CursorHold, which completion plugins use.
set timeoutlen=500        " The default is 1000ms.

" Completion, mouse, clipboard and splits
set completeopt=menuone,noinsert,noselect  " Show the menu but never auto-insert a match.
set shortmess+=c          " Flag c silences completion messages.
set mouse=a
set clipboard+=unnamedplus
set splitright
set splitbelow
set conceallevel=0        " Keep markdown syntax visible.
