# Neovim Configuration

A plugin-free Neovim setup with good defaults, split across four files.

## Modular Structure

- `init.vim` - entry point. Loads the other files.
- `options.vim` - settings and options
- `keymaps.vim` - key mappings
- `plugins.vim` - plugin management. A placeholder today.
- `lua/` - Lua modules. Empty today.
- `after/plugin/` - per-plugin configuration. Empty today.
- `undodir/` - persistent undo history

One file per concern, so you can find a setting and change it alone.

## Features

- **Clean interface**: line numbers, cursor highlighting, clear indicators
- **Smart editing**: indentation, spacing and line wrapping
- **Efficient navigation**: shortcuts for buffers and windows
- **Tuned settings**: faster completion, better search, system clipboard

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

1. Uncomment the plugin manager section in `plugins.vim`.
2. Add the plugins you want.
3. Source `plugins.vim` from `init.vim`.
4. Run the plugin manager's install command.

### Plugin-Specific Configurations

Put per-plugin settings in one of these:

- `after/plugin/[plugin-name].vim` for VimScript
- `lua/[plugin-name].lua` for Lua

### Future Plans

Candidates for expansion:

- A plugin manager: vim-plug, packer or lazy.nvim
- LSP for code completion
- Treesitter for syntax highlighting
- Telescope for fuzzy finding

## References

- [Neovim Documentation](https://neovim.io/doc/)
- [Learn Vimscript the Hard Way](https://learnvimscriptthehardway.stevelosh.com/)
- [Lua Guide for Neovim](https://neovim.io/doc/user/lua-guide.html)
