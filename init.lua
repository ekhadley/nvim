-- Cache compiled Lua modules
vim.loader.enable()

-- Skip builtin runtime plugins
for _, name in ipairs({ "gzip", "matchit", "netrwPlugin", "tarPlugin", "zipPlugin", "tutor_mode_plugin", "remote_plugins" }) do
    vim.g["loaded_" .. name] = 1
end

-- Options first: they set the leader key, which plugins and keymaps read
require("core.options")
require("plugins")
require("core.keymaps")
require("core.autocmds")

require("notes")
require("search_hud")
