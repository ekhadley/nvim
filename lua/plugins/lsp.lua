-- LSP Configuration
return {
	-- Mason (LSP installer)
	{
		"williamboman/mason.nvim",
		cmd = { "Mason", "MasonInstall", "MasonUpdate" },
		opts = {
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		},
	},

	-- Mason-lspconfig bridge
	{
		"williamboman/mason-lspconfig.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = { "williamboman/mason.nvim" },
		opts = { automatic_installation = false },
	},

	-- LSP config (using vim.lsp.config API for nvim 0.11+)
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = { "saghen/blink.cmp" },
		config = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			-- Diagnostic config
			vim.diagnostic.config({
				virtual_text = { prefix = "●" },
				signs = true,
				underline = true,
				update_in_insert = false,
				severity_sort = true,
				float = { border = "rounded", source = "always" },
			})

			-- Diagnostic signs
			local signs = { Error = " ", Warn = " ", Hint = "󰌵 ", Info = " " }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
			end

			-- LSP servers with default config
			local servers = { "superhtml", "cssls", "clangd", "zls", "hyprls", "biome", "rust_analyzer" }
			for _, server in ipairs(servers) do
				vim.lsp.config[server] = { capabilities = capabilities }
			end
			vim.lsp.enable(servers)

			-- basedpyright with custom settings
			vim.lsp.config.basedpyright = {
				capabilities = capabilities,
				settings = {
					basedpyright = {
						analysis = {
                            typeCheckingMode = "basic"
                        },
					},
				},
			}
			vim.lsp.enable("basedpyright")

			-- lua_ls: don't index $HOME when opening a loose lua file (e.g. ~/.config/hypr/hyprland.lua)
			-- https://github.com/LuaLS/lua-language-server/issues/2975
			vim.lsp.config.lua_ls = {
				capabilities = capabilities,
				on_init = function(client)
					if client.workspace_folders then
						local path = client.workspace_folders[1].name
						if path ~= vim.fn.expand("~") and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc")) then
							return
						end
					end
					client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua or {}, {
						runtime = { version = "LuaJIT" },
						workspace = {
							checkThirdParty = false,
							library = { vim.env.VIMRUNTIME },
						},
					})
				end,
				settings = { Lua = {} },
			}
			vim.lsp.enable("lua_ls")

			-- Yuck LSP (requires manual start per buffer)
			vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
				pattern = { "*.yuck" },
				callback = function()
					vim.bo.commentstring = "; %s"
					vim.lsp.start({
						name = "yuckls",
						cmd = { "yuckls" },
						root_dir = vim.fn.getcwd(),
						capabilities = capabilities,
					})
				end,
			})
		end,
	},
}
