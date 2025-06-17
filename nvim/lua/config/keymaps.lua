-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Escape terminal mode
vim.api.nvim_set_keymap("t", "<Leader><ESC>", "<C-\\><C-n>", { noremap = true })
vim.api.nvim_set_keymap("t", "<ESC><ESC>", "<C-\\><C-n>", { noremap = true })

-- Quick commentstring setup for unknown file types
vim.keymap.set("n", "gcs", function()
  local comment_string = vim.fn.input("Comment string (use %s for text): ")
  if comment_string ~= "" then
    vim.bo.commentstring = comment_string
    print("Commentstring set to: " .. comment_string)
  end
end, { desc = "Set comment string for current buffer" })

-- Quick presets for common comment styles
vim.keymap.set("n", "gc/", function()
  vim.bo.commentstring = "// %s"
  print("Commentstring set to: // %s")
end, { desc = "Set C-style comments (//) for current buffer" })

vim.keymap.set("n", "gc#", function()
  vim.bo.commentstring = "# %s"
  print("Commentstring set to: # %s")
end, { desc = "Set shell-style comments (#) for current buffer" })

vim.keymap.set("n", "gc-", function()
  vim.bo.commentstring = "-- %s"
  print("Commentstring set to: -- %s")
end, { desc = "Set SQL/Lua-style comments (--) for current buffer" })
