return {
  {
    "s1n7ax/nvim-window-picker",
    enabled = true,
    name = "window-picker",
    event = "VeryLazy",
    version = "2.*",
    config = function()
      local picker = require("window-picker")

      picker.setup({
        -- Use "floating-big-letter" for mnemonic letters
        -- hint = "floating-big-letter",
        hint = "floating-letter",
        show_prompt = true,

        -- Customize your mnemonic keys - these are home row keys on QWERTY
        selection_chars = "fjdksla;cmrueiwoqp",
      })

      -- Add keybinding to pick a window
      vim.keymap.set("n", "<leader>wp", function()
        local window_id = picker.pick_window()
        if window_id then
          vim.api.nvim_set_current_win(window_id)
        end
      end, { desc = "Switch Window Select" })

      vim.keymap.set("n", "<leader>wc", function()
        local window_id = picker.pick_window()
        if window_id then
          vim.api.nvim_win_close(window_id, false)
        end
      end, { desc = "Close Window Select" })
    end,
  },

  {
    "yorickpeterse/nvim-window",
    enabled = true,
    lazy = false,
    priority = 1000,
    keys = {
      { "<leader><space>", "<cmd>lua require('nvim-window').pick()<cr>", desc = "Select Window" },
    },
    opts = {

      -- A group to use for overwriting the Normal highlight group in the floating
      -- window. This can be used to change the background color.
      normal_hl = "TodoBdFIX",

      -- The highlight group to apply to the line that contains the hint characters.
      -- This is used to make them stand out more.
      hint_hl = "@text.strong",

      -- The border style to use for the floating window.
      border = "single",

      -- How the hints should be rendered. The possible values are:
      --
      -- - "float" (default): renders the hints using floating windows
      -- - "status": renders the hints to a string and calls `redrawstatus`,
      --   allowing you to show the hints in a status or winbar line
      render = "float",
      chars = {
        "f",
        "j",
        "d",
        "k",
        "s",
        "l",
        "a",
        ";",
        "c",
        "m",
        "r",
        "u",
        "e",
        "i",
        "w",
        "o",
        "q",
        "p",
      },
    },
  },
}
