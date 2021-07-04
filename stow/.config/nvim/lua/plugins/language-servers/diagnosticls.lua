return function(on_attach)
  return {
    on_attach = on_attach,
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
    init_options = {
      linters = {
        eslint = {
          command = "eslint",
          args = {
            "--stdin",
            "--stdin-filename",
            "%filepath",
            "--format",
            "json"
          },
          rootPatterns = {".git", ".bashrc"},
          debounce = 100,
          sourceName = "eslint",
          parseJson = {
            errorsRoot = "[0].messages",
            line = "line",
            column = "column",
            endLine = "endLine",
            endColumn = "endColumn",
            message = "[eslint] ${message} [${ruleId}]",
            security = "severity"
          },
          securities = {[2] = "error", [1] = "warning"}
        }
      },
      formatters = {
        prettier = {
          command = "prettier",
          args = {"--stdin-filepath", "%filepath"},
          rootPatterns = {".git", ".bashrc"}
        },
        luaFormat = {
          command = "lua-format",
          args = {
            "-i",
            "--indent-width=2",
            "--continuation-indent-width=2",
            "--extra-sep-at-table-end"
          }
        }
      },
      filetypes = {
        javascript = "eslint",
        javascriptreact = "eslint",
        typescript = "eslint",
        typescriptreact = "eslint"
      },
      formatFiletypes = {
        javascript = "prettier",
        javascriptreact = "prettier",
        typescript = "prettier",
        typescriptreact = "prettier",
        css = "prettier",
        scss = "prettier",
        yaml = "prettier",
        json = "prettier",
        html = "prettier",
        markdown = "prettier",
        lua = "luaFormat"
      }
    }
  }
end
