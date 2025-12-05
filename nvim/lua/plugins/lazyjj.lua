return {
  {
    "swaits/lazyjj.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    keys = {
      { "<leader>jj", "<cmd>LazyJJ<cr>", desc = "LazyJJ" },
    },
    opts = {
      mapping = false, -- We define our own keys above
    },
  },
}
