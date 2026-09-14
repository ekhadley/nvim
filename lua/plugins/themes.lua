-- Theme plugins
return {
	-- Gruvbox theme
	{
		"ellisonleao/gruvbox.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("gruvbox").setup({
				terminal_colors = false,
				undercurl = true,
				underline = true,
				bold = true,
				italic = {
					strings = false,
					emphasis = true,
					comments = true,
					operators = false,
					folds = true,
				},
				strikethrough = true,
				invert_selection = false,
				invert_signs = false,
				invert_tabline = false,
				invert_intend_guides = false,
				inverse = true,
				contrast = "",
				palette_overrides = {},
				overrides = {
					LspReferenceText  = { bg = "#504945", fg = "NONE", bold = false, reverse = false },
					LspReferenceRead  = { bg = "#504945", fg = "NONE", bold = false, reverse = false },
					LspReferenceWrite = { bg = "#504945", fg = "NONE", bold = false, reverse = false },
					Search    = { bg = "#7c6f64", fg = "#fabd2f", bold = true, reverse = false },
					IncSearch = { bg = "#b57614", fg = "#282828", bold = true, reverse = false },
					CurSearch = { bg = "#b57614", fg = "#282828", bold = true, reverse = false },
					["@constant.builtin.python"] = { link = "GruvboxPurple" },
				},
				dim_inactive = false,
				transparent_mode = false,
			})
			-- remember the last theme across restarts, and reapply custom highlights on top of gruvbox
			local theme_file = vim.fn.stdpath("data") .. "/theme"
			vim.api.nvim_create_autocmd("ColorScheme", {
				callback = function()
					vim.fn.writefile({ vim.g.colors_name }, theme_file)
					if vim.g.colors_name:match("gruvbox") then
						package.loaded["highlights"] = nil
						require("highlights")
					end
				end,
			})
			local ok, saved = pcall(vim.fn.readfile, theme_file)
			vim.cmd.colorscheme(ok and saved[1] or "gruvbox")
		end,
	},

	-- Tokyo Night theme
	{
		"folke/tokyonight.nvim",
		lazy = true,
		opts = {
			style = "night",
			transparent = false,
			terminal_colors = false,
		},
	},

	-- Catppuccin theme
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = true,
		opts = {
			flavour = "mocha",
			transparent_background = false,
			term_colors = true,
		},
	},
}
