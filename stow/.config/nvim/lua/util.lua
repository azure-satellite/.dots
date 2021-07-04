local M = {}

-- Allow string indexing (e.x. string_var[2])
-- http://lua-users.org/wiki/StringIndexing
getmetatable("").__index = function(str, i)
  if type(i) == "number" then
    return string.sub(str, i, i)
  else
    return string[i]
  end
end

M.os = {
  home = os.getenv("HOME"),
  data = vim.fn.stdpath("data"),
  cache = vim.fn.stdpath("cache"),
  config = vim.fn.stdpath("config")
}

-- Pretty print lua value
function M.dump(...)
  print(vim.inspect(...))
end

-- Used to store lua functions used in commands and autocommands
__Callbacks = {}

function M.callback(fn)
  local key = tostring(fn)
  __Callbacks[key] = fn
  if type(fn) == "string" then
    return fn
  end
  return string.format("__Callbacks['%s']()", key)
end

function M.set_indent(num)
  vim.bo.tabstop = num
  vim.bo.shiftwidth = num
  vim.bo.softtabstop = num
end

local function map_callback(cmd, expr)
  if type(cmd) == "string" then
    return cmd
  end
  if expr == true then
    return string.format('luaeval("%s")', U.callback(cmd))
  end
  return string.format("<cmd>lua %s<cr>", U.callback(cmd))
end

function M.map(mode, lhs, rhs, opts)
  vim.api.nvim_set_keymap(mode, lhs, map_callback(rhs, (opts or {}).expr), opts or {})
end

function M.noremap(mode, lhs, rhs, opts)
  vim.api.nvim_set_keymap(
    mode,
    lhs,
    map_callback(rhs, (opts or {}).expr),
    vim.tbl_extend("force", opts or {}, {noremap = true})
  )
end

function M.buf_map(mode, lhs, rhs, opts)
  vim.api.nvim_buf_set_keymap(
    0,
    mode,
    lhs,
    map_callback(rhs, (opts or {}).expr),
    opts or {}
  )
end

function M.buf_noremap(mode, lhs, rhs, opts)
  vim.api.nvim_buf_set_keymap(
    0,
    mode,
    lhs,
    map_callback(rhs, (opts or {}).expr),
    vim.tbl_extend("force", opts or {}, {noremap = true})
  )
end

-- https://github.com/vheon/ycm.nvim/blob/585c7b645db705ed76700b692bc5da7a738fd22f/lua/ycm/autocmd.lua

-- Just some lua for defining autocmds.
-- It mimics https://github.com/neovim/neovim/pull/12076 so that when it is
-- merged we can just lose this file.

function M.augroup(group, opts)
  vim.cmd("augroup " .. group)
  if opts.clear then
    vim.cmd("au!")
  end
  vim.cmd("augroup END")
end

function M.au(spec)
  vim.cmd(
    table.concat(
      {
        "au!",
        spec.group or "",
        type(spec.event) == "table" and table.concat(spec.event, ",") or spec.event,
        spec.pattern or "*",
        spec.once and "++once" or "",
        spec.nested and "++nested" or "",
        string.format(
          "%s%s",
          type(spec.cmd) == "string" and "" or "lua ",
          U.callback(spec.cmd)
        )
      },
      " "
    )
  )
end

return M
