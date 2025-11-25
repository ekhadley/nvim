local colors = {
	black = '#282828',
	white = '#ebdbb2',
	red = '#fb4934',
	green = '#8EC07C',
	blue = '#83a598',
	yellow = '#CCA700',
	gray = '#A89984',
	darkgray = '#3c3836',
	lightgray = '#504945',
	inactivegray = '#7c6f64',
}

return {
	normal = {
		a = { bg = colors.gray, fg = colors.black, gui = 'bold' },
		b = { bg = colors.lightgray, fg = colors.white },
		c = { bg = colors.darkgray, fg = colors.gray },
	},
	insert = {
		a = { bg = colors.blue, fg = colors.black, gui = 'bold' },
		b = { bg = colors.lightgray, fg = colors.white },
		c = { bg = colors.darkgray, fg = colors.gray },
	},
	visual = {
		a = { bg = colors.yellow, fg = colors.black, gui = 'bold' },
		b = { bg = colors.lightgray, fg = colors.white },
		c = { bg = colors.darkgray, fg = colors.gray },
	},
	replace = {
		a = { bg = colors.red, fg = colors.black, gui = 'bold' },
		b = { bg = colors.lightgray, fg = colors.white },
		c = { bg = colors.black, fg = colors.gray },
	},
	command = {
		a = { bg = colors.green, fg = colors.black, gui = 'bold' },
		b = { bg = colors.lightgray, fg = colors.white },
		c = { bg = colors.black, fg = colors.gray },
	},
	inactive = {
		a = { bg = colors.darkgray, fg = colors.black, gui = 'bold' },
		b = { bg = colors.lightgray, fg = colors.white },
		c = { bg = colors.black, fg = colors.gray },
	},
}
