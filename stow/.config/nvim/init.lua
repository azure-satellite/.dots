local util = require("util")

-- http://lua-users.org/wiki/StringIndexing
getmetatable("").__index = function(str, i)
  if type(i) == "number" then
    return string.sub(str, i, i)
  else
    return string[i]
  end
end

-- The most important function ever
_G.dump = function(...)
  print(vim.inspect(...))
end

-- Expose globals for vimscript and manual use
_G.site = {
  __callbacks = {}, -- For storing lua functions used in commands and autocommands
  callback = function(fn)
    local key = tostring(fn)
    site.__callbacks[key] = fn
    if type(fn) == "string" then
      return fn
    end
    return string.format("site.__callbacks['%s']()", key)
  end,
  util = util
  -- lsp = {util = require("lsp/util")}
}

require("options")
require("mappings")
require("colorscheme")
require("init_packer")

-- Reload colors when the colorscheme is changed
util.au(
  {
    event = "BufWritePost",
    pattern = "colorscheme.lua",
    cmd = ":hi! clear | luafile <afile>"
  }
)

-- Recompile plugins whenever plugins.lua is updated.
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

-- Execute {buf,win,tab,arg}do and return to initial window/buffer
vim.cmd("command! -nargs=+ -complete=command Windo call core#windo(<q-args>)")
vim.cmd("command! -nargs=+ -complete=command Bufdo call core#bufdo(<q-args>)")
vim.cmd("command! -nargs=+ -complete=command Tabdo call core#tabdo(<q-args>)")
vim.cmd("command! -nargs=+ -complete=command Argdo call core#argdo(<q-args>)")

-- Execute command and redirect output to new window
vim.cmd("command! -nargs=1 -complete=command Out call core#out(<q-args>)")

local function completion_search(s_arr, prefix, r_arr)
  if #s_arr == 0 then
    return
  end
  if not r_arr then
    r_arr = _G
  end
  local head = table.remove(s_arr, 1)
  if type(r_arr[head]) == "table" then
    prefix = prefix .. head .. "."
    return completion_search(s_arr, prefix, r_arr[head])
  end
  local result = {}
  local keys = vim.tbl_keys(r_arr)
  table.sort(keys)
  for _, v in ipairs(keys) do
    local regex = "^" .. string.gsub(head, "%*", ".*")
    if v:find(regex) then
      table.insert(result, prefix .. v)
    end
  end
  return result
end

-- https://github.com/rafcamlet/nvim-luapad/blob/master/lua/luapad/completion.lua
local function complete_lua(line)
  local index = line:find("[%w._*]*$")
  local cmd = line:sub(index)
  local prefix = line:sub(1, index - 1)
  local arr = vim.split(cmd, ".", true)
  return completion_search(arr, prefix)
end

site.__callbacks["complete_lua"] = complete_lua
local lua_complete = "-complete=customlist,v:lua.site.__callbacks.complete_lua"

-- Just to have autocompletion on :lua
vim.cmd("command! -nargs=1 " .. lua_complete .. " Lua lua <args>")

-- Composition of lua and out
vim.cmd(
  "command! -nargs=1 " ..
    lua_complete .. " LuaOut call core#out('lua dump('.<q-args>.')')"
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

util.au(
  {
    event = {"BufNewFile", "BufRead"},
    pattern = "*.nix",
    cmd = "set ft=nix"
  }
)
