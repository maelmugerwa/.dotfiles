" plugins.vim - Plugin manager setup. Nothing is active yet.

" Option 1: vim-plug.

" call plug#begin('~/.config/nvim/plugged')
" Plug 'tpope/vim-surround'
" Plug 'nvim-telescope/telescope.nvim'
" Plug 'neovim/nvim-lspconfig'
" call plug#end()

" Option 2: packer.nvim.

" lua << EOF
" require('packer').startup(function(use)
"   -- Packer can manage itself
"   use 'wbthomason/packer.nvim'
"
"   -- Add plugins here
"   use 'tpope/vim-surround'
"   use {
"     'nvim-telescope/telescope.nvim',
"     requires = { 'nvim-lua/plenary.nvim' }
"   }
" end)
" EOF

" To enable one option:
" 1. Uncomment that section.
" 2. Install the plugin manager.
" 3. Add `source $HOME/.config/nvim/plugins.vim` to init.vim.
" 4. Run its install command, such as :PlugInstall or :PackerInstall.
