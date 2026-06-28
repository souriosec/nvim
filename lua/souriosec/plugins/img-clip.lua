return {
	"HakonHarnes/img-clip.nvim",
	event = "VeryLazy",
	opts = {
		default = {
			dir_path = "assets", -- saves relative to current file
			file_name = "%Y-%m-%d-%H-%M-%S",
		},
	},
	keys = {
		-- suggested keymap
		{ "<leader>ip", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
	},
}
