local c = require "theme"
local lspconfig = require "lspconfig"
local lspinstall = require "lspinstall"

-- Set LSP client's log level. Server's log level is not affected.
vim.lsp.set_log_level("warn")

vim.g.lsp_log_dir = vim.fn.fnamemodify(vim.lsp.get_log_path(), ":h") .. "/lsp_servers"

-- Enable/disable specific diagnostics features
vim.lsp.handlers["textDocument/publishDiagnostics"] =
  vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics,
  {
    underline = false,
    virtual_text = false,
    signs = true,
    update_in_insert = false
  }
)

vim.lsp.handlers["textDocument/formatting"] = function(err, _, result, _, bufnr)
  if err ~= nil or result == nil then
    return
  end
  if vim.fn.exists("b:format_buf") == 0 or vim.api.nvim_buf_get_var(bufnr, "format_buf") then
    vim.lsp.util.apply_text_edits(result, bufnr)
    if vim.api.nvim_get_current_buf() == bufnr then
      vim.api.nvim_command("noautocmd update")
    end
  end
end

-- Diagnostics highlights and signs
local function set_diagnostic_sign(type, icon, color)
  vim.cmd(string.format("hi! LspDiagnosticsDefault%s guifg=%s", type, color))
  vim.cmd(
    string.format(
      "sign define LspDiagnosticsSign%s text=%s texthl=LspDiagnosticsSign%s linehl= numhl=",
      type,
      icon,
      type
    )
  )
end
set_diagnostic_sign("Hint", "", c.magenta)
set_diagnostic_sign("Information", "", c.magenta)
set_diagnostic_sign("Warning", "", c.yellow)
set_diagnostic_sign("Error", "", c.red)

-- Completion

-- Function = " [function]",
-- Method = " [method]",
-- Reference = " [refrence]",
-- Enum = " [enum]",
-- Field = "ﰠ [field]",
-- Keyword = " [key]",
-- Variable = " [variable]",
-- Folder = " [folder]",
-- Snippet = " [snippet]",
-- Operator = " [operator]",
-- Module = " [module]",
-- Text = "ﮜ[text]",
-- Class = " [class]",
-- Interface = " [interface]"

local function on_attach(client)
  -- Completion
  vim.api.nvim_buf_set_option(0, "omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Formatting
  if client.resolved_capabilities.document_formatting then
    U.au(
      {
        event = "BufWritePost",
        pattern = "<buffer>",
        cmd = vim.lsp.buf.formatting
      }
    )

    -- Toggle formatting unimpaired style
    U.buf_noremap(
      "n",
      "yof",
      function()
        vim.b.format_buf = not (vim.b.format_buf == nil or vim.b.format_buf)
      end
    )
  end

  local function map_capability(mapping, name, capability_name)
    if client.resolved_capabilities[capability_name or name] then
      U.buf_noremap("n", mapping, "<cmd>lua vim.lsp.buf." .. name .. "()<cr>")
    end
  end

  -- List of capabilities names
  -- * call_hierarchy
  -- * code_action
  -- * code_lens
  -- * code_lens_resolve
  -- * completion
  -- * declaration
  -- * document_formatting
  -- * document_highlight
  -- * document_range_formatting
  -- * document_symbol
  -- * execute_command
  -- * find_references
  -- * goto_definition
  -- * hover
  -- * implementation
  -- * rename
  -- * signature_help
  -- * signature_help_trigger_characters
  -- * text_document_did_change
  -- * text_document_open_close
  -- * text_document_save
  -- * text_document_save_include_text
  -- * text_document_will_save
  -- * text_document_will_save_wait_until
  -- * type_definition
  -- * workspace_folder_properties
  -- * workspace_symbol
  map_capability("gd", "definition", "goto_definition")
  map_capability("<c-]>", "declaration")
  map_capability("gr", "references", "find_references")
  map_capability("gD", "implementation")
  map_capability("K", "hover")
  map_capability("<c-k>", "signature_help")
  map_capability("g0", "document_symbol")
  map_capability("gW", "workspace_symbol")

  -- Go to prev diagnostic
  U.buf_noremap(
    "n",
    "[r",
    "<cmd>lua vim.lsp.diagnostic.goto_prev({ wrap = false, popup_opts = { } })<cr>"
  )

  -- Go to first diagnostic
  U.buf_noremap(
    "n",
    "[R",
    "<cmd>lua vim.lsp.diagnostic.goto_next({ cursor_position = {0, 0} })<cr>"
  )

  -- Go to next diagnostic
  U.buf_noremap("n", "]r", "<cmd>lua vim.lsp.diagnostic.goto_next({ wrap = false })<cr>")

  -- Go to last diagnostic
  U.buf_noremap(
    "n",
    "]R",
    "<cmd>lua vim.lsp.diagnostic.goto_prev({ cursor_position = {-1, -1} })<cr>"
  )
end

local function setup_servers()
  lspinstall.setup()
  local installed = lspinstall.installed_servers()
  -- lspinstall's server name sometimes differs from that of lspconfig's
  local server_names = {typescript = "tsserver", lua = "sumneko_lua"}
  for _, name in pairs(installed) do
    local server = server_names[name] or name
    local exists, config = pcall(require, "plugins.language-servers." .. server)
    if exists then
      lspconfig[server].setup(config(on_attach))
    end
  end
end

setup_servers()
