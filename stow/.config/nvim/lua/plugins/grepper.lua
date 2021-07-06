vim.g.grepper = {
  switch = 0,
  dir = "repo,file,pwd",
  side_cmd = "tabnew",
  tools = {"rg", "rgall"},
  operator = {prompt = 1},
  rg = {grepprg = vim.o.grepprg},
  rgall = {grepprg = vim.o.grepprg .. " --no-ignore-vcs"}
}

U.map("n", "gs", "<Plug>(GrepperOperator)")

U.noremap(
  "n",
  "<space>s",
  "'<cmd>Grepper ' . (&ft ==# 'dirvish' ? '-dir file' : '') . '<cr>'",
  {silent = true, expr = true}
)
