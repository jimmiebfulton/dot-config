return {
  {
    "zbirenbaum/copilot.lua",
    enabled = true,
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "BufReadPost",
    opts = {
      suggestion = {
        enabled = false,
        auto_trigger = false,
      },
      panel = {
        enabled = false,
      },
    },
    keys = {
      {
        "<leader>uP",
        function()
          local suggestion = require("copilot.suggestion")
          if suggestion.is_visible() then
            suggestion.dismiss()
          else
            suggestion.toggle_auto_trigger()
          end
        end,
        desc = "Toggle Copilot",
      },
    },
  },
}
