return {
  -- {
  --   "stevearc/conform.nvim",
  --   -- event = 'BufWritePre', -- uncomment for format on save
  --   opts = require "configs.conform",
  -- },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  {
  	"nvim-treesitter/nvim-treesitter",
    highlight = {
        enable = true,
    }
  },
  {
  	"HiPhish/rainbow-delimiters.nvim",
  },
  {
  	"j-hui/fidget.nvim",
  },
}
