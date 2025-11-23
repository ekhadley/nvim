# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This is a vanilla Neovim configuration using lazy.nvim as the plugin manager. It was migrated from NvChad to use community plugins directly for full control over the configuration.

### Core Entry Point

- `init.lua` - Bootstraps lazy.nvim plugin manager and loads all modules

### Module Structure

```
~/.config/nvim/
├── init.lua                    # Entry point, bootstrap lazy.nvim
├── lua/
│   ├── core/
│   │   ├── options.lua         # vim.opt settings
│   │   ├── keymaps.lua         # all keybindings
│   │   └── autocmds.lua        # autocommands (including HyprLand filetype detection)
│   ├── plugins/
│   │   ├── init.lua            # imports all plugin modules
│   │   ├── lsp.lua             # LSP + mason config
│   │   ├── cmp.lua             # completion (nvim-cmp) config
│   │   ├── treesitter.lua      # treesitter + rainbow-delimiters config
│   │   ├── ui.lua              # lualine, bufferline, alpha, toggleterm, which-key, indent-blankline, colorizer
│   │   ├── editor.lua          # nvim-tree, telescope, gitsigns
│   │   └── themes.lua          # themery + gruvbox, tokyonight, catppuccin
│   └── highlights.lua          # custom Gruvbox-based syntax highlighting overrides
```

### Active Plugins

**Core UI:**
- lualine.nvim (statusline)
- bufferline.nvim (buffer tabs)
- alpha-nvim (dashboard)
- toggleterm.nvim (terminal)
- which-key.nvim (keybinding hints)
- indent-blankline.nvim (indent guides)
- nvim-colorizer.lua (color preview)

**Theming:**
- themery.nvim (theme switcher)
- gruvbox.nvim (default theme)
- tokyonight.nvim
- catppuccin

**Editor:**
- nvim-tree.lua (file explorer)
- telescope.nvim (fuzzy finder)
- gitsigns.nvim (git integration)

**LSP & Completion:**
- nvim-lspconfig (LSP)
- mason.nvim + mason-lspconfig.nvim (LSP installer)
- nvim-cmp + sources (completion)
- LuaSnip + friendly-snippets (snippets)
- lsp_signature.nvim (function signatures)
- fidget.nvim (LSP progress)

**Syntax:**
- nvim-treesitter (syntax highlighting)
- rainbow-delimiters.nvim (bracket colorization)

### LSP Servers Configured

- superhtml, cssls, clangd, zls, basedpyright, hyprls, biome, rust_analyzer
- yuckls (manual start per buffer)

## Testing and Development

This is a Neovim configuration, not a software project. Changes are tested by:
1. Editing the relevant `.lua` configuration files
2. Reloading Neovim or sourcing the changed file with `:source %`
3. Verifying the behavior in Neovim

To check for Lua syntax errors:
```bash
nvim --headless -c "luafile init.lua" -c "quit"
```

## Key Bindings

| Action | Binding |
|--------|---------|
| Leader | `<Space>` |
| Command mode | `;` |
| Escape | `jk` |
| File explorer | `<C-b>` |
| Find files | `<leader>ff` or `<C-e>` |
| Live grep | `<leader>fw` |
| Buffers | `<leader>fb` |
| Terminal | `<C-\`>` |
| Theme picker | `<leader>th` |
| Next buffer | `<Tab>` |
| Prev buffer | `<S-Tab>` |
| Close buffer | `<leader>x` |

## Important Notes

- Custom filetype detection for HyprLand config files is in `lua/core/autocmds.lua`
- Custom Gruvbox syntax highlights are applied via `lua/highlights.lua` (loaded on ColorScheme event)
- Many default Neovim plugins are disabled in `init.lua` for performance
- LSP keymaps are set on `LspAttach` event in `lua/plugins/lsp.lua`
