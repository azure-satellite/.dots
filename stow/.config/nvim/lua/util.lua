local M = {}

local function map_callback(cmd)
  if type(cmd) == "string" then
    return cmd
  end
  return string.format("<cmd>%s<cr>", site.callback(cmd))
end

function M.map(mode, lhs, rhs, opts)
  vim.api.nvim_set_keymap(mode, lhs, map_callback(rhs), opts or {})
end

function M.noremap(mode, lhs, rhs, opts)
  vim.api.nvim_set_keymap(
    mode,
    lhs,
    map_callback(rhs),
    vim.tbl_extend("force", opts or {}, {noremap = true})
  )
end

function M.buf_map(mode, lhs, rhs, opts)
  vim.api.nvim_buf_set_keymap(0, mode, lhs, map_callback(rhs), opts or {})
end

function M.buf_noremap(mode, lhs, rhs, opts)
  vim.api.nvim_buf_set_keymap(
    0,
    mode,
    lhs,
    map_callback(rhs),
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
        type(spec.event) == "table" and table.concat(spec.event, ",") or
          spec.event,
        spec.pattern or "*",
        spec.once and "++once" or "",
        spec.nested and "++nested" or "",
        site.callback(spec.cmd)
      },
      " "
    )
  )
end

return M
