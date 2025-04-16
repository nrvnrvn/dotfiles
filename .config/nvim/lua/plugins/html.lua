return {
  "stevearc/conform.nvim",
  dependencies = {
    {
      "williamboman/mason.nvim",
      opts = {
        ensure_installed = {
          "prettier",
        },
      },
    },
  },
  opts = {
    formatters_by_ft = {
      html = { "prettier" },
    },
  },
}
