-- The most important function ever
_G.dump = function(...)
  print(vim.inspect(...))
end

-- Expose globals for vimscript and manual use
_G.site = {
  util = require("util"),
  lsp = {util = require("lsp/util")},
  packer = {
    recompile_plugins = function()
      package.loaded.plugins = nil
      package.loaded.init_packer = nil
      require("init_packer")
      require("packer").compile()
    end
  }
}

require("options")
require("mappings")
require("colorscheme")
require("init_packer")

-- Recompile plugins whenever plugins.lua is updated.
vim.cmd("au BufWritePost plugins.lua :call v:lua.site.packer.recompile_plugins()")

-- Execute {buf,win,tab,arg}do and return to initial window/buffer
vim.cmd("command! -nargs=+ -complete=command Windo call core#windo(<q-args>)")
vim.cmd("command! -nargs=+ -complete=command Bufdo call core#bufdo(<q-args>)")
vim.cmd("command! -nargs=+ -complete=command Tabdo call core#tabdo(<q-args>)")
vim.cmd("command! -nargs=+ -complete=command Argdo call core#argdo(<q-args>)")

-- Execute command and redirect output to new window
vim.cmd("command! -nargs=1 -complete=command Out call core#out(<q-args>)")

-- Just to have autocompletion on :lua
vim.cmd(
  "command! -nargs=1 -complete=customlist,v:lua.site.util.complete_lua Lua lua <args>"
)

-- Composition of lua and out
vim.cmd(
  "command! -nargs=1 -complete=customlist,v:lua.site.util.complete_lua LuaOut call core#out('lua dump('.<q-args>.')')"
)

-- https://github.com/neovim/neovim/issues/1936
vim.cmd("au FocusGained * :checktime")
