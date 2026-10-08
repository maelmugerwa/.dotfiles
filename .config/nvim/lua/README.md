# Lua Configuration

Put Lua configuration modules here. This directory is empty today.

Neovim treats Lua as a first-class configuration language. It gives you a real
module system and a richer API than VimScript.

## Usage

Load a module from `init.vim`:

```vim
lua require('plugins')
lua require('keymaps')
lua require('settings')
```

## Best Practices

- Write one module per area of configuration.
- Use `require` and `return` so modules compose.
- Prefer Neovim's Lua API over VimScript equivalents.

## Example Structure

```lua
-- ~/.config/nvim/lua/plugins.lua
return {
  -- Plugin configurations
}

-- ~/.config/nvim/lua/keymaps.lua
local M = {}

function M.setup()
  -- Set key mappings
end

return M
```
