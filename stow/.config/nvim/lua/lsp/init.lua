-- Good references:
-- https://github.com/lukas-reineke/dotfiles/blob/7eec44f99c64be1916e246ab51c1d4e4a4083670/vim/lua/lsp.lua
local lspconfig = require("lspconfig")
local util = require("lsp/util")
local diagnostics = require("lsp/diagnostics")
require("lsp/completion")

-- Set LSP client's log level. Server's log level is not affected.
vim.lsp.set_log_level("warn")

local log_dir =
  vim.fn.fnamemodify(vim.lsp.get_log_path(), ":p:h") .. "/lsp_servers"

local function on_attach(serverLog)
  return function(client)
    if serverLog then
      vim.api.nvim_buf_set_var(0, "serverLog", serverLog)
    end

    -- Completion
    vim.api.nvim_buf_set_option(0, "omnifunc", "v:lua.vim.lsp.omnifunc")

    -- Formatting
    if client.resolved_capabilities.document_formatting then
      vim.cmd [[augroup Format]]
      vim.cmd [[autocmd! * <buffer>]]
      -- Use BufWritePre with formatting_sync so the buffer doesn't stay
      -- modified after formatting.
      vim.cmd [[autocmd BufWritePre <buffer> :call v:lua.site.lsp.util.format_buf()]]
      vim.cmd [[augroup END]]
      -- Toggle formatting unimpaired style
      util.buf_nnoremap("yof", "call v:lua.site.lsp.util.toggle_format_buf()")
    end

    local function map_capability(mapping, name, capability_name)
      if client.resolved_capabilities[capability_name or name] then
        util.buf_nnoremap(mapping, "lua vim.lsp.buf." .. name .. "()")
      end
    end

    map_capability("gd", "definition", "goto_definition")
    map_capability("<c-]>", "declaration")
    map_capability("gr", "references")
    map_capability("gD", "implementation")
    map_capability("K", "hover")
    map_capability("<c-k>", "signature_help")
    map_capability("g0", "document_symbol")
    map_capability("gW", "workspace_symbol")

    diagnostics.on_attach(client)
  end
end

---- General purpose language server
---- https://github.com/mattn/efm-langserver
----
---- NOTE: If formatting/linting does not work and there are messages like
----
----  > "lint for LanguageID not supported: {language here}"
----
---- in the server log, it's because the configuration did not get loaded due to
---- an error. Unfortunately I don't know how to detect such an error so be very
---- careful when changing this which currently works.

---- [eslint|pretter] commands work per-project only if ./node_modules/.bin has
---- been added to $PATH. The alternative is `npx [eslint|prettier]`, which is
---- much slower.

local prettier = {formatCommand = "prettier"}
local eslint = {
  lintCommand = "eslint -f unix --stdin",
  lintIgnoreExitCode = true,
  lintStdin = true
}

lspconfig.efm.setup {
  cmd = {"efm-langserver", "-logfile", log_dir .. "/efm.log"},
  on_attach = on_attach(log_dir .. "/efm.log"),
  -- Fallback to .bashrc as a project root to enable LSP on loose files
  root_dir = lspconfig.util.root_pattern(".git/", ".bashrc"),
  -- Enable document formatting (other capabilities are off by default).
  init_options = {documentFormatting = true},
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "css",
    "scss",
    "yaml",
    "json",
    "html",
    "markdown",
    "lua"
  },
  settings = {
    rootMarkers = {".git/", ".bashrc"},
    languages = {
      javascript = {prettier, eslint},
      typescript = {prettier, eslint},
      javascriptreact = {prettier, eslint},
      typescriptreact = {prettier, eslint},
      yaml = {prettier},
      json = {prettier},
      html = {prettier},
      scss = {prettier},
      css = {prettier},
      markdown = {prettier},
      -- npm i -g lua-fmt
      lua = {{formatCommand = "luafmt -i 2 -l 82 --stdin", formatStdin = true}}
    }
  }
}

-- -- Keep an eye out for https://github.com/denoland/deno_lint and
-- -- https://github.com/rslint/rslint
-- lspconfig.diagnosticls.setup {
--   on_attach = on_attach(),
--   filetypes = {
--     "javascript",
--     "javascriptreact",
--     "typescript",
--     "typescriptreact",
--     "css",
--     "scss",
--     "yaml",
--     "json",
--     "html",
--     "markdown",
--     "lua",
--   },
--   init_options = {
--     linters = {
--       eslint = {
--         command = "eslint",
--         args = {"--stdin", "--stdin-filename", "%filepath", "--format", "json"},
--         rootPatterns = {".git", ".bashrc"},
--         debounce = 100,
--         sourceName = "eslint",
--         parseJson = {
--           errorsRoot = "[0].messages",
--           line = "line",
--           column = "column",
--           endLine = "endLine",
--           endColumn = "endColumn",
--           message = "[eslint] ${message} [${ruleId}]",
--           security = "severity",
--         },
--         securities = {[2] = "error", [1] = "warning"},
--       },
--     },
--     formatters = {
--       prettier = {
--         command = "prettier",
--         args = {"--stdin-filepath", "%filepath"},
--         rootPatterns = {".git", ".bashrc"},
--       },
--       luaFormat = {
--         command = "lua-format",
--         args = {"-i", "--indent-width=2", "--continuation-indent-width=2", "--extra-sep-at-table-end"},
--       },
--     },
--     filetypes = {
--       javascript = "eslint",
--       javascriptreact = "eslint",
--       typescript = "eslint",
--       typescriptreact = "eslint",
--     },
--     formatFiletypes = {
--       javascript = "prettier",
--       javascriptreact = "prettier",
--       typescript = "prettier",
--       typescriptreact = "prettier",
--       css = "prettier",
--       json = "prettier",
--       scss = "prettier",
--       yaml = "prettier",
--       json = "prettier",
--       html = "prettier",
--       markdown = "prettier",
--       lua = "luaFormat",
--     },
--   },
-- }

-- https://github.com/microsoft/TypeScript/wiki/Standalone-Server-%28tsserver%29
-- https://github.com/theia-ide/typescript-language-server
lspconfig.tsserver.setup {
  cmd = {
    "typescript-language-server",
    "--stdio",
    "--log-level",
    "4", -- Has no effect whatsoever
    "--tsserver-log-file",
    log_dir .. "/tsserver.log",
    "--tsserver-log-verbosity",
    "normal"
  },
  handlers = {},
  on_attach = function(client)
    -- Disable formatting. Using prettier via the efm server for this.
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false
    on_attach(log_dir .. "/tsserver.log")(client)
  end
}

-- https://github.com/rust-analyzer/rust-analyzer
lspconfig.rust_analyzer.setup {
  cmd = {"rust-analyzer", "-v", "--log-file", log_dir .. "/rust_analyzer.log"},
  on_attach = on_attach(log_dir .. "/rust_analyzer.log")
}
