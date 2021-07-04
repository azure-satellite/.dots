-- https://github.com/rust-analyzer/rust-analyzer

return function(on_attach)
  return {
    cmd = {
      "rust-analyzer",
      "-v",
      "--log-file",
      vim.g.lsp_log_dir .. "/rust_analyzer.log"
    },
    on_attach = on_attach
  }
end
