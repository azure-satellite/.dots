vim.g.dirvish_mode = 2

U.map("n", "<bs>", "<plug>(dirvish_up)")

U.noremap("n", "<space><bs>", "<cmd>Dirvish<cr>", {silent = true})

U.noremap(
  "n",
  "g<bs>",
  "<cmd>exe 'Dirvish ' . fnamemodify(b:git_dir, ':h')<cr>",
  {silent = true}
)

U.au(
  {
    event = "FileType",
    pattern = "dirvish",
    cmd = function()
      -- Sort directories first
      vim.cmd("sort ,^.*[\\/],")
      -- Reload after entering a dirvish window
      U.buf_map("n", "q", "gq")
      U.au(
        {
          event = {"FocusGained"},
          pattern = "<buffer>",
          cmd = "Dirvish %"
        }
      )
    end
  }
)
