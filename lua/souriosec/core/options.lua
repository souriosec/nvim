vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

opt.relativenumber = true -- show relative line numbers
opt.number = true -- show absolute line number on cursor line
opt.tabstop = 2 -- 2 spaces for tabs
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line onto new line
opt.wrap = false -- disable line wrap
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- set case sensitive search on mixed-case search
opt.cursorline = true -- highlight the current cursor line
opt.termguicolors = true -- colorscheme fix
opt.background = "dark" -- set colorscheme dark background
opt.signcolumn = "yes" -- show sign column so text doesn't shift
opt.backspace = "indent,eol,start" -- allow backspace
opt.clipboard:append("unnamedplus") -- use system clipboard
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom
opt.swapfile = false -- turn of swap file
opt.scrolloff = 12
