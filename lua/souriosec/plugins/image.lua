return {
	"3rd/image.nvim",
	build = false, -- so that it doesn't build the rock https://github.com/3rd/image.nvim/issues/91#issuecomment-2453430239
	opts = {
		processor = "magick_cli",
	},

	config = function()
		require("image").setup({
			integrations = {
				markdown = {
					clear_in_insert_mode = true,
					only_render_image_at_cursor = true,
					only_render_image_at_cursor_mode = "popup",
				},
			},
			tmux_show_only_in_active_window = true, -- hides image when pane loses focus
		})
	end,
}
