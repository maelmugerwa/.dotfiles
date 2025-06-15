# Lua Configuration

This directory is for Lua-based configuration files. Neovim supports Lua as a first-class configuration language, which is more powerful and flexible than VimScript.

## Usage

Lua configurations can be loaded from your `init.vim` with commands like:

```vim
lua require('plugins')
lua require('keymaps')
lua require('settings')
```

## Best Practices

- Create separate modules for different parts of your configuration
- Use the Lua module system (require/return) for better organization
- Leverage Neovim's Lua API for more powerful configurations

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

This directory is currently empty but ready for future expansion as you migrate to more Lua-based configurations.
