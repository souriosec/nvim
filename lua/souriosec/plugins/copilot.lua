return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		opts = {
			suggestion = { enabled = false }, -- Disable inline to avoid overlap
			panel = { enabled = false },
		},
	},
}
