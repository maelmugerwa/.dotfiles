" plugins.vim - Plugin management
" This file is for managing Neovim plugins
" Currently empty but can be used with plugin managers like vim-plug, packer.nvim, or lazy.nvim

" Example for vim-plug:

" Uncomment the following lines and add your plugins

" call plug#begin('~/.config/nvim/plugged')

" Plugins go here
" Plug 'tpope/vim-surround'
" Plug 'nvim-telescope/telescope.nvim'
" Plug 'neovim/nvim-lspconfig'

" call plug#end()

" Example for Packer.nvim:

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

" To enable one of these systems:
" 1. Uncomment the appropriate section
" 2. Install the plugin manager
" 3. Source this file from init.vim with: `source $HOME/.config/nvim/plugins.vim`
" 4. Run the appropriate plugin install command (:PlugInstall, :PackerInstall, etc.)
