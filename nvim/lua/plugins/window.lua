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
        hint = "floating-big-letter",
        show_prompt = false,
        selection_chars = "fjdksla;cmrueiwoqp",
        filter_rules = {
          autoselect_one = true,
          include_current_win = false,
          bo = {
            filetype = { "NvimTree", "neo-tree", "notify", "snacks_notif" },
            buftype = { "terminal", "quickfix" },
          },
        },
      })

      local function pick_window()
        local window_id = picker.pick_window()
        if window_id then
          vim.api.nvim_set_current_win(window_id)
        end
      end

      vim.keymap.set("n", "<leader><leader>", pick_window, { desc = "Select Window" })
      vim.keymap.set("n", "<leader>wp", pick_window, { desc = "Select Window" })

      vim.keymap.set("n", "<leader>wc", function()
        local window_id = picker.pick_window()
        if window_id then
          vim.api.nvim_win_close(window_id, false)
        end
      end, { desc = "Close Window Select" })
    end,
  },
}
