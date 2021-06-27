local M = {}

function M.set_indent(num)
  vim.bo.tabstop = num
  vim.bo.shiftwidth = num
  vim.bo.softtabstop = num
end

local function is_file_like()
  local type = vim.bo.buftype
  return type == "" or type == "acwrite" or type == "nowrite"
end

-- function M.statusline_file()
--   let l:file = expand(@%)
--   if get(g:, 'loaded_conflicted')
--     let l:version = trim(ConflictedVersion())
--     if !empty(l:version) && l:version !=? 'working'
--       return l:version
--     else
--       return l:file
--     endif
--   else
--     return l:file
--   endif
-- end

return M
