return {
  "sphamba/smear-cursor.nvim",
  config = function()
    if not vim.g.neovide then
      require("smear_cursor").setup()
    end
  end,
}
