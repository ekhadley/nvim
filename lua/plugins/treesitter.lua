-- Treesitter configuration
return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		cmd = { "TSInstall", "TSUpdate", "TSUpdateSync" },
		opts = {
			ensure_installed = {
				"lua",
				"vim",
				"vimdoc",
				"bash",
				"cpp",
				"c",
				"python",
				"markdown",
				"markdown_inline",
				"yuck",
				"zig",
				"hyprlang",
				"json",
				"yaml",
				"toml",
				"rust",
				"html",
				"css",
				"javascript",
				"typescript",
			},
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
			indent = {
				enable = true,
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},

	-- Rainbow brackets
	{
		"HiPhish/rainbow-delimiters.nvim",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			local rainbow_delimiters = require("rainbow-delimiters")

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

			-- Custom colors for rainbow brackets
			vim.api.nvim_set_hl(0, "col1", { fg = "#CE6C9C" })
			vim.api.nvim_set_hl(0, "col2", { fg = "#2374E2" })
			vim.api.nvim_set_hl(0, "col3", { fg = "#F1CC0D" })
		end,
	},
}
