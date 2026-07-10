return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-neotest/neotest-python",
	},
	config = function()
		require("neotest").setup({
			adapters = {
				require("neotest-python")({
					runner = "pytest",
					python = ".venv/bin/python",
					dap = { justMyCode = false },
					args = { "--log-level", "DEBUG" },
				}),
			},
		})
	end,
	keys = {
		{ "<leader>tn", "<cmd>Neotest run<cr>", desc = "Run nearest test" },
		{ "<leader>tl", "<cmd>Neotest run last<cr>", desc = "Run last test" },
		{ "<leader>tS", "<cmd>Neotest stop<cr>", desc = "Stop tests" },
		{ "<leader>ts", "<cmd>Neotest summary toggle<cr>", desc = "Toggle test summary" },
		{ "<leader>ti", "<cmd>Neotest output<cr>", desc = "Show test output" },
		{ "<leader>to", "<cmd>Neotest output-panel toggle<cr>", desc = "Toggle test output panel" },
		{
			"<leader>ta",
			function()
				require("neotest").run.run(vim.fn.getcwd())
			end,
			desc = "Run all tests",
		},
		{
			"<leader>tf",
			function()
				require("neotest").run.run(vim.fn.expand("%"))
			end,
			desc = "Test current file",
		},
	},
}
