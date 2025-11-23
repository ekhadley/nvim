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
		dependencies = {
			"williamboman/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		opts = {
			automatic_installation = false,
		},
	},

	-- LSP config
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- Custom on_attach function
			local on_attach = function(client, bufnr)
				local map = function(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
				end

				-- LSP keymaps
				map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
				map("n", "gd", vim.lsp.buf.definition, "Go to definition")
				map("n", "K", vim.lsp.buf.hover, "Hover documentation")
				map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
				map("n", "<C-k>", vim.lsp.buf.signature_help, "Signature help")
				map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "Add workspace folder")
				map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "Remove workspace folder")
				map("n", "<leader>wl", function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end, "List workspace folders")
				map("n", "<leader>D", vim.lsp.buf.type_definition, "Type definition")
				map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
				map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
				map("n", "gr", vim.lsp.buf.references, "References")
				map("n", "<leader>fm", function()
					vim.lsp.buf.format({ async = true })
				end, "Format")

				-- Diagnostic keymaps
				map("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic")
				map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
				map("n", "<leader>e", vim.diagnostic.open_float, "Open diagnostic float")
				map("n", "<leader>q", vim.diagnostic.setloclist, "Diagnostic list")
			end

			-- Diagnostic config
			vim.diagnostic.config({
				virtual_text = { prefix = "●" },
				signs = true,
				underline = true,
				update_in_insert = false,
				severity_sort = true,
				float = {
					border = "rounded",
					source = "always",
				},
			})

			-- Diagnostic signs
			local signs = { Error = " ", Warn = " ", Hint = "󰌵 ", Info = " " }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
			end

			-- LSP servers with default config
			local servers = {
				"superhtml",
				"cssls",
				"clangd",
				"zls",
				"hyprls",
				"biome",
				"rust_analyzer",
			}

			for _, lsp in ipairs(servers) do
				lspconfig[lsp].setup({
					on_attach = on_attach,
					capabilities = capabilities,
				})
			end

			-- basedpyright with custom settings
			lspconfig.basedpyright.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				settings = {
					basedpyright = {
						analysis = {
							typeCheckingMode = "basic",
						},
					},
				},
			})

			-- Yuck LSP (requires manual start per buffer)
			vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
				pattern = { "*.yuck" },
				callback = function()
					vim.bo.commentstring = "; %s"
					vim.lsp.start({
						name = "YuckLs",
						cmd = { "yuckls" },
						root_dir = vim.fn.getcwd(),
						on_attach = on_attach,
						capabilities = capabilities,
					})
				end,
			})
		end,
	},

	-- LSP progress indicator
	{
		"j-hui/fidget.nvim",
		event = "LspAttach",
		opts = {
			notification = {
				window = {
					winblend = 0,
				},
			},
		},
	},

	-- Function signature help
	{
		"ray-x/lsp_signature.nvim",
		event = "LspAttach",
		opts = {
			bind = true,
			handler_opts = {
				border = "rounded",
			},
			hint_enable = true,
			hint_prefix = "󰏫 ",
		},
	},
}
