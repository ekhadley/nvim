-- Editor plugins: nvim-tree, telescope, gitsigns
return {
	-- File explorer
	{
		"nvim-tree/nvim-tree.lua",
		cmd = { "NvimTreeToggle" },
		keys = {
			{ "<C-b>", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file explorer" },
		},
		opts = {
			on_attach = function(bufnr)
				local api = require("nvim-tree.api")
				api.config.mappings.default_on_attach(bufnr)
				vim.keymap.set("n", "<Tab>", function()
					api.node.open.edit()
					api.tree.focus()
				end, { buffer = bufnr, desc = "Open and stay" })
			end,
			filters = {
				dotfiles = false,
			},
			disable_netrw = true,
			hijack_netrw = true,
			hijack_cursor = true,
			hijack_unnamed_buffer_when_opening = false,
			sync_root_with_cwd = true,
			update_focused_file = {
				enable = true,
				update_root = false,
			},
			view = {
				adaptive_size = false,
				side = "left",
				width = 30,
			},
			git = {
				enable = true,
				ignore = false,
			},
			filesystem_watchers = {
				enable = true,
			},
			actions = {
				open_file = {
					resize_window = true,
				},
			},
			renderer = {
				root_folder_label = false,
				highlight_git = true,
                special_files = {},
				highlight_opened_files = "none",
				indent_markers = {
					enable = true,
				},
				icons = {
					show = {
						file = true,
						folder = true,
						folder_arrow = true,
						git = true,
					},
					glyphs = {
						default = "󰈚",
						symlink = "",
						folder = {
							default = "",
							empty = "",
							empty_open = "",
							open = "",
							symlink = "",
							symlink_open = "",
							arrow_open = "",
							arrow_closed = "",
						},
						git = {
							unstaged = "",
							staged = "✓",
							unmerged = "",
							renamed = "➜",
							untracked = "",
							deleted = "",
							ignored = "",
							-- unstaged = "✗",
							-- staged = "✓",
							-- unmerged = "",
							-- renamed = "➜",
							-- untracked = "★",
							-- deleted = "",
							-- ignored = "◌",
						},
					},
				},
			},
		},
	},

	-- Fuzzy finder
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		keys = {
			{ "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
			{ "<leader>fw", "<cmd>Telescope live_grep<CR>", desc = "Live grep" },
			{ "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Buffers" },
			{ "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help tags" },
			{ "<leader>fo", "<cmd>Telescope oldfiles<CR>", desc = "Recent files" },
			{ "<leader>fr", "<cmd>Telescope resume<CR>", desc = "Resume last search" },
			{ "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "Git commits" },
			{ "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "Git status" },
			{ "<C-e>", "<cmd>Telescope find_files<CR>", desc = "Find files" },
		},
		opts = {
			defaults = {
				prompt_prefix = "   ",
				selection_caret = " ",
				entry_prefix = " ",
				sorting_strategy = "ascending",
				layout_config = {
					horizontal = {
						prompt_position = "top",
						preview_width = 0.55,
					},
					width = 0.87,
					height = 0.80,
				},
				mappings = {
					n = { ["q"] = require("telescope.actions").close },
				},
			},
			pickers = {
				find_files = {
					hidden = true,
					find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
				},
			},
		},
	},

	-- Git signs
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			signs = {
				add = { text = "│" },
				change = { text = "│" },
				delete = { text = "󰍵" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
				untracked = { text = "│" },
			},
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns

				local map = function(mode, l, r, desc)
					vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
				end

				-- Navigation
				map("n", "]c", function()
					if vim.wo.diff then
						return "]c"
					end
					vim.schedule(function()
						gs.next_hunk()
					end)
					return "<Ignore>"
				end, "Next hunk")

				map("n", "[c", function()
					if vim.wo.diff then
						return "[c"
					end
					vim.schedule(function()
						gs.prev_hunk()
					end)
					return "<Ignore>"
				end, "Previous hunk")

				-- Actions
				map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
				map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
				map("v", "<leader>hs", function()
					gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, "Stage hunk")
				map("v", "<leader>hr", function()
					gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, "Reset hunk")
				map("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
				map("n", "<leader>hu", gs.undo_stage_hunk, "Undo stage hunk")
				map("n", "<leader>hR", gs.reset_buffer, "Reset buffer")
				map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
				map("n", "<leader>hb", function()
					gs.blame_line({ full = true })
				end, "Blame line")
				map("n", "<leader>hd", gs.diffthis, "Diff this")
				map("n", "<leader>hD", function()
					gs.diffthis("~")
				end, "Diff this ~")

				-- Text object
				map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Select hunk")
			end,
		},
	},
    --
	-- Plenary (dependency)
	{
		"nvim-lua/plenary.nvim",
		lazy = true,
	},

	-- Easy motion
	{
		"smoka7/hop.nvim",
		keys = {
			{ "s", "<cmd>HopWord<CR>", mode = { "n", "v" }, desc = "Hop to word" },
			{ "S", "<cmd>HopChar1<CR>", mode = { "n", "v" }, desc = "Hop to char" },
		},
		opts = { keys = 'asdfqwerzxcvtgbplmokniyjh' },
	},

    {
        'MeanderingProgrammer/render-markdown.nvim',
        lazy = false,
        opts = {
            render_modes = { 'n', 'c', 't', 'i' },
            heading = {
                icons = { " " },
                backgrounds = { 'GruvboxYellowSign', 'GruvboxGreenSign', 'GruvboxBlueSign', 'GruvboxPurpleSign', 'GruvboxOrangeSign', },
            },
            bullet = {
                highlight = { 'GruvboxYellowSign', 'GruvboxYellowSign', 'GruvboxGreenSign', 'GruvboxGreenSign', 'GruvboxBlueSign', 'GruvboxBlueSign', 'GruvboxPurpleSign', 'GruvboxPurpleSign', 'GruvboxOrangeSign', 'GruvboxOrangeSign' },
            },
            code = {
                inline = false,
            },
            -- latex = {
            --     enabled = true,
            --     converter = 'utftex',
            --     highlight = 'RenderMarkdownMath',
            --     position = 'center',
            -- },
            pipe_table = {
                preset = "round",
            },
            anti_conceal = { enabled = true }
        }
    },
}
