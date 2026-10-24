return {
	"mfussenegger/nvim-dap",
	event = "VeryLazy",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"rcarriga/nvim-dap-ui",
		"theHamsta/nvim-dap-virtual-text",
		"mfussenegger/nvim-dap-python",
		{
			"jay-babu/mason-nvim-dap.nvim",
			dependencies = { "williamboman/mason.nvim" },
			opts = {
				ensure_installed = { "codelldb" },
				handlers = {}, -- configured manually below for full control
			},
		},
	},

	config = function()
		local dap = require("dap")
		local dapui = require("dapui")
		local dap_vt = require("nvim-dap-virtual-text")
		local dap_python = require("dap-python")

		-------------------------------------------------
		-- UI & virtual text
		-------------------------------------------------
		dapui.setup()
		dap_vt.setup({ commented = true })

		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end

		dap_python.setup("debugpy-adapter")

		-- C/C++
		-- Mason installs codelldb under:
		--   %LOCALAPPDATA%\nvim-data\mason\packages\codelldb\extension\adapter\codelldb.exe
		local mason_registry = require("mason-registry")
		local codelldb_path = mason_registry.get_package("codelldb"):get_install_path()
			.. "/extension/adapter/codelldb.exe"

		dap.adapters.codelldb = {
			type = "server",
			port = "${port}",
			executable = {
				command = codelldb_path,
				args = { "--port", "${port}" },
				-- Important on Windows
				detached = false,
			},
		}

		-- Shared configuration for C and C++
		local cpp_config = {
			{
				name = "Launch (codelldb)",
				type = "codelldb",
				request = "launch",
				program = function()
					-- Looks for the binary next to compile_commands.json build/ dir
					return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "\\build\\", "file")
				end,
				cwd = "${workspaceFolder}",
				stopOnEntry = false,

				-- Interactive prompt for arguments
				args = function()
					local input = vim.fn.input("Arguments: ")
					return vim.split(input, " +", { trimempty = true })
				end,

				-- Useful for WinAPI apps that create windows
				-- console = "integratedTerminal",
			},
			{
				name = "Attach to process",
				type = "codelldb",
				request = "attach",
				pid = require("dap.utils").pick_process,
				args = {},
			},
		}

		dap.configurations.c = cpp_config
		dap.configurations.cpp = cpp_config

		local keymap = vim.keymap
		keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
		keymap.set("n", "<leader>dc", dap.continue, { desc = "Start / Continue" })
		keymap.set("n", "<leader>di", dap.step_into, { desc = "Step into" })
		keymap.set("n", "<leader>dO", dap.step_out, { desc = "Step out" })
		keymap.set("n", "<leader>do", dap.step_over, { desc = "Step over" })
		keymap.set("n", "<leader>de", function()
			dapui.eval(nil, { enter = true })
		end, { desc = "Eval under cursor" })
		keymap.set("n", "<leader>dt", dap.terminate, { desc = "Terminate" })
		keymap.set("n", "<leader>dr", dap.repl.open, { desc = "Open REPL" })
	end,
}
