-- search hud: floating window by the cursor for / ? searches and :s substitutions, showing the live pattern colored by token,
-- the match count or regex error, and a plain-words legend of each regex token.
-- while hlsearch is on, the current/total count sits at the end of the cursor line
local M = {}
local buf, win, count_buf
local ns = vim.api.nvim_create_namespace("search_hud")

local kind_hl = { group = "Statement", quant = "Number", anchor = "Type", class = "String", flag = "Comment", esc = "Function" }
-- symbols that are operators when bare, per magic level. a backslash flips operator <-> literal
local bare_ops = { v = ".*[~^$+=?{()|<>@%&", m = ".*[~^$", M = "^$", V = "" }
-- symbol -> { kind, description }
local ops = {
    ["."] = { "class", "any character" }, ["["] = { "class", "any one of these characters" }, ["~"] = { "class", "the last substitute string" },
    ["*"] = { "quant", "0 or more of the previous" }, ["+"] = { "quant", "1 or more of the previous" },
    ["="] = { "quant", "previous is optional" }, ["?"] = { "quant", "previous is optional" },
    ["{"] = { "quant", "previous repeated n to m times, {-n,m} as few as possible" },
    ["("] = { "group", "start group" }, [")"] = { "group", "end group" }, ["|"] = { "group", "or" },
    ["&"] = { "group", "and: both sides must match here" }, ["@"] = { "group", "lookaround, see :h /\\@=" },
    ["^"] = { "anchor", "start of line" }, ["$"] = { "anchor", "end of line" },
    ["<"] = { "anchor", "start of word" }, [">"] = { "anchor", "end of word" },
    ["%"] = { "anchor", "special position or character, see :h /\\%" },
}
-- letter after a backslash -> { kind, description }, the same at every magic level
local escapes = {
    d = { "class", "digit" }, D = { "class", "non-digit" },
    w = { "class", "word character: letter, digit or _" }, W = { "class", "non-word character" },
    s = { "class", "space or tab" }, S = { "class", "anything but space or tab" },
    a = { "class", "letter" }, A = { "class", "non-letter" },
    l = { "class", "lowercase letter" }, L = { "class", "anything but a lowercase letter" },
    u = { "class", "uppercase letter" }, U = { "class", "anything but an uppercase letter" },
    x = { "class", "hex digit" }, X = { "class", "non-hex digit" },
    h = { "class", "letter or _" }, H = { "class", "anything but a letter or _" },
    n = { "class", "newline" }, t = { "class", "tab" }, r = { "class", "carriage return" }, e = { "class", "escape character" },
    b = { "class", "backspace character, not a word boundary" },
    c = { "flag", "ignore case" }, C = { "flag", "match case" },
    v = { "flag", "very magic: symbols are operators" }, m = { "flag", "magic: only . * [ ] ^ $ ~ are operators" },
    M = { "flag", "nomagic: only ^ $ are operators" }, V = { "flag", "very nomagic: only \\ is special" },
}

