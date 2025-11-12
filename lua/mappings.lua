require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Override file explorer toggle to Ctrl+B instead of Ctrl+N
map("n", "<C-b>", "<cmd>NvimTreeToggle<cr>", { desc = "nvimtree toggle window" })
map("n", "<C-n>", "<nop>", { desc = "disabled default nvimtree toggle" })

-- Override terminal toggle to Ctrl+Tilde instead of Alt+H
map({ "n", "t" }, "<C-`>", function()
  require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm" }
end, { desc = "terminal toggleable horizontal term" })
map({ "n", "t" }, "<A-h>", "<nop>", { desc = "disabled default terminal toggle" })

-- Swap jump list navigation (ctrl-i backward, ctrl-o forward)
map("n", "<C-i>", "<C-o>", { desc = "jump to older position (backward)" })
map("n", "<C-o>", "<C-i>", { desc = "jump to newer position (forward)" })

-- Telescope resume last search
map("n", "<leader>fr", "<cmd>Telescope resume<cr>", { desc = "telescope resume last search" })
