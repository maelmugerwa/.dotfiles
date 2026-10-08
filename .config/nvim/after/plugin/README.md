# Plugin Configurations

Put per-plugin configuration here. This directory is empty today.

Neovim loads every file in `after/plugin` once the plugins themselves have
loaded. Your settings therefore override plugin defaults.

## Best Practices

- Write one file per plugin, or per related group.
- Name each file after the plugin it configures, such as `telescope.vim`.
- Keep a plugin's mappings and settings together in its own file.

## Example

```vim
" after/plugin/telescope.vim - Telescope configuration

" Telescope key mappings
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" Telescope settings
lua << EOF
require('telescope').setup {
  defaults = {
    file_ignore_patterns = { "node_modules", ".git/" },
    mappings = {
      i = {
        ["<C-j>"] = "move_selection_next",
        ["<C-k>"] = "move_selection_previous",
      }
    }
  }
}
EOF
```
