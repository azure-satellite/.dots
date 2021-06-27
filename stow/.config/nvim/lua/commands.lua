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

_G.__callbacks["complete_lua"] = complete_lua
local lua_complete = "-complete=customlist,v:lua._G.__callbacks.complete_lua"

-- Just to have autocompletion on :lua
vim.cmd("command! -nargs=1 " .. lua_complete .. " Lua lua <args>")

-- Composition of lua and out
vim.cmd(
  "command! -nargs=1 " ..
    lua_complete .. " LuaOut call core#out('lua dump('.<q-args>.')')"
)
