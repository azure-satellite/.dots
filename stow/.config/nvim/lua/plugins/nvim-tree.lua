local util = require "util"

vim.g.nvim_tree_ignore = {".git", "node_modules"}
vim.g.nvim_tree_show_icons = {git = 0, folders = 0, files = 0}
vim.g.nvim_tree_auto_close = 1 -- Close if last window

util.noremap("n", "<space>t", "<cmd>NvimTreeToggle<cr>", {silent = true})
