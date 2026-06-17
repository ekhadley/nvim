-- Keybindings
local map = vim.keymap.set

-- General
map("n", ";", ":", { desc = "CMD enter command mode" })
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })

-- Navigate display lines (wrapped lines)
map({ "n", "v" }, "j", "gj", { desc = "Down (display line)" })
map({ "n", "v" }, "k", "gk", { desc = "Up (display line)" })
map({ "n", "v" }, "<Down>", "gj", { desc = "Down (display line)" })
map({ "n", "v" }, "<Up>", "gk", { desc = "Up (display line)" })

-- Command abbreviations
vim.cmd.cnoreabbrev('Q', 'qa')
vim.cmd.cnoreabbrev('W', 'wa')
vim.cmd.cnoreabbrev('WQ', 'wqa')

-- Window navigation
map("n", "<C-Down>", "<C-w>j", { desc = "Window down" })
map("n", "<C-Up>", "<C-w>k", { desc = "Window up" })
map("n", "<C-Left>", "<C-w>h", { desc = "Window left" })
map("n", "<C-Right>", "<C-w>l", { desc = "Window right" })

-- Select inside word
map("n", "W", "viw", { desc = "Select inside word" })
map("x", "W", "iw", { desc = "Inside word" })

-- Word jumping
map({ "n", "v" }, "<C-h>", "b", { desc = "Jump word backward" })
map({ "n", "v" }, "<C-l>", "w", { desc = "Jump word forward" })
map("v", "<C-Left>", "b", { desc = "Jump word backward" })
map("v", "<C-Right>", "w", { desc = "Jump word forward" })
map("i", "<C-h>", "<C-o>b", { desc = "Jump word backward" })
map("i", "<C-l>", "<C-o>w", { desc = "Jump word forward" })
map("i", "<C-S-h>", "<Esc>vb", { desc = "Select word backward" })
map("i", "<C-S-l>", "<Esc>ve", { desc = "Select word forward" })
map("i", "<C-j>", "<Down>", { desc = "Move down" })
map("i", "<C-k>", "<Up>", { desc = "Move up" })

-- Buffer navigation
map("n", "<Tab>", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<S-Tab>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<PageDown>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
map("n", "<PageUp>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Previous buffer" })
map("n", "<S-PageDown>", "<cmd>BufferLineMoveNext<CR>", { desc = "Move buffer right" })
map("n", "<S-PageUp>", "<cmd>BufferLineMovePrev<CR>", { desc = "Move buffer left" })
map("n", "<leader>x", function()
    local buf = vim.api.nvim_get_current_buf()
    if vim.bo[buf].filetype == "NvimTree" then return end
    vim.cmd("bprevious | bdelete " .. buf)
end, { desc = "Close buffer" })
map("n", "<leader>b", "<cmd>enew<CR>", { desc = "New buffer" })

-- Move lines
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })

-- Stay in visual mode after indenting
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Jump list navigation (swapped as per your preference)
map("n", "<C-i>", "<C-o>", { desc = "Jump to older position (backward)" })
map("n", "<C-o>", "<C-i>", { desc = "Jump to newer position (forward)" })

-- Jump 8 lines
map({ "n", "v" }, "<S-Down>", "8gj", { desc = "Down 8 lines" })
map({ "n", "v" }, "<S-Up>", "8gk", { desc = "Up 8 lines" })

-- Keep cursor centered when scrolling
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down centered" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up centered" })
map("n", "n", "nzzzv", { desc = "Next search result centered" })
map("n", "N", "Nzzzv", { desc = "Previous search result centered" })

-- Save file
map("n", "<C-s>", "<cmd>w<CR>", { desc = "Save file" })
map("i", "<C-s>", "<Esc><cmd>w<CR>", { desc = "Save file" })

-- System clipboard
map("v", "<leader>c", '"+y', { desc = "Copy to system clipboard" })
map({ "n", "v" }, "<C-S-v>", '"+p', { desc = "Paste from system clipboard" })
map("i", "<C-S-v>", '<C-r>+', { desc = "Paste from system clipboard" })
map("v", "<C-c>", '"+y', { desc = "Copy to system clipboard" })
map({ "n", "v" }, "<C-v>", '"+p', { desc = "Paste from system clipboard" })
map("i", "<C-v>", '<C-r>+', { desc = "Paste from system clipboard" })

-- Toggle line wrap
map("n", "<A-S-z>", "<cmd>set wrap!<CR>", { desc = "Toggle line wrap" })

-- Toggle markdown checkbox
local function toggle_checkbox(line)
	if line:match("%[x%]") then
		return (line:gsub("%[x%]", "[ ]", 1))
	elseif line:match("%[ %]") then
		return (line:gsub("%[ %]", "[x]", 1))
	end
	return line
end

local function toggle_bullet_checkbox(line)
	if line:match("^(%s*[%-%*])%s+%[.%]%s") then
		return (line:gsub("^(%s*[%-%*])%s+%[.%]%s", "%1 ", 1))
	elseif line:match("^(%s*[%-%*])%s") then
		return (line:gsub("^(%s*[%-%*])%s", "%1 [ ] ", 1))
	end
	return line
end

local function apply_to_visual_range(fn)
	local s = vim.fn.line("v")
	local e = vim.fn.line(".")
	if s > e then s, e = e, s end
	for lnum = s, e do
		vim.fn.setline(lnum, fn(vim.fn.getline(lnum)))
	end
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
end

map("n", "<leader>[", function()
	vim.api.nvim_set_current_line(toggle_checkbox(vim.api.nvim_get_current_line()))
end, { desc = "Toggle markdown checkbox" })
map("x", "<leader>[", function() apply_to_visual_range(toggle_checkbox) end, { desc = "Toggle markdown checkbox" })

-- Toggle bullet checkbox existence
map("n", "<leader>]", function()
	vim.api.nvim_set_current_line(toggle_bullet_checkbox(vim.api.nvim_get_current_line()))
end, { desc = "Toggle bullet checkbox" })
map("x", "<leader>]", function() apply_to_visual_range(toggle_bullet_checkbox) end, { desc = "Toggle bullet checkbox" })

-- Comment (using native neovim comment)
map("n", "<leader>/", "gcc", { desc = "Toggle comment", remap = true })
map("v", "<leader>/", "gc", { desc = "Toggle comment", remap = true })
map("n", "<C-/>", "gcc", { desc = "Toggle comment", remap = true })
map("v", "<C-/>", "gc", { desc = "Toggle comment", remap = true })
map("i", "<C-/>", "<Esc>gcca", { desc = "Toggle comment", remap = true })

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
		map("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, opts("Previous diagnostic"))
		map("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, opts("Next diagnostic"))
		map("n", "<leader>e", vim.diagnostic.open_float, opts("Open diagnostic float"))
		map("n", "<leader>q", vim.diagnostic.setloclist, opts("Diagnostic list"))

		-- Highlight references to the symbol under the cursor
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client and client:supports_method("textDocument/documentHighlight") then
			local group = vim.api.nvim_create_augroup("lsp_document_highlight_" .. bufnr, { clear = true })
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = bufnr,
				group = group,
				callback = vim.lsp.buf.document_highlight,
			})
			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = bufnr,
				group = group,
				callback = vim.lsp.buf.clear_references,
			})
		end
	end,
})

