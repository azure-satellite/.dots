local M = {}

local function dump_clients()
  local servers = {}
  for _, client in pairs(vim.lsp.get_active_clients()) do
    table.insert(servers, {
      name = client.name,
      id = client.id,
      capabilities = client.resolved_capabilities,
    })
  end
  _G.dump(servers)
end

function M.active() dump_clients(vim.lsp.get_active_clients()) end

function M.buf_active() dump_clients(vim.lsp.buf_get_clients()) end

function M.server_logs()
  local serverLog = vim.api.nvim_buf_get_var(0, "serverLog")
  if serverLog then
    vim.cmd("tabnew")
    vim.cmd("e " .. serverLog)
  else
    vim.cmd('echoe "No server log specified"')
  end
end

function M.buf_nnoremap(lhs, rhs)
  vim.api.nvim_buf_set_keymap(0, "n", lhs, "<cmd>" .. rhs .. "<cr>",
                              {noremap = true, silent = true})
end

function M.toggle_format_buf()
  vim.b.format_buf = not (vim.b.format_buf == nil or vim.b.format_buf)
end

function M.format_buf()
  if vim.b.format_buf == nil or vim.b.format_buf == true then
    -- Block the editor for up to 2s.
    vim.lsp.buf.formatting_sync({}, 2000)
  end
end

return M
