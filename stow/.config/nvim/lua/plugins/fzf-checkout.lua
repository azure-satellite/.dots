local util = require "util"

-- TODO:
-- Is there a way of getting the git root from the current buffer?
-- Deleting current branch doesn't work
-- Local prefix?
vim.g.fzf_checkout_git_bin = "hub"
vim.g.fzf_checkout_merge_settings = true
vim.g.fzf_branch_actions = {
  track = {
    keymap = "ctrl-o"
  }
}

util.noremap("n", "<space>j", "<cmd>GBranches --locals<cr>", {silent = true})
util.noremap("n", "<space>k", "<cmd>GBranches --remotes<cr>", {silent = true})
