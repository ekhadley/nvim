require("nvim-treesitter.configs").setup {
    ensure_installed = { "lua", "vim", "bash", "cpp", "python", "markdown", "yuck" },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
}

-- copied from vscode monokai highlighting theme
--[[
local keyword_color = "#FB4934"
local function_color = "#69C22E"
local variable_color = "#DDDDD8"
local string_color = "#E6DB74"
local comment_color = "#75715E"
local number_color = "#A280E2"
local type_color = "#4AACDB"
local builtin_color = "#1B81A8"

vim.api.nvim_set_hl(0, "@function", { fg = function_color})
vim.api.nvim_set_hl(0, "@constructor.python", { fg = function_color})
vim.api.nvim_set_hl(0, "@function.call", { fg = function_color})
vim.api.nvim_set_hl(0, "@function.method", { fg = function_color})
vim.api.nvim_set_hl(0, "@function.method.call", { fg = function_color})
vim.api.nvim_set_hl(0, "@module", { fg = function_color})

vim.api.nvim_set_hl(0, "@type", { fg = type_color})
vim.api.nvim_set_hl(0, "@type.builtin", { fg = type_color})

vim.api.nvim_set_hl(0, "@keyword", { fg = keyword_color })
vim.api.nvim_set_hl(0, "@keyword.repeat", { fg = keyword_color })
vim.api.nvim_set_hl(0, "@operator", { fg = keyword_color })
vim.api.nvim_set_hl(0, "@punctuation.bracket", { fg = keyword_color })
vim.api.nvim_set_hl(0, "@keyword.exception.zig", { fg = keyword_color })

vim.api.nvim_set_hl(0, "@string", { fg = string_color })
vim.api.nvim_set_hl(0, "@character", { fg = string_color })

vim.api.nvim_set_hl(0, "@variable", { fg = variable_color })
vim.api.nvim_set_hl(0, "@variable.field", { fg = variable_color })
vim.api.nvim_set_hl(0, "@parameter", { fg = variable_color})
vim.api.nvim_set_hl(0, "@variable.member", { fg = variable_color })

vim.api.nvim_set_hl(0, "@keyword.function", { fg = builtin_color })
vim.api.nvim_set_hl(0, "@function.builtin", { fg = builtin_color })

vim.api.nvim_set_hl(0, "@comment", { fg = comment_color, italic = true })

vim.api.nvim_set_hl(0, "@number", { fg = number_color})
vim.api.nvim_set_hl(0, "@string.escape", { fg = number_color})
vim.api.nvim_set_hl(0, "@constant", { fg = number_color })
]]--
