-- Completion configuration (blink.cmp)
return {
	{
		"saghen/blink.cmp",
		event = "InsertEnter",
		version = "*",
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				version = "v2.*",
				dependencies = { "rafamadriz/friendly-snippets" },
				config = function()
					require("luasnip.loaders.from_vscode").lazy_load()
				end,
			},
		},
		opts = {
			snippets = { preset = "luasnip" },
			keymap = {
				preset = "enter",
				["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
				["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
				["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
				["<C-e>"] = { "hide", "fallback" },
				["<C-b>"] = { "scroll_documentation_up", "fallback" },
				["<C-f>"] = { "scroll_documentation_down", "fallback" },
			},
			completion = {
				menu = {
					border = "rounded",
					auto_show = function()
						return vim.bo.filetype ~= "markdown"
					end,
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 200,
					window = { border = "rounded" },
				},
				ghost_text = {
					enabled = function() return vim.bo.filetype ~= "markdown" end,
				},
			},
			sources = {
				default = { "lsp", "path", "snippets" },
			},
			signature = { enabled = true, window = { border = "rounded" } },
		},
	},
}
