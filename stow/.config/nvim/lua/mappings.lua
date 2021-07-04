-- Insert
U.noremap("i", "jk", "<esc>")
U.noremap("i", "<c-c>", "<esc>") -- <c-c> doesn't trigger InsertLeave
U.noremap("i", "<c-u>", "<c-g>u<c-u>") -- Remember <c-u> as a new change

-- Normal

U.noremap("n", ",", ":")
U.noremap("n", "Y", "y$")
U.noremap("n", "k", "gk")
U.noremap("n", "j", "gj")
U.noremap("n", "<c-j>", "<cmd>wall<cr>")
U.noremap("n", "<c-l>", "<cmd>tabnext<cr>", {silent = true})
U.noremap("n", "<c-h>", "<cmd>tabprevious<cr>", {silent = true})

-- Open url under cursor
U.noremap(
  "n",
  "go",
  '<Cmd>call jobstart(["open", expand("<cfile>")], {"detach": v:true})<CR>'
)

-- Toggle location window
U.noremap(
  "n",
  "<leader>w",
  '(get(getloclist(0, {"winid": 1}), "winid") != 0? "<cmd>lclose" : "<cmd>lopen") . "<cr><cmd>wincmd p<cr>"',
  {expr = true}
)

-- Toggle quickfix window
U.noremap(
  "n",
  "<leader>q",
  '(get(getqflist({"winid": 1}), "winid") != 0? "<cmd>cclose" : "<cmd>botright copen") . "<cr><cmd>wincmd p<cr>"',
  {silent = true, expr = true}
)

-- Toggle syntax a là unimpaired
U.noremap(
  "n",
  "yoy",
  '"<cmd>set syntax=" . (&syntax == "ON" ? "OFF" : "ON") . "<cr>"',
  {silent = true, expr = true}
)

-- Visually select last pasted text
U.noremap("n", "gp", '"`[" . strpart(getregtype(), 0, 1) . "`]"', {expr = true})

-- Visual

U.noremap("v", ",", ":")
U.noremap("v", "v", "<esc>")
U.noremap("v", "j", "gj")
U.noremap("v", "k", "gk")

-- Command

-- :h c_<Down> c_<Up>
U.noremap("c", "<c-n>", "<down>")
U.noremap("c", "<c-p>", "<up>")

-- Expand to directory of current file.
U.noremap("c", "%%", '<c-r>=fnameescape(expand("%:~:h"))<cr>')

-- Terminal

U.noremap("t", "jk", "<c-\\><c-n>")
