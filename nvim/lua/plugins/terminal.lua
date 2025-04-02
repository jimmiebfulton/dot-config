return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    lazy = false,
    opts = {
      autochdir = true,
      persist_mode = false,
      shell = "nu",
      hide_numbers = true,
      start_in_insert = true,
      on_create = function()
        vim.cmd([[ setlocal signcolumn=no ]])
      end,
    },
    keys = {
      {
        "<c-/>",
        "<cmd>9ToggleTerm size=35 direction=float<cr>",
        desc = "Terminal Float",
        mode = { "n", "t" },
      },
      {
        "<c-,>",
        function()
          require("toggleterm").toggle(7, 35, nil, "horizontal", "Left")
        end,
        desc = "Terminal Toggle",
        mode = { "n" },
      },
      {
        "<c-.>",
        function()
          require("toggleterm").toggle(8, 35, nil, "horizontal", "Right")
        end,
        desc = "Terminal Toggle",
        mode = { "n" },
      },
      {
        "<c-h>",
        "<cmd>wincmd h<cr>",
        desc = "Window Left",
        mode = { "t" },
      },
      {
        "<c-j>",
        "<cmd>wincmd j<cr>",
        desc = "Window Up",
        mode = { "t" },
      },
      {
        "<c-k>",
        "<cmd>wincmd k<cr>",
        desc = "Window Down",
        mode = { "t" },
      },
      {
        "<c-l>",
        "<cmd>wincmd l<cr>",
        desc = "Window Right",
        mode = { "t" },
      },
      {
        "<c-,>",
        function()
          require("toggleterm").toggle(7, 35, nil, "horizontal", "Left")
        end,
        desc = "Terminal Toggle",
        mode = { "t" },
      },
      {
        "<c-.>",
        function()
          require("toggleterm").toggle(8, 35, nil, "horizontal", "Right")
        end,
        desc = "Terminal Toggle",
        mode = { "t" },
      },
      {
        "<c-\\>",
        function()
          require("toggleterm").toggle_all(nil)
        end,
        desc = "Terminal Toggle",
        mode = { "n", "t" },
      },
    },
  },
}
