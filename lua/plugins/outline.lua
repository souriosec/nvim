return {
	"hedyhli/outline.nvim",
	config = function()
		local keymap = vim.keymap
		keymap.set("n", "<leader>o", "<cmd>Outline<CR>", { desc = "Toggle Outline" })

		require("outline").setup({})
	end,
}
