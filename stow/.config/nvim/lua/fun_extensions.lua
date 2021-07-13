local M = {}

-- XXX: This causes a stack overflow on large arrays
-- See: https://github.com/luafun/luafun/issues/39
M.flatten = function(x)
  return foldl(chain, {}, x)
end

M.join = function(sep, x)
  return foldl(
    function(acc, x)
      return acc == "" and x or acc .. sep .. x
    end,
    "",
    x
  )
end

return M
