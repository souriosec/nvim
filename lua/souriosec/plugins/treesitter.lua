return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	dependencies = { "windwp/nvim-ts-autotag" },

	config = function()
		local treesitter = require("nvim-treesitter.configs")

		treesitter.setup({
			highlight = { enable = true },
			indent = { enable = true },
			autotag = { enable = true },
			ensure_installed = {
				"html",
				"css",
				"typescript",
				"javascript",
				"tsx",
				"lua",
				"vim",
				"java",
				"c",
				"cpp",
				"rust",
				"python",
				"ron",
				"go",
				"bash",
				"json",
				"yaml",
				"markdown",
				"markdown_inline",
				"dockerfile",
				"terraform",
				"gitignore",
				"vimdoc",
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},
		})
	end,
}
