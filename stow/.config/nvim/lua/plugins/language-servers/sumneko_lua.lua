-- https://github.com/sumneko/lua-language-server/wiki/Command-line

return function(on_attach)
  return {
    cmd = {
      U.os.data .. "/lspinstall/lua/sumneko-lua-language-server",
      "--logpath=" .. vim.g.lsp_log_dir .. "/sumneko_lua",
      "--locale=en-us"
    },
    filetypes = {"lua"},
    on_attach = on_attach,
    settings = {
      -- https://github.com/sumneko/vscode-lua/blob/master/setting/schema.json
      Lua = {
        diagnostics = {
          globals = totable(
            chain(
              {"vim", "U"},
              vim.tbl_keys(require "fun"),
              vim.tbl_keys(require "fun_extensions")
            )
          )
        },
        -- Neovim uses LuaJIT
        runtime = {version = "LuaJIT", path = vim.split(package.path, ";")},
        -- Make the server aware of Neovim runtime files
        workspace = {library = vim.api.nvim_get_runtime_file("", true)},
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {enable = false}
      }
    }
  }
end
