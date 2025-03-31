return {
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    keys = {
      {
        "<leader>bs",
        "<cmd>BufferLinePick<cr>",
        desc = "Select Buffer",
      },
    },
    opts = {
      options = {
        always_show_bufferline = false,
        separator_style = "slope",
        auto_toggle_bufferline = true,
        enforce_regular_tabs = false,
        show_buffer_close_icons = false,
      },
    },
  },
}
