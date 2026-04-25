-- Treesitter configuration (main branch rewrite, requires nvim 0.12+)
return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter").install({
				"lua", "vim", "vimdoc", "bash", "cpp", "c", "python",
				"markdown", "markdown_inline", "yuck", "zig", "hyprlang",
				"json", "yaml", "toml", "rust", "html", "css",
				"javascript", "typescript",
			})

			vim.api.nvim_create_autocmd("FileType", {
				callback = function(ev)
					if pcall(vim.treesitter.start, ev.buf) then
						vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end
				end,
			})

			-- Incremental selection (skip markdown). <C-space> grows, <BS> shrinks.
			local sel_stack = {}
			local function smallest_named()
				local node = vim.treesitter.get_node()
				while node and not node:named() do node = node:parent() end
				return node
			end
			local function select_node(node)
				local sr, sc, er, ec = node:range()
				if ec == 0 and er > sr then
					er = er - 1
					ec = #vim.fn.getline(er + 1)
				end
				vim.cmd([[execute "normal! \<Esc>"]])
				vim.api.nvim_win_set_cursor(0, { sr + 1, sc })
				vim.cmd("normal! v")
				vim.api.nvim_win_set_cursor(0, { er + 1, math.max(ec - 1, 0) })
			end
			local function init_sel()
				local node = smallest_named()
				if not node then return end
				sel_stack[vim.api.nvim_get_current_buf()] = { node }
				select_node(node)
			end
			local function grow_sel()
				local buf = vim.api.nvim_get_current_buf()
				local stack = sel_stack[buf]
				if not stack or #stack == 0 then return init_sel() end
				local parent = stack[#stack]:parent()
				while parent and not parent:named() do parent = parent:parent() end
				if not parent then return end
				table.insert(stack, parent)
				select_node(parent)
			end
			local function shrink_sel()
				local stack = sel_stack[vim.api.nvim_get_current_buf()]
				if not stack or #stack <= 1 then return end
				table.remove(stack)
				select_node(stack[#stack])
			end
			local function active() return vim.bo.filetype ~= "markdown" end
			vim.keymap.set("n", "<C-space>", function() if active() then init_sel() end end, { desc = "TS: init selection" })
			vim.keymap.set("x", "<C-space>", function() if active() then grow_sel() end end, { desc = "TS: grow selection" })
			vim.keymap.set("x", "<BS>", function() if active() then shrink_sel() end end, { desc = "TS: shrink selection" })

			-- Workaround: nvim nightly can invalidate TSNode objects during reparse,
			-- causing get_node_text to crash on :range(). Re-register with pcall guard.
			local aliases = { ex = "elixir", pl = "perl", sh = "bash", uxn = "uxntal", ts = "typescript" }
			vim.treesitter.query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
				local node = match[pred[2]]
				if not node then return end
				local ok, text = pcall(vim.treesitter.get_node_text, node, bufnr)
				if not ok or not text then return end
				local lang = text:lower()
				metadata["injection.language"] = vim.filetype.match({ filename = "a." .. lang }) or aliases[lang] or lang
			end, { force = true, all = false })
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