-- index of the ] closing the collection whose [ is at i, nil if unclosed
local function collection_end(p, i)
    local j = i + 1
    if p:sub(j, j) == "^" then j = j + 1 end
    if p:sub(j, j) == "]" then j = j + 1 end
    while j <= #p do
        local c = p:sub(j, j)
        if c == "]" then return j end
        j = c == "\\" and j + 2 or p:match("^%[:%a+:%]()", j) or j + 1
    end
end

-- split a vim regex into { text, kind, description } tokens. plain literals have no kind or description
local function tokenize(p)
    local toks, i, level = {}, 1, "m"
    while i <= #p do
        local esc = p:sub(i, i) == "\\" and i < #p
        local s = esc and i + 1 or i -- the char that decides the token
        local c, e, kind, desc = p:sub(s, s), s, nil, nil
        local prev, rest = toks[#toks], p:sub(s + 1)
        local is_op = ops[c] and (bare_ops[level]:find(c, 1, true) ~= nil) ~= esc
        -- outside very magic, ^ and $ are only anchors at the edges of the pattern or of a branch
        if level ~= "v" and c == "^" then is_op = is_op and (not prev or prev[2] == "flag" or prev[1]:match("^\\%%?[(|&n]$")) end
        if level ~= "v" and c == "$" then is_op = is_op and (rest == "" or rest:match("^\\[|)&n]")) end
        if is_op then
            kind, desc = ops[c][1], ops[c][2]
            if c == "[" then
                e = collection_end(p, s) or #p
                if rest:sub(1, 1) == "^" then desc = "any one character except these" end
            elseif c == "{" then
                e = p:find("}", s, true) or #p
            elseif c == "@" then
                e = select(2, p:find("^@%d*<?[=!>]", s)) or s
            elseif c == "%" then
                e = select(2, p:find("^%%[<>]?%d*.", s)) or s
                if p:sub(e, e) == "(" then kind, desc = "group", "start group, not captured" end
            end
            -- the very magic operators that python treats as plain text
            if level == "v" and not esc and ("<>=@%~&"):find(c, 1, true) then desc = desc .. " (\\" .. c .. " for a literal " .. c .. ")" end
        elseif esc and escapes[c] then
            kind, desc = escapes[c][1], escapes[c][2]
            if bare_ops[c] then level = c end
        elseif esc and c == "z" then
            e, kind, desc = s + 1, "anchor", ({ s = "match starts here", e = "match ends here" })[rest:sub(1, 1)]
        elseif esc and c == "_" then
            local base = escapes[rest:sub(1, 1)] or ops[rest:sub(1, 1)]
            e, kind, desc = s + 1, "class", base and base[2] .. ", or a newline"
        elseif esc and c:match("%d") then
            kind, desc = "class", "same text as group " .. c
        elseif esc then
            kind, desc = "esc", c:match("%a") and "see :h /\\" .. c or "literal " .. c
        elseif ops[c] and not bare_ops[level]:find(c, 1, true) then
            desc = "literal here (\\" .. c .. " → " .. ops[c][2] .. ")"
        end
        toks[#toks + 1] = { p:sub(i, e), kind, desc }
        i = e + 1
    end
    return toks
end

local function chunks(toks)
    return vim.tbl_map(function(tk) return { tk[1], kind_hl[tk[2]] } end, toks)
end

-- one row per distinct token that has a description
local function legend(toks)
    local rows, seen, width = {}, { ["\\v"] = true }, 0
    for _, tk in ipairs(toks) do
        if tk[3] and not seen[tk[1]] then
            seen[tk[1]] = true
            width = math.max(width, vim.fn.strdisplaywidth(tk[1]))
            rows[#rows + 1] = { { tk[1], kind_hl[tk[2]] }, { tk[3] } }
        end
    end
    for _, row in ipairs(rows) do row[2][1] = (" "):rep(width - vim.fn.strdisplaywidth(row[1][1]) + 2) .. row[2][1] end
    return rows
end

-- rows: list of lines, each a list of { text, hl } chunks. sits under the cursor, or above it near the bottom of the screen.
-- the border is red on a regex error, white with matches, muted otherwise
local function show(rows, err, matches)
    if not buf then
        buf = vim.api.nvim_create_buf(false, true)
    end
    local width = 0
    for _, row in ipairs(rows) do
        width = math.max(width, vim.fn.strdisplaywidth(table.concat(vim.tbl_map(function(chunk) return chunk[1] end, row))))
    end
    local cur = vim.fn.getcurpos()
    local below = vim.fn.screenpos(0, cur[2], cur[3]).row + #rows + 2 < vim.o.lines - vim.o.cmdheight
    local cfg = { relative = "win", win = vim.api.nvim_get_current_win(), bufpos = { cur[2] - 1, cur[3] - 1 }, anchor = below and "NW" or "SW", row = below and 1 or 0, col = 0, width = width + 2, height = #rows, style = "minimal", border = "rounded", focusable = false, noautocmd = true }
    if win and vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_set_config(win, cfg)
    else
        win = vim.api.nvim_open_win(buf, false, cfg)
    end
    vim.wo[win].winhighlight = "FloatBorder:" .. (err and "SearchHudError" or matches > 0 and "SearchHudMatches" or "SearchHudMuted")
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.fn["repeat"]({ "" }, #rows))
    vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
    for i, row in ipairs(rows) do
        vim.api.nvim_buf_set_extmark(buf, ns, i - 1, 0, { virt_text = row, virt_text_win_col = 1 })
    end
end

function M.hide()
    if win and vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_close(win, true) end
    win = nil
    if count_buf and vim.api.nvim_buf_is_valid(count_buf) then vim.api.nvim_buf_clear_namespace(count_buf, ns, 0, -1) end
end

local function regex_error(pat)
    local ok, err = pcall(vim.regex, pat)
    if not ok then return err:match("E%d+:.*") or err end
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
        local err, toks = regex_error(line), tokenize(line)
        local rows, total = { vim.list_extend({ { t, "Comment" } }, chunks(toks)) }, 0
        if err then
            rows[2] = { { err, "ErrorMsg" } }
        elseif line ~= "" and line ~= "\\v" then
            local sc = vim.fn.searchcount({ pattern = line, maxcount = 0, timeout = 50 })
            -- "17+" if the count timed out
            total, rows[2] = sc.total, { { sc.total .. (sc.incomplete ~= 0 and "+" or "") .. " matches", "Comment" } }
        end
        show(vim.list_extend(rows, legend(toks)), err, total)
    elseif t == ":" then
        local ok, cmd = pcall(vim.api.nvim_parse_cmd, line, {})
        if not ok or cmd.cmd ~= "substitute" or not cmd.args[1] then return M.hide() end
        local pat, rep = split_sub(cmd.args[1])
        if pat == "" then pat = vim.fn.getreg("/") end
        if pat == "" then return M.hide() end
        local range = cmd.range or {}
        local first = range[1] or vim.fn.line(".")
        local last = range[2] or first
        local err, toks = regex_error(pat), tokenize(pat)
        local where = first == last and ("line " .. first) or ("lines " .. first .. "-" .. last)
        local total = err and 0 or #vim.fn.matchbufline("%", pat, first, last)
        local rows = { vim.list_extend(chunks(toks), { { " → " .. (rep or ""), "Function" } }), { { err or (total .. " matches, " .. where), err and "ErrorMsg" or "Comment" } } }
        show(vim.list_extend(rows, legend(toks)), err, total)
    end
    vim.cmd.redraw()
end

local function on_moved()
    M.hide()
    if vim.v.hlsearch == 0 then return end
    local sc = vim.fn.searchcount({ maxcount = 0, timeout = 50 })
    if sc.total == 0 then return end
    count_buf = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_extmark(count_buf, ns, vim.fn.line(".") - 1, 0, { virt_text = { { sc.current .. " of " .. sc.total .. (sc.incomplete ~= 0 and "+" or ""), "Comment" } } })
end

-- border colors: the fg of an existing group over the float background
local function set_border_hls()
    local bg = vim.api.nvim_get_hl(0, { name = "NormalFloat", link = false }).bg
    for name, src in pairs({ SearchHudError = "DiagnosticError", SearchHudMatches = "NormalFloat", SearchHudMuted = "Comment" }) do
        vim.api.nvim_set_hl(0, name, { fg = vim.api.nvim_get_hl(0, { name = src, link = false }).fg, bg = bg })
    end
end
set_border_hls()

local group = vim.api.nvim_create_augroup("search_hud", {})
vim.api.nvim_create_autocmd("ColorScheme", { group = group, callback = set_border_hls })
vim.api.nvim_create_autocmd("CmdlineEnter", { group = group, callback = M.hide })
vim.api.nvim_create_autocmd("CmdlineChanged", { group = group, callback = on_typing })
vim.api.nvim_create_autocmd("CmdlineLeave", { group = group, callback = function() M.hide(); vim.schedule(on_moved) end })
vim.api.nvim_create_autocmd("CursorMoved", { group = group, callback = on_moved })

return M
