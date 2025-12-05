-- Snacks terminal configuration (replaces toggleterm)
-- Uses nushell as default shell

-- Terminal configurations (centralized for toggle-all)
local terminal_configs = {
  bottom = {
    cmd = "nu",
    opts = {
      count = 1,
      win = {
        position = "bottom",
        height = 0.35,
      },
    },
  },
  second = {
    cmd = "nu",
    opts = {
      count = 2,
      env = { SNACKS_TERM_ID = "second" },
      win = {
        position = "bottom",
        height = 0.35,
      },
    },
  },
  float = {
    cmd = "nu",
    opts = {
      count = 3,
      env = { SNACKS_TERM_ID = "float" },
      win = {
        position = "float",
        height = 0.8,
        width = 0.8,
        border = "rounded",
        backdrop = 60,
        zindex = 50,
      },
    },
  },
}

-- Track which terminals were hidden (for restore)
_G.snacks_hidden_terms = _G.snacks_hidden_terms or {}

-- Focus terminal if visible and not current, toggle if current or closed
local function smart_terminal(cmd, opts)
  local term = Snacks.terminal.get(cmd, { create = false, count = opts.count, env = opts.env, cwd = opts.cwd })
  if term and term:win_valid() then
    if term.win == vim.api.nvim_get_current_win() then
      -- We're in this terminal, toggle it off
      term:hide()
    else
      -- Terminal is visible but we're elsewhere, focus it
      vim.api.nvim_set_current_win(term.win)
      vim.cmd.startinsert()
    end
  else
    -- Terminal not visible, open it
    Snacks.terminal(cmd, opts)
  end
end

function _G.toggle_all_terminals()
  -- Get all terminal objects from Snacks
  local all_terminals = Snacks.terminal.list()
  
  -- Find which ones are currently visible (have a valid window)
  local visible = {}
  for _, term in ipairs(all_terminals) do
    if term:win_valid() then
      table.insert(visible, term)
    end
  end
  
  if #visible > 0 then
    -- Hide all visible terminals and remember them
    _G.snacks_hidden_terms = visible
    for _, term in ipairs(visible) do
      term:hide()
    end
  elseif #_G.snacks_hidden_terms > 0 then
    -- Restore only the terminals that were previously visible
    for _, term in ipairs(_G.snacks_hidden_terms) do
      if term:buf_valid() and not term:win_valid() then
        term:show()
      end
    end
    _G.snacks_hidden_terms = {}
  end
end

return {
  {
    "folke/snacks.nvim",
    opts = {
      terminal = {
        win = {
          wo = {
            signcolumn = "no",
          },
          keys = {
            hide_slash = false, -- Disable LazyVim's <C-/> hide so we can use it for float
          },
        },
      },
    },
    keys = {
      -- Bottom terminal
      {
        "<C-,>",
        function()
          local cfg = terminal_configs.bottom
          smart_terminal(cfg.cmd, cfg.opts)
        end,
        desc = "Terminal Bottom",
        mode = { "n", "t" },
      },
      -- Second bottom terminal
      {
        "<C-.>",
        function()
          local cfg = terminal_configs.second
          smart_terminal(cfg.cmd, cfg.opts)
        end,
        desc = "Terminal Bottom (2)",
        mode = { "n", "t" },
      },
      -- Floating terminal
      {
        "<C-/>",
        function()
          local cfg = terminal_configs.float
          smart_terminal(cfg.cmd, cfg.opts)
        end,
        desc = "Terminal Float",
        mode = { "n", "t" },
      },
      -- Window navigation from terminal mode
      { "<C-h>", "<cmd>wincmd h<cr>", desc = "Window Left", mode = "t" },
      { "<C-j>", "<cmd>wincmd j<cr>", desc = "Window Down", mode = "t" },
      { "<C-k>", "<cmd>wincmd k<cr>", desc = "Window Up", mode = "t" },
      { "<C-l>", "<cmd>wincmd l<cr>", desc = "Window Right", mode = "t" },
      -- Toggle all terminals
      {
        "<C-\\>",
        function()
          _G.toggle_all_terminals()
        end,
        desc = "Toggle All Terminals",
        mode = { "n", "t" },
      },
    },
  },
}
