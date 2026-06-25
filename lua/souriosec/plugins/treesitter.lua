return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").setup({})

		require("nvim-treesitter").install({
			"html",
			"css",
			"typescript",
			"javascript",
			"tsx",
			"lua",
			"vim",
			"vimdoc",
			"java",
			"c",
			"cpp",
			"rust",
			"python",
			"go",
			"gomod",
			"gosum",
			"gowork",
			"bash",
			"json",
			"yaml",
			"markdown",
			"markdown_inline",
			"dockerfile",
			"terraform",
			"gitignore",
			"ron",
		})

		vim.api.nvim_create_autocmd("FileType", {
			callback = function()
				pcall(vim.treesitter.start)
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})
	end,
}
