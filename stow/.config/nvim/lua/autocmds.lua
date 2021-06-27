local util = require("util")

-- Reload colors when the colorscheme is changed.
util.au(
  {
    event = "BufWritePost",
    pattern = "colorscheme.lua",
    cmd = ":hi! clear | luafile <afile>"
  }
)

-- Recompile plugins when plugins.lua is updated.
util.au(
  {
    event = "BufWritePost",
    pattern = "plugins.lua",
    cmd = function()
      package.loaded.plugins = nil
      package.loaded.init_packer = nil
      require("init_packer")
      require("packer").compile()
    end
  }
)

-- https://github.com/neovim/neovim/issues/1936
util.au({event = "FocusGained", cmd = ":checktime"})

-- https://old.reddit.com/r/neovim/comments/gofplz/neovim_has_added_the_ability_to_highlight_yanked/
util.au(
  {
    event = "TextYankPost",
    cmd = "lua vim.highlight.on_yank({ timeout = 300 })"
  }
)

-- TODO: This should be a ftdetect file
util.au(
  {
    event = {"BufNewFile", "BufRead"},
    pattern = "*.nix",
    cmd = "set ft=nix"
  }
)
