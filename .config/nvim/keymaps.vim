" keymaps.vim - Neovim key mappings
" This file contains all key mappings and keyboard shortcuts
" Sourced from init.vim

" Leader key
let mapleader = " "       " Set leader key to space

" =====================================================
" Basic operations
" =====================================================

" File operations
nnoremap <leader>w :w<CR>                     " Save file
nnoremap <leader>q :q<CR>                     " Quit
nnoremap <leader>wq :wq<CR>                   " Save and quit
nnoremap <leader>e :e                         " Edit file

" Editing improvements
nnoremap <leader>c :noh<CR>                   " Clear search highlighting
nnoremap <leader>h :set hlsearch!<CR>         " Toggle search highlighting
nnoremap <leader>s :%s/\<<C-r><C-w>\>//g<left><left> " Search and replace word under cursor
vnoremap <leader>s y:%s/<C-r>"//g<left><left>  " Search and replace selected text
nnoremap <leader>nh :nohlsearch<CR>           " Clear search highlights

" =====================================================
" Navigation
" =====================================================

" Buffer navigation
nnoremap <leader>bn :bnext<CR>                " Next buffer
nnoremap <leader>bp :bprevious<CR>            " Previous buffer
nnoremap <leader>bd :bdelete<CR>              " Delete buffer
nnoremap <leader>bl :ls<CR>                   " List buffers
nnoremap <leader>1 :1b<CR>                    " Go to buffer 1
nnoremap <leader>2 :2b<CR>                    " Go to buffer 2
nnoremap <leader>3 :3b<CR>                    " Go to buffer 3

" Window navigation
nnoremap <C-h> <C-w>h                         " Move to left window
nnoremap <C-j> <C-w>j                         " Move to window below
nnoremap <C-k> <C-w>k                         " Move to window above
nnoremap <C-l> <C-w>l                         " Move to right window

" Window management
nnoremap <leader>v :vsplit<CR>                " Vertical split
nnoremap <leader>s :split<CR>                 " Horizontal split
nnoremap <leader>= <C-w>=                     " Equal window size
nnoremap <leader>- :resize -5<CR>             " Decrease window height
nnoremap <leader>+ :resize +5<CR>             " Increase window height
nnoremap <leader>, :vertical resize -5<CR>    " Decrease window width
nnoremap <leader>. :vertical resize +5<CR>    " Increase window width

" =====================================================
" Text manipulation
" =====================================================

" Indentation
vnoremap < <gv                                " Shift left and reselect
vnoremap > >gv                                " Shift right and reselect

" Move lines
vnoremap J :m '>+1<CR>gv=gv                  " Move selected lines down
vnoremap K :m '<-2<CR>gv=gv                  " Move selected lines up
nnoremap <leader>j :m .+1<CR>==               " Move current line down
nnoremap <leader>k :m .-2<CR>==               " Move current line up

" =====================================================
" Convenience mappings
" =====================================================

" Quick access to common files
nnoremap <leader>ev :e $MYVIMRC<CR>           " Edit init.vim
nnoremap <leader>ek :e ~/.config/nvim/keymaps.vim<CR> " Edit keymaps
nnoremap <leader>eo :e ~/.config/nvim/options.vim<CR> " Edit options
nnoremap <leader>ep :e ~/.config/nvim/plugins.vim<CR> " Edit plugins
nnoremap <leader>sv :source $MYVIMRC<CR>      " Source init.vim

" Terminal
nnoremap <leader>t :terminal<CR>              " Open terminal
tnoremap <Esc> <C-\><C-n>                     " Escape from terminal mode
