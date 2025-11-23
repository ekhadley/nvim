# NvChad to Vanilla Neovim Migration Plan

This document outlines replacing NvChad with a standalone Neovim configuration using community plugins.

## Current NvChad Features to Replace

| NvChad Component | Replacement | Notes |
|------------------|-------------|-------|
| base46 (theming) | `themery.nvim` + theme plugins | base46 is NvChad-specific, won't work standalone |
| tabufline | `bufferline.nvim` | Popular, highly configurable |
| statusline | `lualine.nvim` | Per your preference |
| nvdash | `alpha-nvim` | Minimal dashboard |
| cheatsheet | `which-key.nvim` | Already bundled by NvChad, shows keybindings on demand |
| terminal toggle | `toggleterm.nvim` | Standard terminal manager |
| theme picker | `themery.nvim` | Or `telescope-themes` |
| colorify | `nvim-colorizer.lua` | Hex color preview |
| lsp_signature | `lsp_signature.nvim` | Function signature popup |
| lsp_renamer | Built-in `vim.lsp.buf.rename()` | Native LSP, no plugin needed |

## Plugins to Keep (Already Independent)

These are community plugins NvChad bundles - we just configure them directly:

- `nvim-treesitter` - syntax highlighting
- `nvim-lspconfig` - LSP configs
- `mason.nvim` + `mason-lspconfig.nvim` - LSP installer
- `nvim-cmp` + sources - completion
- `telescope.nvim` - fuzzy finder
- `nvim-tree.lua` - file explorer
- `gitsigns.nvim` - git integration
- `luasnip` - snippets
- `indent-blankline.nvim` - indent guides

## New Plugin List

### Core UI
```lua
{ "nvim-lualine/lualine.nvim" }           -- statusline
{ "akinsho/bufferline.nvim" }             -- bufferline/tabs
{ "goolord/alpha-nvim" }                  -- dashboard
{ "akinsho/toggleterm.nvim" }             -- terminal
{ "folke/which-key.nvim" }                -- keybinding hints/cheatsheet
```

### Theming
```lua
{ "zaldih/themery.nvim" }                 -- theme switcher
{ "ellisonleao/gruvbox.nvim" }            -- gruvbox theme
{ "catppuccin/nvim" }                     -- catppuccin (optional)
{ "folke/tokyonight.nvim" }               -- tokyonight (optional)
-- Add more themes as desired
```

### Editor Enhancement
```lua
{ "nvim-tree/nvim-tree.lua" }             -- file explorer
{ "nvim-telescope/telescope.nvim" }       -- fuzzy finder
{ "lewis6991/gitsigns.nvim" }             -- git signs
{ "lukas-reineke/indent-blankline.nvim" } -- indent guides
{ "NvChad/nvim-colorizer.lua" }           -- color preview (this one is from NvChad but standalone)
```

### LSP & Completion
```lua
{ "neovim/nvim-lspconfig" }               -- LSP
{ "williamboman/mason.nvim" }             -- LSP installer
{ "williamboman/mason-lspconfig.nvim" }   -- mason + lspconfig bridge
{ "hrsh7th/nvim-cmp" }                    -- completion
{ "hrsh7th/cmp-nvim-lsp" }                -- LSP completion source
{ "hrsh7th/cmp-buffer" }                  -- buffer completion
{ "hrsh7th/cmp-path" }                    -- path completion
{ "L3MON4D3/LuaSnip" }                    -- snippets
{ "saadparwaiz1/cmp_luasnip" }            -- snippet completion
{ "ray-x/lsp_signature.nvim" }            -- function signatures
```

### Syntax
```lua
{ "nvim-treesitter/nvim-treesitter" }     -- syntax highlighting
{ "HiPhish/rainbow-delimiters.nvim" }     -- rainbow brackets (you already have this)
```

### Dependencies
```lua
{ "nvim-lua/plenary.nvim" }               -- required by telescope, gitsigns
{ "nvim-tree/nvim-web-devicons" }         -- icons
```

## File Structure (New)

```
~/.config/nvim/
├── init.lua                    # Entry point, bootstrap lazy.nvim
├── lua/
│   ├── core/
│   │   ├── options.lua         # vim.opt settings
│   │   ├── keymaps.lua         # all keybindings
│   │   └── autocmds.lua        # autocommands
│   ├── plugins/
│   │   ├── init.lua            # plugin specs (lazy.nvim)
│   │   ├── lsp.lua             # LSP + mason config
│   │   ├── cmp.lua             # completion config
│   │   ├── treesitter.lua      # treesitter config
│   │   ├── ui.lua              # lualine, bufferline, alpha
│   │   ├── editor.lua          # nvim-tree, telescope, gitsigns
│   │   └── themes.lua          # themery + theme plugins
│   └── highlights.lua          # custom highlight overrides (keep yours)
```

## Keybinding Mapping

Preserve NvChad-style bindings:

| Action | NvChad Binding | Keep? |
|--------|---------------|-------|
| Leader | `<Space>` | Yes |
| Command mode | `;` | Yes |
| Escape | `jk` | Yes |
| File explorer | `<C-n>` or `<C-b>` | Yes (`<C-b>` per your config) |
| Find files | `<leader>ff` | Yes |
| Live grep | `<leader>fw` | Yes |
| Buffers | `<leader>fb` | Yes |
| Terminal | `` <C-`> `` | Yes (per your config) |
| Theme picker | `<leader>th` | Yes |
| Cheatsheet | `<leader>ch` | Map to which-key |
| Next buffer | `<Tab>` | Yes |
| Prev buffer | `<S-Tab>` | Yes |
| Close buffer | `<leader>x` | Yes |

## Migration Steps

1. **Create new branch** for vanilla config
2. **Rewrite init.lua** - remove NvChad, keep lazy.nvim bootstrap
3. **Create core modules** - options.lua, keymaps.lua
4. **Add UI plugins** - lualine, bufferline, alpha, toggleterm
5. **Add theme system** - themery + gruvbox + other themes
6. **Configure LSP** - mason + lspconfig (similar to current)
7. **Configure completion** - nvim-cmp setup
8. **Add editor plugins** - nvim-tree, telescope, gitsigns
9. **Port custom highlights** - keep your gruvbox overrides
10. **Test everything**

## What We're Dropping

- NvChad's `nvchad.configs.*` helper modules (we'll configure directly)
- NvChad's `chadrc.lua` pattern (replaced by direct plugin config)
- base46 caching system (themery handles theme switching differently)
- NvChad-specific autocmds

## Estimated Plugin Count

- **Current (NvChad)**: ~20 plugins loaded via NvChad + your additions
- **New (Vanilla)**: ~22-25 plugins (slightly more explicit, but you control all of them)

## Open Questions

1. **Additional themes?** - Should I include more than gruvbox in themery?
2. **Completion style** - NvChad has custom cmp styling. Want to replicate or use defaults?
3. **Dashboard content** - What do you want on the alpha-nvim dashboard? (recent files, buttons, ascii art?)
4. **Notifications** - Want `nvim-notify` for LSP/plugin notifications? (NvChad doesn't include this by default)

## Risk Assessment

| Risk | Mitigation |
|------|------------|
| Missing keybinding | Keep old config as reference, test thoroughly |
| Theme looks different | Your highlights.lua overrides will help; may need tweaking |
| Slower startup | lazy.nvim handles this; should be comparable |
| Missing feature | We agreed to add back as needed |

---

**Next step**: Once you approve this plan (or request changes), I'll implement it on a new branch.
