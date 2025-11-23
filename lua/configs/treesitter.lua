require("nvim-treesitter.configs").setup {
	ensure_installed = { "lua", "vim", "bash", "cpp", "python", "markdown", "yuck", "zig", "c", "hyprlang" },
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
}

-- Load custom highlight overrides
require "configs.highlights"
