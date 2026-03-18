---@diagnostic disable: undefined-global
return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
		"williamboman/mason-lspconfig.nvim",
	},

	config = function()
		local lspconfig = require("lspconfig")
		local mason_lspconfig = require("mason-lspconfig")
		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local keymap = vim.keymap

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				local client = vim.lsp.get_client_by_id(ev.data.client_id)

				-- Enable semantic tokens highlighting
				if client and client.server_capabilities and client.server_capabilities.semanticTokensProvider then
					vim.lsp.semantic_tokens.start(ev.buf, client.id)
				end

				local opts = { buffer = ev.buf, silent = true }

				opts.desc = "Show workspace symbols"
				keymap.set("n", "<leader>fw", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", opts)

				opts.desc = "Show document symbols"
				keymap.set("n", "<leader>fd", "<cmd>Telescope lsp_document_symbols<cr>", opts)

				opts.desc = "Show LSP references"
				keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

				opts.desc = "Go to declaration"
				keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

				opts.desc = "Show LSP definitions"
				keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

				opts.desc = "Show LSP implementations"
				keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

				opts.desc = "Show LSP type definitions"
				keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

				opts.desc = "See available code actions"
				keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

				opts.desc = "Smart rename"
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

				opts.desc = "Show buffer diagnostics"
				keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

				opts.desc = "Show line diagnostics"
				keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

				opts.desc = "Go to previous diagnostic"
				keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

				opts.desc = "Go to next diagnostic"
				keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

				opts.desc = "Show documentation for what is under cursor"
				keymap.set("n", "K", vim.lsp.buf.hover, opts)

				opts.desc = "Restart LSP"
				keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
			end,
		})

		-- used to enable autocompletion (assign to every lsp server config)
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Change the Diagnostic symbols in the sign column (gutter)
		local signs = { Error = "", Warn = "", Hint = "󰠠 ", Info = "" }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		-- Configure LSP semantic token highlight groups for better syntax highlighting
		vim.api.nvim_set_hl(0, "@lsp.type.type", { link = "Type" })
		vim.api.nvim_set_hl(0, "@lsp.type.class", { link = "Type" })
		vim.api.nvim_set_hl(0, "@lsp.type.enum", { link = "Type" })
		vim.api.nvim_set_hl(0, "@lsp.type.interface", { link = "Type" })
		vim.api.nvim_set_hl(0, "@lsp.type.struct", { link = "Type" })
		vim.api.nvim_set_hl(0, "@lsp.type.typeParameter", { link = "Type" })
		vim.api.nvim_set_hl(0, "@lsp.type.function", { link = "Function" })
		vim.api.nvim_set_hl(0, "@lsp.type.method", { link = "Function" })
		vim.api.nvim_set_hl(0, "@lsp.type.namespace", { link = "Type" })
		vim.api.nvim_set_hl(0, "@lsp.type.parameter", { link = "Identifier" })
		vim.api.nvim_set_hl(0, "@lsp.type.property", { link = "Identifier" })
		vim.api.nvim_set_hl(0, "@lsp.type.variable", {})
		vim.api.nvim_set_hl(0, "@lsp.type.enumMember", { link = "Constant" })
		vim.api.nvim_set_hl(0, "@lsp.type.decorator", { link = "Function" })
		vim.api.nvim_set_hl(0, "@lsp.type.macro", { link = "Macro" })
		vim.api.nvim_set_hl(0, "@lsp.type.comment", { link = "Comment" })
		vim.api.nvim_set_hl(0, "@lsp.type.string", { link = "String" })
		vim.api.nvim_set_hl(0, "@lsp.type.keyword", { link = "Keyword" })
		vim.api.nvim_set_hl(0, "@lsp.type.number", { link = "Number" })
		vim.api.nvim_set_hl(0, "@lsp.type.operator", { link = "Operator" })

		-- check if mason-lspconfig is available first
		local mason_lspconfig_ok = pcall(require, "mason_lspconfig")

		if mason_lspconfig_ok then
			mason_lspconfig.setup_handlers({
				-- default handler for installed servers
				function(server_name)
					lspconfig[server_name].setup({
						capabilities = capabilities,
					})
				end,
				["ts_ls"] = function()
					lspconfig["ts_ls"].setup({
						capabilities = capabilities,
					})
				end,
				["clangd"] = function()
					lspconfig["clangd"].setup({
						capabilities = capabilities,
						filetypes = { "c", "cpp" },
						cmd = {
							"clangd",
							"--compile-commands-dir=build",
						},
					})
				end,
				["pyright"] = function()
					lspconfig["pyright"].setup({
						capabilities = capabilities,
						settings = {
							python = {
								venvPath = "./",
								venv = ".venv",
								pythonPath = "./.venv/bin/python",
							},
						},
					})
				end,
				["emmet_ls"] = function()
					lspconfig["emmet_ls"].setup({
						capabilities = capabilities,
						filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less" },
					})
				end,
				["lua_ls"] = function()
					lspconfig["lua_ls"].setup({
						capabilities = capabilities,
						settings = {
							Lua = {
								diagnostics = {
									globals = { "vim" },
								},
								completion = {
									callSnippet = "Replace",
								},
							},
						},
					})
				end,
				["gopls"] = function()
					lspconfig["gopls"].setup({
						capabilities = capabilities,
						settings = {
							gopls = {
								build = {
									allowModfileModifications = false,
									allowNetworkBuild = false,
								},
								formatting = {
									gofumpt = true,
								},
								ui = {
									usePlaceholders = true,
									semanticTokens = true,
								},
								analyses = {
									unusedparams = true,
									shadow = true,
								},
								hints = {
									assignVariableTypes = true,
									compositeLiteralFields = true,
									constantValues = true,
									functionTypeParameters = true,
									parameterNames = true,
									rangeVariableTypes = true,
								},
							},
						},
					})
				end,
				["gdscript"] = function()
					lspconfig["gdscript"].setup({
						capabilities = capabilities,
					})
				end,
			})
		end
	end,
}
