-- Ensure packer is installed
-- Load plugins configuration
-- Install plugins on first run
-- Setup packer otherwise

local install_path =
  string.format("%s/site/pack/packer/start/packer.nvim", vim.fn.stdpath("data"))

local installed = vim.fn.empty(vim.fn.glob(install_path)) == 0

if not installed then
  vim.cmd(
    string.format(
      "!git clone %s %s",
      "https://github.com/wbthomason/packer.nvim",
      install_path
    )
  )
  vim.cmd("packadd packer.nvim")
end

local packer = require("packer")
packer.startup(
  {require("plugins"), config = {display = {open_cmd = "tabnew [packer]"}}}
)

if not installed then
  packer.install()
end
