return {

  ---@type LazySpec
  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    keys = {
      -- 👇 in this section, choose your own keymappings!
      {
        "<leader>fy",
        mode = { "n", "v" },
        "<cmd>Yazi<cr>",
        desc = "Open Yazi",
      },
      {
        "<leader>fY",
        mode = { "n", "v" },
        "<cmd>Yazi cwd<cr>",
        desc = "Open Yazi (cwd)",
      },
    },
    ---@type YaziConfig
    opts = {
      -- if you want to open yazi instead of netrw, see below for more info
      open_for_directories = false,
      open_multiple_tabs = true,
      yazi_floating_window_winblend = 5,
      keymaps = {
        show_help = "<f1>",
        cycle_open_buffers = "<tab>",
      },
    },
  },
}
