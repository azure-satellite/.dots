local M = {}

-- TODO: compose/flow
-- map(function, table)
-- e.g: map(double, {1,2,3})    -> {2,4,6}
function M.map(fun, iter)
  local results = {}
  for _, v in pairs(iter) do
    table.insert(results, fun(v))
  end
  return results
end

-- head(table)
-- e.g: head({1,2,3}) -> 1
function M.head(tbl)
  return tbl[1]
end

-- tail(table)
-- e.g: tail({1,2,3}) -> {2,3}
--
-- XXX This is a BAD and ugly implementation.
-- should return the address to next pointer, like in C (arr+1)
function M.tail(tbl)
  if table.getn(tbl) < 1 then
    return nil
  else
    local newtbl = {}
    local tblsize = table.getn(tbl)
    local i = 2
    while (i <= tblsize) do
      table.insert(newtbl, i - 1, tbl[i])
      i = i + 1
    end
    return newtbl
  end
end

-- foldr(function, default_value, table)
-- e.g: foldr(operator.mul, 1, {1,2,3,4,5}) -> 120
function M.foldr(func, val, tbl)
  for _, v in ipairs(tbl) do
    val = func(val, v)
  end
  return val
end

-- reduce(function, table)
-- e.g: reduce(operator.add, {1,2,3,4}) -> 10
function M.reduce(func, tbl)
  return M.foldr(func, M.head(tbl), M.tail(tbl))
end

return M
