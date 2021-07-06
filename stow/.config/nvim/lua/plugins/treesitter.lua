require "nvim-treesitter.configs".setup {
  ensure_installed = "maintained",
  highlight = {enable = true},
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
U.noremap(
  "n",
  "<space>e",
  "<cmd>write<bar>edit<bar>TSBufEnable highlight<bar>set fdm=indent<cr>"
)
