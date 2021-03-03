local util = require "util"

vim.g.coc_fzf_opts = {"--layout=reverse"}

util.noremap("n", "<space>a", "<cmd>CocFzfList actions<cr>", {silent = true})
util.noremap("n", "<space>c", "<cmd>CocFzfList commands<cr>", {silent = true})
util.noremap(
  "n",
  "<space>d",
  "<cmd>CocFzfList diagnostics<cr>",
  {silent = true}
)
util.noremap("n", "<space>o", "<cmd>CocFzfList outline<cr>", {silent = true})
util.noremap("n", "<space>s", "<cmd>CocFzfList snippets<cr>", {silent = true})
util.noremap("n", "<space>w", "<cmd>CocFzfList symbols<cr>", {silent = true})
