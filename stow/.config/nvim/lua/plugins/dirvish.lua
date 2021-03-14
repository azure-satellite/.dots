local util = require "util"

vim.g.dirvish_mode = 2

util.map("n", "<bs>", "<plug>(dirvish_up)")

util.noremap("n", "<space><bs>", "<cmd>Dirvish<cr>", {silent = true})

util.noremap(
  "n",
  "g<bs>",
  "<cmd>exe 'Dirvish ' . fnamemodify(b:git_dir, ':h')<cr>",
  {silent = true}
)

util.au(
  {
    event = "FileType",
    pattern = "dirvish",
    cmd = function()
      local util = require("util")
      -- Sort directories first
      vim.cmd("sort ,^.*[\\/],")
      -- Reload after entering a dirvish window
      util.buf_map("n", "q", "gq")
      util.au(
        {
          event = {"FocusGained"},
          pattern = "<buffer>",
          cmd = "Dirvish %"
        }
      )
    end
  }
)
