return {
	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("oil").setup({
				columns = { "icon" },
				keymaps = {
					["<C-h>"] = false,
					["<C-l>"] = false,
					["<C-k>"] = false,
					["<C-j>"] = false,
					["<M-h>"] = "actions.select_split",
				},
				view_options = {
					show_hidden = true,
				},
			})

			vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

			vim.keymap.set(
				"n",
				"<space>-",
				require("oil").toggle_float,
				{ desc = "Open parent directory in floating window" }
			)

			require("oil").setup({
				keymaps = {
					["yp"] = {
						"actions.yank_entry",
						desc = "Yank path of entry under cursor",
					},
				},
			})
		end,
	},
}
