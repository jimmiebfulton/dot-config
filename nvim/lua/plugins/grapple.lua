return {
  {
    "cbochs/grapple.nvim",
    opts = {
      scope = "git", -- also try out "git_branch"
    },
    event = { "BufReadPost", "BufNewFile" },
    cmd = "Grapple",
    keys = {
      { "<leader>G", desc = "Grapple" },
      { "<leader>Gg", "<cmd>Grapple toggle<cr>", desc = "Grapple Toggle Tag" },
      { "<leader>GG", "<cmd>Grapple toggle_tags<cr>", desc = "Grapple Open Tags" },
      { "<leader>Gn", "<cmd>Grapple cycle_tags next<cr>", desc = "Grapple Next Tag" },
      { "<leader>Gp", "<cmd>Grapple cycle_tags prev<cr>", desc = "Grapple Prev Tag" },
    },
  },
}
