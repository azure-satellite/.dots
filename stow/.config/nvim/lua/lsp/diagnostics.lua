local util = require("util")
local colors = require("colors")

local M = {}

-- Enable/disable specific diagnostics features
-- :h vim.lsp.diagnostic.on_publish_diagnostics()
vim.lsp.handlers["textDocument/publishDiagnostics"] =
  vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics,
  {
    underline = false,
    virtual_text = true,
    signs = true,
    update_in_insert = false
  }
)

-- Customize diagnostics signs
local function set_sign(type, icon)
  local sign = string.format("LspDiagnosticsSign%s", type)
  local texthl = string.format("LspDiagnosticsDefault%s", type)
  vim.fn.sign_define(sign, {text = icon, texthl = texthl})
end
set_sign("Hint", "")
set_sign("Information", "")
set_sign("Warning", "")
set_sign("Error", "ﰸ")

-- Customize diagnostics highlights
local function set_highlight(type, color)
  vim.cmd(string.format("hi! LspDiagnosticsDefault%s guifg=%s", type, color))
end
set_highlight("Hint", colors.green)
set_highlight("Information", colors.cyan)
set_highlight("Warning", colors.yellow)
set_highlight("Error", colors.red)

-- Setup mappings on a buffer that supports diagnostics
function M.on_attach(client)
  -- Go to prev diagnostic
  util.buf_noremap(
    "n",
    "[r",
    "lua vim.lsp.diagnostic.goto_prev({ wrap = false, popup_opts = { } })"
  )

  -- Go to first diagnostic
  util.buf_noremap(
    "n",
    "[R",
    "lua vim.lsp.diagnostic.goto_next({ cursor_position = {0, 0} })"
  )

  -- Go to next diagnostic
  util.buf_noremap(
    "n",
    "]r",
    "lua vim.lsp.diagnostic.goto_next({ wrap = false })"
  )

  -- Go to last diagnostic
  util.buf_noremap(
    "n",
    "]R",
    "lua vim.lsp.diagnostic.goto_prev({ cursor_position = {-1, -1} })"
  )
end

return M
