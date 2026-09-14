-- todo sidecar: attach a narrow right column with the todo files to the current window
local N = vim.fn.expand("~/Notes")
local WIDTH = 0.30
local FILES = { N .. "/todo.md", N .. "/global_todo.md" }
local LABELS = { "todo", "global" }

local M = {}

-- accent pulled from existing groups so it follows a colorscheme switch
local function set_hl()
    local on = vim.api.nvim_get_hl(0, { name = "Special", link = false })
    local off = vim.api.nvim_get_hl(0, { name = "Comment", link = false })
    vim.api.nvim_set_hl(0, "NotesTabOn", { fg = on.fg, bold = true })
    vim.api.nvim_set_hl(0, "NotesTabOff", { fg = off.fg, bold = true })
end
set_hl()
vim.api.nvim_create_autocmd("ColorScheme", { callback = set_hl })

function M.winbar()
    local cur = vim.api.nvim_buf_get_name(0)
    local parts = {}
    for i, f in ipairs(FILES) do
        parts[i] = (f == cur and "%#NotesTabOn#" or "%#NotesTabOff#") .. "  " .. LABELS[i] .. "  "
    end
    return "%=" .. table.concat(parts) .. "%="
end

-- :edit clears winbar, so it has to be reapplied every time the file changes
local function open(f)
    vim.cmd.edit(f)
    vim.bo.buflisted = false -- :edit relists, so keep them out of the bnext rotation
    vim.wo.winbar = "%!v:lua.require'notes'.winbar()"
end

function M.cycle()
    open(vim.api.nvim_buf_get_name(0) == FILES[1] and FILES[2] or FILES[1])
end

local saved_tabline, sidecar_win

vim.api.nvim_create_autocmd("WinClosed", {
    callback = function(a)
        if sidecar_win and tonumber(a.match) == sidecar_win then
            vim.o.showtabline = saved_tabline
            sidecar_win = nil
        end
    end,
})

local function sidecar()
    for _, f in ipairs(FILES) do
        local buf = vim.fn.bufadd(f)
        vim.fn.bufload(buf)
        vim.bo[buf].buflisted = false
        vim.keymap.set("n", "<Tab>", M.cycle, { buffer = buf, desc = "Next todo file" })
    end
    saved_tabline = vim.o.showtabline -- bufferline is redundant next to the winbar tabs
    vim.o.showtabline = 0
    vim.cmd("botright vsplit")
    open(FILES[1])
    vim.cmd("vertical resize " .. math.floor(vim.o.columns * WIDTH))
    vim.wo.winfixwidth = true
    sidecar_win = vim.api.nvim_get_current_win()
    local buf = vim.api.nvim_win_get_buf(sidecar_win)
    vim.cmd("wincmd h")
    -- log files open with "# August 2026" on line 1; title is fixed, so set it once
    local head = (vim.api.nvim_buf_get_lines(0, 0, 1, false)[1] or ""):gsub("^#%s*", "")
    vim.wo.winbar = "%=%#NotesTabOn#  Daily Log " .. head .. "  %="

    -- render-markdown only paints the focused window, and silently drops render requests
    -- made during startup (measured: anything before ~100ms is a no-op, regardless of
    -- parser or viewport state), so force the sidecar once nvim has settled. no event
    -- fires reliably after that point, hence the delay. focusing it repaints anyway.
    vim.defer_fn(function()
        require("render-markdown").render({ buf = buf, win = sidecar_win })
    end, 200)

    -- bufferline loads on VeryLazy, after this runs, and forces showtabline=2
    vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        once = true,
        callback = function()
            saved_tabline = vim.o.showtabline
            vim.o.showtabline = 0
        end,
    })
end

vim.api.nvim_create_user_command("NoteSidecar", sidecar, {})

return M
