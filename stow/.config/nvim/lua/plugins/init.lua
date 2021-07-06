local plugins = {
  -- Let packer manage itself
  {"https://github.com/wbthomason/packer.nvim"},
  -- Aliases
  {
    "https://github.com/konfekt/vim-alias",
    config = [[
      vim.cmd("packadd vim-alias")
      vim.cmd("Alias! ve e\\ $MYVIMRC")
      vim.cmd(
        "Alias! pe exec\\ 'e\\ '.fnamemodify($MYVIMRC,':h').'/lua/plugins/init.lua'"
      )
      vim.cmd("Alias! w up")
      vim.cmd("Alias! man Man")
    ]]
  },
  -- Motions
  {"https://github.com/vim-utils/vim-vertical-move"},
  {
    "https://github.com/ggandor/lightspeed.nvim",
    event = "VimEnter", -- So config actually run after the plugin
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
  {
    "https://github.com/neovim/nvim-lspconfig",
    config = "require 'plugins.lspconfig'",
    requires = {
      {"https://github.com/kabouzeid/nvim-lspinstall"}
    }
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
      },
      {
        "https://github.com/antoinemadec/coc-fzf",
        branch = "release",
        config = [[
          vim.g.coc_fzf_opts = {"--layout=reverse"}
          U.noremap("n", "<space>a", "<cmd>CocFzfList actions<cr>", {silent = true})
          U.noremap("n", "<space>c", "<cmd>CocFzfList commands<cr>", {silent = true})
          U.noremap("n", "<space>d", "<cmd>CocFzfList diagnostics<cr>", {silent = true})
          U.noremap("n", "<space>o", "<cmd>CocFzfList outline<cr>", {silent = true})
          U.noremap("n", "<space>s", "<cmd>CocFzfList snippets<cr>", {silent = true})
          U.noremap("n", "<space>w", "<cmd>CocFzfList symbols<cr>", {silent = true})
        ]]
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
    requires = {{"https://github.com/tpope/vim-rhubarb"}}
  },
  -- Searching
  {
    "https://github.com/mhinz/vim-grepper",
    config = "require 'plugins.grepper'"
  },
  -- Fuzzy Picker
  {
    "https://github.com/nvim-telescope/telescope.nvim",
    requires = {{"nvim-lua/popup.nvim"}, {"nvim-lua/plenary.nvim"}},
    config = "require 'plugins.telescope'"
  },
  {
    "~/.furnisher/gitmodules/fzf.vim",
    branch = "local-gfiles",
    config = "require 'plugins.fzf'",
    requires = {
      {"https://github.com/junegunn/fzf"},
      {
        "https://github.com/stsewd/fzf-checkout.vim",
        config = [[
          vim.g.fzf_checkout_git_bin = "hub"
          vim.g.fzf_checkout_merge_settings = true
          vim.g.fzf_branch_actions = { track = { keymap = "ctrl-o" } }
          U.noremap("n", "<space>j", "<cmd>GBranches --locals<cr>", {silent = true})
          U.noremap("n", "<space>k", "<cmd>GBranches --remotes<cr>", {silent = true})
        ]]
      }
    }
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
    event = "VimEnter", -- So config actually run after the plugin
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
  {'https://github.com/folke/which-key.nvim', disable = true}
}

local package_path = U.os.data .. "/site/pack"
local compile_path = U.os.data .. "/site/plugin/packer_compiled.lua"
local install_path = package_path .. "/packer/start/packer.nvim"

-- Ensure packer is installed and load it
-- https://github.com/wbthomason/packer.nvim#bootstrapping
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system(
    {"git", "clone", "https://github.com/wbthomason/packer.nvim", install_path}
  )
  vim.cmd [[packadd packer.nvim]]
end

-- Configure packer with list of plugins
require "packer".startup(
  {
    plugins,
    config = {
      compile_path = compile_path,
      package_path = package_path,
      display = {open_cmd = "tabnew [packer]"}
    }
  }
)

-- Recompile plugins when this file is updated.
U.au(
  {
    event = "BufWritePost",
    pattern = "*/lua/plugins/init.lua",
    cmd = function()
      package.loaded.plugins = nil
      require "plugins"
      require "packer".compile()
    end
  }
)
