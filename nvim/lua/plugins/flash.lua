return {
  {
    "folke/flash.nvim",
    enabled = true,
    opts = {
      jump = {
        autojump = false,
      },
      label = {
        after = true,
        before = false,
        rainbow = {
          enabled = true,
          shade = 6,
        },
      },
      highlight = {
        backdrop = true,
        matches = false,
      },
      modes = {
        search = {
          enabled = true,
          jump = { nohlsearch = false },
        },
        char = {
          jump_labels = true,
        },
      },
      remote_op = {
        restore = true,
        motion = false,
      },
    },
  },
}
