local rainbow_delimiters = require "rainbow-delimiters"

vim.g.rainbow_delimiters = {
    strategy = {
        [""] = rainbow_delimiters.strategy["global"], -- Apply globally
        vim = rainbow_delimiters.strategy["local"],   -- Different strategy for Vimscript
    },
    query = {
        [""] = "rainbow-delimiters",
        lua = "rainbow-blocks", -- Custom behavior for Lua
    },
    highlight = {
        "col1",
        "col2",
        "col3",
    },
}

vim.api.nvim_set_hl(0, "col1", { fg = "#CE6C9C" })
vim.api.nvim_set_hl(0, "col2", { fg = "#2374E2" })
vim.api.nvim_set_hl(0, "col3", { fg = "#F1CC0D" })

-- vim.api.nvim_set_hl(0, "RainbowDelimiterRed", { fg = "#F92672" }) -- Pink
-- vim.api.nvim_set_hl(0, "RainbowDelimiterYellow", { fg = "#E6DB74" }) -- Yellow
-- vim.api.nvim_set_hl(0, "RainbowDelimiterBlue", { fg = "#66D9EF" }) -- Blue
-- vim.api.nvim_set_hl(0, "RainbowDelimiterOrange", { fg = "#FD971F" }) -- Orange
-- vim.api.nvim_set_hl(0, "RainbowDelimiterGreen", { fg = "#A6E22E" }) -- Green
-- vim.api.nvim_set_hl(0, "RainbowDelimiterViolet", { fg = "#AE81FF" }) -- Purple
-- vim.api.nvim_set_hl(0, "RainbowDelimiterCyan", { fg = "#A1EFE4" }) -- Cyan
