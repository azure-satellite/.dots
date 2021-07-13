local wk = require "which-key"
local builtin = require "telescope.builtin"
local themes = require "telescope.themes"

require "telescope".setup {
  defaults = {
    -- vimgrep_arguments = vim.g.grepprg,
    sorting_strategy = "ascending",
    layout_config = {prompt_position = "top"}
  }
}

local get_cwd = function()
  return vim.o.ft == "dirvish" and vim.b.dirvish._dir
end

local file_picker_theme = function(opts)
  return themes.get_ivy(
    vim.tbl_extend(
      "force",
      {previewer = false},
      -- {previewer = false, entry_maker = entry_maker()},
      opts
    )
  )
end

local mappings = {
  g = {
    function()
      builtin.git_files(file_picker_theme({show_untracked = false}))
    end,
    "Git Files"
  },
  j = {
    function()
      builtin.git_branches({previewer = false})
    end,
    "Git Branches"
  },
  f = {
    function()
      builtin.find_files(file_picker_theme({cwd = get_cwd(), hidden = true}))
    end,
    "Files"
  },
  b = {
    function()
      builtin.buffers(file_picker_theme({sort_lastused = true}))
    end,
    "Buffers"
  },
  i = {
    function()
      builtin.oldfiles(file_picker_theme({}))
    end,
    "File History"
  },
  l = {
    function()
      builtin.current_buffer_fuzzy_find({previewer = false})
    end,
    "Buffer Lines"
  },
  r = {
    function()
      builtin.live_grep({cwd = get_cwd()})
    end,
    "Live Grep"
  },
  h = {
    function()
      builtin.help_tags({})
    end,
    "Help Tags"
  }
}

wk.register(mappings, {prefix = "<space>"})
