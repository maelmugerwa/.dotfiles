# Neovim Configuration

This directory contains the Neovim configuration files that are part of the dotfiles repository.

## Overview

The configuration is designed to be simple, yet functional with good defaults for development. It uses a modular structure for better organization and easier maintenance.

## Modular Structure

The configuration is split into multiple files:

- `init.vim` - Main entry point that loads all other configuration files
- `options.vim` - All Neovim settings and options 
- `keymaps.vim` - Key mappings and keyboard shortcuts
- `plugins.vim` - Plugin management (currently a placeholder)
- `lua/` - Directory for Lua-based configurations (for future use)
- `after/plugin/` - Plugin-specific configurations (for future use)
- `undodir/` - Directory for persistent undo history

This structure makes it easy to:
- Find specific settings
- Add or modify configurations without changing everything
- Maintain separation of concerns

## Features

- **Clean Interface**: Line numbers, cursor highlighting, and clear visual indicators
- **Smart Editing**: Proper indentation, spacing, and line wrapping
- **Efficient Navigation**: Keyboard shortcuts for buffers and window management
- **Optimized Settings**: Faster completion, improved search, and better system integration
- **Modular Design**: Easy to extend and maintain

## Key Mappings

The leader key is set to `Space`. See `keymaps.vim` for a complete list of mappings.

### Basic Operations
- `<leader>w` - Save file
- `<leader>q` - Quit
- `<leader>wq` - Save and quit
- `<leader>e` - Edit file (requires filename)

### Editing
- `<leader>c` - Clear search highlighting
- `<leader>h` - Toggle search highlighting
- `<leader>s` - Search and replace word under cursor

### Buffer Navigation
- `<leader>bn` - Next buffer
- `<leader>bp` - Previous buffer
- `<leader>bd` - Delete buffer
- `<leader>bl` - List buffers

### Window Navigation
- `Ctrl+h` - Move to left window
- `Ctrl+j` - Move to down window
- `Ctrl+k` - Move to up window
- `Ctrl+l` - Move to right window

### Quick Access
- `<leader>ev` - Edit init.vim
- `<leader>ek` - Edit keymaps.vim
- `<leader>eo` - Edit options.vim
- `<leader>ep` - Edit plugins.vim

## Extending the Configuration

### Adding Plugins

To add plugins, you can:

1. Uncomment the plugin manager section in `plugins.vim`
2. Add your desired plugins
3. Source `plugins.vim` from `init.vim`
4. Run the plugin installation command

### Plugin-Specific Configurations

Place plugin-specific settings in:
- `after/plugin/[plugin-name].vim` for VimScript configurations
- `lua/[plugin-name].lua` for Lua-based configurations

### Future Plans

The configuration is ready to be expanded with:
- Plugin management (vim-plug, packer, or lazy.nvim)
- LSP configuration for intelligent code completions
- Treesitter for better syntax highlighting
- Telescope for fuzzy finding

## References

- [Neovim Documentation](https://neovim.io/doc/)
- [Learn Vimscript the Hard Way](https://learnvimscriptthehardway.stevelosh.com/)
- [Lua Guide for Neovim](https://neovim.io/doc/user/lua-guide.html)
