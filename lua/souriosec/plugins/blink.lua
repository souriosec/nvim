return {
	"saghen/blink.cmp",
	dependencies = {
		"rafamadriz/friendly-snippets",
		"fang2hou/blink-copilot",
	},

	version = "1.*",

	opts = {
		completion = {
			menu = { border = "single" },
			documentation = {
				auto_show = true, -- Automatically show documentation
				auto_show_delay_ms = 100, -- Delay before showing
				window = {
					border = "single", -- or "single", "double", "none"
				},
			},
		},
		sources = {
			default = { "lsp", "buffer", "snippets", "path", "copilot" },
			providers = {
				copilot = {
					name = "copilot",
					module = "blink-copilot",
					score_offset = 100,
					async = true,
					opts = {
						max_completions = 3,
						max_attempts = 4,
						kind_name = "Copilot",
						kind_icon = " ",
						kind_hl = false,
						debounce = 200,
						auto_refresh = {
							backward = true,
							forward = true,
						},
					},
				},
			},
		},
	},
}
