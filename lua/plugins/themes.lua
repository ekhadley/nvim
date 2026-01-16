-- Theme plugins and themery configuration
return {
	-- Theme switcher
	{
		"zaldih/themery.nvim",
		lazy = false,
		priority = 1000,
		keys = {
			{ "<leader>th", "<cmd>Themery<CR>", desc = "Theme picker" },
		},
		opts = {
			themes = {
				{
					name = "Gruvbox Dark",
					colorscheme = "gruvbox",
					before = [[vim.opt.background = "dark"]],
				},
				{
					name = "Tokyo Night",
					colorscheme = "tokyonight-night",
				},
				{
					name = "Tokyo Night Storm",
					colorscheme = "tokyonight-storm",
				},
				{
					name = "Tokyo Night Moon",
					colorscheme = "tokyonight-moon",
				},
				{
					name = "Catppuccin Mocha",
					colorscheme = "catppuccin-mocha",
				},
				{
					name = "Catppuccin Macchiato",
					colorscheme = "catppuccin-macchiato",
				},
				{
					name = "Catppuccin Frappe",
					colorscheme = "catppuccin-frappe",
				},
			},
			livePreview = true,
		},
		config = function(_, opts)
			require("themery").setup(opts)
			-- Load custom highlights after theme
			vim.api.nvim_create_autocmd("ColorScheme", {
				callback = function()
					-- Only apply custom highlights for gruvbox
					local colorscheme = vim.g.colors_name
					if colorscheme and colorscheme:match("gruvbox") then
						pcall(require, "highlights")
					end
				end,
			})
		end,
	},

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
				overrides = {},
				dim_inactive = false,
				transparent_mode = false,
			})
			-- Set default colorscheme
			vim.cmd.colorscheme("gruvbox")
			-- Apply custom highlights
			pcall(require, "highlights")
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
