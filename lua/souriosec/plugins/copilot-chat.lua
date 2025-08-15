return {
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{
				"github/copilot.vim",
				config = function()
					vim.g.copilot_enabled = false
				end,
			}, -- or zbirenbaum/copilot.lua
			{ "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
		},
		build = "make tiktoken", -- Only on MacOS or Linux
		config = function()
			require("CopilotChat").setup({
				model = "claude-sonnet-4",
			})
		end,
		keys = {
			{ "<leader>zc", ":CopilotChat<CR>", mode = "n", desc = "Open Copilot chat" },
			{ "<leader>zx", ":CopilotChatClose<CR>", mode = "n", desc = "Close Copilot chat" },
			{ "<leader>ze", ":CopilotChatExplain<CR>", mode = "v", desc = "Explain code" },
			{ "<leader>zr", ":CopilotChatReview<CR>", mode = "v", desc = "Review code" },
			{ "<leader>zf", ":CopilotChatFix<CR>", mode = "v", desc = "Fix code issues" },
			{ "<leader>zo", ":CopilotChatOptimize<CR>", mode = "v", desc = "Optimize code" },
			{ "<leader>zd", ":CopilotChatDocs<CR>", mode = "v", desc = "Generate docs" },
			{ "<leader>zt", ":CopilotChatTests<CR>", mode = "v", desc = "Generate tests" },
			{ "<leader>zm", ":CopilotChatCommit<CR>", mode = "n", desc = "Generate commit message" },
			{ "<leader>zs", ":CopilotChatCommit<CR>", mode = "v", desc = "Generate commit for selection" },
		},
	},
}
