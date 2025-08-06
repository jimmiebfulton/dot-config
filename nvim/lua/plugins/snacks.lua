return {
  {
    "folke/snacks.nvim",
    opts = {
      explorer = {
        replace_netrw = false,
      },
      picker = {
        formatters = {
          file = {
            filename_first = true,
            truncate = 250,
          },
        },
        win = {
          list = {
            -- keys = {
            --   ["<S-CR>"] = {
            --     -- {
            --     function()
            --       local picker = require("window-picker")
            --
            --       local window_id = picker.pick_window()
            --       if window_id then
            --         vim.api.nvim_set_current_win(window_id)
            --       end
            --     end,
            --     -- "jump",
            --     -- },
            --   },
            -- },
          },
        },
        -- win = {
        --   input = {
        --     keys = {
        --       ["<S-CR>"] = {
        --         {
        --           function()
        --             local picker = require("window-picker")
        --
        --             local window_id = picker.pick_window()
        --             if window_id then
        --               vim.api.nvim_set_current_win(window_id)
        --             end
        --           end,
        --           "jump",
        --         },
        --         mode = { "n", "i" },
        --       },
        --     },
        --   },
        -- },
      },
      terminal = {
        enabled = false,
      },
    },
    -- stylua: ignore
    keys = {
      { "<leader>fs", function() Snacks.picker.spelling() end, desc = "Spelling" },
      { "<leader>fe", function() Snacks.picker.explorer({ layout = "default", auto_close = true, focus = "input" }) end, desc = "Explorer" },
      { "<leader>fE", function() Snacks.picker.explorer({ focus = "input", auto_close = true, }) end, desc = "Explorer Sidebar" },
      { "<leader>e", function() Snacks.picker.explorer({ layout = "default", auto_close = true }) end, desc = "Explorer" },
      { "<leader>E", function() Snacks.picker.explorer() end, desc = "Explorer Sidebar" },
      { "<leader>fF", LazyVim.pick("files"), desc = "Find Files (Root Dir)" },
      { "<leader>ff", LazyVim.pick("files", { root = false }), desc = "Find Files (cwd)" },
      { "<leader>fc", desc = "Config" },
      { "<leader>fcc", function() Snacks.picker.files({ dirs = { "~/.config/", }}) end, desc = "Config" },
      { "<leader>fcn", function() Snacks.picker.files({ dirs = { "~/.config/nvim/", }}) end, desc = "Neovim" },
      { "<leader>fcN", function() Snacks.picker.files({ dirs = { "~/.config/nushell/", }}) end, desc = "Nushell" },
      { "<leader>fcf", function() Snacks.picker.files({ dirs = { "~/.config/fish/", }}) end, desc = "Fish" },
      { "<leader>fcs", function() Snacks.picker.files({ dirs = { "~/.config/starship/", }}) end, desc = "Starship" },
      { "<leader>fcy", function() Snacks.picker.files({ dirs = { "~/.config/yazi/", }}) end, desc = "Yazi" },
      { "<leader>fcw", function() Snacks.picker.files({ dirs = { "~/.config/wezterm/", }}) end, desc = "Wezterm" },
      { "<leader>sD",  function() Snacks.picker.diagnostics() end, desc = "Diagnostics (Workspace)" },
      { "<leader>sd",  function() Snacks.picker.diagnostics_buffer() end, desc = "Diagnostics (Buffer)" },
      { "<leader>sl",  function() Snacks.picker.lines({ sort = { fields = { "idx"}}}) end, desc = "Lines" },
      { "<leader>sL",  function() Snacks.picker.loclist() end, desc = "Location List" },
      { "<leader>sp",  function() Snacks.picker.pick() end, desc = "Pickers" },
      { "<leader>sP",  function() Snacks.picker.picker_layouts() end, desc = "Picker Layouts" },
      { "<leader>sz",  function() Snacks.picker.zoxide() end, desc = "Zoxide" },
      { "<leader>sZ",  function() Snacks.picker.lazy() end, desc = "Lazy" },
      { "<leader>fS", function() Snacks.picker.smart() end, desc = "Smart" },
      { "<leader><space>", function() require('nvim-window').pick() end, desc = "Select Window" },
    },
  },
}
