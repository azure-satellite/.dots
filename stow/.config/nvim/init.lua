-- Install packer if necessary
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local is_installed = vim.fn.empty(vim.fn.glob(install_path)) == 0
if not is_installed then
  vim.fn.system(
    {"git", "clone", "https://github.com/wbthomason/packer.nvim", install_path}
  )
end

-- Make all module names available in the global namespace
function globalize_module(mod)
  for k, v in pairs(mod) do
    _G[k] = v
  end
end

function do_user_configuration()
  -- There's a potential to run this code more than once if
  -- `packer_compiled.lua` gets sourced again.
  if vim.g.did_user_config then
    return
  end
  vim.g.did_user_config = true

  globalize_module(require "fun")
  globalize_module(require "fun_extensions")

  U = require "util"
  require "mappings"

  require "options"
  vim.o.statusline = "%!v:lua.require'statusline'()"
  vim.o.background = "light"

  -- Custom colorscheme, not a plugin
  vim.cmd("colorscheme furnisher")

  -- Recompile plugins when they have been changed
  vim.cmd("au BufWritePost plugins.lua lua reload_plugins()")

  -- `compile_on_sync` is not enough since I'd like to re-compile plugins on
  -- install/update/clean/sync as well.
  vim.cmd("au User PackerComplete PackerCompile")

  -- `auto_reload_compiled` is nice but I like to see the actual command.
  vim.cmd("au User PackerCompileDone source plugin/packer_compiled.lua")

  -- Reload colors when the colorscheme is changed.
  vim.cmd("au! BufWritePost furnisher.lua source <afile>")

  -- https://github.com/neovim/neovim/issues/1936
  vim.cmd("au! FocusGained * checktime")

  -- :h lua-highlight
  vim.cmd("au! TextYankPost * silent! lua vim.highlight.on_yank({ timeout = 300 })")
end

local packer = require "packer"

local packer_config = {
  compile_on_sync = false,
  auto_reload_compiled = false
}

function reload_plugins()
  package.loaded["plugins"] = nil
  packer.startup({require "plugins", config = packer_config})
  packer.compile()
end

function init_packer()
  packer.startup({require "plugins", config = packer_config})
  if not is_installed then
    packer.install()
  end
end

init_packer()
