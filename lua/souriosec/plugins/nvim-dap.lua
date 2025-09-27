return {
	"jay-babu/mason-nvim-dap.nvim",
	event = "VeryLazy",
	dependencies = {
		"williamboman/mason.nvim",
		"mfussenegger/nvim-dap",
	},

	opts = {
		handlers = {},
	},

	config = function()
		local keymap = vim.keymap
		keymap.set("n", "<leader>db", "<cmd>DapToggleBreakpoint<CR>", { desc = "Add line breakpoint" })
		keymap.set("n", "<leader>dr", "<cmd>DapContinue<CR>", { desc = "Start or continue the debugger" })
	end,
}
