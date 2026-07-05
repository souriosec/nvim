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
		local mason_lspconfig = require("mason-lspconfig")
		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local keymap = vim.keymap

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				local client = vim.lsp.get_client_by_id(ev.data.client_id)

				-- Enable semantic tokens highlighting
				if client and client.server_capabilities and client.server_capabilities.semanticTokensProvider then
					vim.lsp.semantic_tokens.enable(true, { bufnr = ev.buf })
				end

				-- ruff's hover only shows ruff rule docs; defer hover (K) to ty
				-- so you get real type info instead.
				if client and client.name == "ruff" then
					client.server_capabilities.hoverProvider = false
				end

				local opts = { buffer = ev.buf, silent = true }

				opts.desc = "Show workspace symbols"
				keymap.set("n", "<leader>fw", function()
					Snacks.picker.lsp_workspace_symbols()
				end, opts)

				opts.desc = "Show document symbols"
				keymap.set("n", "<leader>fd", function()
					Snacks.picker.lsp_symbols()
				end, opts)

				opts.desc = "Show LSP references"
				keymap.set("n", "gR", function()
					Snacks.picker.lsp_references()
				end, opts)

				opts.desc = "Go to declaration"
				keymap.set("n", "gD", function()
					Snacks.picker.lsp_declarations()
				end, opts)

				opts.desc = "Show LSP definitions"
				keymap.set("n", "gd", function()
					Snacks.picker.lsp_definitions()
				end, opts)

				opts.desc = "Show LSP implementations"
				keymap.set("n", "gi", function()
					Snacks.picker.lsp_implementations()
				end, opts)

				opts.desc = "Show LSP type definitions"
				keymap.set("n", "gt", function()
					Snacks.picker.lsp_type_definitions()
				end, opts)

				opts.desc = "See available code actions"
				keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

				opts.desc = "Smart rename"
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

				opts.desc = "Show buffer diagnostics"
				keymap.set("n", "<leader>D", function()
					Snacks.picker.diagnostics_buffer()
				end, opts)

				opts.desc = "Show line diagnostics"
				keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

				opts.desc = "Go to previous diagnostic"
				keymap.set("n", "[d", function()
					vim.diagnostic.jump({ count = -1, float = true })
				end, opts)

				opts.desc = "Go to next diagnostic"
				keymap.set("n", "]d", function()
					vim.diagnostic.jump({ count = 1, float = true })
				end, opts)

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

		-- mason-lspconfig 2.0+ removed setup_handlers()/handlers in favor of the
		-- native vim.lsp.config() / vim.lsp.enable() API. automatic_enable (on by
		-- default) calls vim.lsp.enable() for everything in ensure_installed, so
		-- we just need to provide per-server config via vim.lsp.config().
		-- NOTE: pyright removed (replaced by ty). ty is enabled explicitly below
		-- rather than via ensure_installed here, because mason-lspconfig does not
		-- yet reliably map/recognize ty.
		mason_lspconfig.setup({
			ensure_installed = { "lua_ls", "gopls", "clangd", "ts_ls", "emmet_ls" },
		})

		-- base capabilities applied to every server, individual vim.lsp.config()
		-- calls below are merged on top of this
		vim.lsp.config("*", { capabilities = capabilities })

		vim.lsp.config("clangd", {
			filetypes = { "c", "cpp" },
			cmd = {
				"clangd",
				"--compile-commands-dir=build",
				"--query-driver="
					.. vim.fn.expand("~")
					.. "/.platformio/packages/toolchain-xtensa/bin/xtensa-lx106-elf-*",
			},
		})

		-- ty (astral) replaces pyright as the Python type checker + language server.
		-- The base config (cmd = { "ty", "server" }, filetypes, root markers) ships
		-- with nvim-lspconfig, so this table only needs optional overrides.
		--
		-- No venvPath / pythonPath here: ty discovers the active environment on its
		-- own. With uv, run nvim from a project that has a `.venv` (or with
		-- $VIRTUAL_ENV set) and ty will resolve your dependencies automatically.
		vim.lsp.config("ty", {
			-- settings = {
			-- 	ty = {
			-- 		-- e.g. inlayHints = { variableTypes = false },
			-- 		--      diagnosticMode = "workspace",
			-- 	},
			-- },
		})

		-- mason-lspconfig's automatic_enable does not reliably enable ty yet,
		-- so enable it explicitly. The "*" capabilities above still apply.
		vim.lsp.enable("ty")

		-- ruff (astral) language server: live lint diagnostics + code actions
		-- (autofix, organize imports on <leader>ca). This replaces the nvim-lint
		-- ruff setup. ruff owns lint/format; ty owns types/hover/go-to-def.
		-- The base config (cmd = { "ruff", "server" }, filetypes, root markers)
		-- ships with nvim-lspconfig, and "*" above applies capabilities, so we
		-- only need to enable it. Hover is turned off in the LspAttach handler
		-- above so it doesn't compete with ty.
		--
		-- NOTE: do NOT pass an empty init_options.settings here. Neovim encodes an
		-- empty Lua table as a JSON array ([]), and ruff rejects that with
		-- "received invalid client settings - falling back to default". Only add a
		-- vim.lsp.config("ruff", { init_options = { settings = { ... } } }) block
		-- when settings is actually non-empty (e.g. lint = { select = {...} }).
		vim.lsp.enable("ruff")

		vim.lsp.config("emmet_ls", {
			filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less" },
		})

		vim.lsp.config("gopls", {
			settings = {
				gopls = {
					gofumpt = true,
					usePlaceholders = true,
					semanticTokens = true,
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

		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					diagnostics = { globals = { "vim" } },
					workspace = {
						library = vim.api.nvim_get_runtime_file("", true),
						checkThirdParty = false,
					},
				},
			},
		})

		vim.lsp.config("markdown_oxide", {
			-- Ensure that dynamicRegistration is enabled! This allows the LS to take into account actions like the
			-- Create Unresolved File code action, resolving completions for unindexed code blocks, ...
			capabilities = vim.tbl_deep_extend("force", capabilities, {
				workspace = {
					didChangeWatchedFiles = {
						dynamicRegistration = true,
					},
				},
			}),
		})
		vim.lsp.enable("markdown_oxide")
	end,
}
