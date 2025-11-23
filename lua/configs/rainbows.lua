local rainbow_delimiters = require "rainbow-delimiters"

vim.g.rainbow_delimiters = {
	strategy = {
		[""] = rainbow_delimiters.strategy["global"],
		vim = rainbow_delimiters.strategy["local"],
	},
	query = {
		[""] = "rainbow-delimiters",
		lua = "rainbow-blocks",
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
