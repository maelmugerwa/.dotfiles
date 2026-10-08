" init.vim - Neovim entry point.

" plugins.vim stays unloaded until you install a plugin manager.
" source $HOME/.config/nvim/plugins.vim

source $HOME/.config/nvim/options.vim

source $HOME/.config/nvim/keymaps.vim

" undofile needs undodir to exist, so create it.
if !isdirectory($HOME . "/.config/nvim/undodir")
  call mkdir($HOME . "/.config/nvim/undodir", "p")
endif

" Uncomment to load the Lua config.
" lua require('init')

" Notes
" - Put extra plugin configuration in after/plugin/.
" - Put Lua modules in lua/.
" - Put machine-specific settings in local.vim.
