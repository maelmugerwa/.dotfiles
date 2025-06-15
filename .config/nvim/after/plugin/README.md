# Plugin Configurations

This directory contains plugin-specific configuration files that are loaded automatically after plugins have been loaded. This follows Neovim's conventional `after/plugin` structure.

## How It Works

Files in this directory are loaded automatically after Neovim has loaded the plugins. This ensures that plugin-specific settings are applied after the plugins themselves are initialized.

## Best Practices

- Create one file per plugin or per related group of plugins
- Name files after the plugins they configure (`telescope.vim`, `lsp.vim`, etc.)
- Keep plugin-specific mappings and settings in these files

## Example

Here's a simple example of what a plugin configuration file might look like:

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

This directory is currently empty but ready for future expansion as you add plugins to your Neovim configuration.
