return {
  "saghen/blink.cmp",
  dependencies = {
    { "xzbdmw/colorful-menu.nvim" },
  },
  lazy = false,
  opts = {
    keymap = {
      preset = "super-tab",
      ["<CR>"] = { "select_and_accept", "fallback" },
      ["<Up>"] = { "select_prev", "fallback" },
      ["<C-k>"] = { "select_prev", "fallback" },
      ["<Down>"] = { "select_next", "fallback" },
      ["<C-j>"] = { "select_next", "fallback" },
      ["<C-M-j>"] = { "scroll_documentation_down" },
      ["<C-M-k>"] = { "scroll_documentation_up" },
    },
    completion = {
      accept = { auto_brackets = { enabled = false } },
      menu = {
        auto_show = true,
        draw = {
          columns = {
            { "kind_icon", "label", gap = 1 },
            { "kind" },
          },
          components = {
            label = {
              text = function(ctx)
                return require("colorful-menu").blink_components_text(ctx)
              end,
              highlight = function(ctx)
                return require("colorful-menu").blink_components_highlight(ctx)
              end,
            },
          },
          treesitter = { "lsp" },
        },
      },

      -- Show documentation when selecting a completion item
      documentation = { auto_show = true, auto_show_delay_ms = 500 },

      keyword = { range = "full" },

      list = {
        selection = {
          preselect = true,
          auto_insert = false,
        },
      },
      -- Display a preview of the selected item on the current line
      ghost_text = { enabled = true },

      trigger = {
        show_in_snippet = true,
      },
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },

    signature = { enabled = true },

    cmdline = {
      enabled = true,
      keymap = {
        -- preset = "cmdline",
        preset = "super-tab",
        ["<Up>"] = { "select_prev" },
        ["<C-k>"] = { "select_prev" },
        ["<Down>"] = { "select_next" },
        ["<C-j>"] = { "select_next" },
      },
      sources = function()
        local type = vim.fn.getcmdtype()
        -- Search forward and backward
        if type == "/" or type == "?" then
          return { "buffer" }
        end
        -- Commands
        if type == ":" or type == "@" then
          return { "cmdline" }
        end
        return {}
      end,
      completion = {
        trigger = {
          show_on_blocked_trigger_characters = {},
          show_on_x_blocked_trigger_characters = {},
        },
        list = {
          selection = {
            -- When `true`, will automatically select the first item in the completion list
            preselect = true,
            -- When `true`, inserts the completion item automatically when selecting it
            auto_insert = true,
          },
        },
        -- Whether to automatically show the window when new completion items are available
        menu = { auto_show = true },
        -- Displays a preview of the selected item on the current line
        ghost_text = { enabled = true },
      },
    },
  },
}
