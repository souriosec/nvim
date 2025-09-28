return {
	"mfussenegger/nvim-dap",
	event = "VeryLazy",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"rcarriga/nvim-dap-ui",
		"mfussenegger/nvim-dap",
		"theHamsta/nvim-dap-virtual-text",
		"mfussenegger/nvim-dap-python",
	},

	opts = {
		handlers = {},
	},

	config = function()
		local dap = require("dap")
		local dapui = require("dapui")
		local dap_python = require("dap-python")
		local dap_vt = require("nvim-dap-virtual-text")

		dapui.setup()
		dap_vt.setup({ commented = true })
		dap_python.setup("debugpy-adapter")

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

		local keymap = vim.keymap
		keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Add breakpoint" })
		keymap.set("n", "<leader>dc", dap.continue, { desc = "Start or continue the debugger" })
		keymap.set("n", "<leader>di", dap.step_into, { desc = "Step into" })
		keymap.set("n", "<leader>dO", dap.step_out, { desc = "Step out" })
		keymap.set("n", "<leader>do", dap.step_over, { desc = "Step over" })
		keymap.set("n", "<leader>de", function()
			dapui.eval(nil, { enter = true })
		end, { desc = "Eval under cursor" })
	end,
}
