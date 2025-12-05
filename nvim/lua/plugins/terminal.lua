-- Helper to toggle terminal from any window context (including floats like snacks explorer)
local function toggle_term_safe(id, size, direction)
  return function()
    local win = vim.api.nvim_get_current_win()
    local win_config = vim.api.nvim_win_get_config(win)

    -- If we're in a floating window, find a non-floating window first
    if win_config.relative ~= "" then
      -- Find first non-floating window
      for _, w in ipairs(vim.api.nvim_list_wins()) do
        local cfg = vim.api.nvim_win_get_config(w)
        if cfg.relative == "" then
          vim.api.nvim_set_current_win(w)
          break
        end
      end
    end

    vim.cmd(string.format("%dToggleTerm size=%d direction=%s", id, size, direction))
  end
end

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
        toggle_term_safe(7, 35, "horizontal"),
        desc = "Terminal Left",
        mode = { "n" },
      },
      {
        "<c-.>",
        toggle_term_safe(8, 35, "horizontal"),
        desc = "Terminal Right",
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
        desc = "Window Down",
        mode = { "t" },
      },
      {
        "<c-k>",
        "<cmd>wincmd k<cr>",
        desc = "Window Up",
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
        toggle_term_safe(7, 35, "horizontal"),
        desc = "Terminal Left",
        mode = { "t" },
      },
      {
        "<c-.>",
        toggle_term_safe(8, 35, "horizontal"),
        desc = "Terminal Right",
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
