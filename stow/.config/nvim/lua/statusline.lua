local c = require "theme"
local has_devicons, devicons = pcall(require, "nvim-web-devicons")

local function buf_icon(buf)
  local icon = devicons.get_icon(vim.fn.fnamemodify(buf.name, ":e"))
  return icon and icon .. "  " or ""
end

local function diagnostics(buf, is_active)
  if not vim.tbl_isempty(vim.lsp.buf_get_clients(buf.bufnr)) then
    local e = vim.lsp.diagnostic.get_count(buf.bufnr, "Error")
    local w = vim.lsp.diagnostic.get_count(buf.bufnr, "Warning")
    local section = string.format(" %i  %i", e, w)
    if is_active then
      if e > 0 then
        return string.format("%%#LspDiagnosticsStatusError# %s %%*", section)
      elseif w > 0 then
        return string.format("%%#LspDiagnosticsStatusWarning# %s %%*", section)
      end
    end
    return string.format(" %s ", section)
  end
end

-- https://github.com/neovim/neovim/blob/master/runtime/lua/vim/lsp/handlers.lua#L29
-- Extend the default neovim progress handler to add a sequence number to each
-- progress message so we can display the correct spinner frame on redrawing the
-- statusline.
local progress_handler = vim.lsp.handlers["$/progress"]
vim.lsp.handlers["$/progress"] = function(_, _, params, client_id)
  -- Invoke default progress handler
  progress_handler(nil, nil, params, client_id)
  -- Add a sequence number to the progress message so we can show a spinner
  -- progression
  local client = vim.lsp.get_client_by_id(client_id)
  local seq = client.messages.progress[params.token].seq
  client.messages.progress[params.token].seq = seq and seq + 1 or 0
  -- Redraw all status lines
  vim.cmd("redrawstatus!")
end

local spinners = {"⣷", "⣯", "⣟", "⡿", "⢿", "⣻", "⣽", "⣾"}

local function servers_progress(buf)
  local section = nil
  local clients = vim.lsp.buf_get_clients(buf.bufnr)
  for _, client in pairs(clients) do
    local progress = client.messages.progress
    local reports =
      vim.tbl_filter(
      function(x)
        return not x.done
      end,
      progress
    )
    if not client.is_stopped() and #reports > 0 then
      section = string.format("%s (%s)", section or "", client.name)
      for _, x in pairs(reports) do
        local spinner = spinners[((x.seq or 0) % #spinners) + 1]
        section = string.format("%s %s %s, %s", section, spinner, x.title, x.message)
      end
    end
  end
  return section and string.format(" %s ", section)
end

local sections = {
  "%=",
  has_devicons and buf_icon,
  "%{fnamemodify(expand('%'),':~:.')}",
  "%{&modified ? '  ●' : ''}",
  "%=",
  function(buf, is_active)
    return servers_progress(buf) or diagnostics(buf, is_active)
  end
}

vim.cmd(string.format("hi! LspDiagnosticsStatusError guifg=%s guibg=%s", c.white, c.red))
vim.cmd(
  string.format("hi! LspDiagnosticsStatusWarning guifg=%s guibg=%s", c.white, c.yellow)
)

return function()
  local winid = vim.g.statusline_winid
  local buffer = vim.fn.getbufinfo(vim.api.nvim_win_get_buf(winid))[1]
  local is_active = winid == vim.fn.win_getid()
  local statusline = ""
  for _, section in pairs(sections) do
    if type(section) == "table" then
      local active, inactive = unpack(section)
      section = is_active and active or inactive
    elseif type(section) == "function" then
      section = section(buffer, is_active)
    end
    statusline = statusline .. (section or "")
  end
  return statusline
end
