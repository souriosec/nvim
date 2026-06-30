return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")
		local mason_tool_installer = require("mason-tool-installer")

		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		mason_lspconfig.setup({
			-- list of servers for mason to install
			-- NOTE: pyright removed. ty is installed via mason-tool-installer
			-- below (as a plain package) rather than here, because mason-lspconfig
			-- does not yet reliably recognize ty in ensure_installed /
			-- automatic_enable. It is enabled explicitly in lspconfig.lua.
			ensure_installed = {
				"ts_ls",
				"html",
				"cssls",
				"lua_ls",
				"graphql",
				"emmet_ls",
				"clangd",
				"gopls",
			},
		})

		mason_tool_installer.setup({
			ensure_installed = {
				"prettier", -- prettier formatter
				"stylua", -- lua formatter
				"ruff", -- python linter + formatter (astral)
				"ty", -- python type checker / LSP (astral)
				"eslint_d", -- js linter
				"clang-format", -- c/cpp formatter
				"gofumpt", -- go formatter
			},
		})
	end,
}
