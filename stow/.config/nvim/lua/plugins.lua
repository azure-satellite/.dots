local util = require "util"

vim.g.loaded_gzip = 0 -- Edit compressed files
vim.g.loaded_matchparen = 1 -- Show matching parentheses
vim.g.loaded_netrwPlugin = 1 -- Filetree and more
vim.g.loaded_spellfile_plugin = 1 -- Download spell files
vim.g.loaded_2html_plugin = 1 -- Convert syntax highlighted file to html
vim.g.loaded_tutor_mode_plugin = 1 -- Vim tutor

return function(use)
  -- Let packer manage itself

  use {"https://github.com/wbthomason/packer.nvim"}

  -- Aliases

  use {
    "https://github.com/konfekt/vim-alias",
    event = "VimEnter *",
    config = function()
      vim.cmd("Alias vime exec\\ 'e\\ '.$MYVIMRC")
      vim.cmd("Alias w up")
      vim.cmd("Alias man Man")
      vim.cmd("Alias bufdo Bufdo")
      vim.cmd("Alias windo Windo")
      vim.cmd("Alias tabdo Tabdo")
      vim.cmd("Alias argdo Argdo")
      vim.cmd("Alias o Out")
      vim.cmd("Alias lua Lua")
      vim.cmd("Alias lo LuaOut")
    end
  }

  -- Motions

  use {"https://github.com/vim-utils/vim-vertical-move"}

  use {"https://github.com/justinmk/vim-sneak"}

  use {"https://github.com/justinmk/vim-ipmotion"}

  use {"https://github.com/tpope/vim-rsi"}
  vim.g.ip_skipfold = 1
  vim.g.rsi_no_meta = 1

  -- Text Objects

  use {"https://github.com/kana/vim-textobj-user"}

  use {"https://github.com/Julian/vim-textobj-variable-segment"}

  use {"https://github.com/kana/vim-textobj-indent"}

  use {
    "https://github.com/machakann/vim-swap",
    config = function()
      local util = require "util"
      vim.g.swap_no_default_key_mappings = 1
      util.map("n", "g<", "<plug>(swap-prev)")
      util.map("n", "g>", "<plug>(swap-next)")
      util.map("o", "i,", "<plug>(swap-textobject-i)")
      util.map("x", "i,", "<plug>(swap-textobject-i)")
      util.map("o", "a,", "<plug>(swap-textobject-a)")
      util.map("x", "a,", "<plug>(swap-textobject-a)")
    end
  }

  -- Operators

  use {"https://github.com/tommcdo/vim-lion"}
  use {"https://github.com/tpope/vim-commentary"}
  use {"https://github.com/tpope/vim-repeat"}
  use {
    "https://github.com/tommcdo/vim-exchange",
    config = function()
      local util = require "util"
      util.map("x", "X", "<plug>(Exchange)")
      util.map("n", "gx", "<plug>(Exchange)")
      util.map("n", "gxc", "<plug>(ExchangeClear)")
      util.map("n", "gxx", "<plug>(ExchangeLine)")
    end
  }

  -- Editing

  -- Messes up with the <CR> mapping
  -- use {"https://github.com/9mm/vim-closer"}

  use {"https://github.com/tpope/vim-abolish"}

  use {"https://github.com/tpope/vim-surround"}
  vim.g.surround_no_insert_mappings = 1

  use {
    "https://github.com/mhartington/formatter.nvim",
    ft = {"lua"},
    config = 'require "plugins.formatter"'
  }

  -- Language Server Protocol

  -- use {
  --   "https://github.com/neovim/nvim-lspconfig",
  --   config = 'require "plugins.lsp"'
  -- }

  use {
    "https://github.com/neoclide/coc.nvim",
    branch = "release",
    config = 'require "plugins.coc"'
  }

  -- Filetypes

  -- use {"https://github.com/sheerun/vim-polyglot"}

  use {
    "https://github.com/nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    config = function()
      require "nvim-treesitter.configs".setup {
        -- Can't install from a nix-shell so once installed do open vim in a
        -- non nix-shell shell and `:TSInstall all`
        -- ensure_installed = "maintained",
        highlight = {
          enable = true
        },
        playground = {
          enable = true,
          disable = {},
          -- Debounced time for highlighting nodes in the playground from
          -- source code
          updatetime = 25,
          -- Whether the query persists across vim sessions
          persist_queries = false
        }
      }
      -- Use when the treesitter buffer gets messed up
      require "util".noremap(
        "n",
        "<space>e",
        "<cmd>write<bar>edit<bar>TSBufEnable highlight<cr>"
      )
    end,
    requires = {
      {
        "https://github.com/nvim-treesitter/playground",
        config = function()
          require "util".buf_noremap(
            "n",
            "ga",
            "<cmd>TSHighlightCapturesUnderCursor<cr>"
          )
        end
      }
    }
  }

  -- Version Control

  use {
    "https://github.com/tpope/vim-fugitive",
    after = "vim-alias",
    config = function()
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
    end
  }

  use {"https://github.com/tpope/vim-rhubarb"}

  use {"https://github.com/christoomey/vim-conflicted"}

  -- Searching

  use {
    "https://github.com/mhinz/vim-grepper",
    config = 'require "plugins.grepper"'
  }

  -- Fuzzy Picker

  use {
    "https://github.com/nvim-telescope/telescope.nvim",
    requires = {{"nvim-lua/popup.nvim"}, {"nvim-lua/plenary.nvim"}},
    config = 'require "plugins.telescope"'
  }

  use {
    "~/.furnisher/gitmodules/fzf.vim",
    branch = "local-gfiles",
    config = 'require "plugins.fzf"',
    requires = {
      {"https://github.com/junegunn/fzf"},
      {
        "https://github.com/antoinemadec/coc-fzf",
        branch = "release",
        config = "require 'plugins.fzf-coc'"
      },
      {
        "https://github.com/stsewd/fzf-checkout.vim",
        config = "require 'plugins/fzf-checkout'"
      }
    }
  }

  -- CLI Tools

  use {"https://github.com/editorconfig/editorconfig-vim"}

  use {
    "https://github.com/tyru/open-browser.vim",
    config = function()
      local util = require "util"
      vim.g.openbrowser_message_verbosity = 1
      vim.g.openbrowser_use_vimproc = 0
      util.map("n", "go", "<plug>(openbrowser-smart-search)")
      util.map("v", "go", "<plug>(openbrowser-smart-search)")
    end
  }

  use {
    "https://github.com/tpope/vim-eunuch",
    after = "vim-alias",
    config = function()
      vim.cmd("Alias mv Move")
      vim.cmd("Alias rm Delete")
      vim.cmd("Alias ren Rename")
      vim.cmd("Alias cmo Chmod")
      vim.cmd("Alias mk Mkdir")
      vim.cmd("Alias sue SudoEdit")
      vim.cmd("Alias suw SudoWrite")
    end
  }

  -- Colors

  use {
    "https://github.com/norcalli/nvim-colorizer.lua",
    event = "VimEnter *",
    config = 'require "colorizer".setup(nil, {hsl_fn = true})'
  }

  -- Window Management

  -- use {
  --   "https://github.com/szw/vim-maximizer",
  --   config = function()
  --     local util = require "util"
  --     vim.g.maximizer_set_default_mapping = 0
  --     util.noremap("n", "<c-w>m", "<cmd>MaximizerToggle!<cr>", {silent = true})
  --     util.noremap(
  --       "n",
  --       "<c-w><c-m>",
  --       "<cmd>MaximizerToggle!<cr>",
  --       {silent = true}
  --     )
  --   end
  -- }

  -- use {"https://github.com/t9md/vim-choosewin"}
  -- util.map("n", "<space>w", "<plug>(choosewin)", {silent = true})

  -- Other

  use {"https://github.com/tweekmonster/startuptime.vim"}

  -- use {"https://github.com/tjdevries/express_line.nvim"}

  use {
    "https://github.com/tpope/vim-scriptease",
    after = "vim-alias",
    config = function()
      vim.cmd("Alias ve Vedit")
      vim.cmd("Alias vo Vopen")
      vim.cmd("Alias vr Vread")
      vim.cmd("Alias vs Vsplit")
      vim.cmd("Alias vv Vvsplit")
      vim.cmd("Alias vt Vtabedit")
      vim.cmd("Alias vos Vsplit!")
      vim.cmd("Alias vov Vvsplit!")
      vim.cmd("Alias vot Vtabedit!")
    end
  }

  use {"https://github.com/tpope/vim-characterize"}
  util.map("n", "gz", "<plug>(characterize)")

  -- use {"https://github.com/zhimsel/vim-stay"}

  use {"https://github.com/kopischke/vim-fetch"}

  use {"https://github.com/AndrewRadev/linediff.vim"}

  use {
    "https://github.com/tpope/vim-unimpaired",
    config = function()
      local util = require "util"
      local unmaps = {"[l", "[L", "]l", "]L", "=p", "=P", "=o", "=O", "=op"}
      for _, m in ipairs(unmaps) do
        vim.cmd("silent! unmap " .. m)
      end
      util.map("n", "[w", "<plug>unimpairedLPrevious")
      util.map("n", "[W", "<plug>unimpairedLFirst")
      util.map("n", "]w", "<plug>unimpairedLNext")
      util.map("n", "]W", "<plug>unimpairedLLast")
      util.map("n", "co", "yo")
    end
  }

  use {"https://github.com/mbbill/undotree"}
  vim.g.undotree_DiffAutoOpen = 0
  vim.g.undotree_SetFocusWhenToggle = 1
  vim.g.undotree_SplitWidth = 40
  util.noremap("n", "<leader>u", ":UndotreeToggle<cr>", {silent = true})

  use {
    "https://github.com/justinmk/vim-dirvish",
    config = 'require "plugins.dirvish"'
  }

  -- use {
  --   "https://github.com/kyazdani42/nvim-tree.lua",
  --   config = 'require"plugins.nvim-tree"'
  -- }

  -- use {"https://github.com/preservim/nerdtree"}

  -- use {"https://github.com/mattn/emmet-vim"}
end
