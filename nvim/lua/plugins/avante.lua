-- Avante: Cursor-like AI assistant with side panel and diff-based edits
-- Uses <leader>aa prefix (avante's default)

return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false,
    build = "make",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      provider = "claude",
      providers = {
        claude = {
          model = "claude-sonnet-4-20250514",
          extra_request_body = {
            max_tokens = 8192,
          },
        },
      },
      behaviour = {
        auto_suggestions = false,
        auto_set_keymaps = true,
        auto_set_highlight_group = true,
      },
      windows = {
        position = "right",
        width = 40,
        sidebar_header = {
          align = "center",
          rounded = true,
        },
      },
      mappings = {
        ask = "<leader>aaa",
        edit = "<leader>aae",
        refresh = "<leader>aar",
        focus = "<leader>aaf",
        toggle = {
          default = "<leader>aat",
          debug = "<leader>aad",
          hint = "<leader>aah",
          suggestion = "<leader>aas",
          repomap = "<leader>aam",
        },
      },
      -- Diff keymaps (in diff view):
      -- co - choose ours
      -- ct - choose theirs
      -- ca - choose all
      -- cc - choose cursor
      -- ]x / [x - navigate conflicts
    },
    keys = {
      { "<leader>aa", desc = "Avante" },
    },
  },

  -- Better markdown rendering in Avante chat
  {
    "MeanderingProgrammer/render-markdown.nvim",
    optional = true,
    ft = function(_, ft)
      vim.list_extend(ft, { "Avante" })
    end,
    opts = function(_, opts)
      opts.file_types = opts.file_types or {}
      vim.list_extend(opts.file_types, { "Avante" })
    end,
  },
}
