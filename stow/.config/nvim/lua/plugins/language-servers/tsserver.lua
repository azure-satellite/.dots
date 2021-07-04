-- https://github.com/microsoft/TypeScript/wiki/Standalone-Server-%28tsserver%29
-- https://github.com/theia-ide/typescript-language-server

return function(on_attach)
  return {
    cmd = {
      U.os.data .. "/lspinstall/typescript/node_modules/.bin/typescript-language-server",
      "--stdio",
      "--log-level",
      "4", -- Has no effect whatsoever
      "--tsserver-log-file",
      vim.g.lsp_log_dir .. "/tsserver.log",
      "--tsserver-log-verbosity",
      "normal"
    },
    handlers = {},
    on_attach = function(client, bufnr)
      -- Disable formatting. Using prettier via the efm server for this.
      client.resolved_capabilities.document_formatting = false
      client.resolved_capabilities.document_range_formatting = false
      on_attach(client, bufnr)
    end
  }
end
