-- Keybindings
local map = vim.keymap.set

-- General
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>", { desc = "Exit insert mode" })
map("n", "<Esc>", "<cmd>noh<CR>", { desc = "Clear search highlights" })

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })

-- Window resize
map("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })

-- Buffer navigation
map("n", "<Tab>", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<S-Tab>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>x", "<cmd>bdelete<CR>", { desc = "Close buffer" })
map("n", "<leader>b", "<cmd>enew<CR>", { desc = "New buffer" })

-- Move lines
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- Stay in visual mode after indenting
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Jump list navigation (swapped as per your preference)
map("n", "<C-i>", "<C-o>", { desc = "Jump to older position (backward)" })
map("n", "<C-o>", "<C-i>", { desc = "Jump to newer position (forward)" })

-- Keep cursor centered when scrolling
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down centered" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up centered" })
map("n", "n", "nzzzv", { desc = "Next search result centered" })
map("n", "N", "Nzzzv", { desc = "Previous search result centered" })

-- Save file
map("n", "<C-s>", "<cmd>w<CR>", { desc = "Save file" })
map("i", "<C-s>", "<Esc><cmd>w<CR>", { desc = "Save file" })

-- Copy entire file
map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "Copy entire file" })

-- Comment (using native neovim comment)
map("n", "<leader>/", "gcc", { desc = "Toggle comment", remap = true })
map("v", "<leader>/", "gc", { desc = "Toggle comment", remap = true })

-- LSP keymaps (set on LspAttach)
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local bufnr = args.buf
		local opts = function(desc) return { buffer = bufnr, desc = desc } end

		map("n", "gD", vim.lsp.buf.declaration, opts("Go to declaration"))
		map("n", "gd", vim.lsp.buf.definition, opts("Go to definition"))
		map("n", "K", vim.lsp.buf.hover, opts("Hover documentation"))
		map("n", "gi", vim.lsp.buf.implementation, opts("Go to implementation"))
		map("n", "<C-k>", vim.lsp.buf.signature_help, opts("Signature help"))
		map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts("Add workspace folder"))
		map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts("Remove workspace folder"))
		map("n", "<leader>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, opts("List workspace folders"))
		map("n", "<leader>D", vim.lsp.buf.type_definition, opts("Type definition"))
		map("n", "<leader>rn", vim.lsp.buf.rename, opts("Rename"))
		map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts("Code action"))
		map("n", "gr", vim.lsp.buf.references, opts("References"))
		map("n", "<leader>fm", function() vim.lsp.buf.format({ async = true }) end, opts("Format"))

		-- Diagnostics
		map("n", "[d", vim.diagnostic.goto_prev, opts("Previous diagnostic"))
		map("n", "]d", vim.diagnostic.goto_next, opts("Next diagnostic"))
		map("n", "<leader>e", vim.diagnostic.open_float, opts("Open diagnostic float"))
		map("n", "<leader>q", vim.diagnostic.setloclist, opts("Diagnostic list"))
	end,
})
