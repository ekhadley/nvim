-- Plugins: vim.pack installs and loads them, then each file below configures its group
local function gh(repo) return "https://github.com/" .. repo end

-- Rebuild treesitter parsers when nvim-treesitter updates
vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
        if ev.data.spec.name == "nvim-treesitter" and ev.data.kind == "update" then vim.cmd("TSUpdate") end
    end,
})

vim.pack.add({
    -- Themes
    gh("ellisonleao/gruvbox.nvim"),
    gh("folke/tokyonight.nvim"),
    { src = gh("catppuccin/nvim"), name = "catppuccin" },
    -- UI
    gh("nvim-tree/nvim-web-devicons"),
    gh("nvim-lualine/lualine.nvim"),
    gh("akinsho/bufferline.nvim"),
    gh("folke/which-key.nvim"),
    gh("NvChad/nvim-colorizer.lua"),
    -- Editor
    gh("nvim-tree/nvim-tree.lua"),
    gh("nvim-lua/plenary.nvim"),
    gh("nvim-telescope/telescope.nvim"),
    gh("jvgrootveld/telescope-zoxide"),
    gh("lewis6991/gitsigns.nvim"),
    gh("smoka7/hop.nvim"),
    gh("lervag/vimtex"),
    gh("MeanderingProgrammer/render-markdown.nvim"),
    -- Treesitter
    { src = gh("nvim-treesitter/nvim-treesitter"), version = "main" },
    gh("HiPhish/rainbow-delimiters.nvim"),
    -- LSP & completion
    gh("neovim/nvim-lspconfig"),
    { src = gh("saghen/blink.cmp"), version = vim.version.range("*") },
    { src = gh("L3MON4D3/LuaSnip"), version = vim.version.range("2") },
    gh("rafamadriz/friendly-snippets"),
})

require("plugins.themes")
require("plugins.ui")
require("plugins.editor")
require("plugins.treesitter")
-- Inside VS Code (vscode-neovim), completion and LSP belong to VS Code
if not vim.g.vscode then
    require("plugins.cmp")
    require("plugins.lsp")
end
