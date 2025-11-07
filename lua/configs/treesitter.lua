require("nvim-treesitter.configs").setup {
    ensure_installed = { "lua", "vim", "bash", "cpp", "python", "markdown", "yuck", "zig" },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
}

-- Gruvbox color scheme
local gruvbox = {
  red = "#fb4934",
  green = "#b8bb26",
  yellow = "#fabd2f",
  blue = "#83a598",
  purple = "#d3869b",
  aqua = "#8ec07c",
  orange = "#fe8019",
  gray = "#928374",
  fg = "#ebdbb2",
}

-- Keywords and control flow
vim.api.nvim_set_hl(0, "@keyword", { fg = gruvbox.red })
vim.api.nvim_set_hl(0, "@keyword.repeat", { fg = gruvbox.red })
vim.api.nvim_set_hl(0, "@keyword.return", { fg = gruvbox.red })
vim.api.nvim_set_hl(0, "@keyword.function", { fg = gruvbox.red })
vim.api.nvim_set_hl(0, "@keyword.conditional", { fg = gruvbox.red })
vim.api.nvim_set_hl(0, "@keyword.exception", { fg = gruvbox.red })
vim.api.nvim_set_hl(0, "@keyword.import", { fg = gruvbox.red })

-- Functions
vim.api.nvim_set_hl(0, "@function", { fg = gruvbox.aqua })
vim.api.nvim_set_hl(0, "@function.call", { fg = gruvbox.aqua })
vim.api.nvim_set_hl(0, "@function.method", { fg = gruvbox.aqua })
vim.api.nvim_set_hl(0, "@function.method.call", { fg = gruvbox.aqua })
vim.api.nvim_set_hl(0, "@function.builtin", { fg = gruvbox.yellow })
vim.api.nvim_set_hl(0, "@constructor", { fg = gruvbox.yellow })

-- Types
vim.api.nvim_set_hl(0, "@type", { fg = gruvbox.yellow })
vim.api.nvim_set_hl(0, "@type.builtin", { fg = gruvbox.yellow })

-- Strings
vim.api.nvim_set_hl(0, "@string", { fg = gruvbox.green })
vim.api.nvim_set_hl(0, "@character", { fg = gruvbox.green })
vim.api.nvim_set_hl(0, "@string.escape", { fg = gruvbox.orange })

-- Variables
vim.api.nvim_set_hl(0, "@variable", { fg = gruvbox.fg })
vim.api.nvim_set_hl(0, "@variable.builtin", { fg = gruvbox.purple })
vim.api.nvim_set_hl(0, "@variable.parameter", { fg = gruvbox.blue })
vim.api.nvim_set_hl(0, "@variable.member", { fg = gruvbox.blue })

-- Constants and numbers
vim.api.nvim_set_hl(0, "@constant", { fg = gruvbox.purple })
vim.api.nvim_set_hl(0, "@constant.builtin", { fg = gruvbox.purple })
vim.api.nvim_set_hl(0, "@number", { fg = gruvbox.purple })
vim.api.nvim_set_hl(0, "@boolean", { fg = gruvbox.purple })

-- Operators and punctuation
vim.api.nvim_set_hl(0, "@operator", { fg = gruvbox.orange })
vim.api.nvim_set_hl(0, "@punctuation.bracket", { fg = gruvbox.fg })
vim.api.nvim_set_hl(0, "@punctuation.delimiter", { fg = gruvbox.fg })

-- Comments
vim.api.nvim_set_hl(0, "@comment", { fg = gruvbox.gray, italic = true })

-- Modules/imports
vim.api.nvim_set_hl(0, "@module", { fg = gruvbox.yellow })

-- Zig LSP Semantic Highlighting (ZLS)
vim.api.nvim_set_hl(0, "zigStructure", { fg = gruvbox.yellow })
vim.api.nvim_set_hl(0, "zigKeyword", { fg = gruvbox.red })
vim.api.nvim_set_hl(0, "zigType", { fg = gruvbox.yellow })
vim.api.nvim_set_hl(0, "zigFunction", { fg = gruvbox.aqua })
vim.api.nvim_set_hl(0, "zigOperator", { fg = gruvbox.orange })
vim.api.nvim_set_hl(0, "zigVariable", { fg = gruvbox.fg })
vim.api.nvim_set_hl(0, "zigNumber", { fg = gruvbox.purple })
vim.api.nvim_set_hl(0, "zigString", { fg = gruvbox.green })
vim.api.nvim_set_hl(0, "zigBuiltin", { fg = gruvbox.orange })
vim.api.nvim_set_hl(0, "zigComment", { fg = gruvbox.gray, italic = true })
vim.api.nvim_set_hl(0, "zigConstant", { fg = gruvbox.purple })
vim.api.nvim_set_hl(0, "zigNamespace", { fg = gruvbox.yellow })
vim.api.nvim_set_hl(0, "zigEnumMember", { fg = gruvbox.purple })
