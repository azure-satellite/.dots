-- https://github.com/mattn/efm-langserver

local lspconfig = require "lspconfig"

local prettier = {
  -- Script is at stow/.local/bin/prettierme.sh
  -- Ensure that `npm i -g prettier_d_slim`
  formatCommand = "prettierme.sh ${INPUT}",
  formatStdin = true
}

local eslint = {
  -- Script is at stow/.local/bin/eslintme.sh
  -- Ensure that `npm i -g eslint_d`
  lintCommand = "eslintme.sh ${INPUT} -f visualstudio",
  lintIgnoreExitCode = true,
  lintStdin = true,
  lintFormats = {"%f(%l,%c): %tarning %m", "%f(%l,%c): %rror %m"}
}

local luafmt = {
  -- Ensure that `npm i -g lua-fmt`
  formatCommand = "luafmt -i 2 -l 90 --stdin",
  formatStdin = true
}

local languages = {
  css = {prettier},
  html = {prettier},
  javascript = {prettier, eslint},
  javascriptreact = {prettier, eslint},
  json = {prettier},
  lua = {luafmt},
  markdown = {prettier},
  scss = {prettier},
  typescript = {prettier, eslint},
  typescriptreact = {prettier, eslint},
  yaml = {prettier}
}

-- Fallback to .bashrc as a project root to enable LSP on loose files
local root_markers = {".git/", ".bashrc"}

return function(on_attach)
  return {
    cmd = {
      U.os.data .. "/lspinstall/efm/efm-langserver",
      "-logfile",
      vim.g.lsp_log_dir .. "/efm.log"
    },
    on_attach = on_attach,
    root_dir = lspconfig.util.root_pattern(unpack(root_markers)),
    -- Enable document formatting (other capabilities are off by default).
    init_options = {documentFormatting = true},
    filetypes = vim.tbl_keys(languages),
    settings = {rootMarkers = root_markers, languages = languages}
  }
end
