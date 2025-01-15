return {
	"linux-cultist/venv-selector.nvim",
	dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim", "mfussenegger/nvim-dap-python" },
	event = "VeryLazy", -- Optional: needed only if you want to type `:VenvSelect` without a keymapping

	config = function()
		require("venv-selector").setup({
			name = ".venv",
			stay_on_this_version = true,
		})

		local keymap = vim.keymap
		keymap.set("n", "<leader>vs", "<cmd>VenvSelect<cr>", { desc = "Open venv selector" })
		keymap.set("n", "<leader>vc", "<cmd>VenvSelectCached<cr>", { desc = "Retrience venv from cache" })
	end,
}
