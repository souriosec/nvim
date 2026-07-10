return {
	"mistweaverco/kulala.nvim",
	ft = { "http", "rest" },
	event = { "SessionLoadPost", "VimLeavePre" },
	opts = {
		treesitter = { enable = false },
	},
	keys = {
		{
			"<leader>Rs",
			function()
				require("kulala").run()
			end,
			desc = "Send request",
		},
		{
			"<leader>Ra",
			function()
				require("kulala").run_all()
			end,
			desc = "Send all",
		},
		{
			"<leader>Rr",
			function()
				require("kulala").replay()
			end,
			desc = "Replay last",
		},
	},
}
