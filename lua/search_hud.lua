-- search hud: floating window in the top right showing the live pattern, match count, and regex errors
-- for / ? searches and :s substitutions, then the current/total count while hlsearch is on
local M = {}
local buf, win
local ns = vim.api.nvim_create_namespace("search_hud")

local function show(lines, hls)
    if not buf then
        buf = vim.api.nvim_create_buf(false, true)
    end
    local width = 0
    for _, l in ipairs(lines) do width = math.max(width, vim.fn.strdisplaywidth(l)) end
    local cfg = { relative = "editor", anchor = "NE", row = 0, col = vim.o.columns, width = width + 2, height = #lines, style = "minimal", border = "rounded", focusable = false, noautocmd = true }
    if win and vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_set_config(win, cfg)
    else
        win = vim.api.nvim_open_win(buf, false, cfg)
    end
    for i, l in ipairs(lines) do lines[i] = " " .. l end
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
    for i, hl in ipairs(hls) do
        vim.api.nvim_buf_set_extmark(buf, ns, i - 1, 0, { line_hl_group = hl })
    end
end

function M.hide()
    if win and vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_close(win, true) end
    win = nil
end

local function regex_error(pat)
    local ok, err = pcall(vim.regex, pat)
    if not ok then return err:match("E%d+:.*") or err end
end

-- "17 matches" or "17+ matches" if the count timed out
local function total_str(pat)
    local sc = vim.fn.searchcount({ pattern = pat, maxcount = 0, timeout = 50 })
    return sc.total .. (sc.incomplete ~= 0 and "+" or "") .. " matches"
end

-- split "/pat/rep/flags" on its unescaped delimiter
local function split_sub(arg)
    local delim, parts, cur, i = arg:sub(1, 1), {}, "", 2
    while i <= #arg do
        local c = arg:sub(i, i)
        if c == "\\" then
            cur, i = cur .. arg:sub(i, i + 1), i + 2
        elseif c == delim then
            parts[#parts + 1], cur, i = cur, "", i + 1
        else
            cur, i = cur .. c, i + 1
        end
    end
    parts[#parts + 1] = cur
    return parts[1], parts[2]
end

local function on_typing()
    local t, line = vim.fn.getcmdtype(), vim.fn.getcmdline()
    if t == "/" or t == "?" then
        if line == "" then return M.hide() end
        local err = regex_error(line)
        show({ t .. line, err or total_str(line) }, { "Function", err and "ErrorMsg" or "Comment" })
    elseif t == ":" then
        local ok, cmd = pcall(vim.api.nvim_parse_cmd, line, {})
        if not ok or cmd.cmd ~= "substitute" or not cmd.args[1] then return M.hide() end
        local pat, rep = split_sub(cmd.args[1])
        if pat == "" then pat = vim.fn.getreg("/") end
        if pat == "" then return M.hide() end
        local range = cmd.range or {}
        local first = range[1] or vim.fn.line(".")
        local last = range[2] or first
        local err = regex_error(pat)
        local where = first == last and ("line " .. first) or ("lines " .. first .. "-" .. last)
        show({ pat .. " → " .. (rep or ""), err or (#vim.fn.matchbufline("%", pat, first, last) .. " matches, " .. where) }, { "Function", err and "ErrorMsg" or "Comment" })
    end
    vim.cmd.redraw()
end

local function on_moved()
    if vim.v.hlsearch == 0 then return M.hide() end
    local sc = vim.fn.searchcount({ maxcount = 0, timeout = 50 })
    if sc.total == 0 then return M.hide() end
    show({ "/" .. vim.fn.getreg("/"), sc.current .. " of " .. sc.total .. (sc.incomplete ~= 0 and "+" or "") }, { "Function", "Comment" })
end

local group = vim.api.nvim_create_augroup("search_hud", {})
vim.api.nvim_create_autocmd("CmdlineChanged", { group = group, callback = on_typing })
vim.api.nvim_create_autocmd("CmdlineLeave", { group = group, callback = function() M.hide(); vim.schedule(on_moved) end })
vim.api.nvim_create_autocmd("CursorMoved", { group = group, callback = on_moved })
vim.api.nvim_create_autocmd("VimResized", { group = group, callback = function() if win then on_moved() end end })

return M
