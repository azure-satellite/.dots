-- TODO
-- Function to:
--   Move selected code into its own file using <plug>(coc-codeaction-selected)
--   Prompt for file name and rename the new file
--   Open new file in a split
-- Move code to existing file
-- Port https://marketplace.visualstudio.com/items?itemName=nicoespeon.abracadabra to COC

local ft = {
  "typescript",
  "typescriptreact",
  "typescript.tsx",
  "typescript.jsx",
  "javascript",
  "javascriptreact",
  "html",
  "json",
  "css",
  "lua"
}

-- There are issues with the cursor dissapearing without this
vim.g.coc_disable_transparent_cursor = 1
vim.g.coc_snippet_prev = "<c-h>"
vim.g.coc_snippet_next = "<c-l>"

vim.g.coc_global_extensions = {
  "coc-tsserver",
  "coc-eslint",
  "coc-prettier",
  "coc-css",
  "coc-json",
  "coc-lua",
  "coc-snippets"
}

vim.g.coc_user_config = {
  diagnostic = {
    enable = true,
    messageTarget = "echo"
  },
  signature = {
    enable = false
  },
  list = {
    nextKeymap = "<c-n>",
    previousKeymap = "<c-p>",
    source = {
      symbols = {
        excludes = {"**/node_modules/**"}
      }
    }
  },
  suggest = {
    autoTrigger = "none",
    noselect = false
  },
  snippets = {
    ultisnips = {enable = false},
    userSnippetsDirectory = string.format(
      "%s/nvim/snippets",
      vim.fn.getenv("XDG_CONFIG_HOME")
    )
  },
  coc = {
    preferences = {
      formatOnSaveFiletypes = ft
    }
  },
  javascript = {
    suggestionActions = {
      enabled = false
    }
  },
  Lua = {diagnostics = {globals = {"vim"}}}
}

U.au(
  {
    event = "FileType",
    pattern = table.concat(ft, ","),
    cmd = function()
      -- Disable coc when a file is being diffed
      U.au(
        {
          event = "OptionSet",
          pattern = "diff",
          cmd = function()
            -- Apparently there's no way to disable for only current buffer
            -- so... yeah.
            if vim.v.option_new == "1" then
              vim.cmd("CocDisable")
            else
              vim.cmd("CocEnable")
            end
          end
        }
      )

      U.buf_map("n", "=", "<plug>(coc-format-selected)", {silent = true})
      U.buf_map("n", "==", "<plug>(coc-format)", {silent = true})
      U.buf_map("n", "[r", "<plug>(coc-diagnostic-prev)")
      U.buf_map("n", "]r", "<plug>(coc-diagnostic-next)")
      U.buf_map("n", "gd", "<plug>(coc-definition)")
      -- U.buf_map("n", "<space>lu", "<plug>(coc-references)")
      -- U.buf_map("n", "<space>lr", "<plug>(coc-rename)")
      -- U.buf_map("n", "<space>lf", "<plug>(coc-refactor)")
      U.buf_map("x", "<space>la", "<plug>(coc-codeaction-selected)", {silent = true})
      U.buf_map("n", "<space>la", "<plug>(coc-codeaction)", {silent = true})
      U.buf_noremap(
        "i",
        "<tab>",
        function()
          local col = vim.fn.col(".")
          local line = vim.fn.getline(".")
          if vim.fn.pumvisible() ~= 0 then
            -- If popup menu is open, select next item
            return ""
          elseif string.match(line[col - 2], "%s") or col == 1 then
            -- If a tab is predecing or this is the first column, insert <tab>
            return "	"
          else
            -- Open the popup menu
            return vim.fn["coc#refresh"]()
          end
        end,
        {expr = true}
      )

      U.buf_noremap(
        "i",
        "<cr>",
        function()
          if vim.fn.pumvisible() ~= 0 then
            -- If popup menu is open, accept current completion suggestion
            return ""
          elseif vim.fn["coc#expandableOrJumpable"]() then
            -- If the input string is a snippet, expand it
            return string.format(
              "=%s\",
              "coc#rpc#request('doKeymap', ['snippets-expand', ''])"
            )
          else
            -- Insert <cr> and notify coc so it formats the buffer
            return string.format("\=%s\", "coc#on_enter()")
          end
        end,
        {expr = true}
      )

      -- When errors occur midway editing all those underlines make it really
      -- hard to read the code
      vim.cmd("hi! CocUnderline gui=NONE")
    end
  }
)
