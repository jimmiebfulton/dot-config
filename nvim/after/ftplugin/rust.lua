local bufnr = vim.api.nvim_get_current_buf()

vim.keymap.set(
  "n",
  "<leader>ck",
  function()
    vim.cmd.RustLsp({ "hover", "actions" })
    vim.cmd.RustLsp({ "hover", "actions" })
  end,
  { silent = true, buffer = bufnr, desc = "Rust Hover Actions" }
)
