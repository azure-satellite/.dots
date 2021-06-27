-- Allow string indexing (e.x. string_var[2])
-- http://lua-users.org/wiki/StringIndexing
getmetatable("").__index = function(str, i)
  if type(i) == "number" then
    return string.sub(str, i, i)
  else
    return string[i]
  end
end

-- Pretty print lua value
_G.dump = function(...)
  print(vim.inspect(...))
end

-- Used to store lua functions used in commands and autocommands
_G.__callbacks = {}

_G.callback = function(fn)
  local key = tostring(fn)
  _G.__callbacks[key] = fn
  if type(fn) == "string" then
    return fn
  end
  return string.format("_G.__callbacks['%s']()", key)
end
