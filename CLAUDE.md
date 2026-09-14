# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

Vanilla Neovim configuration using lazy.nvim as the plugin manager. Targets nvim 0.12+ (uses `vim.lsp.config`/`vim.lsp.enable` and the nvim-treesitter `main` branch).

### Module Structure

```
~/.config/nvim/
├── init.lua                    # Entry point, bootstraps lazy.nvim, loads core + notes + search_hud
├── lua/
│   ├── core/
│   │   ├── options.lua         # vim.opt settings
│   │   ├── keymaps.lua         # all keybindings (LSP keymaps + document-highlight autocmds on LspAttach)
│   │   └── autocmds.lua        # autocommands (indent guides, hyprlang filetype, Neovide zoxide launch)
│   ├── plugins/
│   │   ├── init.lua            # imports all plugin modules
│   │   ├── lsp.lua             # nvim-lspconfig: servers, diagnostics
│   │   ├── cmp.lua             # blink.cmp + LuaSnip
│   │   ├── treesitter.lua      # treesitter (main branch) + incremental selection + rainbow-delimiters
│   │   ├── ui.lua              # lualine, bufferline, which-key, colorizer
│   │   ├── editor.lua          # nvim-tree, telescope(+zoxide), gitsigns, hop, vimtex, render-markdown
│   │   └── themes.lua          # gruvbox (with overrides + theme persistence), tokyonight, catppuccin
│   ├── highlights.lua          # custom Gruvbox-based syntax highlighting overrides
│   ├── lualine_theme.lua       # custom Gruvbox-based lualine statusline theme
│   ├── notes.lua               # :NoteSidecar — right-hand todo column over ~/Notes/{todo,global_todo}.md
│   └── search_hud.lua          # floating top-right HUD: live pattern, match count, regex errors for / ? :s
├── colors/
│   ├── walrs.lua               # dynamic colorscheme loading ~/.cache/wal/colors-nvim.lua
│   ├── gruvbox_dark.lua        # gruvbox dark color definitions
│   ├── highlights.lua          # alternate highlights file
│   └── lualine_theme.lua       # alternate lualine theme file
```

### Active Plugins

**UI:** lualine.nvim (custom theme from lualine_theme.lua), bufferline.nvim, which-key.nvim, nvim-colorizer.lua, nvim-web-devicons

**Theming:** gruvbox.nvim (default), tokyonight.nvim, catppuccin, plus the local `walrs` colorscheme. Theme picker is telescope's colorscheme picker; the chosen theme is written to `stdpath("data")/theme` and restored on startup.

**Editor:** nvim-tree.lua, telescope.nvim + telescope-zoxide, gitsigns.nvim, hop.nvim, vimtex, render-markdown.nvim

**LSP & Completion:** nvim-lspconfig, blink.cmp, LuaSnip + friendly-snippets

**Syntax:** nvim-treesitter (main branch), rainbow-delimiters.nvim

Indent guides are native: `listchars` `leadmultispace`, rebuilt per buffer from `shiftwidth` in autocmds.lua. No terminal plugin.

### LSP Servers

There is no mason. Servers are installed system-wide (pacman, cargo, npm) and must be on PATH.

- Default config: superhtml, cssls, clangd, zls, hyprls, biome, rust_analyzer
- basedpyright (typeCheckingMode = basic)
- lua_ls (on_init avoids indexing $HOME for loose lua files)
- yuckls (manual `vim.lsp.start` per `*.yuck` buffer)

## Testing and Development

Changes are tested by editing the `.lua` files and restarting Neovim. To check for startup errors:
```bash
nvim --headless -c qa
```

## Key Bindings

### General
| Action | Binding |
|--------|---------|
| Leader | `<Space>` |
| Command mode | `;` |
| Clear search highlight + HUD | `<Esc>` |
| Save file | `<C-s>` |
| New buffer | `<leader>b` |
| Next buffer | `<Tab>` or `<PageDown>` |
| Prev buffer | `<S-Tab>` or `<PageUp>` |
| Move buffer right/left | `<S-PageDown>` / `<S-PageUp>` |
| Close buffer | `<leader>x` |
| Toggle comment | `<leader>/` or `<C-/>` (n, v, i) |
| Copy to system clipboard | `<leader>c` or `<C-c>` (visual) |
| Paste from system clipboard | `<C-v>` or `<C-S-v>` |
| Select inside word | `W` |
| Toggle line wrap | `<A-S-z>` |
| Toggle markdown `[ ]`/`[x]` | `<leader>[` (n, x) |
| Add/remove bullet checkbox | `<leader>]` (n, x) |
| `:Q` / `:W` / `:WQ` | abbreviations for `qa` / `wa` / `wqa` |
| Todo sidecar | `:NoteSidecar` (`<Tab>` cycles files inside it) |

