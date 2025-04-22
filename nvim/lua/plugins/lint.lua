return {
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters = {
        ["markdownlint-cli2"] = {
          args = { "--config", "/Users/jimmie/.config/nvim/support/markdownlint.yaml", "--" },
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        markdown = { "markdownlint-cli2" },
      },
      formatters = {
        ["markdownlint-cli2"] = {
          args = { "--config", "/Users/jimmie/.config/nvim/support/markdownlint.yaml", "--" },
        },
      },
    },
  },
}
