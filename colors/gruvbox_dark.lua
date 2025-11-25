-- Gruvbox Dark colorscheme
-- Based on ellisonleao/gruvbox.nvim

vim.cmd('hi clear')
if vim.fn.exists('syntax_on') then
	vim.cmd('syntax reset')
end

vim.o.termguicolors = true
vim.g.colors_name = 'gruvbox_dark'

-- Gruvbox Dark palette
local colors = {
	bg0 = '#1D2021',
	bg1 = '#3c3836',
	bg2 = '#504945',
	bg3 = '#665c54',
	bg4 = '#7c6f64',
	fg0 = '#fbf1c7',
	fg1 = '#ebdbb2',
	fg2 = '#d5c4a1',
	fg3 = '#bdae93',
	fg4 = '#a89984',
	red = '#fb4934',
	green = '#b8bb26',
	yellow = '#fabd2f',
	blue = '#83a598',
	purple = '#d3869b',
	aqua = '#8ec07c',
	orange = '#fe8019',
	gray = '#928374',
}

-- Editor highlights
vim.api.nvim_set_hl(0, 'Normal', { fg = colors.fg1, bg = colors.bg0 })
vim.api.nvim_set_hl(0, 'NormalFloat', { fg = colors.fg1, bg = colors.bg1 })
vim.api.nvim_set_hl(0, 'Comment', { fg = colors.gray, italic = true })
vim.api.nvim_set_hl(0, 'Constant', { fg = colors.purple })
vim.api.nvim_set_hl(0, 'String', { fg = colors.green })
vim.api.nvim_set_hl(0, 'Character', { fg = colors.purple })
vim.api.nvim_set_hl(0, 'Number', { fg = colors.purple })
vim.api.nvim_set_hl(0, 'Boolean', { fg = colors.purple })
vim.api.nvim_set_hl(0, 'Float', { fg = colors.purple })
vim.api.nvim_set_hl(0, 'Identifier', { fg = colors.blue })
vim.api.nvim_set_hl(0, 'Function', { fg = colors.green, bold = true })
vim.api.nvim_set_hl(0, 'Statement', { fg = colors.red })
vim.api.nvim_set_hl(0, 'Conditional', { fg = colors.red })
vim.api.nvim_set_hl(0, 'Repeat', { fg = colors.red })
vim.api.nvim_set_hl(0, 'Label', { fg = colors.red })
vim.api.nvim_set_hl(0, 'Operator', { fg = colors.orange })
vim.api.nvim_set_hl(0, 'Keyword', { fg = colors.red })
vim.api.nvim_set_hl(0, 'Exception', { fg = colors.red })
vim.api.nvim_set_hl(0, 'PreProc', { fg = colors.aqua })
vim.api.nvim_set_hl(0, 'Include', { fg = colors.aqua })
vim.api.nvim_set_hl(0, 'Define', { fg = colors.aqua })
vim.api.nvim_set_hl(0, 'Macro', { fg = colors.aqua })
vim.api.nvim_set_hl(0, 'PreCondit', { fg = colors.aqua })
vim.api.nvim_set_hl(0, 'Type', { fg = colors.yellow })
vim.api.nvim_set_hl(0, 'StorageClass', { fg = colors.orange })
vim.api.nvim_set_hl(0, 'Structure', { fg = colors.aqua })
vim.api.nvim_set_hl(0, 'Typedef', { fg = colors.yellow })
vim.api.nvim_set_hl(0, 'Special', { fg = colors.orange })
vim.api.nvim_set_hl(0, 'SpecialChar', { fg = colors.red })
vim.api.nvim_set_hl(0, 'Tag', { fg = colors.orange })
vim.api.nvim_set_hl(0, 'Delimiter', { fg = colors.orange })
vim.api.nvim_set_hl(0, 'SpecialComment', { fg = colors.gray })
vim.api.nvim_set_hl(0, 'Debug', { fg = colors.red })
vim.api.nvim_set_hl(0, 'Underlined', { fg = colors.blue, underline = true })
vim.api.nvim_set_hl(0, 'Ignore', { fg = colors.bg4 })
vim.api.nvim_set_hl(0, 'Error', { fg = colors.red, bg = colors.bg0, bold = true })
vim.api.nvim_set_hl(0, 'Todo', { fg = colors.bg0, bg = colors.yellow, bold = true })

