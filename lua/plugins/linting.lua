return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")
		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
		local eslint = lint.linters.eslint_d

		lint.linters_by_ft = {
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescriptreact = { "eslint_d" },
			python = { "ruff" },
		}

		-- Use full path to eslint_d
		eslint.cmd = vim.fn.expand("$HOME/.npm-global/bin/eslint_d")

		-- Set the working directory to the LSP root (where package.json/eslint config lives)
		eslint.cwd = function()
			local clients = vim.lsp.get_clients({ bufnr = 0 })
			for _, client in ipairs(clients) do
				if client.name == "ts_ls" and client.config.root_dir then
					return client.config.root_dir
				end
			end
			return vim.fn.expand("%:p:h")
		end

		eslint.args = {
			"--no-warn-ignored",
			"--format",
			"json",
			"--stdin",
			"--stdin-filename",
			function()
				return vim.api.nvim_buf_get_name(0)
			end,
		}

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
			end,
		})

		vim.keymap.set("n", "<leader>l", function()
			lint.try_lint()
		end, { desc = "Trigger linting for current file" })
	end,
}
