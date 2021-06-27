local util = require("util")

-- Insert

util.noremap("i", "jk", "<esc>")
util.noremap("i", "<c-c>", "<esc>") -- <c-c> doesn't trigger InsertLeave
util.noremap("i", "<c-u>", "<c-g>u<c-u>") -- Remember <c-u> as a new change

-- Normal

util.noremap("n", ",", ":")
util.noremap("n", "Y", "y$")
util.noremap("n", "k", "gk")
util.noremap("n", "j", "gj")
util.noremap("n", "<c-j>", "<cmd>wall<cr>")
util.noremap("n", "<c-l>", "<cmd>tabnext<cr>", {silent = true})
util.noremap("n", "<c-h>", "<cmd>tabprevious<cr>", {silent = true})

-- Toggle location window
util.noremap(
  "n",
  "<leader>w",
  '(get(getloclist(0, {"winid": 1}), "winid") != 0? "<cmd>lclose" : "<cmd>lopen") . "<cr><cmd>wincmd p<cr>"',
  {expr = true}
)

-- Toggle quickfix window
util.noremap(
  "n",
  "<leader>q",
  '(get(getqflist({"winid": 1}), "winid") != 0? "<cmd>cclose" : "<cmd>botright copen") . "<cr><cmd>wincmd p<cr>"',
  {silent = true, expr = true}
)

-- Toggle tabline a là unimpaired
util.noremap(
  "n",
  "yot",
  '"<cmd>set showtabline=" . (&showtabline != 2 ? 2 : 0) . "<cr>"',
  {silent = true, expr = true}
)

-- Toggle syntax a là unimpaired
util.noremap(
  "n",
  "yoy",
  '"<cmd>set syntax=" . (&syntax == "ON" ? "OFF" : "ON") . "<cr>"',
  {silent = true, expr = true}
)

-- Visually select last pasted text
util.noremap(
  "n",
  "gp",
  '"`[" . strpart(getregtype(), 0, 1) . "`]"',
  {expr = true}
)

-- Visual

util.noremap("v", ",", ":")
util.noremap("v", "v", "<esc>")
util.noremap("v", "j", "gj")
util.noremap("v", "k", "gk")

-- Command

-- :h c_<Down> c_<Up>
util.noremap("c", "<c-n>", "<down>")
util.noremap("c", "<c-p>", "<up>")

-- Expand to directory of current file.
util.noremap("c", "%%", '<c-r>=fnameescape(expand("%:~:h"))<cr>')

-- Terminal

util.noremap("t", "jk", "<c-\\><c-n>")
