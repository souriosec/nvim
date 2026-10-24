return {
	"linux-cultist/venv-selector.nvim",
	dependencies = {
		"neovim/nvim-lspconfig",
		"mfussenegger/nvim-dap-python",
		"folke/snacks.nvim",
	},
	ft = "python",
	opts = {
		options = {
			picker = "snacks",
		},
	},
	keys = {
		{ "<leader>vs", "<cmd>VenvSelect<cr>", desc = "Open venv selector" },
	},
}
