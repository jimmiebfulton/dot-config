return {
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>G", icon = "🪝", desc = "Grapple" },
        { "<leader>i", icon = "", desc = "Info" },
        { "<leader>j", icon = "", desc = "JJ" },
        { "<leader>m", icon = "󰗧", desc = "Multicursors", mode = { "n", "x" } },
        { "<leader>ip", "<cmd>pwd<cr>", icon = "", desc = "PWD" },
        { "<leader>iP", "<c-g>", icon = "", desc = "File Path" },
      },
    },
  },
}
