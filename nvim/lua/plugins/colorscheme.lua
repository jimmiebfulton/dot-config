return {
  {
    "LazyVim/LazyVim",
    opts = {
      -- colorscheme = "github_dark_dimmed",
      colorscheme = "nordfox",
    },
  },

  {
    "EdenEast/nightfox.nvim",
    priority = 1000,
    opts = {
      options = {
        dim_inactive = true,
        transparent = false,
        styles = {
          comments = "italic",
          keywords = "bold",
          types = "italic,bold",
        },
        inverse = { -- Inverse highlight for different types
          match_paren = false,
          visual = false,
          search = false,
        },
      },
    },
  },

  {
    "olimorris/onedarkpro.nvim",
    priority = 1000, -- Ensure it loads first
  },

  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    opts = {
      background = { -- map the value of 'background' option to a theme
        dark = "dragon", -- try "dragon" !
        light = "lotus",
      },
    },
  },

  {
    "projekt0n/github-nvim-theme",
    name = "github-theme",
    priority = 1000,
  },

  {
    "marko-cerovac/material.nvim",
    priority = 1000,
  },
}
