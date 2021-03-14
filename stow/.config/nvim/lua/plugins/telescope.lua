local util = require "util"

require "telescope".setup {
  defaults = {
    prompt_position = "top",
    sorting_strategy = "ascending",
    layout_defaults = {
      horizontal = {
        width_padding = 3,
        height_padding = 1
      }
    }
  }
}

util.noremap(
  "n",
  "<space>r",
  '"<cmd>lua require(\'telescope.builtin\').live_grep(" . (&ft ==# "dirvish" ? "{cwd=\'%\'}" : "") . ")<cr>"',
  {silent = true, expr = true}
)
