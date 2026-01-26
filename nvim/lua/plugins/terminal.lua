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

-- Track which terminals were hidden (for restore) in order
_G.snacks_hidden_terms = _G.snacks_hidden_terms or {}
-- Track the order terminals were opened
_G.snacks_terminal_order = _G.snacks_terminal_order or {}

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
    -- Terminal not visible, open it and track order
    Snacks.terminal(cmd, opts)
    -- Track this terminal's count for ordering
    local count = opts.count
    -- Remove if already in order list, then add to end
    for i, c in ipairs(_G.snacks_terminal_order) do
      if c == count then
        table.remove(_G.snacks_terminal_order, i)
        break
      end
    end
    table.insert(_G.snacks_terminal_order, count)
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
    -- Build a map of count -> term for ordering
    local term_by_count = {}
    for _, term in ipairs(_G.snacks_hidden_terms) do
      if term:buf_valid() then
        local term_info = vim.b[term.buf].snacks_terminal
        if term_info and term_info.id then
          term_by_count[term_info.id] = term
        end
      end
    end
    
    -- Restore in the order they were originally opened
    for _, count in ipairs(_G.snacks_terminal_order) do
      local term = term_by_count[count]
      if term and not term:win_valid() then
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
      -- Arrow key parity for terminal mode
      { "<C-Left>", "<cmd>wincmd h<cr>", desc = "Window Left", mode = "t" },
      { "<C-Down>", "<cmd>wincmd j<cr>", desc = "Window Down", mode = "t" },
      { "<C-Up>", "<cmd>wincmd k<cr>", desc = "Window Up", mode = "t" },
      { "<C-Right>", "<cmd>wincmd l<cr>", desc = "Window Right", mode = "t" },
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
