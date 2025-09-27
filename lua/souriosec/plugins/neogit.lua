return {
	"NeogitOrg/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim", -- required
		"sindrets/diffview.nvim", -- optional - Diff integration
	},
	config = function()
		local neogit = require("neogit")
		neogit.setup({})

		-- set keymaps
		local keymap = vim.keymap
		keymap.set("n", "<leader>gg", "<cmd>Neogit<CR>", { desc = "Open Neogit" })
	end,
}
