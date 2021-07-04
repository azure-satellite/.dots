require "telescope".setup {
  defaults = {
    sorting_strategy = "ascending",
    layout_config = {
      prompt_position = "top",
      horizontal = {
        width_padding = 3,
        height_padding = 1
      }
    }
  }
}

U.noremap(
  "n",
  "<space>r",
  '"<cmd>lua require(\'telescope.builtin\').live_grep(" . (&ft ==# "dirvish" ? "{cwd=\'%\'}" : "") . ")<cr>"',
  {silent = true, expr = true}
)
