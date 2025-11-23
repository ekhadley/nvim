return {
	-- LSP configuration
	{
		"neovim/nvim-lspconfig",
		config = function()
			require "configs.lspconfig"
		end,
	},

	-- Syntax highlighting
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		config = function()
			require "configs.treesitter"
		end,
	},

	-- Rainbow brackets
	{
		"HiPhish/rainbow-delimiters.nvim",
		lazy = false,
		config = function()
			require "configs.rainbows"
		end,
	},

	-- LSP progress indicator
	{
		"j-hui/fidget.nvim",
		event = "LspAttach",
		opts = {},
	},
}
