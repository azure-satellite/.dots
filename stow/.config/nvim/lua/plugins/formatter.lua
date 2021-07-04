require("formatter").setup(
  {
    logging = false,
    filetype = {
      lua = {
        function()
          return {
            exe = "luafmt",
            args = {"--indent-count", 2, "--stdin", "--line-width", 80},
            stdin = true
          }
        end
      }
    }
  }
)

U.au(
  {
    event = "BufWritePost",
    pattern = "*.lua",
    cmd = "FormatWrite"
  }
)