### Navigation
| Action | Binding |
|--------|---------|
| `j` / `k` / arrows | move by display line |
| Hop word on current line | `s` |
| Hop to word | `S` |
| Window down/up/left/right | `<C-Down>` / `<C-Up>` / `<C-Left>` / `<C-Right>` |
| Down/up 8 lines | `<S-Down>` / `<S-Up>` |
| Word backward/forward | `<C-h>` / `<C-l>` (n, v, i) |
| Select word backward/forward (insert) | `<C-S-h>` / `<C-S-l>` |
| Move down/up (insert) | `<C-j>` / `<C-k>` |
| Jump backward/forward | `<C-i>` / `<C-o>` (swapped) |
| Scroll down/up centered | `<C-d>` / `<C-u>` |
| Next/prev search centered | `n` / `N` |

### Visual Mode
| Action | Binding |
|--------|---------|
| Move line up/down | `K` / `J` |
| Indent left/right (stay visual) | `<` / `>` |

### Treesitter Selection (all filetypes except markdown)
| Action | Binding |
|--------|---------|
| Init selection (normal) | `<C-space>` |
| Grow selection (visual) | `<C-space>` |
| Shrink selection (visual) | `<BS>` |

### File Explorer & Search
| Action | Binding |
|--------|---------|
| Toggle file explorer | `<C-b>` |
| Open and stay (nvim-tree) | `<Tab>` |
| Find files | `<leader>ff` or `<C-e>` |
| Live grep | `<leader>fw` |
| Buffers | `<leader>fb` |
| Recent files | `<leader>fo` |
| Recent directories (zoxide, cd on select) | `<leader>fd` |
| Help tags | `<leader>fh` |
| Resume search | `<leader>fr` |
| Git commits / status | `<leader>gc` / `<leader>gs` |
| Theme picker | `<leader>th` |
| Which-key (buffer) | `<leader>?` |

### Completion (insert mode, blink.cmp)
| Action | Binding |
|--------|---------|
| Show / toggle docs | `<C-Space>` |
| Confirm selection | `<CR>` |
| Next item / snippet forward | `<Tab>` |
| Prev item / snippet back | `<S-Tab>` |
| Scroll docs up/down | `<C-b>` / `<C-f>` |
| Hide | `<C-e>` |

Menu and ghost text are disabled for markdown and tex; tex uses only lsp + path sources.

### LSP (after LspAttach)
| Action | Binding |
|--------|---------|
| Go to definition / declaration | `gd` / `gD` |
| Hover docs | `K` |
| Go to implementation | `gi` |
| Signature help | `<C-k>` |
| Type definition | `<leader>D` |
| Rename | `<leader>rn` |
| Code action | `<leader>ca` |
| References | `gr` |
| Format | `<leader>fm` |
| Prev/next diagnostic | `[d` / `]d` |
| Diagnostic float / list | `<leader>e` / `<leader>q` |
| Add/remove/list workspace folder | `<leader>wa` / `<leader>wr` / `<leader>wl` |

### Gitsigns
| Action | Binding |
|--------|---------|
| Next/prev hunk | `]c` / `[c` |
| Stage / reset hunk | `<leader>hs` / `<leader>hr` |
| Stage / reset buffer | `<leader>hS` / `<leader>hR` |
| Undo stage hunk | `<leader>hu` |
| Preview hunk | `<leader>hp` |
| Blame line | `<leader>hb` |
| Diff this / against ~ | `<leader>hd` / `<leader>hD` |
| Select hunk (text obj) | `ih` |

## Important Notes

- Custom filetype detection for Hyprland config files is in `lua/core/autocmds.lua`
- Custom Gruvbox syntax highlights in `lua/highlights.lua` are re-required on every ColorScheme event when the scheme name matches gruvbox
- Search/IncSearch/CurSearch and LspReference* highlights live in gruvbox.nvim's `overrides` field in `lua/plugins/themes.lua` (not `highlights.lua`) — gruvbox re-applies these groups internally, so the `overrides` table is the only place that wins. Always include `reverse = false` when overriding, since gruvbox's `inverse = true` defaults to reverse on those groups.
- Many default Neovim plugins are disabled in `init.lua` for performance
- Rainbow delimiters use custom highlight groups (`col1`, `col2`, `col3`) defined in treesitter.lua
- treesitter.lua re-registers the `set-lang-from-info-string!` directive with a pcall guard to work around TSNode invalidation crashes on nightly
- Neovide launched with no file args opens the zoxide picker
- 4-space indentation is the target, but files are a mix of tabs and spaces

## TODO

- Make a 256-color hardcoded gruvbox dark theme designed to work with ghostty's automatic 256 colorscheme generation
