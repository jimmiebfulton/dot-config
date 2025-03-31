return {
  {
    -- https://github.com/jake-stewart/multicursor.nvim
    "jake-stewart/multicursor.nvim",
    enabled = true,
    branch = "1.0",
    config = function()
      local mc = require("multicursor-nvim")

      mc.setup()

      local set = vim.keymap.set
      -- Add a cursor on every line in motion
      set({ "n" }, "ga", mc.addCursorOperator, { desc = "Add Cursors" })
      set({ "n", "x" }, "<leader>mJ", mc.matchAddCursor, { desc = "Match" })
      set({ "n", "x" }, "<leader>mA", mc.matchAllAddCursors, { desc = "Match All" })
      set({ "n", "x" }, "<leader>me", mc.enableCursors, { desc = "Enable Cursors" })
      set({ "n", "x" }, "<leader>md", mc.disableCursors, { desc = "Disable Cursors" })
      set({ "n" }, "<leader>mm", mc.toggleCursor, { desc = "Toggle Cursor" })
      set({ "x" }, "<leader>mm", mc.visualToCursors, { desc = "Visual to Cursors" })
      -- Add cursor at every regex match
      set({ "x" }, "<leader>mM", mc.matchCursors, { desc = "Match Regex" })
      set({ "x" }, "<leader>mS", mc.splitCursors, { desc = "Split Regex" })
      set({ "n", "x" }, "<leader>mo", mc.operator, { desc = "Operator" })

      set("v", "<leader>mt", function()
        mc.transposeCursors(1)
      end, { desc = "Transpose Down" })

      set("v", "<leader>mT", function()
        mc.transposeCursors(-1)
      end, { desc = "Transpose Up" })
      -- a, b, c, d

      set({ "n", "x" }, "<leader>mj", function()
        mc.lineAddCursor(1)
      end, { desc = "Add Cursor Down" })
      set({ "n", "x" }, "<leader>mk", function()
        mc.lineAddCursor(-1)
      end, { desc = "Add Cursor Up" })

      set({ "n", "x" }, "<leader>m|", mc.alignCursors, { desc = "Align Cursors" })

      set({ "n", "x" }, "<leader>mw", function()
        -- In normal/visual mode, press `mcwif` will create a cursor in every match of
        -- the word captured by `iw` (or visually selected range) inside the bigger
        -- range specified by `ap`. Useful to replace a word inside a function, e.g. mwif.
        require("multicursor-nvim").operator({ motion = "iw", visual = true })
        -- Or you can pass a pattern, press `mwi{` will select every \w,
        -- basically every char in a `{ a, b, c, d }`.
        -- mc.operator({ pattern = [[\<\w]] })
      end, { desc = "Inside Word" })

      set({ "n", "x" }, "<leader>mi", function()
        require("multicursor-nvim").operator({ motion = "i", visual = true })
      end, { desc = "Inside" })

      set({ "n", "x" }, "<leader>ma", function()
        require("multicursor-nvim").operator({ motion = "a", visual = false })
      end, { desc = "Around" })

      set({ "n", "x" }, "<leader>ms", function()
        require("multicursor-nvim").operator({ motion = "s", visual = false })
      end, { desc = "Flash" })

      set({ "n", "x" }, "<leader>mS", function()
        require("multicursor-nvim").operator({ motion = "S", visual = false })
      end, { desc = "Flash Treesitter" })

      set({ "n", "x" }, "<leader>mf", function()
        require("multicursor-nvim").operator({ motion = "f", visual = false })
      end, { desc = "Forward" })

      set({ "n", "x" }, "<leader>mt", function()
        require("multicursor-nvim").operator({ motion = "t", visual = false })
      end, { desc = "To" })

      -- Add a cursor and jump to the next/previous search result.
      set("n", "<leader>mn", function()
        mc.searchAddCursor(1)
      end, { desc = "Add Search Down" })

      set("n", "<leader>mp", function()
        mc.searchAddCursor(-1)
      end, { desc = "Add Search Up" })

      -- Jump to the next/previous search result without adding a cursor.
      set("n", "<leader>mN", function()
        mc.searchSkipCursor(1)
      end, { desc = "Skip Search Down" })
      set("n", "<leader>mP", function()
        mc.searchSkipCursor(-1)
      end, { desc = "Skip Search Up" })
      -- set({ "n" }, "<leader>m<space>", function()
      --   require("which-key").show({
      --     keys = "<leader>m",
      --     loop = true, -- this will keep the popup open until you hit <esc>
      --   })
      -- end, { desc = "Hydra" })

      -- Add and remove cursors with control + left click.
      set({ "n" }, "<c-leftmouse>", mc.handleMouse)
      set({ "n" }, "<c-leftdrag>", mc.handleMouseDrag)

      -- Append/insert for each line of visual selections.
      set("x", "I", mc.insertVisual)
      set("x", "A", mc.appendVisual)

      -- Jumplist support
      set({ "n", "x" }, "<c-i>", mc.jumpForward)
      set({ "n", "x" }, "<c-o>", mc.jumpBackward)

      mc.addKeymapLayer(function(layerSet)
        set({ "n", "x" }, "<leader>mc", mc.clearCursors, { desc = "Clear Cursors" })

        -- Select a different cursor as the main one.
        layerSet({ "n", "x" }, "<left>", mc.prevCursor)
        layerSet({ "n", "x" }, "<right>", mc.nextCursor)

        -- Delete the main cursor.
        layerSet({ "n", "x" }, "<leader>mx", mc.deleteCursor)

        -- Enable and clear cursors using escape.
        layerSet({ "n" }, "<esc>", function()
          if not mc.cursorsEnabled() and mc.hasCursors() then
            mc.enableCursors()
          else
            mc.clearCursors()
          end
        end)
      end)
      -- Customize how cursors look.
      local hl = vim.api.nvim_set_hl
      hl(0, "MultiCursorCursor", { link = "Cursor" })
      hl(0, "MultiCursorVisual", { link = "Visual" })
      hl(0, "MultiCursorSign", { link = "SignColumn" })
      hl(0, "MultiCursorMatchPreview", { link = "Search" })
      hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
      hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
      hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
    end,
  },
}
