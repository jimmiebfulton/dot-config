-- Codecompanion: Chat-based AI assistant with inline actions
-- Uses <leader>ao prefix (o for "other" or "open")

return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      adapters = {
        anthropic = function()
          return require("codecompanion.adapters").extend("anthropic", {
            schema = {
              model = {
                default = "claude-sonnet-4-20250514",
              },
            },
          })
        end,
      },
      strategies = {
        chat = {
          adapter = "anthropic",
        },
        inline = {
          adapter = "anthropic",
        },
      },
      display = {
        chat = {
          window = {
            layout = "vertical",
            width = 0.4,
          },
        },
      },
    },
    keys = {
      { "<leader>ao", desc = "Codecompanion" },
      -- Chat
      { "<leader>aoc", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Toggle Chat", mode = { "n", "v" } },
      { "<leader>aon", "<cmd>CodeCompanionChat<cr>", desc = "New Chat", mode = { "n", "v" } },
      { "<leader>aoa", "<cmd>CodeCompanionChat Add<cr>", desc = "Add Selection to Chat", mode = "v" },

      -- Inline assistance
      { "<leader>aoi", "<cmd>CodeCompanion<cr>", desc = "Inline Assist", mode = { "n", "v" } },

      -- Quick actions (visual mode)
      { "<leader>aoe", "<cmd>CodeCompanion /explain<cr>", desc = "Explain Code", mode = "v" },
      { "<leader>aof", "<cmd>CodeCompanion /fix<cr>", desc = "Fix Code", mode = "v" },
      { "<leader>aor", "<cmd>CodeCompanion /refactor<cr>", desc = "Refactor Code", mode = "v" },
      { "<leader>aot", "<cmd>CodeCompanion /tests<cr>", desc = "Generate Tests", mode = "v" },
      { "<leader>aod", "<cmd>CodeCompanion /doc<cr>", desc = "Add Documentation", mode = "v" },

      -- Actions menu
      { "<leader>aop", "<cmd>CodeCompanionActions<cr>", desc = "Actions Palette", mode = { "n", "v" } },
    },
    config = function(_, opts)
      require("codecompanion").setup(opts)
    end,
  },
}
