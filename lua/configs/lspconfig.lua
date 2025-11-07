-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local servers = { "superhtml", "cssls", "clangd", "zls", "hyprls", "biome", "rust-analyzer" }
local nvlsp = require "nvchad.configs.lspconfig"

-- lsps with default config
for _, lsp in ipairs(servers) do
  vim.lsp.config(lsp, {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  })
  vim.lsp.enable(lsp)
end

-- basedpyright with custom type checking mode
vim.lsp.config("basedpyright", {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  settings = {
    basedpyright = {
      analysis = {
        typeCheckingMode = "basic",
      },
    },
  },
})
vim.lsp.enable("basedpyright")

-- configuring single server, example: typescript
-- vim.lsp.config("ts_ls", {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- })
-- vim.lsp.enable "ts_ls"

-- yuck LSP (requires manual start per buffer)
vim.api.nvim_create_autocmd(
  { "BufEnter", "BufWinEnter" },
  {
    pattern = { "*.yuck" },
    callback = function()
      vim.bo.commentstring = "; %s"
      vim.lsp.start({
        name = "YuckLs",
        cmd = { "yuckls" },
        root_dir = vim.fn.getcwd(),
        on_attach = nvlsp.on_attach,
        capabilities = nvlsp.capabilities,
      })
    end
  }
)
