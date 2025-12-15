-- Core Neovim options
local opt = vim.opt
local g = vim.g

-- Leader key
g.mapleader = " "
g.maplocalleader = " "

-- Line numbers
opt.number = true
opt.relativenumber = false
opt.numberwidth = 2
opt.ruler = false

-- Indentation
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Appearance
opt.termguicolors = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.wrap = true
opt.linebreak = true
opt.showmode = false

-- Behavior
opt.splitbelow = true
opt.splitright = true
opt.clipboard = "unnamedplus"
opt.mouse = "a"
opt.undofile = true
opt.swapfile = false
opt.updatetime = 250
opt.timeoutlen = 400
opt.fillchars = { eob = " " }

-- Completion
opt.completeopt = "menu,menuone,noselect"
opt.pumheight = 10

-- Disable some default providers
g.loaded_node_provider = 0
g.loaded_python3_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0
