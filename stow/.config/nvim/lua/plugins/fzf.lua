vim.g.fzf_layout = {window = {width = 0.8, height = 0.8}}

U.noremap("n", "<space>,", "<cmd>History:<cr>", {silent = true})
U.noremap("n", "<space>/", "<cmd>History/<cr>", {silent = true})
U.noremap("n", "<space>h", "<cmd>Helptags<cr>", {silent = true})
U.noremap("n", "<space>i", "<cmd>History<cr>", {silent = true})
U.noremap("n", "<space>b", "<cmd>Buffers<cr>", {silent = true})
U.noremap("n", "<space>l", "<cmd>BLines<cr>", {silent = true})

U.noremap(
  "n",
  "<space>f",
  "'<cmd>Files ' . (&ft ==# 'dirvish' ? fnamemodify(expand('%'), ':~:h') : '') . '<cr>'",
  {silent = true, expr = true}
)

U.noremap(
  "n",
  "<space>g",
  "'<cmd>GLFiles ' . (&ft ==# 'dirvish' ? fnamemodify(expand('%'), ':~:h') : '') . '<cr>'",
  {silent = true, expr = true}
)

-- U.noremap(
--   "n",
--   "<space>r",
--   "'<cmd>Rg ' . (&ft ==# 'dirvish' ? fnamemodify(expand('%'), ':~:h') : '') . '<cr>'",
--   {silent = true, expr = true}
-- )
