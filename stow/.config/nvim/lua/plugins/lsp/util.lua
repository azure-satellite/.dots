local M = {}

local function dump_clients()
  local servers = {}
  for _, client in pairs(vim.lsp.get_active_clients()) do
    table.insert(
      servers,
      {
        name = client.name,
        id = client.id,
        capabilities = client.resolved_capabilities
      }
    )
  end
  _G.dump(servers)
end

function M.active()
  dump_clients(vim.lsp.get_active_clients())
end

function M.buf_active()
  dump_clients(vim.lsp.buf_get_clients())
end

function M.server_logs()
  local serverLog = vim.api.nvim_buf_get_var(0, "serverLog")
  if serverLog then
    vim.cmd("tabnew")
    vim.cmd("e " .. serverLog)
  else
    vim.cmd('echoe "No server log specified"')
  end
end

return M
