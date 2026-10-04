-- Editor plugins: nvim-tree, telescope, gitsigns, hop, vimtex, render-markdown

-- File explorer
require("nvim-tree").setup({
    on_attach = function(bufnr)
        local api = require("nvim-tree.api")
        api.config.mappings.default_on_attach(bufnr)
        vim.keymap.set("n", "<Tab>", function()
            api.node.open.edit()
            api.tree.focus()
        end, { buffer = bufnr, desc = "Open and stay" })
    end,
    filters = {
        dotfiles = false,
    },
    disable_netrw = true,
    hijack_netrw = true,
    hijack_cursor = true,
    hijack_unnamed_buffer_when_opening = false,
    sync_root_with_cwd = true,
    update_focused_file = {
        enable = true,
        update_root = false,
    },
    view = {
        adaptive_size = false,
        side = "left",
        width = 30,
    },
    git = {
        enable = true,
        ignore = false,
    },
    filesystem_watchers = {
        enable = true,
    },
    actions = {
        open_file = {
            resize_window = true,
        },
    },
    renderer = {
        root_folder_label = false,
        highlight_git = true,
        special_files = {},
        highlight_opened_files = "none",
        indent_markers = {
            enable = true,
        },
        icons = {
            show = {
                file = true,
                folder = true,
                folder_arrow = true,
                git = true,
            },
            glyphs = {
                default = "󰈚",
                symlink = "",
                folder = {
                    default = "",
                    empty = "",
                    empty_open = "",
                    open = "",
                    symlink = "",
                    symlink_open = "",
                    arrow_open = "",
                    arrow_closed = "",
                },
                git = {
                    unstaged = "",
                    staged = "✓",
                    unmerged = "",
                    renamed = "➜",
                    untracked = "",
                    deleted = "",
                    ignored = "",
                    -- unstaged = "✗",
                    -- staged = "✓",
                    -- unmerged = "",
                    -- renamed = "➜",
                    -- untracked = "★",
                    -- deleted = "",
                    -- ignored = "◌",
                },
            },
        },
    },
})

-- Fuzzy finder
require("telescope").setup({
    defaults = {
        prompt_prefix = "   ",
        selection_caret = " ",
        entry_prefix = " ",
        sorting_strategy = "ascending",
        layout_config = {
            horizontal = {
                prompt_position = "top",
                preview_width = 0.55,
            },
            width = 0.87,
            height = 0.80,
        },
        mappings = {
            n = { ["q"] = require("telescope.actions").close },
        },
    },
    pickers = {
        find_files = {
            hidden = true,
            find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
        },
    },
})
require("telescope").load_extension("zoxide")

-- Git signs
require("gitsigns").setup({
    signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "󰍵" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "│" },
    },
    on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local map = function(mode, l, r, desc)
            vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end

        -- Navigation
        map("n", "]c", function()
            if vim.wo.diff then
                return "]c"
            end
            vim.schedule(function()
                gs.next_hunk()
            end)
            return "<Ignore>"
        end, "Next hunk")

        map("n", "[c", function()
            if vim.wo.diff then
                return "[c"
            end
            vim.schedule(function()
                gs.prev_hunk()
            end)
            return "<Ignore>"
        end, "Previous hunk")

        -- Actions
        map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
        map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
        map("v", "<leader>hs", function()
            gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Stage hunk")
        map("v", "<leader>hr", function()
            gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Reset hunk")
        map("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
        map("n", "<leader>hu", gs.undo_stage_hunk, "Undo stage hunk")
        map("n", "<leader>hR", gs.reset_buffer, "Reset buffer")
        map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
        map("n", "<leader>hb", function()
            gs.blame_line({ full = true })
        end, "Blame line")
        map("n", "<leader>hd", gs.diffthis, "Diff this")
        map("n", "<leader>hD", function()
            gs.diffthis("~")
        end, "Diff this ~")

        -- Text object
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Select hunk")
    end,
})

-- Easy motion
-- require("hop").setup({ keys = 'asdfqwerzxcvtgbplmokniyjh' })
require("hop").setup({ keys = 'sqweadzxcrfvplmoknijb' })

-- Vimtex (globals are read when its plugin/ files load, after init.lua)
vim.g.vimtex_view_method = 'general'
vim.g.vimtex_view_automatic = 0
vim.g.vimtex_mappings_enabled = 1
vim.g.vimtex_quickfix_mode = 0
vim.g.vimtex_compiler_latexmk = {
    out_dir = 'build',
}

-- Markdown rendering
require('render-markdown').setup({
    render_modes = { 'n', 'c', 't', 'i' },
    heading = {
        icons = {},
        backgrounds = { 'GruvboxYellowSign', 'GruvboxGreenSign', 'GruvboxBlueSign', 'GruvboxPurpleSign', 'GruvboxOrangeSign', 'GruvboxRedSign' },
    },
    bullet = {
        -- icons = { '●' },
        highlight = { 'GruvboxOrange', 'GruvboxOrange', 'GruvboxBlue', 'GruvboxBlue', 'GruvboxRed', 'GruvboxRed', 'GruvboxPurple', 'GruvboxPurple' },
    },
    code = {
        style = 'none',
        highlight_inline = 'RenderMarkdownCodeInline',
    },
    latex = { enabled = false },
    pipe_table = {
        preset = "round",
    },
    checkbox = {
        custom = {
            tilde = { raw = '[~]', rendered = '󰡖 ', highlight = 'RenderMarkdownWarn' },
        },
    },
    html = { comment = { conceal = false } },
    anti_conceal = { enabled = true }
})
