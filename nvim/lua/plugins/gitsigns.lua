-- LazyVim provides these gitsigns defaults:
--   ]h / [h      — next/prev hunk
--   ]H / [H      — last/first hunk
--   <leader>ghs  — stage hunk
--   <leader>ghr  — reset hunk (revert changes)
--   <leader>ghR  — reset buffer
--   <leader>ghS  — stage buffer
--   <leader>ghu  — undo stage hunk
--   <leader>ghp  — preview hunk inline
--   <leader>ghb  — blame line
--   <leader>ghB  — blame buffer
--   <leader>ghd  — diff this
--   <leader>ghD  — diff this ~
--   ih           — text object for hunk (use with d, y, v, etc.)
--
-- This config adds extra toggles under <leader>gt

return {
  {
    "lewis6991/gitsigns.nvim",
    keys = {
      {
        "<leader>gtb",
        function()
          require("gitsigns").toggle_current_line_blame()
        end,
        desc = "Toggle Line Blame",
      },
      {
        "<leader>gtw",
        function()
          require("gitsigns").toggle_word_diff()
        end,
        desc = "Toggle Word Diff",
      },
      {
        "<leader>gtd",
        function()
          require("gitsigns").toggle_deleted()
        end,
        desc = "Toggle Deleted",
      },
    },
  },
}
