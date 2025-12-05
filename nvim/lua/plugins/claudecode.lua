-- Claude Code: Integrates Claude CLI with Neovim via WebSocket
-- When Claude CLI runs, it automatically connects and can access your editor
-- Uses <leader>ac prefix

return {
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    opts = {
      auto_start = true,
      log_level = "warn",
      -- Use nushell to run claude, which has the proper PATH
      terminal_cmd = "nu -l -c 'claude --dangerously-skip-permissions'",
      terminal = {
        split_side = "right",
        split_width_percentage = 0.4,
        provider = "snacks",
      },
    },
    keys = {
      { "<leader>ac", desc = "Claude Code" },
      { "<leader>acc", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>acf", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>acs", "<cmd>ClaudeCodeSend<cr>", desc = "Send Selection", mode = "v" },
      { "<leader>aco", "<cmd>ClaudeCodeOpen<cr>", desc = "Open Claude" },
      { "<leader>acx", "<cmd>ClaudeCodeClose<cr>", desc = "Close Claude" },
    },
  },
}
