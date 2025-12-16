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
│   │   ├── keymaps.lua         # all keybindings (including LSP keymaps on LspAttach)
│   │   └── autocmds.lua        # autocommands (including HyprLand filetype detection)
│   ├── plugins/
│   │   ├── init.lua            # imports all plugin modules
│   │   ├── lsp.lua             # LSP + mason config (servers, diagnostics)
│   │   ├── cmp.lua             # completion (nvim-cmp) config
│   │   ├── treesitter.lua      # treesitter + rainbow-delimiters config
│   │   ├── ui.lua              # lualine, bufferline, toggleterm, which-key, indent-blankline, colorizer
│   │   ├── editor.lua          # nvim-tree, telescope, gitsigns, hop, render-markdown
│   │   └── themes.lua          # themery + gruvbox, tokyonight, catppuccin
│   ├── highlights.lua          # custom Gruvbox-based syntax highlighting overrides
│   └── lualine_theme.lua       # custom Gruvbox-based lualine statusline theme
├── colors/                     # color-related files (some duplicates of lua/ files)
│   ├── gruvbox_dark.lua        # gruvbox dark color definitions
│   ├── highlights.lua          # alternate highlights file
│   └── lualine_theme.lua       # alternate lualine theme file
```

### Active Plugins

**Core UI:**
- lualine.nvim (statusline, uses custom theme from lualine_theme.lua)
- bufferline.nvim (buffer tabs)
- toggleterm.nvim (terminal)
- which-key.nvim (keybinding hints)
- indent-blankline.nvim (indent guides)
- nvim-colorizer.lua (color preview)
- nvim-web-devicons (icons)

**Theming:**
- themery.nvim (theme switcher)
- gruvbox.nvim (default theme)
- tokyonight.nvim
- catppuccin

**Editor:**
- nvim-tree.lua (file explorer)
- telescope.nvim (fuzzy finder)
- gitsigns.nvim (git integration)
- hop.nvim (easy motion)
- render-markdown.nvim (markdown rendering with LaTeX support)

**LSP & Completion:**
- nvim-lspconfig (LSP)
- mason.nvim + mason-lspconfig.nvim (LSP installer)
- nvim-cmp + sources (completion)
- LuaSnip + friendly-snippets (snippets)

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

### General
| Action | Binding |
|--------|---------|
| Leader | `<Space>` |
| Command mode | `;` |
| Save file | `<C-s>` |
| New buffer | `<leader>b` |
| Next buffer | `<Tab>` |
| Prev buffer | `<S-Tab>` |
| Close buffer | `<leader>x` |
| Toggle comment | `<leader>/` |

### Navigation
| Action | Binding |
|--------|---------|
| Hop to word | `s` |
| Hop to char | `S` |
| Window left/down/up/right | `<C-Arrow>` |
| Jump backward | `<C-i>` (swapped) |
| Jump forward | `<C-o>` (swapped) |
| Scroll down centered | `<C-d>` |
| Scroll up centered | `<C-u>` |
| Next search centered | `n` |
| Prev search centered | `N` |

### Visual Mode
| Action | Binding |
|--------|---------|
| Move line up | `K` |
| Move line down | `J` |
| Indent left (stay visual) | `<` |
| Indent right (stay visual) | `>` |

### Treesitter Selection
| Action | Binding |
|--------|---------|
| Init/increment selection | `<C-space>` |
| Decrement selection | `<bs>` |

### File Explorer & Search
| Action | Binding |
|--------|---------|
| Toggle file explorer | `<C-b>` |
| Find files | `<leader>ff` or `<C-e>` |
| Live grep | `<leader>fw` |
| Buffers | `<leader>fb` |
| Recent files | `<leader>fo` |
| Help tags | `<leader>fh` |
| Resume search | `<leader>fr` |
| Git commits | `<leader>gc` |
| Git status | `<leader>gs` |

### Terminal & UI
| Action | Binding |
|--------|---------|
| Terminal | `` <C-`> `` |
| Theme picker | `<leader>th` |
| Which-key (buffer) | `<leader>?` |

### Completion (insert mode)
| Action | Binding |
|--------|---------|
| Trigger completion | `<C-Space>` |
| Confirm selection | `<CR>` |
| Next item / expand snippet | `<Tab>` |
| Prev item / jump snippet back | `<S-Tab>` |
| Scroll docs down | `<C-f>` |
| Scroll docs up | `<C-b>` |
| Abort completion | `<C-e>` |

### LSP (available after LspAttach)
| Action | Binding |
|--------|---------|
| Go to definition | `gd` |
| Go to declaration | `gD` |
| Hover docs | `K` |
| Go to implementation | `gi` |
| Signature help | `<C-k>` |
| Type definition | `<leader>D` |
| Rename | `<leader>rn` |
| Code action | `<leader>ca` |
| References | `gr` |
| Format | `<leader>fm` |
| Prev/next diagnostic | `[d` / `]d` |
| Diagnostic float | `<leader>e` |
| Diagnostic list | `<leader>q` |
| Add workspace folder | `<leader>wa` |
| Remove workspace folder | `<leader>wr` |
| List workspace folders | `<leader>wl` |

### Gitsigns
| Action | Binding |
|--------|---------|
| Next/prev hunk | `]c` / `[c` |
| Stage hunk | `<leader>hs` |
| Reset hunk | `<leader>hr` |
| Stage buffer | `<leader>hS` |
| Undo stage hunk | `<leader>hu` |
| Reset buffer | `<leader>hR` |
| Preview hunk | `<leader>hp` |
| Blame line | `<leader>hb` |
| Diff this | `<leader>hd` |
| Diff this ~ | `<leader>hD` |
| Select hunk (text obj) | `ih` |

## Important Notes

- Custom filetype detection for HyprLand config files is in `lua/core/autocmds.lua`
- Custom Gruvbox syntax highlights are applied via `lua/highlights.lua` (loaded on ColorScheme event, only for gruvbox)
- Custom lualine theme defined in `lua/lualine_theme.lua` (Gruvbox-based colors)
- Many default Neovim plugins are disabled in `init.lua` for performance
- LSP keymaps are set on `LspAttach` event in `lua/core/keymaps.lua`
- Uses nvim 0.11+ `vim.lsp.config` API for LSP server configuration
- Rainbow delimiters use custom highlight groups (`col1`, `col2`, `col3`) defined in treesitter.lua
