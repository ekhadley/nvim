return {
    -- Statusline
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			options = {
				theme = require("lualine_theme"),
				globalstatus = true,
                component_separators = { left = '', right = '' },
                -- component_separators = { left = '', right = ''},
                -- component_separators = { left = '', right = '' },
                -- section_separators = { left = '', right = ''},
                -- component_separators = { left = '', right = ''},
                -- section_separators = { left = '', right = '' },
                section_separators = { left = '', right = '' },
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff" },
				lualine_c = { { "filename", path = 1 } },
                lualine_x = { { "filetype", icon_only=true }, "diagnostics" },
				lualine_y = { "location", "progress" },
				lualine_z = { "lsp_status" },
            }
        },
	},
    
    -- Bufferline (tabs)
	{
		"akinsho/bufferline.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			options = {
				mode = "buffers",
				themable = true,
				numbers = "none",
				close_command = "bdelete! %d",
				-- indicator = { style = "icon", icon = "▎" },
				buffer_close_icon = "󰅖",
				modified_icon = "●",
				close_icon = "",
				left_trunc_marker = "",
				right_trunc_marker = "",
				max_name_length = 18,
				max_prefix_length = 15,
				truncate_names = true,
				tab_size = 18,
				diagnostics = "nvim_lsp",
				diagnostics_update_in_insert = false,
				offsets = {
					{
						filetype = "NvimTree",
						text = "File Explorer",
						highlight = "Directory",
						separator = true,
					},
				},
				show_buffer_icons = true,
				-- show_buffer_close_icons = false,
				show_close_icon = true,
				show_tab_indicators = true,
				separator_style = "slant",
				always_show_bufferline = true,
			},
		}
	},
	{ -- Terminal
		"akinsho/toggleterm.nvim",
		version = "*",
		keys = {
			{ "<C-`>", "<cmd>ToggleTerm direction=horizontal<CR>", desc = "Toggle terminal" },
		},
		opts = {
			size = function(term)
				if term.direction == "horizontal" then
					return 15
				elseif term.direction == "vertical" then
					return vim.o.columns * 0.4
				end
			end,
			open_mapping = [[<C-`>]],
			hide_numbers = true,
			shade_terminals = true,
			shading_factor = 2,
			start_in_insert = true,
			insert_mappings = true,
			terminal_mappings = true,
			persist_size = true,
			persist_mode = true,
			direction = "horizontal",
			close_on_exit = true,
			shell = vim.o.shell,
			float_opts = {
				border = "curved",
				winblend = 0,
			},
		},
	},

	-- Which-key (keybinding hints)
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			preset = "modern",
			delay = 300,
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer local keymaps",
			},
		},
	},

	-- Indent guides
	{
		"lukas-reineke/indent-blankline.nvim",
		event = { "BufReadPost", "BufNewFile" },
		main = "ibl",
		opts = {
			indent = { char = "│" },
			scope = { enabled = true },
			exclude = {
				filetypes = {
					"help",
					"alpha",
					"dashboard",
					"neo-tree",
					"Trouble",
					"lazy",
					"mason",
					"notify",
					"toggleterm",
				},
			},
		},
	},
	
	{ -- Color preview
		"NvChad/nvim-colorizer.lua",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			user_default_options = {
				names = false,
				RGB = true,
				RRGGBB = true,
				RRGGBBAA = true,
				css = true,
				css_fn = true,
				mode = "background",
			},
		},
	},

	-- Icons
	{
		"nvim-tree/nvim-web-devicons",
		lazy = true,
	},
}
