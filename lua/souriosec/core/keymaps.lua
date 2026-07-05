vim.g.mapleader = " " -- set leader to space

local keymap = vim.keymap

-- Search
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- Increment/Decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" })
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

-- Window management: Splits
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
keymap.set("n", "<leader>sc", "<cmd>close<CR>", { desc = "Close current window" })

-- Window management: Buffers
keymap.set("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "Next buffer" })
keymap.set("n", "<leader>bp", "<cmd>bprev<CR>", { desc = "Prev buffer" })
keymap.set("n", "<leader>bb", "<cmd>e #<CR>", { desc = "Alternate buffer (last used)" })
keymap.set("n", "<leader>bo", "<cmd>only<CR>", { desc = "Open split in new window" })

-- Start: File/Image management
keymap.set("n", "<leader>io", function()
	local file = vim.fn.expand("<cfile>")
	vim.fn.system('open "' .. file .. '"')
end, { desc = "Open new note" })

keymap.set("n", "<leader>nn", function()
	-- Prompt for a file name
	local input = vim.fn.input("Note name (empty = datetime): ")

	local filename
	if input == "" then
		-- Generate datetime + weekday, e.g. 20260628-200810-Sunday
		local weekdays = { "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday" }
		local weekday = weekdays[tonumber(os.date("%w")) + 1]
		filename = os.date("%Y%m%d-%H%M%S") .. "-" .. weekday
	else
		-- Sanitize: replace spaces with dashes, strip unsafe chars
		filename = input:gsub("%s+", "-"):gsub("[^%w%-_]", "")
	end

	local notes_dir = vim.fn.expand("~/Documents/notes")
	local filepath = notes_dir .. "/" .. filename .. ".md"

	-- Make sure the directory exists
	vim.fn.mkdir(notes_dir, "p")

	-- Open the file in a new buffer
	vim.cmd("edit " .. vim.fn.fnameescape(filepath))

	-- Seed the file with a title heading if it's brand new
	if vim.fn.filereadable(filepath) == 0 then
		local title = (input ~= "") and input or filename
		vim.api.nvim_buf_set_lines(0, 0, -1, false, {
			"# " .. title,
			"",
		})
		vim.cmd("normal! G") -- jump to end so cursor is ready to type
	end
end, { desc = "Open new note" })
-- End: File/Image management

-- Terminal Management
vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]])
vim.keymap.set("n", "<leader>tt", function()
	local height = math.floor(vim.o.lines * 0.33) -- bottom 1/3
	vim.cmd("botright " .. height .. "split | terminal") -- span full width
	vim.cmd("startinsert") -- start in insert mode
end, { desc = "Open terminal" })
