return {
	{
		"ellisonleao/gruvbox.nvim",
		priority = 1000,
		config = function()
			require("gruvbox").setup({
				italic = {
					strings = false,
					emphasis = false,
					comments = false,
					operators = false,
					folds = false,
				},
				contrast = "soft", -- can be "hard", "soft" or empty string
			})
			vim.cmd([[colorscheme gruvbox]])
		end,
		opts = ...,
	},
}
