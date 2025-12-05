return {
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        {
          mode = { "n", "v" },
          { "<leader>a", group = "ai", icon = "󰚩" },
          { "<leader>aa", group = "avante", icon = "" },
          { "<leader>ac", group = "claude code", icon = "" },
          { "<leader>ao", group = "codecompanion", icon = "" },
        },
        {
          mode = { "n", "x" },
          { "<leader>G", icon = "🪝", desc = "Grapple" },
          { "<leader>gt", group = "git toggles", icon = "" },
          { "<leader>i", group = "info", icon = "" },
          { "<leader>j", group = "jj", icon = "" },
          { "<leader>m", group = "multicursors", icon = "󰗧" },
        },
        { "<leader>ip", "<cmd>pwd<cr>", icon = "", desc = "PWD" },
        { "<leader>iP", "<c-g>", icon = "", desc = "File Path" },
      },
    },
  },
}
