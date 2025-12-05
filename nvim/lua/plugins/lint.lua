local markdownlint_config = vim.fn.stdpath("config") .. "/support/markdownlint.yaml"

return {
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters = {
        ["markdownlint-cli2"] = {
          args = { "--config", markdownlint_config, "--" },
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
          args = { "--config", markdownlint_config, "--" },
        },
      },
    },
  },
}
