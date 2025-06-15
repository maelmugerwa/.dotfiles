" init.vim - Main Neovim configuration file
" This is the entry point for the Neovim configuration

" Load external configuration files
" ----------------------------------------

" Load plugin configurations (when ready)
" source $HOME/.config/nvim/plugins.vim

" Load editor options
source $HOME/.config/nvim/options.vim

" Load keybindings
source $HOME/.config/nvim/keymaps.vim

" ----------------------------------------
" Create required directories
" ----------------------------------------
if !isdirectory($HOME . "/.config/nvim/undodir")
  call mkdir($HOME . "/.config/nvim/undodir", "p")
endif

" ----------------------------------------
" Advanced configurations (when ready)
" ----------------------------------------
" Uncomment these lines as you expand your configuration

" Lua configurations
" lua require('init')

" ----------------------------------------
" Notes
" ----------------------------------------
" - Additional plugin configurations go in after/plugin/
" - Custom Lua modules go in lua/
" - For machine-specific settings, consider creating local.vim
