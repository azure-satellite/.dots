vim.g.loaded_gzip = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_logiPat = 1
vim.g.loaded_rrhelper = 1
-- Needed for vim-rhubarb
-- vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_netrwFileHandlers = 1
vim.g.loaded_spellfile_plugin = 1
vim.g.loaded_tutor_mode_plugin = 1

-- https://github.com/wbthomason/packer.nvim/issues/180
vim.fn.setenv("MACOSX_DEPLOYMENT_TARGET", "10.15")

local plugins = {
  -- Utils required by other plugins
  {"https://github.com/nvim-lua/popup.nvim"},
  {"https://github.com/nvim-lua/plenary.nvim"},
  -- Aliases
  {
    "https://github.com/konfekt/vim-alias",
    config = [[
      vim.cmd("packadd vim-alias")
      vim.cmd("Alias! ve e\\ $MYVIMRC")
      vim.cmd(
        "Alias! pe exec\\ 'e\\ '.fnamemodify($MYVIMRC,':h').'/lua/plugins.lua'"
      )
      vim.cmd("Alias! w up")
      vim.cmd("Alias! man Man")
    ]]
  },
  -- Motions
  {"https://github.com/vim-utils/vim-vertical-move"},
  {
    "https://github.com/ggandor/lightspeed.nvim",
    event = "VimEnter", -- So config actually runs after the plugin
    config = [[
      vim.cmd("silent! unmap f")
      vim.cmd("silent! unmap F")
      vim.cmd("silent! unmap t")
      vim.cmd('silent! unmap T')
    ]]
  },
  {"https://github.com/justinmk/vim-ipmotion"},
  {
    "https://github.com/tpope/vim-rsi",
    config = [[
      vim.g.ip_skipfold = 1
      vim.g.rsi_no_meta = 1
    ]]
  },
  -- Text Objects
  {"https://github.com/kana/vim-textobj-user"},
  {"https://github.com/Julian/vim-textobj-variable-segment"},
  {"https://github.com/kana/vim-textobj-indent"},
  {
    "https://github.com/machakann/vim-swap",
    config = [[
      vim.g.swap_no_default_key_mappings = 1
      U.map("n", "g<", "<plug>(swap-prev)")
      U.map("n", "g>", "<plug>(swap-next)")
      U.map("o", "i,", "<plug>(swap-textobject-i)")
      U.map("x", "i,", "<plug>(swap-textobject-i)")
      U.map("o", "a,", "<plug>(swap-textobject-a)")
      U.map("x", "a,", "<plug>(swap-textobject-a)")
    ]]
  },
  -- Operators
  {"https://github.com/tommcdo/vim-lion"},
  {"https://github.com/tpope/vim-commentary"},
  {"https://github.com/tpope/vim-repeat"},
  {
    "https://github.com/tommcdo/vim-exchange",
    config = [[
      U.map("x", "X", "<plug>(Exchange)")
      U.map("n", "gx", "<plug>(Exchange)")
      U.map("n", "gxc", "<plug>(ExchangeClear)")
      U.map("n", "gxx", "<plug>(ExchangeLine)")
    ]]
  },
  -- Editing
  {"https://github.com/rstacruz/vim-closer"},
  {"https://github.com/tpope/vim-abolish"},
  {
    "https://github.com/tpope/vim-surround",
    config = [[
      vim.g.surround_no_insert_mappings = 1
    ]]
  },
  -- LSP
  -- Plugins/tools to look out for
  -- * https://github.com/jose-elias-alvarez/null-ls.nvim
  -- * https://github.com/denoland/deno_lint
  -- * https://github.com/rslint/rslint
  {"https://github.com/kabouzeid/nvim-lspinstall"},
  {
    "https://github.com/neovim/nvim-lspconfig",
    config = "require 'plugins.lspconfig'",
    after = "nvim-lspinstall"
  },
  {
    "https://github.com/neoclide/coc.nvim",
    disable = true,
    branch = "release",
    config = "require 'plugins.coc'",
    requires = {
      {
        "https://github.com/mhartington/formatter.nvim",
        ft = {"lua"},
        config = "require 'plugins.formatter'"
      }
    }
  },
  -- Filetypes
  {
    "https://github.com/nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    config = "require'plugins.treesitter'",
    requires = {
      {
        "https://github.com/nvim-treesitter/playground",
        after = "nvim-treesitter",
        config = [[
          U.noremap("n", "ga", "<cmd>TSHighlightCapturesUnderCursor<cr>")
        ]]
      },
      {
        "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
        disable = true,
        after = "nvim-treesitter",
        config = "require 'plugins.treesitter-textobjects'"
      },
      {
        "https://github.com/RRethy/nvim-treesitter-textsubjects",
        disable = true
      }
    }
  },
  -- Version Control
  {
    "https://github.com/tpope/vim-fugitive",
    after = "vim-alias",
    config = [[
      -- https://github.com/tpope/vim-rhubarb/commit/964d48fd11db7c3a3246885993319d544c7c6fd5
      vim.g.fugitive_git_command = "hub"
      vim.cmd("Alias g G")
      vim.cmd("Alias gbl Git\\ blame\\ -w\\ -M")
      vim.cmd("Alias -range go GBrowse")
      vim.cmd("Alias gd Gdiffsplit")
      vim.cmd("Alias ge Gedit")
      vim.cmd("Alias gcm Git\\ commit")
      vim.cmd("Alias gcma Git\\ commit\\ --amend")
      vim.cmd("Alias gcman Git\\ commit\\ --amend\\ --reuse-message\\ HEAD")
      vim.cmd("Alias gr Gread")
      vim.cmd("Alias gs Git")
      vim.cmd("Alias gw Gwrite")
      vim.cmd("Alias gco Git\\ checkout")
    ]],
    requires = {
      {"https://github.com/tpope/vim-rhubarb"}
    }
  },
  -- Searching
  {
    -- Temporary until https://github.com/mhinz/vim-grepper/issues/244 gets
    -- resolved
    "https://github.com/trsdln/vim-grepper",
    -- "https://github.com/mhinz/vim-grepper",
    config = "require 'plugins.grepper'"
  },
  -- Fuzzy Picker
  {
    "https://github.com/nvim-telescope/telescope.nvim",
    after = {"popup.nvim", "plenary.nvim", "which-key.nvim", "nvim-web-devicons"},
    config = "require 'plugins.telescope'"
  },
  -- CLI Tools
  {"https://github.com/editorconfig/editorconfig-vim"},
  {
    "https://github.com/tpope/vim-eunuch",
    after = "vim-alias",
    config = [[
      vim.cmd("Alias mv Move")
      vim.cmd("Alias rm Delete")
      vim.cmd("Alias ren Rename")
      vim.cmd("Alias cmo Chmod")
      vim.cmd("Alias mk Mkdir")
      vim.cmd("Alias sue SudoEdit")
      vim.cmd("Alias suw SudoWrite")
    ]]
  },
  -- Colors
  {
    "https://github.com/norcalli/nvim-colorizer.lua",
    config = "require 'colorizer'.setup(nil, {hsl_fn = true})"
  },
  -- Window Management
  {
    "https://github.com/szw/vim-maximizer",
    config = [[
      vim.g.maximizer_set_default_mapping = 0
      U.noremap("n", "<c-w>m", "<cmd>MaximizerToggle!<cr>", {silent = true})
      U.noremap("n", "<c-w><c-m>", "<cmd>MaximizerToggle!<cr>", {silent = true})
    ]]
  },
  -- Other
  {"https://github.com/tweekmonster/startuptime.vim", cmd = "StartupTime"},
  {"https://github.com/tpope/vim-scriptease"},
  {"https://github.com/AndrewRadev/linediff.vim", cmd = "Linediff"},
  {
    "https://github.com/tpope/vim-unimpaired",
    event = "VimEnter", -- So config actually runs after the plugin
    config = function()
      local unmaps = {"[l", "[L", "]l", "]L", "=p", "=P", "=o", "=O", "=op"}
      for _, m in ipairs(unmaps) do
        vim.cmd("silent! unmap " .. m)
      end
      U.map("n", "[w", "<plug>unimpairedLPrevious")
      U.map("n", "[W", "<plug>unimpairedLFirst")
      U.map("n", "]w", "<plug>unimpairedLNext")
      U.map("n", "]W", "<plug>unimpairedLLast")
      U.map("n", "co", "yo")
    end
  },
  {
    "https://github.com/mbbill/undotree",
    config = [[
      vim.g.undotree_DiffAutoOpen = 0
      vim.g.undotree_SetFocusWhenToggle = 1
      vim.g.undotree_SplitWidth = 40
      U.noremap("n", "<leader>u", ":UndotreeToggle<cr>", {silent = true})
    ]]
  },
  {
    "https://github.com/justinmk/vim-dirvish",
    config = "require 'plugins.dirvish'"
  },
  {
    "https://github.com/kyazdani42/nvim-web-devicons",
    config = "require'nvim-web-devicons'.setup()"
  },
  {"https://github.com/L3MON4D3/LuaSnip", disable = true},
  {"https://github.com/pwntester/octo.nvim", disable = true},
  {"https://github.com/windwp/nvim-ts-autotag", disable = true},
  {"https://github.com/kevinhwang91/nvim-bqf", disable = true},
  {"https://github.com/NTBBloodbath/rest.nvim", disable = true},
  {"https://github.com/folke/which-key.nvim"}
}

-- Recursively set `after` on the plugin to load after packer because all my
-- mappings, options, etc... get set on packer's config field, which is,
-- admittedly, a weird place to setup my editor instead of the more standard
-- init.{vim,lua}. The reason being that I'd like to use luarocks packages as
-- early as possible, however they are only available after packer_compiled.lua
-- gets sourced, which happens _after_ init.{vim,lua} has been sourced. This
-- hack ensures the loading order I want in `packer_compiled.lua`:
--  * `package.path` gets set, making luarocks packages available.
--  * `packer.nvim` config code runs before every other plugin, since they all
--    specify `after = "packer.nvim"`.
--  * The rest of the plugins and their configuration gets run next. At this
--    point, both lua packages and whatever utils I've made available in the
--    global scope can be used.
local function set_load_after_packer(plugins)
  for _, plug in pairs(plugins) do
    if not plug.after then
      plug.after = "packer.nvim"
    end
    if plug.requires then
      set_load_after_packer(plug.requires)
    end
  end
end

set_load_after_packer(plugins)

table.insert(
  plugins,
  {
    "https://github.com/wbthomason/packer.nvim",
    rocks = {"fun"},
    config = "do_user_configuration()"
  }
)

return plugins