-- UI elements
vim.api.nvim_set_hl(0, 'Cursor', { reverse = true })
vim.api.nvim_set_hl(0, 'CursorLine', { bg = colors.bg1 })
vim.api.nvim_set_hl(0, 'CursorColumn', { bg = colors.bg1 })
vim.api.nvim_set_hl(0, 'LineNr', { fg = colors.bg4 })
vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = colors.yellow })
vim.api.nvim_set_hl(0, 'Visual', { bg = colors.bg3 })
vim.api.nvim_set_hl(0, 'VisualNOS', { bg = colors.bg3 })
vim.api.nvim_set_hl(0, 'IncSearch', { fg = colors.bg0, bg = colors.orange })
vim.api.nvim_set_hl(0, 'Search', { fg = colors.bg0, bg = colors.yellow })
vim.api.nvim_set_hl(0, 'MatchParen', { bg = colors.bg3, bold = true })
vim.api.nvim_set_hl(0, 'StatusLine', { fg = colors.fg1, bg = colors.bg2 })
vim.api.nvim_set_hl(0, 'StatusLineNC', { fg = colors.bg4, bg = colors.bg1 })
vim.api.nvim_set_hl(0, 'VertSplit', { fg = colors.bg2, bg = colors.bg0 })
vim.api.nvim_set_hl(0, 'Pmenu', { fg = colors.fg1, bg = colors.bg2 })
vim.api.nvim_set_hl(0, 'PmenuSel', { fg = colors.bg0, bg = colors.blue })
vim.api.nvim_set_hl(0, 'PmenuSbar', { bg = colors.bg2 })
vim.api.nvim_set_hl(0, 'PmenuThumb', { bg = colors.bg4 })
vim.api.nvim_set_hl(0, 'SignColumn', { bg = colors.bg0 })
vim.api.nvim_set_hl(0, 'ColorColumn', { bg = colors.bg1 })
vim.api.nvim_set_hl(0, 'Folded', { fg = colors.gray, bg = colors.bg1, italic = true })
vim.api.nvim_set_hl(0, 'FoldColumn', { fg = colors.gray, bg = colors.bg1 })

-- Diff
vim.api.nvim_set_hl(0, 'DiffAdd', { fg = colors.green, bg = colors.bg0, reverse = true })
vim.api.nvim_set_hl(0, 'DiffChange', { fg = colors.aqua, bg = colors.bg0, reverse = true })
vim.api.nvim_set_hl(0, 'DiffDelete', { fg = colors.red, bg = colors.bg0, reverse = true })
vim.api.nvim_set_hl(0, 'DiffText', { fg = colors.yellow, bg = colors.bg0, reverse = true })

-- Git signs
vim.api.nvim_set_hl(0, 'GitSignsAdd', { fg = colors.green })
vim.api.nvim_set_hl(0, 'GitSignsChange', { fg = colors.aqua })
vim.api.nvim_set_hl(0, 'GitSignsDelete', { fg = colors.red })

-- Diagnostics
vim.api.nvim_set_hl(0, 'DiagnosticError', { fg = colors.red })
vim.api.nvim_set_hl(0, 'DiagnosticWarn', { fg = colors.yellow })
vim.api.nvim_set_hl(0, 'DiagnosticInfo', { fg = colors.blue })
vim.api.nvim_set_hl(0, 'DiagnosticHint', { fg = colors.aqua })

-- LSP
vim.api.nvim_set_hl(0, 'LspReferenceText', { bg = colors.bg2 })
vim.api.nvim_set_hl(0, 'LspReferenceRead', { bg = colors.bg2 })
vim.api.nvim_set_hl(0, 'LspReferenceWrite', { bg = colors.bg2 })

-- Treesitter
vim.api.nvim_set_hl(0, '@variable', { fg = colors.fg1 })
vim.api.nvim_set_hl(0, '@variable.builtin', { fg = colors.orange })
vim.api.nvim_set_hl(0, '@variable.parameter', { fg = colors.fg1 })
vim.api.nvim_set_hl(0, '@constant.builtin', { fg = colors.purple })
vim.api.nvim_set_hl(0, '@string.escape', { fg = colors.red })
vim.api.nvim_set_hl(0, '@string.special', { fg = colors.orange })
vim.api.nvim_set_hl(0, '@property', { fg = colors.blue })
vim.api.nvim_set_hl(0, '@function.builtin', { fg = colors.green, bold = true })
vim.api.nvim_set_hl(0, '@function.macro', { fg = colors.aqua })
vim.api.nvim_set_hl(0, '@keyword.function', { fg = colors.red })
vim.api.nvim_set_hl(0, '@keyword.operator', { fg = colors.red })
vim.api.nvim_set_hl(0, '@keyword.return', { fg = colors.red })
vim.api.nvim_set_hl(0, '@constructor', { fg = colors.yellow })
vim.api.nvim_set_hl(0, '@tag', { fg = colors.orange })
vim.api.nvim_set_hl(0, '@tag.attribute', { fg = colors.aqua })
vim.api.nvim_set_hl(0, '@tag.delimiter', { fg = colors.fg4 })
