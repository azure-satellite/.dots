-- Reload colors when the colorscheme is changed.
U.au(
  {event = "BufWritePost", pattern = "*/colors/furnisher.lua", cmd = "luafile <afile>"}
)

-- https://github.com/neovim/neovim/issues/1936
U.au({event = "FocusGained", cmd = ":checktime"})

-- https://old.reddit.com/r/neovim/comments/gofplz/neovim_has_added_the_ability_to_highlight_yanked/
U.au({event = "TextYankPost", cmd = "lua vim.highlight.on_yank({ timeout = 300 })"})

-- TODO: This should be a ftdetect file
U.au({event = {"BufNewFile", "BufRead"}, pattern = "*.nix", cmd = "set ft=nix"})
