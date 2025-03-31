local bufnr = vim.api.nvim_get_current_buf()

vim.keymap.set(
  "n",
  "<leader>ck", -- Override Neovim's built-in hover keymap with rustaceanvim's hover actions
  function()
    vim.cmd.RustLsp({ "hover", "actions" })
    vim.cmd.RustLsp({ "hover", "actions" })
  end,
  { silent = false, buffer = bufnr, desc = "Rust Doc" }
)
