# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This is a Neovim configuration built on top of NvChad v2.5, which is used as a plugin rather than a standalone installation. The configuration follows NvChad's modular structure where the main NvChad repo provides base functionality and this repo imports and extends it.

### Core Entry Point

- `init.lua` - Bootstraps lazy.nvim plugin manager, loads NvChad as a plugin, configures additional plugins, and requires core modules
- NvChad is loaded as a lazy.nvim plugin from the `NvChad/NvChad` repo (v2.5 branch)

### Module Structure

- `lua/chadrc.lua` - NvChad configuration (theme, UI, statusline). Uses gruvbox theme with transparency enabled
- `lua/options.lua` - Extends NvChad options with custom Vim settings (scrolloff, shiftwidth, tabstop, wrap)
- `lua/mappings.lua` - Extends NvChad mappings with custom keybindings (`;` for command mode, `jk` for ESC)
- `lua/plugins/init.lua` - Custom plugin declarations for lazy.nvim
- `lua/configs/` - Plugin-specific configuration files:
  - `lspconfig.lua` - LSP server setup (superhtml, cssls, clangd, zls, basedpyright, hyprls, biome)
  - `treesitter.lua` - Contains commented custom treesitter highlight colors (VSCode Monokai theme)
  - `lazy.lua` - lazy.nvim configuration with performance optimizations (many default plugins disabled)
  - `rainbows.lua` - Configuration for rainbow-delimiters plugin
  - `conform.lua` - Formatter configuration (currently unused)

### Active Plugins

Core plugins loaded in `init.lua`:
- NvChad (base framework)
- nvim-treesitter (syntax highlighting)
- rainbow-delimiters (bracket pair colorization)

Additional plugins listed in `lua/plugins/init.lua`:
- nvim-lspconfig (LSP integration)
- conform.nvim (formatter, commented out)

## Testing and Development

This is a Neovim configuration, not a software project. Changes are tested by:
1. Editing the relevant `.lua` configuration files
2. Reloading Neovim or sourcing the changed file with `:source %`
3. Verifying the behavior in Neovim

To check for Lua syntax errors:
```bash
nvim --headless -c "luafile init.lua" -c "quit"
```

## Important Notes

- Custom filetype detection is configured in `init.lua` for HyprLand config files (`*.conf` in `hypr/` directories → `hyprlang`)
- The base46 theme cache is stored in Neovim's data directory
- LSP servers are enabled using the newer `vim.lsp.config()` and `vim.lsp.enable()` API (not `lspconfig.setup()`)
- Many default Neovim plugins are disabled in `lua/configs/lazy.lua` for performance
