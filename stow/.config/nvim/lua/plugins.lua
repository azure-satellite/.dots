local util = require("util")

vim.g.loaded_gzip = 0 -- Edit compressed files
vim.g.loaded_matchparen = 1 -- Show matching parentheses
vim.g.loaded_netrwPlugin = 1 -- Filetree and more
vim.g.loaded_spellfile_plugin = 1 -- Download spell files
vim.g.loaded_2html_plugin = 1 -- Convert syntax highlighted file to html
vim.g.loaded_tutor_mode_plugin = 1 -- Vim tutor

return function(use)
  -- Let packer manage itself

  use {"https://github.com/wbthomason/packer.nvim"}

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
  use {"https://github.com/machakann/vim-swap"}
  vim.g.swap_no_default_key_mappings = 1
  util.map("n", "g<", "<plug>(swap-prev)")
  util.map("n", "g>", "<plug>(swap-next)")
  util.map("o", "i,", "<plug>(swap-textobject-i)")
  util.map("x", "i,", "<plug>(swap-textobject-i)")
  util.map("o", "a,", "<plug>(swap-textobject-a)")
  util.map("x", "a,", "<plug>(swap-textobject-a)")

  -- Operators

  use {"https://github.com/tommcdo/vim-lion"}
  use {"https://github.com/tpope/vim-commentary"}
  use {"https://github.com/tpope/vim-repeat"}
  use {"https://github.com/tommcdo/vim-exchange"}
  util.map("x", "X", "<plug>(Exchange)")
  util.map("n", "gx", "<plug>(Exchange)")
  util.map("n", "gxc", "<plug>(ExchangeClear)")
  util.map("n", "gxx", "<plug>(ExchangeLine)")

  -- Editing

  use {"https://github.com/9mm/vim-closer"}
  use {"https://github.com/tpope/vim-abolish"}
  use {"https://github.com/tpope/vim-surround"}
  vim.g.surround_no_insert_mappings = 1

  -- Language Server Protocol

  -- use {
  --   "https://github.com/neovim/nvim-lspconfig",
  --   event = "VimEnter *",
  --   config = function()
  --     require("lsp")
  --   end
  -- }

  use {"https://github.com/neoclide/coc.nvim", branch = "release"}
  util.au(
    {
      event = "FileType",
      pattern = "javascript,javascriptreact,lua",
      cmd = function()
        util.buf_map('n', '=', '<plug>(coc-format-selected)', { silent = true })
        util.buf_map('n', '==', '<plug>(coc-format)', { silent = true })
        util.buf_map('n', '[r', '<plug>(coc-diagnostic-prev)')
        util.buf_map('n', ']r', '<plug>(coc-diagnostic-next)')
        util.buf_map('n', 'gd', '<plug>(coc-definition)')
        util.buf_noremap('n', 'K', '<cmd>call CocAction("doHover")<cr>')
        util.buf_map('n', '<leader>lu', '<plug>(coc-references)')
        util.buf_map('n', '<leader>lr', '<plug>(coc-rename)')
        util.buf_map('n', '<leader>lf', '<plug>(coc-refactor)')
        util.buf_map('x', '<leader>la', '<plug>(coc-codeaction-selected)')
        util.buf_map('n', '<leader>la', '<plug>(coc-codeaction-selected)')
        util.buf_noremap('n', '<leader>li', '<cmd>call CocActionAsync("runCommand", "tsserver.organizeImports")<cr>')
        --   function! s:check_back_space() abort
        --     let col = col('.') - 1
        --     return !col || getline('.')[col - 1]  =~ '\s'
        --   endfunction
        -- <tab> triggers completion and navigates to next suggestion
        -- util.buf_noremap('i', '<tab>', 'pumvisible() ? "\\<C-n>" : <SID>check_back_space() ? "\\<TAB>" : coc#refresh()', { silent = true, expr = true })
        -- <cr> accepts current suggestion (accepting a suggestion may perform
        -- side-effects like auto importing the selected symbol and expanding a snippet)
        -- util.buf_noremap('i', '<cr>', 'pumvisible() ? "\\<C-y>" : "\\<c-g>u\\<cr>"', { expr = true })
      end
    }
  )

  vim.g.coc_global_extensions = {
    "coc-tsserver",
    "coc-eslint",
    "coc-prettier",
    "coc-css",
    "coc-json",
    "coc-lua"
  }

  vim.g.coc_user_config = {
    diagnostic = {
      enable = true,
      level = 'warning',
    },
    signature = {
      enable = false,
    },
    list = {
      nextKeymap = '<c-n>',
      previousKeymap = '<c-p>',
    },
    suggest = {
      -- noselect = false,
      completionItemKindLabels = {
        ["function"] = "𝜆 ",
        variable     = "𝑥 ",
        constant     = "𝑥 ",
        keyword      = "abc",
        method       = "􀋱  ",
        property     = "􀋱  ",
        field        = "􀋱  ",
        class        = "􀐘  ",
        module       = "􀐚  ",
        file         = "􀈿  ",
      }
    },
    coc = {
      preferences = {
        formatOnSaveFiletypes = {
          'javascript',
          'javascriptreact',
          'json',
          'html',
          'css'
        },
      }
    },
    javascript = {
      suggestionActions = {
        enabled = false,
      }
    },
    Lua = { diagnostics = { globals = { 'vim' } } }
  }

  -- Filetypes

  -- use {"https://github.com/sheerun/vim-polyglot"}

  use {
    "https://github.com/nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    event = "VimEnter *",
    config = function()
      require("nvim-treesitter.configs").setup {
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
    end,
    requires = {
      {
        "https://github.com/nvim-treesitter/playground",
        event = "VimEnter *",
        config = function()
          require("util").noremap(
            "n",
            "ga",
            "<cmd>TSHighlightCapturesUnderCursor<cr>"
          )
        end
      }
    }
  }
  -- Use when the treesitter buffer gets messed up
  util.noremap(
    "n",
    "<space>e",
    "<cmd>write<bar>edit<bar>TSBufEnable highlight<cr>"
  )

  -- Version Control

  use {"https://github.com/tpope/vim-fugitive"}
  use {"https://github.com/tpope/vim-rhubarb"}
  use {"https://github.com/christoomey/vim-conflicted"}
  use {"https://github.com/stsewd/fzf-checkout.vim"}
  util.noremap("n", "<space>j", "<cmd>GBranches<cr>", {silent = true})

  -- Searching

  use {
    "https://github.com/mhinz/vim-grepper",
    event = "VimEnter *",
    config = function()
      local util = require("util")
      vim.g.grepper =
        vim.tbl_deep_extend(
        "force",
        vim.g.grepper,
        {
          switch = 0,
          dir = "repo,file,pwd",
          side_cmd = "tabnew",
          tools = {"rg", "rgall"},
          operator = {prompt = 1},
          rg = {grepprg = vim.o.grepprg},
          rgall = {grepprg = vim.o.grepprg .. " --no-ignore-vcs"}
        }
      )
      util.map("n", "gs", "<Plug>(GrepperOperator)")
      util.noremap(
        "n",
        "gss",
        "'<cmd>Grepper ' . (&ft ==# 'dirvish' ? '-dir file' : '') . '<cr>'",
        {silent = true, expr = true}
      )
      util.noremap(
        "n",
        "gsl",
        "'<cmd>Grepper -noquickfix ' . (&ft ==# 'dirvish' ? '-dir file' : '') . '<cr>'",
        {silent = true, expr = true}
      )
    end
  }

  -- Fuzzy Picker

  use {
    "https://github.com/nvim-telescope/telescope.nvim",
    requires = {{"nvim-lua/popup.nvim"}, {"nvim-lua/plenary.nvim"}}
  }

  use {
    "~/.furnisher/gitmodules/fzf.vim",
    branch = "local-gfiles",
    requires = "https://github.com/junegunn/fzf",
    event = "VimEnter *",
    config = function()
      local util = require("util")
      vim.g.fzf_layout = {window = "call core#centered_floating_window(v:true)"}
      util.noremap("n", "<space>r", "<cmd>Rg<cr>", {silent = true})
      util.noremap("n", "<space>,", "<cmd>History:<cr>", {silent = true})
      util.noremap("n", "<space>/", "<cmd>History/<cr>", {silent = true})
      util.noremap("n", "<space>c", "<cmd>Commands<cr>", {silent = true})
      util.noremap("n", "<space>h", "<cmd>Helptags<cr>", {silent = true})
      util.noremap("n", "<space>i", "<cmd>History<cr>", {silent = true})
      util.noremap("n", "<space>l", "<cmd>BLines!<cr>", {silent = true})
      util.noremap("n", "<space>b", "<cmd>Buffers<cr>", {silent = true})
      util.noremap("n", "<space>t", "<cmd>Tags<cr>", {silent = true})
      -- Search for files at dirvish directory, otherwise, executes :Files
      -- normally
      util.noremap(
        "n",
        "<space>f",
        "'<cmd>Files ' . (&ft ==# 'dirvish' ? fnamemodify(expand('%'), ':~:h') : '') . '<cr>'",
        {silent = true, expr = true}
      )
      util.noremap(
        "n",
        "<space>g",
        "':GLFiles ' . (&ft ==# 'dirvish' ? fnamemodify(expand('%'), ':~:h') : '') . '<cr>'",
        {silent = true, expr = true}
      )
    end
  }

  -- CLI Tools

  use {"https://github.com/editorconfig/editorconfig-vim"}
  use {"https://github.com/tyru/open-browser.vim"}
  vim.g.openbrowser_message_verbosity = 1
  vim.g.openbrowser_use_vimproc = 0
  util.map("n", "go", "<plug>(openbrowser-smart-search)")
  util.map("v", "go", "<plug>(openbrowser-smart-search)")
  use {"https://github.com/tpope/vim-eunuch"}

  -- Colors

  use {
    "https://github.com/norcalli/nvim-colorizer.lua",
    event = "VimEnter *",
    config = function()
      require("colorizer").setup(nil, {hsl_fn = true})
    end
  }
  use {"https://github.com/whatyouhide/vim-gotham"}
  -- use {"https://github.com/xolox/vim-misc"}
  -- use {"https://github.com/xolox/vim-colorscheme-switcher"}

  -- Window Management

  -- use {"https://github.com/szw/vim-maximizer"}
  -- vim.g.maximizer_set_default_mapping = 0
  -- util.noremap("n", "<c-w>m", "<cmd>MaximizerToggle!<cr>", {silent = true})
  -- util.noremap("n", "<c-w><c-m>", "<cmd>MaximizerToggle!<cr>", {silent = true})
  -- use {"https://github.com/t9md/vim-choosewin"}
  -- util.map("n", "<space>w", "<plug>(choosewin)", {silent = true})

  -- Other

  use {"https://github.com/tweekmonster/startuptime.vim"}
  -- use {"https://github.com/tjdevries/express_line.nvim"}
  use {"https://github.com/tpope/vim-scriptease"}
  use {"https://github.com/tpope/vim-characterize"}
  -- use {"https://github.com/zhimsel/vim-stay"}

  use {"https://github.com/kopischke/vim-fetch"}
  util.map("n", "gz", "<plug>(characterize)")

  use {"https://github.com/AndrewRadev/linediff.vim"}
  util.noremap("x", "<leader>d", "<cmd>Linediff<cr>", {silent = true})

  use {
    "https://github.com/tpope/vim-unimpaired",
    event = "VimEnter *",
    config = function()
      local util = require("util")
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

  use {"https://github.com/justinmk/vim-dirvish"}
  vim.g.dirvish_mode = 2
  util.map("n", "<bs>", "<plug>(dirvish_up)")
  util.noremap("n", "<space><bs>", "<cmd>Dirvish<cr>", {silent = true})
  util.noremap(
    "n",
    "g<bs>",
    "<cmd>exe 'Dirvish ' . fnamemodify(b:git_dir, ':h')<cr>",
    {silent = true}
  )
  util.au(
    {
      event = "FileType",
      pattern = "dirvish",
      cmd = function()
        local util = require("util")
        -- Sort directories first
        vim.cmd("sort ,^.*[\\/],")
        -- Reload after entering a dirvish window
        util.buf_map("n", "q", "gq")
        util.au(
          {
            event = {"WinEnter", "FocusGained"},
            pattern = "<buffer>",
            cmd = "Dirvish %"
          }
        )
      end
    }
  )

  use {
    "https://github.com/konfekt/vim-alias",
    event = "VimEnter *",
    config = function()
      -- Scriptease
      vim.cmd("Alias ve Vedit")
      vim.cmd("Alias vo Vopen")
      vim.cmd("Alias vr Vread")
      vim.cmd("Alias vs Vsplit")
      vim.cmd("Alias vv Vvsplit")
      vim.cmd("Alias vt Vtabedit")
      vim.cmd("Alias vos Vsplit!")
      vim.cmd("Alias vov Vvsplit!")
      vim.cmd("Alias vot Vtabedit!")

      -- Fugitive
      vim.cmd("Alias git Git")
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

      -- Eunuch
      vim.cmd("Alias mv Move")
      vim.cmd("Alias rm Delete")
      vim.cmd("Alias ren Rename")
      vim.cmd("Alias cmo Chmod")
      vim.cmd("Alias mk Mkdir")
      vim.cmd("Alias sue SudoEdit")
      vim.cmd("Alias suw SudoWrite")

      -- Edit/load vimrc
      vim.cmd("Alias vime exec\\ 'e\\ '.$MYVIMRC")

      -- Generic aliases
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
end
