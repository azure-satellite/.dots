local util = require "util"

vim.g.grepper = {
  switch = 0,
  dir = "repo,file,pwd",
  side_cmd = "tabnew",
  tools = {"rg", "rgall"},
  operator = {prompt = 1},
  rg = {grepprg = vim.o.grepprg},
  rgall = {grepprg = vim.o.grepprg .. " --no-ignore-vcs"}
}

util.map("n", "gs", "<Plug>(GrepperOperator)")

util.noremap(
  "n",
  "gss",
  "'<cmd>Grepper ' . (&ft ==# 'dirvish' ? '-dir file' : '') . '<cr>'",
  {silent = true, expr = true}
)

util.noremap(
  "n",
  "gsl",
  "'<cmd>Grepper -noquickfix ' . (&ft ==# 'dirvish' ? '-dir file' : '') . '<cr>'",
  {silent = true, expr = true}
)
