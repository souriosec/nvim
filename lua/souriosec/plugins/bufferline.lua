return {
	"akinsho/bufferline.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	version = "*",
	config = function()
		local bufferline = require("bufferline")
		bufferline.setup({
			options = {
				style_preset = bufferline.style_preset.no_italic,
				mode = "buffers",
				diagnostics = "nvim_lsp",
				show_buffer_close_icons = false,
				numbers = "ordinal",
			},
		})

		local keymap = vim.keymap

		keymap.set("n", "<leader>1", "<cmd>BufferLineGoToBuffer 1<CR>")
		keymap.set("n", "<leader>2", "<cmd>BufferLineGoToBuffer 2<CR>")
		keymap.set("n", "<leader>3", "<cmd>BufferLineGoToBuffer 3<CR>")
		keymap.set("n", "<leader>4", "<cmd>BufferLineGoToBuffer 4<CR>")

		keymap.set("n", "]b", "<cmd>BufferLineCycleNext<CR>")
		keymap.set("n", "[b", "<cmd>BufferLineCyclePrev<CR>")
	end,
}
