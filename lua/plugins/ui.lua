local function cwd_prefix()
    local dir, full = vim.fn.getcwd(), vim.fn.expand("%:p")
    if full:sub(1, #dir + 1) ~= dir .. "/" then return "" end
    return vim.fn.fnamemodify(dir, ":~") .. "/"
end

local function rel_dir()
    local head = vim.fn.expand("%:.:h")
    if head == "." or head == "" then return "" end
    return head .. "/"
end

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
				lualine_c = {
					{ cwd_prefix, padding = { left = 1, right = 0 }, color = { fg = "#7c6f64", gui = "underline,bold" } },
					{ rel_dir, padding = 0, color = { gui = "bold" } },
					{ "filename", path = 0, padding = { left = 0, right = 1 }, color = { fg = "#ebdbb2", gui = "bold" } },
				},
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
