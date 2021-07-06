local c = require "theme"
local lsp = vim.lsp
local lspconfig = require "lspconfig"
local lspinstall = require "lspinstall"

-- Set LSP client's log level. Server's log level is not affected.
lsp.set_log_level("warn")

vim.g.lsp_log_dir = vim.fn.fnamemodify(lsp.get_log_path(), ":h") .. "/lsp_servers"

-- All LSP messages
-- https://microsoft.github.io/language-server-protocol/specifications/specification-current
--
-- window/showMessage
-- window/showMessageRequest
-- window/showDocument
-- window/logMessage
-- window/workDoneProgress/create
-- window/workDoneProgress/cancel
--
-- client/registerCapability
-- client/unregisterCapability
--
-- workspace/workspaceFolders
-- workspace/didChangeWorkspaceFolders
-- workspace/didChangeConfiguration
-- workspace/configuration
-- workspace/didChangeWatchedFiles
-- workspace/symbol
-- workspace/executeCommand
-- workspace/applyEdit
-- workspace/willCreateFiles
-- workspace/didCreateFiles
-- workspace/willRenameFiles
-- workspace/didRenameFiles
-- workspace/willDeleteFiles
-- workspace/didDeleteFiles
-- workspace/semanticTokens/refresh
--
-- textDocument/didOpen
-- textDocument/didChange
-- textDocument/willSave
-- textDocument/willSaveWaitUntil
-- textDocument/didSave
-- textDocument/didClose
-- textDocument/publishDiagnostics
-- textDocument/completion
-- completionItem/resolve
-- textDocument/hover
-- textDocument/signatureHelp
-- textDocument/declaration
-- textDocument/definition
-- textDocument/typeDefinition
-- textDocument/implementation
-- textDocument/references
-- textDocument/documentHighlight
-- textDocument/documentSymbol
-- textDocument/codeAction
-- codeAction/resolve
-- textDocument/codeLens
-- codeLens/resolve
-- workspace/codeLens/refresh
-- textDocument/documentLink
-- documentLink/resolve
-- textDocument/documentColor
-- textDocument/colorPresentation
-- textDocument/formatting
-- textDocument/rangeFormatting
-- textDocument/onTypeFormatting
-- textDocument/rename
-- textDocument/prepareRename
-- textDocument/foldingRange
-- textDocument/selectionRange
-- textDocument/prepareCallHierarchy
-- callHierarchy/incomingCalls
-- callHierarchy/outgoingCalls
-- textDocument/semanticTokens/full
-- textDocument/semanticTokens/full/delta
-- textDocument/semanticTokens/range
-- textDocument/linkedEditingRange
-- textDocument/moniker

lsp.handlers["textDocument/publishDiagnostics"] =
  lsp.with(
  lsp.diagnostic.on_publish_diagnostics,
  {
    underline = false,
    virtual_text = false,
    signs = true,
    update_in_insert = false
  }
)

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

-- Ideas for mappings:
-- Show floating window with both definition and references of a given symbol
-- Show floating window for all code actions
local function on_attach(client)
  -- Completion
  vim.api.nvim_buf_set_option(0, "omnifunc", "v:lua.lsp.omnifunc")

  -- Formatting
  if client.resolved_capabilities.document_formatting then
    U.au(
      {event = "BufWritePost", pattern = "<buffer>", cmd = lsp.buf.formatting_seq_sync}
    )
  end

  local function map_capability(mapping, name, capability_name)
    if client.resolved_capabilities[capability_name or name] then
      U.buf_noremap("n", mapping, "<cmd>lua lsp.buf." .. name .. "()<cr>")
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

  -- See `:h lsp.util.open_floating_preview()` for `popup_opts` values
  local opts = {
    wrap = false
    -- border = {"╔", "═", "╗", "║", "╝", "═", "╚", "║"}
  }

  -- Go to prev diagnostic
  U.buf_noremap(
    "n",
    "[r",
    function()
      lsp.diagnostic.goto_prev(opts)
    end
  )

  -- Go to first diagnostic
  U.buf_noremap(
    "n",
    "[R",
    function()
      lsp.diagnostic.goto_next(vim.fn.extend(opts, {cursor_position = {0, 0}}))
    end
  )

  -- Go to next diagnostic
  U.buf_noremap(
    "n",
    "]r",
    function()
      lsp.diagnostic.goto_next(opts)
    end
  )

  -- Go to last diagnostic
  U.buf_noremap(
    "n",
    "]R",
    function()
      lsp.diagnostic.goto_next(vim.fn.extend(opts, {cursor_position = {-1, -1}}))
    end
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
